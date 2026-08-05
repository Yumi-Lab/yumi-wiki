// ─────────────────────────────────────────────────────────────────────────────
// scan.mjs — découverte + ingest des boucles autonomes de la machine (zéro dépendance).
// Partagé par hub.mjs (radar local) et loop-agent.mjs (agent de supervision distante).
//
// Découvre tout dossier `.monitor/` contenant des `*.jsonl` sous HUB_ROOTS → donc les boucles de ce
// kit ET tout fork qui écrit le même format (run-vN.sh). Aucun enregistrement, aucune config projet.
// ─────────────────────────────────────────────────────────────────────────────
import { readdirSync, statSync, existsSync, readFileSync, openSync, readSync, closeSync } from "node:fs";
import { execFileSync } from "node:child_process";
import { join, basename, resolve } from "node:path";
import { homedir } from "node:os";
import { StringDecoder } from "node:string_decoder";
import { MONITOR_DIR, LOCK_DIR, CTL_DIR, VERDICT_FILE } from "./kit-paths.mjs";

export const ROOTS = (process.env.HUB_ROOTS || join(homedir(), "Documents"))
  .split(":").filter(Boolean).map((p) => resolve(p.replace(/^~/, homedir())));
export const DEPTH = Number(process.env.HUB_DEPTH) || 4;
export const STALL_S = Number(process.env.HUB_STALL_S) || 300;
const SKIP = new Set(["node_modules", ".git", "vendor", "dist", "build", "target", "Library", ".venv", "venv"]);

// ─── Table modèle → fenêtre de contexte (miroir de monitor.mjs) ─────────────
const K = 1_000, M = 1_000_000;
export const MODELS = [
  { re: /opus[.-]?5/i, label: "opus-5", win: 200 * K },        // Claude Opus 5
  { re: /opus[.-]?4[.-]?8/i, label: "opus-4.8", win: 200 * K },// Opus 4.8 (parallèle d'Opus 5)
  { re: /opus/i, label: "opus", win: 200 * K }, { re: /sonnet/i, label: "sonnet", win: 200 * K },
  { re: /haiku/i, label: "haiku", win: 200 * K }, { re: /fable/i, label: "fable", win: 200 * K },
  { re: /k3-256k?\b/i, label: "kimi-k3-256k", win: 256 * K },  // Kimi K3 fenêtre 256k (kimi-code/k3-256k)
  { re: /(^|[:\/-])k3\b/i, label: "kimi-k3", win: 1 * M },  // Kimi K3 (kimi:k3 / kimi-code/k3) : 1M
  { re: /kimi/i, label: "kimi", win: 256 * K }, { re: /grok/i, label: "grok", win: 256 * K },
  { re: /devstral/i, label: "devstral", win: 128 * K }, { re: /magistral/i, label: "magistral", win: 128 * K },
  { re: /ministral/i, label: "ministral", win: 128 * K }, { re: /mistral|vibe/i, label: "mistral", win: 128 * K },
  { re: /qwen/i, label: "qwen", win: 256 * K },
];
const matchModel = (m) => (m ? MODELS.find((x) => x.re.test(m)) : null) || null;
export const ctxWindow = (m) => (m && /1m|\[1m\]/i.test(m) ? M : matchModel(m)?.win ?? 200 * K);
export const shortModel = (m) => (!m ? "?" : matchModel(m)?.label ?? m.slice(0, 12));

function findMonitorDirs() {
  const found = [];
  const walk = (dir, depth) => {
    if (depth > DEPTH) return;
    let entries;
    try { entries = readdirSync(dir, { withFileTypes: true }); } catch { return; }
    for (const e of entries) {
      if (!e.isDirectory() || SKIP.has(e.name) || (e.name.startsWith(".") && e.name !== MONITOR_DIR)) continue;
      const p = join(dir, e.name);
      if (e.name === MONITOR_DIR) {
        try { if (readdirSync(p).some((f) => f.endsWith(".jsonl"))) found.push(p); } catch {}
        continue;
      }
      walk(p, depth + 1);
    }
  };
  for (const r of ROOTS) walk(r, 0);
  return found;
}

const LOGCAP = 40;   // lignes de conversation gardées par agent (mode conversation du hub)

// Résout une réf git en sha complet (null si non-git, git absent ou réf invalide/ambiguë).
// Même sémantique que verdict_real_pass de loop.sh : `rev-parse --verify --quiet <ref>^{commit}`
// — fail-closed sur ambiguïté. execFileSync sans shell : argv fixe, aucune interpolation.
function gitRev(repo, ref) {
  try {
    return execFileSync("git", ["rev-parse", "--verify", "--quiet", ref + "^{commit}"],
      { cwd: repo, encoding: "utf8", stdio: ["ignore", "pipe", "ignore"] }).trim() || null;
  } catch { return null; }
}

// M2 — le handoff n'est un GATE humain que si la revue l'a validé. En mode contrôlé (un verdict
// existe), lit .loop/control/last-verdict.json : PASS RÉEL (ni provisional ni stale) ANCRÉ SUR LE
// HEAD COURANT (M4 — un PASS sur un vieux sha ne couvre pas les commits de tête). Retour :
//   true  = revu → statut « GATE » (l'humain peut gater) ;
//   false = non revu → statut « GATE-REVIEW » (l'humain ne doit PAS gater : p. ex. contrôleuse
//           morte ×N → arrêt avec handoff + verdict stale sur disque) ;
//   null  = pas de verdict du tout (boucle coder-only : pas de revue, le gate direct reste valide).
export function gateReviewed(repo) {
  const vf = join(repo, CTL_DIR, VERDICT_FILE);
  if (!existsSync(vf)) return null;
  try {
    const v = JSON.parse(readFileSync(vf, "utf8"));
    if (v?.verdict !== "PASS" || v.provisional === true || v.stale === true) return false;
    const anchored = typeof v.head === "string" ? gitRev(repo, v.head) : null;
    return anchored !== null && anchored === gitRev(repo, "HEAD");
  } catch { return false; }
}
function pushLog(s, kind, text) {
  text = (text || "").replace(/\s+/g, " ").trim();
  if (!text) return;
  s.log.push({ t: Date.now(), kind, text: text.slice(0, 240) });
  if (s.log.length > LOGCAP) s.log.shift();
}

const files = new Map(); // jsonl -> état accumulé (lecture incrémentale)
function ingest(file) {
  let st; try { st = statSync(file); } catch { return null; }
  let s = files.get(file);
  if (!s) { s = { off: 0, buf: "", dec: new StringDecoder("utf8"), model: "", win: 0, ctx: 0, out: 0, cost: 0, outChars: 0, est: false, tool: "", iter: 0, max: 0, log: [], pending: "", yumi: false }; files.set(file, s); }
  if (st.size < s.off) {  // fichier tronqué = nouveau run → reset des accumulateurs
    s.off = 0; s.buf = ""; s.dec = new StringDecoder("utf8");
    s.ctx = 0; s.out = 0; s.cost = 0; s.outChars = 0; s.est = false; s.tool = ""; s.iter = 0; s.max = 0; s.log = []; s.pending = ""; s.yumi = false;
  }
  if (st.size > s.off) {
    // TOCTOU (M5) : le jsonl peut disparaître ou devenir illisible entre statSync et open/read
    // (suppression, renommage, symlink vers dossier, chmod 000) → on saute ce tick, l'état accumulé
    // est conservé et la lecture réussira au prochain snapshot. finally : jamais de fuite de fd.
    // Lecture PARTIELLE possible si le fichier est retaillé après le stat → on ne décode que n octets.
    let fd;
    try {
      fd = openSync(file, "r");
      const b = Buffer.alloc(st.size - s.off);
      const n = readSync(fd, b, 0, b.length, s.off);
      s.off = st.size; s.buf += s.dec.write(b.subarray(0, n));
    } catch { /* tick sauté : réessai au prochain snapshot */ }
    finally { if (fd !== undefined) { try { closeSync(fd); } catch {} } }
    let nl;
    while ((nl = s.buf.indexOf("\n")) >= 0) {
      const line = s.buf.slice(0, nl); s.buf = s.buf.slice(nl + 1);
      if (!line.trim()) continue;
      let e; try { e = JSON.parse(line); } catch { continue; }
      if (typeof e !== "object" || e === null) continue;
      // Grok émet son texte en petits morceaux {type:text,data} : on l'accumule et on le flushe
      // en une ligne de conversation dès qu'un autre type d'événement arrive.
      if (e.type !== "text" && s.pending) { pushLog(s, "say", s.pending); s.pending = ""; }
      if (e.type === "loop") { if (typeof e.iter === "number") s.iter = e.iter; if (typeof e.max === "number") s.max = e.max; }
      else if (e.type === "system" && e.subtype === "init") {
        if (e.model) { s.model = e.model; s.win = Math.max(s.win, ctxWindow(e.model)); }
        // Le seed de loop.sh porte le mot-clé configuré (ex. "yumi:sonnet") AVANT que le CLI ne le
        // remplace par l'id résolu → on capture ici que le run passe par l'orchestrateur yumi.
        if (typeof e.model === "string" && /^yumi(:|$)/i.test(e.model)) s.yumi = true;
      }
      else if (e.type === "assistant") {                        // Claude : télémétrie complète
        const u = e.message?.usage;
        if (u) { s.ctx = (u.input_tokens || 0) + (u.cache_read_input_tokens || 0) + (u.cache_creation_input_tokens || 0); s.out += u.output_tokens || 0; }
        if (e.message?.model) { s.model = e.message.model; s.win = Math.max(s.win, ctxWindow(e.message.model)); }
        const mc = e.message?.content;
        if (Array.isArray(mc)) {
          for (const c of mc) {
            if (c.type === "text") pushLog(s, "say", c.text);
            else if (c.type === "tool_use") { s.tool = c.name; pushLog(s, "tool", "→ " + c.name); }
          }
        } else if (typeof mc === "string" && mc) {
          // Forme hybride yumi : type=="assistant" mais content en CHAÎNE, pas d'usage par message →
          // estimation pendant le run ; l'usage RÉEL arrive dans l'event result (voir plus bas).
          if (!u) { s.est = true; s.outChars += mc.length; }
          pushLog(s, "say", mc);
        }
        if (Array.isArray(e.message?.tool_calls))
          for (const c of e.message.tool_calls) { const n = c?.function?.name || c?.name; if (n) { s.tool = n; pushLog(s, "tool", "→ " + n); } }
      } else if (e.role === "assistant") {                      // Kimi / Vibe (OpenAI-like)
        s.est = true;
        if (typeof e.content === "string") { s.outChars += e.content.length; pushLog(s, "say", e.content); }
        if (Array.isArray(e.tool_calls)) for (const c of e.tool_calls) { const n = c?.function?.name; if (n) { s.tool = n; pushLog(s, "tool", "→ " + n); } }
      } else if (e.type === "text" || e.type === "thought") {   // Grok (thought = raisonnement, ignoré)
        s.est = true;
        if (e.type === "text" && typeof e.data === "string") { s.outChars += e.data.length; s.pending += e.data; }
      } else if (e.type === "result") {
        if (typeof e.total_cost_usd === "number") s.cost += e.total_cost_usd;
        // Providers iso-result SANS usage par message (yumi) : le result porte l'output RÉEL du run →
        // il remplace l'estimation. PAS de jauge contexte depuis ici : input+cache du result sont des
        // CUMULS sur les tours, pas la taille du contexte (claude, lui, a l'usage par event assistant).
        const u = e.usage;
        if (u && s.est && u.output_tokens) { s.out += u.output_tokens; s.est = false; s.outChars = 0; }
        s.tool = e.subtype && e.subtype !== "success" ? "✗ " + e.subtype : "✓ terminé";
        pushLog(s, "end", "— itération terminée —");
      }
    }
  }
  s.mtime = st.mtimeMs;
  return s;
}

// Snapshot : une entrée par BOUCLE (= un repo), avec ses agents. Le statut priorise ce qui a besoin
// d'un HUMAIN. L'ACTIVITÉ prime sur .done (sinon une boucle qui tourne dans un repo où traîne un
// vieux .done — ex. .done-v7 — s'afficherait « terminée » alors qu'elle code en ce moment).
export function snapshot() {
  const now = Date.now();
  const loops = [];
  for (const mdir of findMonitorDirs()) {
    const repo = resolve(join(mdir, ".."));
    let jsonls = [];
    try { jsonls = readdirSync(mdir).filter((f) => f.endsWith(".jsonl")).map((f) => join(mdir, f)); } catch {}
    const agents = [];
    let newest = 0, cost = 0, iter = 0, max = 0, anyReal = false;
    for (const jf of jsonls) {
      const s = ingest(jf);
      if (!s) continue;
      newest = Math.max(newest, s.mtime || 0);
      cost += s.cost; if (!s.est || s.cost > 0) anyReal = true;   // coût réel dès qu'un result l'a émis (claude ET yumi)
      if (s.iter) { iter = s.iter; max = s.max; }
      const aAge = s.mtime ? Math.max(0, Math.round((now - s.mtime) / 1000)) : null;
      agents.push({
        name: basename(jf).replace(/\.jsonl$/, ""), model: shortModel(s.model), est: s.est,
        pct: s.ctx === 0 ? null : Math.min(100, Math.round((s.ctx / (s.win || ctxWindow(s.model))) * 100)),
        ctx: s.ctx, out: s.est ? Math.round(s.outChars / 4) : s.out, cost: s.cost,
        tool: s.tool || "—", age: aAge, live: aAge !== null && aAge < 12,
        log: (s.log || []).slice(-18),          // conversation récente (mode conversation du hub)
      });
    }
    const age = newest ? Math.max(0, Math.round((now - newest) / 1000)) : null;
    const lockDir = join(mdir, LOCK_DIR);
    const locked = existsSync(lockDir);
    let pid = null;
    try { pid = Number(readFileSync(join(lockDir, "pid"), "utf8").trim()) || null; } catch {}
    // ATTRIBUTION boucle → agent : miroir local .monitor/owner.json écrit par l'agent qui a ARMÉ la
    // boucle (la vérité {agent_id, contextId} vivra chez l'orchestrateur A2A ; ce fichier n'en est que
    // le reflet pour le hub). Lu FRAIS à chaque snapshot (même motif que loop.conf/gateText), VALIDÉ et
    // tronqué (containment forks) ; stale = boucle (re)démarrée bien APRÈS l'armement → chip grisée,
    // l'attribution n'est JAMAIS effacée (les relances watchdog/remote n'ont pas l'env du lanceur).
    let owner = null;
    try {
      const o = JSON.parse(readFileSync(join(mdir, "owner.json"), "utf8"));
      if (o && typeof o.agent_id === "string" && o.agent_id) {
        owner = { agent_id: o.agent_id.slice(0, 120) };
        if (typeof o.label === "string" && o.label) owner.label = o.label.slice(0, 120);
        if (typeof o.source === "string" && o.source) owner.source = o.source.slice(0, 60);
        if (typeof o.context_id === "string" && o.context_id) owner.context_id = o.context_id.slice(0, 120);
        if (typeof o.started_at === "string") {
          owner.started_at = o.started_at.slice(0, 40);
          try {
            const st = Date.parse(o.started_at);
            const lockMs = statSync(lockDir).mtimeMs;
            if (Number.isFinite(st) && lockMs && st < lockMs - 60_000) owner.stale = true;
          } catch {}
        }
      }
    } catch {}
    const gateFile = join(repo, ".gate-handoff");
    const gate = existsSync(gateFile);
    // Boucle orchestrée par le CLI yumi ? Vrai si un agent du run est passé par yumi (seed du flux)
    // OU si loop.conf le configure. Détection conf HORS COMMENTAIRES (le gabarit du kit documente
    // yumi: en commentaire) : modèle préfixé `yumi:` n'importe où — coder_model=yumi:… comme le
    // mapping dynamique d'un hook run_custom (ex. `echo yumi:sonnet`, fork qemu) — ou un binaire
    // yumi explicitement pointé (yumi_bin=/YUMI_BIN= non vide).
    let yumi = jsonls.some((jf) => files.get(jf)?.yumi);
    if (!yumi) {
      try {
        const conf = readFileSync(join(repo, "loop.conf"), "utf8").replace(/(^|\s)#[^\n]*/g, "$1");
        yumi = /\byumi:/i.test(conf) || /^[ \t]*yumi_bin[ \t]*=[ \t]*["']?[^"'\s]/mi.test(conf);
      } catch {}
    }
    let doneFile = null;
    try { doneFile = readdirSync(repo).find((f) => f === ".done" || f.startsWith(".done-")) || null; } catch {}

    // Verrou posé → le pid dit si la boucle VIT, et ça tranche TOUT le spectre du silence :
    //  · process VIVANT, silencieux ≥ 60 s → QUIET (orange : build long / gros raisonnement —
    //    vécu : compil qemu > 5 min sans une ligne ; ni le rouge STALLED d'avant, ni le gris IDLE)
    //  · process MORT sous verrou → STALLED (rouge) IMMÉDIATEMENT : un verrou orphelin est un
    //    crash, inutile d'attendre STALL_S pour le dire. (STALL_S/HUB_STALL_S devient inutile ici,
    //    conservé pour compat env ; monitor-watch garde son propre seuil de patinage.)
    let alive = false;
    if (locked && pid) { try { process.kill(pid, 0); alive = true; } catch {} }
    // M2 : « GATE » seulement si la revue a validé (PASS réel ancré HEAD) ou hors mode contrôlé ;
    // sinon « GATE-REVIEW » — le hub l'affiche en orange distinct, avec un prompt dédié qui dit
    // de NE PAS gater (code pas encore revu).
    const reviewed = gate ? gateReviewed(repo) : null;
    let status;
    if (gate) status = reviewed === false ? "GATE-REVIEW" : "GATE";
    else if (age !== null && age < 60) status = "RUNNING";
    else if (doneFile) status = "DONE";
    else if (locked && alive) status = "QUIET";
    else if (locked) status = "STALLED";
    else status = "IDLE";

    let gateText = "";
    if (gate) { try { gateText = readFileSync(gateFile, "utf8").slice(0, 600); } catch {} }

    const live = age !== null && age < 12 && (status === "RUNNING" || status === "GATE" || status === "GATE-REVIEW");
    loops.push({ name: basename(repo), path: repo, status, live, alive, locked, pid, age, iter, max, cost, anyReal, doneFile, gateText, gateReviewed: reviewed, yumi, owner, agents });
  }
  const rank = { GATE: 0, "GATE-REVIEW": 1, STALLED: 2, QUIET: 3, RUNNING: 4, DONE: 5, IDLE: 6 };
  loops.sort((a, b) => (rank[a.status] - rank[b.status]) || a.name.localeCompare(b.name));
  return { ts: now, loops, totalCost: loops.reduce((a, l) => a + (l.anyReal ? l.cost : 0), 0) };
}
