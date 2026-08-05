#!/usr/bin/env node
// Monitor multi-codeurs — temps réel, zéro dépendance.
// Lit les flux stream-json des codeurs dans .monitor/*.jsonl (alimentés par `tee` côté loop.sh, un
// fichier par codeur) et affiche par codeur : modèle · jauge de contexte · tokens · coût · outil ·
// fraîcheur, + l'état de la boucle (itération, DONE, gate-handoff). Usage : node monitor.mjs (Ctrl+C).
import { readdirSync, statSync, openSync, readSync, closeSync, existsSync, appendFileSync } from "node:fs";
import { join, basename } from "node:path";
import { StringDecoder } from "node:string_decoder";

const DIR = join(process.cwd(), ".monitor");
const REFRESH_MS = 1000;
const HISTORY_EVERY = 30;                 // écrit une ligne CSV toutes les ~30 rafraîchissements
const STALL_S = Number(process.env.STALL_S) || 300;   // inactivité (s) → alerte rouge
const DONE_F = process.env.DONE_FILE || ".done";
const HANDOFF_F = process.env.HANDOFF_FILE || ".gate-handoff";
const state = new Map(); // fichier -> état accumulé
let ticks = 0;

// ─── Table modèle → { libellé, fenêtre de contexte } ────────────────────────────────────
// UNE SOURCE DE VÉRITÉ par modèle : « il suffit de définir le modèle » dans loop.conf →
// loop.sh amorce le flux du dashboard avec ce mot-clé (cf. seed_jsonl) → le monitor y lit le
// bon LIBELLÉ et la bonne FENÊTRE. La 1re entrée dont le motif matche gagne (du plus spécifique au
// plus générique). Matche AUSSI les vrais IDs (`claude-opus-4-8`, `mistral-medium-3.5`, `grok-4`…).
// Override global : env CTX_WINDOW=…  ·  Claude en 1M (tag [1m]) : géré à part dans ctxWindow.
const K = 1_000, M = 1_000_000;
const MODELS = [
  { re: /opus[.-]?5/i,       label: "opus-5",   win: 200 * K }, // Claude Opus 5 (claude-opus-5)
  { re: /opus[.-]?4[.-]?8/i, label: "opus-4.8", win: 200 * K }, // Opus 4.8, dispo en parallèle
  { re: /opus/i,      label: "opus",     win: 200 * K },   // autres Opus (4.x) / alias 'opus'
  { re: /sonnet/i,    label: "sonnet",   win: 200 * K },   // Sonnet 5
  { re: /haiku/i,     label: "haiku",    win: 200 * K },   // Haiku 4.5
  { re: /fable/i,     label: "fable",    win: 200 * K },   // Fable 5
  { re: /k3-256k?\b/i, label: "kimi-k3-256k", win: 256 * K }, // Kimi K3 fenêtre 256k (kimi-code/k3-256k)
  { re: /(^|[:\/-])k3\b/i, label: "kimi-k3", win: 1 * M }, // Kimi K3 (kimi:k3 / kimi-code/k3) : 1M
  { re: /kimi/i,      label: "kimi",     win: 256 * K },   // Kimi K2.x (K2.7 kimi-code/kimi-for-coding : 256k)
  { re: /grok/i,      label: "grok",     win: 256 * K },   // Grok 4 / grok-code (256k)
  { re: /devstral/i,  label: "devstral", win: 128 * K },   // Devstral Small
  { re: /magistral/i, label: "magistral",win: 128 * K },
  { re: /ministral/i, label: "ministral",win: 128 * K },
  { re: /mistral|vibe/i, label: "mistral", win: 128 * K }, // Mistral Medium 3.5, Large…
  { re: /qwen/i,      label: "qwen",     win: 256 * K },   // Qwen3 (jusqu'à 256k)
];
const DEFAULT_WIN = 200 * K;
const ENV_CTX_WINDOW = Number(process.env.CTX_WINDOW) || 0;
const matchModel = (m) => (m ? MODELS.find((x) => x.re.test(m)) : null) || null;
const ctxWindow = (m) => {
  if (ENV_CTX_WINDOW > 0) return ENV_CTX_WINDOW;          // override explicite = priorité absolue
  if (m && /1m|\[1m\]/i.test(m)) return 1 * M;            // Claude en mode 1M (option beta)
  return matchModel(m)?.win ?? DEFAULT_WIN;               // fenêtre du modèle, sinon 200k
};
const shortModel = (m) => (!m ? "?" : matchModel(m)?.label ?? m.slice(0, 10));
const fmtTok = (n) => (n >= 1000 ? Math.round(n / 1000) + "k" : String(n || 0));
// Couleurs ANSI 256 — la jauge passe progressivement vert → jaune → orange → rouge.
const RESET = "\x1b[0m", DIM = "\x1b[2m";
const RED = "\x1b[38;5;196m", ORANGE = "\x1b[38;5;208m", GREEN = "\x1b[38;5;42m";
const ctxColor = (pct) => (pct >= 95 ? RED : pct >= 80 ? ORANGE : pct >= 60 ? "\x1b[38;5;220m" : GREEN);
const gauge = (pct, w = 12) => {
  const n = Math.max(0, Math.min(w, Math.round((pct / 100) * w)));
  return ctxColor(pct) + "▓".repeat(n) + DIM + "░".repeat(w - n) + RESET;
};

function listFiles() {
  try { return readdirSync(DIR).filter((x) => x.endsWith(".jsonl")).map((x) => join(DIR, x)); }
  catch { return []; }
}

function freshState() {
  return { off: 0, buf: "", dec: new StringDecoder("utf8"), model: "", win: 0,
    ctx: 0, out: 0, cost: 0, outChars: 0, est: false, tool: "", ts: 0, iter: 0, max: 0 };
}
// Remet à zéro les accumulateurs d'un run (garde model/win : le seed les rétablit). Appelé quand
// loop.sh tronque le .jsonl au redémarrage → sinon le coût/tokens s'ADDITIONNENT d'un run à l'autre.
function resetRun(s) { s.off = 0; s.buf = ""; s.dec = new StringDecoder("utf8");
  s.ctx = 0; s.out = 0; s.cost = 0; s.outChars = 0; s.est = false; s.tool = ""; s.iter = 0; s.max = 0; }

function ingest(file) {
  let st; try { st = statSync(file); } catch { return; }
  let s = state.get(file);
  if (!s) { s = freshState(); state.set(file, s); }
  if (st.size < s.off) resetRun(s);                        // fichier réécrit (nouveau run) → reset propre
  if (st.size === s.off) return;
  const fd = openSync(file, "r"); const b = Buffer.alloc(st.size - s.off);
  readSync(fd, b, 0, b.length, s.off); closeSync(fd);
  s.off = st.size; s.buf += s.dec.write(b);                // StringDecoder : ne coupe pas un char UTF-8 multi-octet
  let nl;
  while ((nl = s.buf.indexOf("\n")) >= 0) {
    const line = s.buf.slice(0, nl); s.buf = s.buf.slice(nl + 1);
    if (!line.trim()) continue;
    let e; try { e = JSON.parse(line); } catch { continue; }
    if (typeof e !== "object" || e === null) continue;
    s.ts = Date.now();
    if (e.type === "loop") {                               // marqueur d'itération émis par loop.sh
      if (typeof e.iter === "number") s.iter = e.iter;
      if (typeof e.max === "number") s.max = e.max;
    } else if (e.type === "system" && e.subtype === "init") {
      if (e.model) { s.model = e.model; s.win = Math.max(s.win, ctxWindow(e.model)); }
    } else if (e.type === "assistant") {
      // Flux Claude stream-json : télémétrie COMPLÈTE (tokens, modèle, coût via result).
      const u = e.message?.usage;
      if (u) { s.ctx = (u.input_tokens || 0) + (u.cache_read_input_tokens || 0) + (u.cache_creation_input_tokens || 0); s.out += u.output_tokens || 0; }
      if (e.message?.model) { s.model = e.message.model; s.win = Math.max(s.win, ctxWindow(e.message.model)); }
      const mc = e.message?.content;
      if (Array.isArray(mc)) { for (const c of mc) if (c.type === "tool_use") s.tool = c.name; }
      else if (typeof mc === "string" && !u) {
        // Forme hybride yumi : type=="assistant" mais content en CHAÎNE et pas d'usage par message →
        // estimation pendant le run ; l'usage RÉEL arrive dans l'event result (voir plus bas).
        s.est = true; s.outChars += mc.length;
      }
      if (Array.isArray(e.message?.tool_calls))
        for (const c of e.message.tool_calls) { const n = c?.function?.name || c?.name; if (n) s.tool = n; }
    } else if (e.role === "assistant") {
      // Flux OpenAI/Vibe/Kimi : PAS de télémétrie tokens/coût émise. On ESTIME la sortie (chars/4) et
      // on suit le dernier outil ; le contexte reste inconnu (affiché « n/a », jamais un 0% trompeur).
      s.est = true;
      if (typeof e.content === "string") s.outChars += e.content.length;
      if (Array.isArray(e.tool_calls)) for (const c of e.tool_calls) { const n = c?.function?.name; if (n) s.tool = n; }
    } else if (e.type === "text" || e.type === "thought") {
      // Flux Grok (xAI) : {"type":"text"|"thought","data":…}. Pas de télémétrie → estimation sur le texte.
      s.est = true;
      if (e.type === "text" && typeof e.data === "string") s.outChars += e.data.length;
    } else if (e.type === "result") {
      if (typeof e.total_cost_usd === "number") s.cost += e.total_cost_usd;
      // Providers iso-result SANS usage par message (yumi) : le result porte l'output RÉEL du run →
      // il remplace l'estimation. PAS de jauge contexte depuis ici : input+cache du result sont des
      // CUMULS sur les tours, pas la taille du contexte (claude, lui, a l'usage par event assistant).
      const u = e.usage;
      if (u && s.est && u.output_tokens) { s.out += u.output_tokens; s.est = false; s.outChars = 0; }
      s.tool = "✓ run terminé";
      if (e.subtype && e.subtype !== "success") s.tool = "✗ " + e.subtype;
    }
  }
}

// Colonne CONTEXTE : soit la vraie jauge (claude, usage PAR MESSAGE), soit « ctx n/a » honnête
// (providers sans usage par message — yumi inclus : l'usage de son event result est un CUMUL sur
// les tours, il ne représente pas la taille du contexte → jamais de jauge depuis un result).
function ctxCell(s) {
  const width = 17; // largeur visuelle de gauge(12) + " " + "xxx%"
  if (s.ctx === 0) return DIM + "ctx n/a".padEnd(width) + RESET;
  const win = s.win || ctxWindow(s.model);
  const pct = Math.min(100, (s.ctx / win) * 100);
  return gauge(pct) + " " + ctxColor(pct) + String(Math.round(pct)).padStart(3) + "%" + RESET;
}

function render() {
  ticks++;
  for (const f of listFiles()) ingest(f);
  const rows = [...state.entries()].sort((a, b) => basename(a[0]).localeCompare(basename(b[0])));
  const now = Date.now();
  let totCost = 0, anyReal = false;
  const it = rows.map(([, s]) => (s.max ? `${s.iter}/${s.max}` : "")).find(Boolean) || "";
  let out = "\x1b[2J\x1b[H";
  out += `  Autonomous Loop · monitor — ${new Date().toLocaleTimeString()}${it ? "  · itération " + it : ""}   (Ctrl+C)\n`;
  // Bandeau d'état de la boucle (sentinelles à la racine du projet).
  if (existsSync(join(process.cwd(), DONE_F))) out += `  ${GREEN}✅ DONE (${DONE_F}) — boucle terminée${RESET}\n`;
  else if (existsSync(join(process.cwd(), HANDOFF_F))) out += `  ${ORANGE}⏸ GATE-HANDOFF (${HANDOFF_F}) — en attente d'un gate humain${RESET}\n`;
  out += "  " + "─".repeat(82) + "\n";
  out += "  CODEUR      MODÈLE   CONTEXTE            TOKENS         COÛT     OUTIL / ÉTAT\n";
  if (!rows.length) out += "\n  (en attente de .monitor/*.jsonl — lance ./loop.sh, il y dirige le flux)\n";
  for (const [f, s] of rows) {
    const age = s.ts ? Math.round((now - s.ts) / 1000) : 0;
    const fresh = age >= STALL_S ? `${RED}⛔ ${Math.round(age / 60)}m inactif${RESET}` : age > 45 ? `⚠ ${age}s` : `${age}s`;
    // yumi : usage/coût RÉELS émis à chaque event result (fin de run) — entre deux results on est en
    // mode estimation (est=true) mais les totaux déjà émis restent réels ('~' final = run en cours).
    const tokCell = s.est
      ? (s.out ? (s.ctx ? "in " + fmtTok(s.ctx) + "/" : "") + "out " + fmtTok(s.out) + "~" : `~${fmtTok(Math.round(s.outChars / 4))} out`)
      : (s.ctx ? "in " + fmtTok(s.ctx) + "/" : "") + "out " + fmtTok(s.out);
    const costCell = (!s.est || s.cost > 0) ? ("$" + s.cost.toFixed(2)).padStart(7) : DIM + "—".padStart(7) + RESET;
    if (!s.est || s.cost > 0) { totCost += s.cost; anyReal = true; }
    out +=
      "  " +
      basename(f).replace(/\.jsonl$/, "").padEnd(11).slice(0, 11) + " " +
      shortModel(s.model).padEnd(8) +
      ctxCell(s) + "   " +
      tokCell.padEnd(15) + costCell + "   " +
      (s.tool || "—").slice(0, 22).padEnd(22) + " " + fresh + "\n";
  }
  out += "  " + "─".repeat(82) + "\n";
  out += `  Coût cumulé : ${anyReal ? "$" + totCost.toFixed(2) : "n/a"}   ·   ${rows.length} codeur(s)`;
  out += DIM + "   (kimi/grok/vibe : tokens estimés ~, coût non émis par ces CLI)" + RESET + "\n";
  process.stdout.write(out);

  // Historique CSV (cadence lente) : post-mortem / plot du coût & contexte par run.
  if (ticks % HISTORY_EVERY === 1 && rows.length) {
    const hf = join(DIR, "history.csv");
    if (!existsSync(hf)) { try { appendFileSync(hf, "ts,coder,model,ctx,out,cost,est\n"); } catch {} }
    for (const [f, s] of rows) {
      const t = Math.floor(now / 1000);
      try { appendFileSync(hf, `${t},${basename(f).replace(/\.jsonl$/, "")},${shortModel(s.model)},${s.ctx},${s.est ? Math.round(s.outChars / 4) : s.out},${s.cost.toFixed(4)},${s.est ? 1 : 0}\n`); } catch {}
    }
  }
}

render();
setInterval(render, REFRESH_MS);
process.on("SIGINT", () => { process.stdout.write("\n"); process.exit(0); });
