#!/usr/bin/env node
// ─────────────────────────────────────────────────────────────────────────────
// HUB multi-boucles — une URL LOCALE pour superviser TOUTES tes boucles autonomes.
//
//   node hub.mjs   →   http://localhost:7777
//
// Interface à ONGLETS : « Vue d'ensemble » (KPIs + flux d'activité temps réel) + un onglet par boucle.
// SCAN sans config (cf. scan.mjs) : tout `.monitor/` avec des `*.jsonl` → boucles du kit ET forks
// (run-vN.sh). État déduit des sentinelles : .lock (en cours) · .gate-handoff (t'attend) · .done (fini).
// RADAR, PAS AUTOPILOTE : lecture seule, aucune action, bind 127.0.0.1 → zéro surface d'attaque.
//
// Env : HUB_PORT=7777 · HUB_ROOTS=~/Documents · HUB_DEPTH=4 · HUB_SCAN_MS=3000 · HUB_STALL_S=300
//       HUB_NOTIFY_CMD='…' (voit $LOOP_NAME/$LOOP_STATE/$LOOP_PATH ; défaut macOS ; vide = off)
// ─────────────────────────────────────────────────────────────────────────────
import { createServer } from "node:http";
import { exec } from "node:child_process";
import { snapshot, ROOTS, DEPTH } from "./scan.mjs";

const PORT = Number(process.env.HUB_PORT) || 7777;
const SCAN_MS = Number(process.env.HUB_SCAN_MS) || 3000;
const NOTIFY_CMD = process.env.HUB_NOTIFY_CMD ??
  (process.platform === "darwin"
    ? `osascript -e 'display notification "$LOOP_STATE" with title "Autonomous Loop" subtitle "$LOOP_NAME"'`
    : "");

// ─── Détection d'événements (flux d'activité) + notifications sur transition ──
const prev = new Map();      // path -> { status, iter, tools:{agent:tool} }
const events = [];           // ring buffer, plus récent en tête
function addEvent(repo, kind, text) { events.unshift({ t: Date.now(), repo, kind, text }); if (events.length > 80) events.pop(); }

function tick() {
  const snap = snapshot();
  for (const l of snap.loops) {
    const p = prev.get(l.path);
    if (p) {
      if (p.status !== l.status) {
        addEvent(l.name, l.status.toLowerCase(), "→ " + l.status);
        if ((l.status === "GATE" || l.status === "GATE-REVIEW" || l.status === "STALLED") && NOTIFY_CMD) {
          const msg = l.status === "GATE" ? "cède la main — gate à faire"
            : l.status === "GATE-REVIEW" ? "gate suspendu — revue en cours (NE PAS gater : code pas encore revu)"
            : "bloquée (plus d'activité)";
          exec(NOTIFY_CMD, { env: { ...process.env, LOOP_NAME: l.name, LOOP_STATE: msg, LOOP_PATH: l.path } }, () => {});
        }
      }
      if (l.iter && l.iter !== p.iter) addEvent(l.name, "iter", "itération " + l.iter + "/" + (l.max || "?"));
      for (const a of l.agents) {
        const pt = p.tools[a.name];
        if (a.tool && a.tool !== "—" && a.tool !== pt) addEvent(l.name, "tool", a.name + " → " + a.tool);
      }
    }
    prev.set(l.path, { status: l.status, iter: l.iter, tools: Object.fromEntries(l.agents.map((a) => [a.name, a.tool])) });
  }
  return { ...snap, events: events.slice(0, 60) };
}

const PAGE = `<!doctype html><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Autonomous Loops — hub</title>
<style>
 :root,:root[data-theme='dark']{--bg:#0d1117;--card:#161b22;--bd:#30363d;--tx:#e6edf3;--dim:#8b949e;--acc:#1f6feb;
   --run:#3fb950;--gate:#d29922;--gaterev:#f0883e;--stall:#f85149;--done:#58a6ff;--idle:#6e7681}
 @media(prefers-color-scheme:light){:root:not([data-theme]){--bg:#f6f8fa;--card:#fff;--bd:#d0d7de;--tx:#1f2328;--dim:#656d76}}
 :root[data-theme='light']{--bg:#f6f8fa;--card:#fff;--bd:#d0d7de;--tx:#1f2328;--dim:#656d76}
 *{box-sizing:border-box}body{margin:0;background:var(--bg);color:var(--tx);
   font:14px/1.5 ui-monospace,SFMono-Regular,Menlo,monospace}
 @keyframes pulse{0%,100%{opacity:1}50%{opacity:.25}}
 .app{display:flex;height:100vh;overflow:hidden}
 .sidebar{width:258px;flex:none;border-right:1px solid var(--bd);background:var(--card);display:flex;flex-direction:column;overflow:hidden;padding:8px}
 #nav{flex:1;overflow-y:auto;min-height:0}
 .sb-hd{font-size:13px;font-weight:600;padding:8px 10px 10px;display:flex;justify-content:space-between;align-items:baseline}
 .clk{color:var(--dim);font-size:11px;font-weight:400}
 .ctrl{display:flex;gap:4px;align-items:center;padding:8px 6px 2px;margin-top:6px;border-top:1px solid var(--bd)}
 .ctrl button{font:inherit;font-size:11px;padding:2px 7px;border-radius:6px;border:1px solid var(--bd);background:transparent;color:var(--dim);cursor:pointer}
 .ctrl button:hover{color:var(--tx)}.ctrl .lng.on{color:var(--tx);border-color:var(--acc)}
 .ctrl .thm{margin-left:auto;font-size:13px;line-height:1}
 .cp.pr{color:var(--acc);opacity:.75}.cp.pr:hover{opacity:1}
 .sec{font-size:10.5px;text-transform:uppercase;letter-spacing:.05em;color:var(--dim);margin:12px 10px 4px}
 .item{display:flex;gap:9px;align-items:center;padding:7px 10px;border-radius:8px;cursor:pointer;margin-bottom:1px}
 .item:hover{background:var(--bg)}.item.on{background:var(--bg)}
 .dot{width:9px;height:9px;border-radius:50%;flex:none}
 .dot.live{animation:pulse 1.3s ease-in-out infinite}
 .d-GATE{background:var(--gate)}.d-GATE-REVIEW{background:var(--gaterev)}.d-RUNNING{background:var(--run)}.d-STALLED{background:var(--stall)}.d-QUIET{background:#d29922}
 .d-DONE{background:var(--done)}.d-IDLE{background:var(--idle)}
 .ib{min-width:0;flex:1}.in{font-size:13px;color:var(--dim);white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
 .mi{width:15px;height:10px;flex:none;vertical-align:-1px;margin-right:3px}
 .is{font-size:11px;color:var(--dim);opacity:.75;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
 .item.on .in{color:var(--tx);font-weight:600}
 .pill{font-size:9.5px;padding:1px 6px;border-radius:99px;border:1px solid var(--gate);color:var(--gate);flex:none}
 .ochip{font-size:9px;padding:0 5px;border:1px solid var(--bd);border-radius:8px;margin-left:5px;color:var(--dim);flex:none;vertical-align:middle}
 .ochip.stale{opacity:.45}
 .owners{margin:8px 0 2px;color:var(--dim);font-size:12px}
 .fold{display:flex;align-items:center;gap:7px;padding:9px 10px 4px;font-size:12px;color:var(--tx);cursor:pointer;font-weight:600}
 .fold:hover{color:var(--acc)}.caret{width:10px;color:var(--dim);flex:none}
 .fcount{margin-left:auto;color:var(--dim);font-weight:400;font-size:11px}
 .item.sub{margin-left:8px}
 main{flex:1;overflow-y:auto;padding:18px}
 @media(max-width:700px){.app{flex-direction:column;height:auto;overflow:visible}
   .sidebar{width:auto;max-height:42vh;border-right:none;border-bottom:1px solid var(--bd)}}
 .kpis{display:flex;gap:10px;flex-wrap:wrap;margin-bottom:16px}
 .kpi{background:var(--card);border:1px solid var(--bd);border-radius:9px;padding:10px 16px;min-width:110px}
 .kpi b{font-size:22px;font-weight:700;display:block}.kpi span{color:var(--dim);font-size:11px;text-transform:uppercase;letter-spacing:.04em}
 .kpi.gate b{color:var(--gate)}.kpi.run b{color:var(--run)}.kpi.live b{color:var(--run)}
 .alert{background:#d2992222;border:1px solid var(--gate);border-radius:8px;padding:10px 14px;margin-bottom:16px;color:var(--gate);cursor:pointer}
 .cols{display:grid;grid-template-columns:1fr 340px;gap:16px}@media(max-width:820px){.cols{grid-template-columns:1fr}}
 .card{background:var(--card);border:1px solid var(--bd);border-left-width:4px;border-radius:9px;padding:12px 14px;margin-bottom:10px}
 .card.GATE{border-left-color:var(--gate)}.card.GATE-REVIEW{border-left-color:var(--gaterev)}.card.RUNNING{border-left-color:var(--run)}
 .card.STALLED{border-left-color:var(--stall)}.card.DONE{border-left-color:var(--done)}.card.IDLE{border-left-color:var(--idle)}.card.QUIET{border-left-color:#d29922}
 .mini{cursor:pointer}.mini:hover{border-color:var(--acc)}
 .hd{display:flex;gap:10px;align-items:baseline;flex-wrap:wrap}.nm{font-weight:600}
 .badge{font-size:11px;padding:1px 7px;border-radius:99px;border:1px solid currentColor}
 .GATE .badge{color:var(--gate)}.GATE-REVIEW .badge{color:var(--gaterev)}.RUNNING .badge{color:var(--run)}.STALLED .badge{color:var(--stall)}.QUIET .badge{color:#d29922}
 .DONE .badge{color:var(--done)}.IDLE .badge{color:var(--idle)}
 .live-badge{font-size:11px;padding:1px 8px;border-radius:99px;border:1px solid var(--idle);color:var(--dim)}
 .live-badge.on{color:var(--run);border-color:var(--run);animation:pulse 1.3s ease-in-out infinite}
 .pth{color:var(--dim);font-size:11px;margin-left:auto;word-break:break-all}
 .cp{cursor:pointer;color:var(--dim);flex:none;display:inline-flex;align-items:center;margin-left:8px}
 .cp:hover{color:var(--acc)}.cp svg{width:13px;height:13px}
 .item .cp{opacity:0;margin-left:4px}.item:hover .cp,.item.on .cp{opacity:.7}.item .cp:hover{opacity:1}
 table{width:100%;border-collapse:collapse;margin-top:8px;font-size:12px}
 td{padding:3px 8px 3px 0;color:var(--dim)}td.m{color:var(--tx)}
 .bar{display:inline-block;width:80px;height:7px;background:#30363d;border-radius:4px;overflow:hidden;vertical-align:middle}.bar>i{display:block;height:100%}
 .gt{white-space:pre-wrap;background:#00000022;border:1px dashed var(--gate);border-radius:6px;padding:9px;margin-top:9px;font-size:12px;max-height:300px;overflow:auto}
 .feed{background:var(--card);border:1px solid var(--bd);border-radius:9px;padding:6px 0;max-height:70vh;overflow:auto}
 .feed h3{font-size:12px;color:var(--dim);text-transform:uppercase;letter-spacing:.04em;margin:6px 14px 8px;font-weight:600}
 .ev{display:flex;gap:9px;padding:3px 14px;font-size:12.5px;align-items:baseline}
 .ev .ti{color:var(--dim);font-size:11px;flex:none;width:58px}.ev .rp{color:var(--tx);flex:none;max-width:130px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
 .ev .tx{color:var(--dim)}
 .k-gate .tx{color:var(--gate)}.k-gate-review .tx{color:var(--gaterev)}.k-done .tx{color:var(--done)}.k-stalled .tx{color:var(--stall)}
 .k-running .tx,.k-iter .tx{color:var(--run)}
 .collapsed{color:var(--dim);font-size:12.5px;background:var(--card);border:1px solid var(--bd);border-radius:9px;padding:9px 14px;margin-bottom:10px}
 .collapsed b{color:var(--tx)}.collapsed s{cursor:pointer;text-decoration:none;color:var(--tx)}.collapsed s:hover{color:var(--acc)}
 .conv{background:var(--card);border:1px solid var(--bd);border-radius:9px;padding:8px 0;max-height:64vh;overflow:auto;margin-top:12px}
 .msg{padding:4px 14px;font-size:12.5px;display:flex;gap:9px;align-items:baseline}
 .msg .who{color:var(--dim);flex:none;width:92px;text-align:right;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
 .msg .bd{white-space:pre-wrap;word-break:break-word}
 .msg.tool .bd{color:var(--acc)}.msg.end{justify-content:center;color:var(--dim);font-size:11px}.msg.end .who{display:none}
 .ft{color:var(--dim);font-size:12px;margin-top:14px;border-top:1px solid var(--bd);padding-top:10px}
</style>
<div class="app"><aside class="sidebar"><div class="sb-hd">Autonomous Loops<span class="clk" id="clk"></span></div>
<div id="nav"></div>
<div class="ctrl"><button class="lng" data-lang="fr">FR</button><button class="lng" data-lang="en">EN</button><button class="lng" data-lang="zh">中</button><button class="thm" data-theme-toggle title="Thème clair/sombre">◐</button></div>
</aside><main id="main"></main></div>
<script>
let S=null, tab='overview', lang='fr';
const collapsed=new Set();
const T={
 fr:{overview:"Vue d'ensemble",loops:"boucles",waiting:"t'attendent",running:"en cours",live:"live",cost:"coût cumulé",
   secPending:"En attente",secActive:"En cours",secDone:"Terminées / idle",collapsed:"Repliées :",
   feed:"Activité temps réel",feedFor:"Activité —",noActive:"aucune boucle active ou en attente",
   convEmpty:"— pas encore de sortie capturée (le mode conversation démarre à la prochaine activité de l'agent) —",
   feedEmpty:"— rien pour l'instant —",gateWaits:"gate — t'attend",gateReview:"gate suspendu — revue en cours",inactive:"inactif",
   copy:"Copier le chemin",copyPrompt:"Copier un prompt prêt à coller (selon l'état)",
   alert:n=>"⏸ <b>"+n+"</b> boucle(s) t'attendent (gate visuel/device) — clique pour voir",
   ovSub:(a,b)=>a+" boucles · "+b+" t'attendent",
   launchedBy:"lancé par",ownerStale:"relancée depuis l'armement",
   footer:"scan auto des .monitor/ · lecture seule · clic sur une boucle = mode conversation · ● LIVE = sortie &lt;12 s"},
 en:{overview:"Overview",loops:"loops",waiting:"waiting",running:"running",live:"live",cost:"total cost",
   secPending:"Waiting",secActive:"Running",secDone:"Done / idle",collapsed:"Collapsed:",
   feed:"Live activity",feedFor:"Activity —",noActive:"no active or waiting loop",
   convEmpty:"— no output captured yet (conversation mode starts on the agent's next activity) —",
   feedEmpty:"— nothing yet —",gateWaits:"gate — waiting",gateReview:"gate suspended — review pending",inactive:"idle",
   copy:"Copy the path",copyPrompt:"Copy a ready-to-paste prompt (state-aware)",
   alert:n=>"⏸ <b>"+n+"</b> loop(s) waiting on you (visual/device gate) — click to view",
   ovSub:(a,b)=>a+" loops · "+b+" waiting",
   launchedBy:"launched by",ownerStale:"relaunched since armed",
   footer:"auto-scan of .monitor/ · read-only · click a loop = conversation mode · ● LIVE = output &lt;12 s ago"},
 zh:{overview:"总览",loops:"循环",waiting:"待处理",running:"运行中",live:"实时",cost:"总花费",
   secPending:"等待中",secActive:"运行中",secDone:"已完成 / 空闲",collapsed:"已折叠：",
   feed:"实时活动",feedFor:"活动 —",noActive:"没有运行或等待中的循环",
   convEmpty:"— 尚无输出（代理下次活动时进入对话模式）—",
   feedEmpty:"— 暂无 —",gateWaits:"关卡 — 等待中",gateReview:"关卡暂停 — 等待审查",inactive:"空闲",
   copy:"复制路径",copyPrompt:"复制可直接粘贴的提示词（按状态生成）",
   alert:n=>"⏸ <b>"+n+"</b> 个循环等待你处理（可视化/设备关卡）— 点击查看",
   ovSub:(a,b)=>a+" 个循环 · "+b+" 待处理",
   launchedBy:"发起者",ownerStale:"武装后已重启",
   footer:"自动扫描 .monitor/ · 只读 · 点击循环 = 对话模式 · ● LIVE = 12 秒内有输出"}
};
const t=k=>{const v=(T[lang]||T.fr)[k]; return v!==undefined?v:(T.fr[k]!==undefined?T.fr[k]:k);};
function curTheme(){ return document.documentElement.dataset.theme || (matchMedia('(prefers-color-scheme: dark)').matches?'dark':'light'); }
function updateThemeIcon(){ const el=document.querySelector('[data-theme-toggle]'); if(el) el.textContent=curTheme()==='dark'?'☾':'☀'; }
function toggleTheme(){ document.documentElement.dataset.theme=curTheme()==='dark'?'light':'dark'; updateThemeIcon(); }
// Générateur de PROMPT prêt à coller, adapté à l'ÉTAT de la boucle (à donner à une instance IA).
const PT={
 fr:{
  GATE:l=>"La boucle autonome dans "+l.path+" a cédé la main pour un GATE visuel/device (itér "+l.iter+"/"+l.max+"). À VÉRIFIER :\\n"+(l.gateText||"(voir "+l.path+"/.gate-handoff)")+"\\n\\nFais le contrôle réel (Chrome MCP desktop 1440 + mobile 390, console 0 erreur). Si OK : cd "+l.path+" puis rm .gate-handoff puis relance la boucle. Si un point cloche : écris le correctif dans .loop/inject.md, puis rm .gate-handoff et relance.",
  'GATE-REVIEW':l=>"La boucle dans "+l.path+" a un gate EN SUSPENS (itér "+l.iter+"/"+l.max+") : le commit du handoff n'a PAS encore été validé par la revue (verdict absent, périmé ou ancré sur un vieux sha). NE FAIS PAS le gate visuel : vérifie d'abord la contrôleuse ("+l.path+"/.loop/control/last-verdict.json, logs .monitor). Si la boucle est arrêtée, relance-la : la revue passera, puis le gate te sera cédé.",
  RUNNING:l=>"Supervise la boucle autonome dans "+l.path+" (EN COURS, itér "+l.iter+"/"+l.max+"). Arme un monitor heartbeat : LOOP_SCRIPT=loop.sh HEARTBEAT=1800 ./monitor-watch.sh "+l.path+"  — puis préviens-moi dès qu'elle cède la main (.gate-handoff), s'arrête, ou PATINE (HEAD figé alors que les cycles montent).",
  STALLED:l=>"La boucle dans "+l.path+" semble BLOQUÉE (HEAD figé, plus d'activité). Inspecte "+l.path+"/.monitor/*.err + le dernier verdict, diagnostique la cause (binaire/token/modèle manquant, ou agent qui tourne à vide), puis corrige et relance, ou stoppe proprement.",
  QUIET:l=>"La boucle dans "+l.path+" TOURNE (process vivant, pid "+l.pid+") mais est SILENCIEUSE depuis "+Math.round((l.age||0)/60)+" min — probablement une tâche longue (build, gros raisonnement). Rien d'urgent : vérifie juste que "+l.path+"/.monitor/*.err est propre ; n'interviens que si le silence dépasse LARGEMENT la durée normale d'un build de ce projet.",
  DONE:l=>"La boucle dans "+l.path+" est TERMINÉE (.done). Vérifie le résultat final (tests verts, DoD atteinte), fais l'éventuel dernier gate visuel, puis nettoie (.done, .monitor) si tout est bon.",
  IDLE:l=>"La boucle dans "+l.path+" est INACTIVE. Reprends-la : lis GOAL.md et PROGRESS.md, relance ./loop.sh, et arme un monitor heartbeat (./monitor-watch.sh "+l.path+")."
 },
 en:{
  GATE:l=>"The autonomous loop in "+l.path+" handed off for a visual/device GATE (iter "+l.iter+"/"+l.max+"). TO VERIFY:\\n"+(l.gateText||"(see "+l.path+"/.gate-handoff)")+"\\n\\nDo the real check (Chrome MCP desktop 1440 + mobile 390, 0 console errors). If OK: cd "+l.path+" then rm .gate-handoff then relaunch. If something is off: write the fix into .loop/inject.md, then rm .gate-handoff and relaunch.",
  'GATE-REVIEW':l=>"The loop in "+l.path+" has a SUSPENDED gate (iter "+l.iter+"/"+l.max+"): the handoff commit has NOT been validated by the review yet (verdict missing, stale, or anchored on an old sha). DO NOT perform the visual gate: check the reviewer first ("+l.path+"/.loop/control/last-verdict.json, .monitor logs). If the loop is stopped, relaunch it: the review will run, then the gate will be handed to you.",
  RUNNING:l=>"Supervise the autonomous loop in "+l.path+" (RUNNING, iter "+l.iter+"/"+l.max+"). Arm a heartbeat monitor: LOOP_SCRIPT=loop.sh HEARTBEAT=1800 ./monitor-watch.sh "+l.path+"  — then alert me as soon as it hands off (.gate-handoff), stops, or STALLS (HEAD frozen while cycles rise).",
  STALLED:l=>"The loop in "+l.path+" looks STALLED (HEAD frozen, no activity). Inspect "+l.path+"/.monitor/*.err + the last verdict, diagnose (missing binary/token/model, or a spinning agent), then fix and relaunch, or stop it cleanly.",
  QUIET:l=>"The loop in "+l.path+" is RUNNING (process alive, pid "+l.pid+") but SILENT for "+Math.round((l.age||0)/60)+" min — likely a long task (build, heavy reasoning). Nothing urgent: just check "+l.path+"/.monitor/*.err is clean; intervene only if the silence far exceeds this project's normal build time.",
  DONE:l=>"The loop in "+l.path+" is DONE (.done). Verify the final result (green tests, DoD met), do the last visual gate if any, then clean up (.done, .monitor) if all good.",
  IDLE:l=>"The loop in "+l.path+" is IDLE. Resume it: read GOAL.md and PROGRESS.md, relaunch ./loop.sh, and arm a heartbeat monitor (./monitor-watch.sh "+l.path+")."
 },
 zh:{
  GATE:l=>"位于 "+l.path+" 的自主循环已移交，需要可视化/设备关卡（第 "+l.iter+"/"+l.max+" 轮）。需核对：\\n"+(l.gateText||"(见 "+l.path+"/.gate-handoff)")+"\\n\\n请做真实检查（Chrome MCP 桌面 1440 + 移动 390，控制台 0 错误）。若通过：cd "+l.path+" 然后 rm .gate-handoff 再重启循环。若有问题：把修正写入 .loop/inject.md，然后 rm .gate-handoff 并重启。",
  'GATE-REVIEW':l=>"位于 "+l.path+" 的循环有一个被暂停的关卡（第 "+l.iter+"/"+l.max+" 轮）：移交提交尚未通过审查（裁决缺失、过期或锚定在旧 sha 上）。请勿执行可视化关卡：先检查审查器（"+l.path+"/.loop/control/last-verdict.json、.monitor 日志）。若循环已停止，请重启它：审查将运行，然后关卡才会移交给你。",
  RUNNING:l=>"监督位于 "+l.path+" 的自主循环（运行中，第 "+l.iter+"/"+l.max+" 轮）。启动心跳监控：LOOP_SCRIPT=loop.sh HEARTBEAT=1800 ./monitor-watch.sh "+l.path+"  — 一旦它移交(.gate-handoff)、停止或空转（HEAD 冻结但轮次上升）立即通知我。",
  STALLED:l=>"位于 "+l.path+" 的循环疑似卡住（HEAD 冻结，无活动）。检查 "+l.path+"/.monitor/*.err 与最新裁决，诊断原因（缺少二进制/令牌/模型，或代理空转），然后修复重启，或干净地停止。",
  QUIET:l=>"位于 "+l.path+" 的循环仍在运行（进程存活，pid "+l.pid+"）但已静默 "+Math.round((l.age||0)/60)+" 分钟 — 可能在执行长任务（编译、深度推理）。不紧急：确认 "+l.path+"/.monitor/*.err 无异常即可；仅当静默远超该项目正常构建时长时才介入。",
  DONE:l=>"位于 "+l.path+" 的循环已完成(.done)。核对最终结果（测试通过、DoD 达成），如需做最后的可视化关卡，然后清理(.done, .monitor)。",
  IDLE:l=>"位于 "+l.path+" 的循环空闲。恢复它：阅读 GOAL.md 和 PROGRESS.md，重启 ./loop.sh，并启动心跳监控(./monitor-watch.sh "+l.path+")。"
 }
};
const promptFor=l=>{const P=PT[lang]||PT.fr; return (P[l.status]||P.IDLE)(l);};
const BUBBLE_SVG='<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 11.5a8 8 0 0 1-11.9 7L3 21l2.5-6.1A8 8 0 1 1 21 11.5z"/></svg>';
// « Mi » officiel Yumi (lettres M + i du logo YUMI, jaune #ffca2b) — marque les boucles orchestrées
// par le CLI yumi (flag l.yumi du scan : seed yumi:* dans le flux ou loop.conf).
const MI_SVG='<svg class="mi" viewBox="497 0 366 251" xmlns="http://www.w3.org/2000/svg"><title>orchestrateur yumi-code</title><g fill="#ffca2b"><path d="M498.73,238.41V7.3C498.73,3.27,502,0,506.03,0h43.55c2.63,0,5.06,1.42,6.36,3.71l74.02,131.03c2.8,4.95,9.93,4.95,12.72-.01L716.38,3.72C717.67,1.42,720.1,0,722.74,0h43.54c4.03,0,7.3,3.27,7.3,7.3v231.11c0,4.03-3.27,7.3-7.3,7.3h-40.5c-4.03,0-7.3-3.27-7.3-7.3v-106.22c0-7.54-10.04-10.14-13.69-3.54l-48.11,86.96c-1.29,2.32-3.73,3.77-6.39,3.77h-28.25c-2.66,0-5.1-1.44-6.39-3.77l-48.11-86.96c-3.65-6.6-13.69-4.01-13.69,3.54v106.22c0,4.03-3.27,7.3-7.3,7.3h-40.51c-4.03,0-7.3-3.27-7.3-7.3Z"/><path d="M806.57,92.79v145.63c0,4.03,3.27,7.3,7.3,7.3h41.21c4.03,0,7.3-3.27,7.3-7.3V92.79c0-2.38-1.93-4.31-4.31-4.31h-47.2c-2.38,0-4.31,1.93-4.31,4.31Z"/><rect x="806.57" y="58.68" width="55.81" height="11.85" rx="4.31"/><path d="M862.39,16.44V7.3c0-4.03-3.27-7.3-7.3-7.3h-41.21c-4.03,0-7.3,3.27-7.3,7.3v9.14c0,2.38,1.93,4.31,4.31,4.31h47.2c2.38,0,4.31-1.93,4.31-4.31Z"/><rect x="806.57" y="32.01" width="55.81" height="11.85" rx="4.31"/></g></svg>';
const promptBtn=l=>'<span class="cp pr" data-copy="'+esc(promptFor(l))+'" title="'+esc(t('copyPrompt'))+'">'+BUBBLE_SVG+'</span>';
const COPY_SVG='<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="9" y="9" width="11" height="11" rx="2"/><path d="M5 15V5a2 2 0 0 1 2-2h10"/></svg>';
const CHECK_SVG='<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M20 6 9 17l-5-5"/></svg>';
const copyBtn=p=>'<span class="cp" data-copy="'+esc(p)+'" title="'+esc(t('copy'))+'">'+COPY_SVG+'</span>';
const folderOf=p=>{const s=p.split('/');return s[s.length-2]||'—';};
function itemSub(l){ if(l.status==='GATE')return t('gateWaits'); if(l.status==='GATE-REVIEW')return t('gateReview'); const last=l.agents.flatMap(a=>a.log||[]).sort((x,y)=>x.t-y.t).pop(); return last?last.text:l.status.toLowerCase(); }
// Chip « lancé par » (attribution boucle → agent, .monitor/owner.json) — grisée si la boucle a été
// relancée depuis l'armement (owner.stale). Champs esc()'és : contenu de fichier non fiable.
function ownerChip(l){ if(!l.owner)return ''; const n=(l.owner.label||l.owner.agent_id).slice(0,16);
  return '<span class="ochip'+(l.owner.stale?' stale':'')+'" title="'+esc(t('launchedBy'))+' '+esc(l.owner.agent_id)
    +(l.owner.stale?' — '+esc(t('ownerStale')):'')+'">👤 '+esc(n)+'</span>'; }
const esc=s=>(s||'').replace(/[&<>"]/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'}[c]));
const tok=n=>n>=1000?Math.round(n/1000)+'k':(n||0);
const col=p=>p>=95?'#f85149':p>=80?'#d29922':p>=60?'#e3b341':'#3fb950';
const hm=t=>new Date(t).toLocaleTimeString([], {hour:'2-digit',minute:'2-digit',second:'2-digit'});
const dot=l=>'<span class="dot d-'+l.status+(l.live?' live':'')+'"></span>';
const liveBadge=l=>l.live?'<span class="live-badge on">● LIVE</span>':'<span class="live-badge">○ '+esc(t('inactive'))+'</span>';
function agentsTable(l){return '<table>'+l.agents.map(a=>{
  const ctx=a.pct===null?'<span style="color:var(--dim)">ctx n/a</span>'
    :'<span class="bar"><i style="width:'+a.pct+'%;background:'+col(a.pct)+'"></i></span> '+a.pct+'%';
  const out=a.est?'~'+tok(a.out)+' out':(a.ctx?'in '+tok(a.ctx)+'/':'')+'out '+tok(a.out);
  const c=(!a.est||a.cost>0)?'$'+a.cost.toFixed(2):'—';
  return '<tr><td class="m">'+esc(a.name)+(a.live?' <span class="dot d-RUNNING live"></span>':'')+'</td><td class="m">'+esc(a.model)+'</td><td>'+ctx+'</td><td>'+out
    +'</td><td>'+c+'</td><td>'+esc(a.tool)+'</td><td>'+(a.age??'?')+'s</td></tr>';}).join('')+'</table>';}
function card(l,mini){return '<div class="card '+l.status+(mini?' mini" data-go="'+esc(l.path):'')+'">'
  +'<div class="hd"><span class="nm">'+dot(l)+' '+esc(l.name)+'</span><span class="badge">'+l.status+'</span>'+liveBadge(l)
  +(l.max?'<span style="color:var(--dim)">itér. '+l.iter+'/'+l.max+'</span>':'')
  +ownerChip(l)
  +(l.anyReal?'<span style="color:var(--dim)">$'+l.cost.toFixed(2)+'</span>':'')
  +'<span class="pth">'+(mini?'':esc(l.path))+'</span>'+copyBtn(l.path)+promptBtn(l)+'</div>'
  +agentsTable(l)+(!mini&&l.gateText?'<div class="gt">'+esc(l.gateText)+'</div>':'')+'</div>';}
function feed(list,title){return '<div class="feed"><h3>'+title+'</h3>'+(list.length?list.map(e=>
  '<div class="ev k-'+esc(e.kind)+'"><span class="ti">'+hm(e.t)+'</span><span class="rp">'+esc(e.repo)
  +'</span><span class="tx">'+esc(e.text)+'</span></div>').join(''):'<div class="ev"><span class="tx">'+esc(t('feedEmpty'))+'</span></div>')+'</div>';}
function conversation(l){
  const msgs=l.agents.flatMap(a=>(a.log||[]).map(m=>({...m,who:a.name}))).sort((x,y)=>x.t-y.t);
  return '<div class="conv" id="conv">'+(msgs.length?msgs.map(m=>
    '<div class="msg '+esc(m.kind)+'"><span class="who">'+esc(m.who)+'</span><span class="bd">'+esc(m.text)+'</span></div>').join('')
    :'<div class="msg"><span class="bd" style="color:var(--dim)">'+esc(t('convEmpty'))+'</span></div>')+'</div>';
}
function render(){
  if(!S)return;
  const gates=S.loops.filter(l=>l.status==='GATE'), run=S.loops.filter(l=>l.status==='RUNNING');
  const prom=S.loops.filter(l=>['GATE','GATE-REVIEW','RUNNING','QUIET','STALLED'].includes(l.status));
  const rest=S.loops.filter(l=>['DONE','IDLE'].includes(l.status));
  if(tab!=='overview'&&!S.loops.some(l=>l.path===tab))tab='overview';
  document.getElementById('clk').textContent=new Date(S.ts).toLocaleTimeString();
  {
    const rank={GATE:0,'GATE-REVIEW':1,STALLED:2,QUIET:3,RUNNING:4,DONE:5,IDLE:6};
    const folders={}; for(const l of S.loops){const f=folderOf(l.path);(folders[f]=folders[f]||[]).push(l);}
    let nav='<div class="item'+(tab==='overview'?' on':'')+'" data-tab="overview">'
      +'<span style="width:9px;flex:none;text-align:center">📊</span>'
      +'<div class="ib"><div class="in">'+t('overview')+'</div>'
      +'<div class="is">'+t('ovSub')(S.loops.length,gates.length)+'</div></div></div>';
    for(const f of Object.keys(folders).sort()){
      const ls=folders[f].sort((a,b)=>(rank[a.status]-rank[b.status])||a.name.localeCompare(b.name));
      const ng=ls.filter(l=>l.status==='GATE').length, open=!collapsed.has(f);
      nav+='<div class="fold" data-fold="'+esc(f)+'"><span class="caret">'+(open?'▾':'▸')+'</span>📁 '+esc(f)
        +'<span class="fcount">'+ls.length+(ng?' · <b style="color:var(--gate)">'+ng+' gate</b>':'')+'</span></div>';
      if(open)nav+=ls.map(l=>'<div class="item sub'+(tab===l.path?' on':'')+'" data-tab="'+esc(l.path)+'">'+dot(l)
        +'<div class="ib"><div class="in">'+(l.yumi?MI_SVG:'')+esc(l.name)+ownerChip(l)+'</div><div class="is">'+esc(itemSub(l))+'</div></div>'
        +(l.status==='GATE'?'<span class="pill">GATE</span>':'')+copyBtn(l.path)+promptBtn(l)+'</div>').join('');
    }
    document.getElementById('nav').innerHTML=nav;
  }
  let h='';
  if(tab==='overview'){
    h+='<div class="kpis">'
      +'<div class="kpi"><b>'+S.loops.length+'</b><span>'+t('loops')+'</span></div>'
      +'<div class="kpi gate"><b>'+gates.length+'</b><span>'+t('waiting')+'</span></div>'
      +'<div class="kpi run"><b>'+run.length+'</b><span>'+t('running')+'</span></div>'
      +'<div class="kpi live"><b>'+S.loops.filter(l=>l.live).length+'</b><span>'+t('live')+'</span></div>'
      +'<div class="kpi"><b>$'+S.totalCost.toFixed(2)+'</b><span>'+t('cost')+'</span></div></div>';
    // Attribution : « lancé par X : N boucles » (agents ayant ≥1 boucle possédée ; sans owner = omis).
    {const own={}; for(const l of S.loops){ if(l.owner){const k=l.owner.label||l.owner.agent_id;own[k]=(own[k]||0)+1;} }
     const ok=Object.keys(own).sort();
     if(ok.length)h+='<div class="owners">'+ok.map(k=>'👤 '+t('launchedBy')+' <b>'+esc(k)+'</b> : '+own[k]+' '+t('loops')).join(' · ')+'</div>';}
    if(gates.length)h+='<div class="alert" data-go="'+esc(gates[0].path)+'">'+t('alert')(gates.length)+'</div>';
    // Seules GATE/RUNNING/STALLED en cartes. Terminées/idle repliées en une ligne (pas d'empilement).
    h+='<div class="cols"><div>'+(prom.length?prom.map(l=>card(l,true)).join(''):'<div class="collapsed">'+t('noActive')+'</div>')
      +(rest.length?'<div class="collapsed"><b>'+t('collapsed')+'</b> '+rest.map(l=>'<s data-go="'+esc(l.path)+'">'
        +(l.status==='DONE'?'✅ ':'💤 ')+esc(l.name)+'</s>').join('  ·  ')+'</div>':'')
      +'</div><div>'+feed(S.events,t('feed'))+'</div></div>';
  } else {
    const l=S.loops.find(x=>x.path===tab);
    h+=card(l,false)+conversation(l);
  }
  h+='<div class="ft">'+t('footer')+'</div>';
  document.getElementById('main').innerHTML=h;
  const c=document.getElementById('conv'); if(c)c.scrollTop=c.scrollHeight;   // tail live de la conversation
}
document.addEventListener('click',e=>{
  const cp=e.target.closest('[data-copy]'); if(cp){ e.stopPropagation();
    navigator.clipboard.writeText(cp.dataset.copy).then(()=>{cp.innerHTML=CHECK_SVG;cp.style.color='var(--run)';cp.style.opacity=1;
      setTimeout(()=>{cp.innerHTML=COPY_SVG;cp.style.color='';cp.style.opacity='';},1200);}).catch(()=>{}); return; }
  const lb=e.target.closest('[data-lang]'); if(lb){ lang=lb.dataset.lang; document.documentElement.lang=lang;
    document.querySelectorAll('.lng').forEach(b=>b.classList.toggle('on',b.dataset.lang===lang)); render(); return; }
  if(e.target.closest('[data-theme-toggle]')){ toggleTheme(); return; }
  const f=e.target.closest('[data-fold]'); if(f){const k=f.dataset.fold; collapsed.has(k)?collapsed.delete(k):collapsed.add(k); render(); return;}
  const tb=e.target.closest('[data-tab]'); if(tb){tab=tb.dataset.tab;render();return;}
  const g=e.target.closest('[data-go]'); if(g){tab=g.dataset.go;render();}
});
updateThemeIcon();
document.querySelectorAll('.lng').forEach(b=>b.classList.toggle('on',b.dataset.lang===lang));
new EventSource('/events').onmessage=e=>{S=JSON.parse(e.data);render();};
</script>`;

const clients = new Set();
createServer((req, res) => {
  if (req.url === "/events") {
    res.writeHead(200, { "Content-Type": "text/event-stream", "Cache-Control": "no-cache", Connection: "keep-alive" });
    clients.add(res);
    res.write(`data: ${JSON.stringify(tick())}\n\n`);
    req.on("close", () => clients.delete(res));
    return;
  }
  if (req.url === "/api/loops") {
    res.writeHead(200, { "Content-Type": "application/json" });
    return res.end(JSON.stringify(tick(), null, 2));
  }
  res.writeHead(200, { "Content-Type": "text/html; charset=utf-8" });
  res.end(PAGE);
}).listen(PORT, "127.0.0.1", () => {   // 127.0.0.1 : jamais exposé au réseau
  console.log(`Autonomous Loops · hub → http://localhost:${PORT}`);
  console.log(`  scan : ${ROOTS.join(", ")} (profondeur ${DEPTH}, toutes les ${SCAN_MS}ms)`);
});

setInterval(() => {
  const snap = tick();                          // scanne + détecte les événements même sans client
  if (!clients.size) return;
  const data = `data: ${JSON.stringify(snap)}\n\n`;
  for (const c of clients) c.write(data);
}, SCAN_MS);
