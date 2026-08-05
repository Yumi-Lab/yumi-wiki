#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# Boucle de codage autonome — une session agent par itération, jusqu'à terminé.
#
#   Chaque itération = une session agent FRAÎCHE (contexte propre) qui :
#     1. lit GOAL.md (la définition de « fini ») + PROGRESS.md (l'état/les cases)
#     2. lit .loop/inject.md (canal temps réel : tu peux y écrire pendant le run)
#     3. prend la prochaine case non cochée, l'implémente, la teste, la coche, commit
#     4. crée le fichier sentinelle ($DONE_FILE) quand TOUT est fini → la boucle s'arrête
#
#   MODE CONTRÔLÉ (loop.conf reviewer=true) : après la CODEUSE, une CONTRÔLEUSE (instance
#   fraîche, read-only) écrit un verdict (.loop/control/last-verdict.json) que la codeuse
#   applique au tour suivant. En mode contrôlé, .done n'est ACCEPTÉ que si verdict=PASS.
#
#   MULTI-PROVIDER — coder_model/reviewer_model route dans run_agent() : `kimi` → Kimi Code,
#   `grok` → Grok (xAI), `mistral|vibe|devstral|mistral-local` → Mistral Vibe, `run_custom`
#   (hook loop.conf) → CLI custom, sinon → `claude`. Routage INSENSIBLE À LA CASSE.
#
#   GARDE-FOUS (anti-runaway) : preflight (fichiers/config/binaire), fail-fast sur échec
#   provider (max_fails), garde de non-progrès git (max_stale), anti ping-pong revue
#   (max_cr), plafond de coût (max_cost), verrou une-boucle-par-repo, verify.sh mécanique.
#
#   GATE-HANDOFF (gate_handoff=true) : la codeuse écrit $HANDOFF_FILE + STOP → cède la main.
#   DÉPLOIEMENT LIVE (deploy_cmd) : déploie après TEST vert puis gate health_url. Vide = local.
#
# Usage :   ./loop.sh [--help|--dry-run|--fresh]   (depuis la racine de TON projet)
#   --fresh : GARANTIT la dernière version du kit avant de démarrer — pull du kit
#             (KIT_DIR, défaut ~/Documents/GitHub/autonomous-loop-kit) + sync-kit.sh vers ce
#             projet + activation de loop.sh.new, puis relance sur la version à jour.
# Réglages : voir loop.conf (mode contrôlé, multi-provider, gardes, gate-handoff, deploy).
#   Env aussi supportés : MAX_ITERS MAX_TURNS MODEL DONE_FILE PROMPT_FILE CTX_WINDOW …
# Prérequis : claude (CLI), jq (optionnel mais recommandé), git ; kimi/vibe si utilisés.
# ─────────────────────────────────────────────────────────────────────────────

# 🛡️ Garde anti-source (anti-runaway) : un `source loop.sh` NE LANCE PAS la boucle.
_SOURCED=0
if [ -n "${ZSH_VERSION:-}" ]; then
  case "${ZSH_EVAL_CONTEXT:-}" in *file*) _SOURCED=1;; esac
elif [ -n "${BASH_VERSION:-}" ] && [ "${BASH_SOURCE:-$0}" != "$0" ]; then
  _SOURCED=1
fi
if [ "$_SOURCED" = 1 ]; then
  echo "⚠️ loop.sh sourcé (pas exécuté) → boucle NON lancée (anti-runaway)." >&2
  return 0 2>/dev/null || exit 0
fi

set -uo pipefail
cd "$(dirname "$0")"

# --- Args : --help / --dry-run / --fresh ------------------------------------
DRY_RUN=0; FRESH=0
case "${1:-}" in
  -h|--help)    awk '/^# ─/{n++; next} n==1{sub(/^# ?/,""); print} n>=2{exit}' "$0"; exit 0;;
  -n|--dry-run) DRY_RUN=1;;
  --fresh|--sync-first) FRESH=1;;
  '' ) ;;
  *) echo "option inconnue: $1 (essaie --help)" >&2; exit 2;;
esac

# --- --fresh : GARANTIT la dernière version du kit avant de démarrer ---------
# pull du kit + sync-kit.sh vers CE projet + activation de loop.sh.new, puis ré-exec sur la
# nouvelle version (LOOP_FRESH_DONE coupe la récursion). Sûr : on n'a pas encore pris le verrou,
# sync-kit remplace donc loop.sh en atomique ; le process courant garde son ancien inode et
# exec bascule proprement sur le nouveau. KIT_DIR surchargable (pads/serveurs, chemins ≠ Mac).
if [ "$FRESH" = 1 ] && [ -z "${LOOP_FRESH_DONE:-}" ]; then
  KIT_DIR="${KIT_DIR:-$HOME/Documents/GitHub/autonomous-loop-kit}"
  if [ -d "$KIT_DIR" ]; then
    git -C "$KIT_DIR" pull --ff-only 2>/dev/null | tail -1 \
      || echo "⚠ --fresh : pull du kit impossible (offline ?) — version LOCALE du kit utilisée." >&2
    [ -x "$KIT_DIR/sync-kit.sh" ] && "$KIT_DIR/sync-kit.sh" "$PWD" | tail -2
    if [ -f loop.sh.new ]; then mv -f loop.sh.new loop.sh && chmod +x loop.sh; fi
    echo "↻ --fresh : kit $(git -C "$KIT_DIR" log -1 --format=%h 2>/dev/null || echo '?') synchronisé → relance sur la version à jour."
    LOOP_FRESH_DONE=1 exec "$0" "$@"
  else
    echo "⚠ --fresh : kit introuvable ($KIT_DIR) — définis KIT_DIR=… ; démarrage sur la version locale." >&2
  fi
fi

# --- Config file (optionnel) : rôles + modèle par instance + limites ---------
LOOP_CONF="${LOOP_CONF:-loop.conf}"
case "$LOOP_CONF" in */*) ;; *) LOOP_CONF="./$LOOP_CONF";; esac   # force le cwd (sinon `.` cherche PATH)
[ -f "$LOOP_CONF" ] && . "$LOOP_CONF"

is_true() { case "$(printf '%s' "${1:-}" | tr '[:upper:]' '[:lower:]')" in true|1|yes|on|y) return 0;; *) return 1;; esac; }

MONITOR_DIR="${MONITOR_DIR:-.monitor}"
DONE_FILE="${DONE_FILE:-.done}"
INJECT_FILE="${INJECT_FILE:-.loop/inject.md}"
PROMPT_FILE="${PROMPT_FILE:-PROMPT.md}"
MAX_ITERS="${max_iters:-${MAX_ITERS:-60}}"
MAX_TURNS="${coder_max_turns:-${MAX_TURNS:-80}}"

# Rôles + modèle PAR instance (conf > env > défaut). reviewer OFF par défaut → compat.
coder="${coder:-true}"
reviewer="${reviewer:-false}"
coder_model="${coder_model:-${MODEL:-}}"
reviewer_model="${reviewer_model:-}"
REVIEWER_MAX_TURNS="${reviewer_max_turns:-40}"
CODER_PROMPT_FILE="${coder_prompt:-prompts/coder.md}"
REVIEWER_PROMPT_FILE="${reviewer_prompt:-prompts/reviewer.md}"
CTL_DIR="${CTL_DIR:-.loop/control}"
VERDICT_FILE="$CTL_DIR/last-verdict.json"

# Garde-fous anti-runaway (surchargeable via loop.conf/env).
MAX_FAILS="${max_fails:-3}"      # échecs provider consécutifs → abandon
MAX_STALE="${max_stale:-4}"      # itérations sans nouveau commit → arrêt
MAX_CR="${max_cr:-3}"            # verdicts CHANGES_REQUESTED d'affilée sur le même HEAD → arrêt
MAX_REVIEW_RETRY="${max_review_retry:-3}"  # revues consécutives SANS verdict frais (contrôleuse morte/JSON illisible) → arrêt
FALLBACK_MODELS="${fallback_models:-}"     # FAILOVER crédit/panne : modèles de secours essayés en rotation (vide = off)
PROBE_EVERY="${probe_every:-3}"            # en failover : sonde le modèle primaire toutes les N itérations

# Hygiène de contexte : inject.md et PROGRESS.md sont relus INTÉGRALEMENT à chaque tour par les
# DEUX agents — trop gros = tours épuisés en lecture (vécu : inject 266 lignes + PROGRESS 213 Ko).
INJECT_WARN_LINES="${inject_warn_lines:-120}"      # seuil (lignes) → consigne d'archivage injectée
PROGRESS_WARN_BYTES="${progress_warn_bytes:-153600}"  # seuil (octets, déf. 150 Ko) pour PROGRESS.md

# Gate-handoff : la codeuse peut céder la main pour un gate visuel/device (écrit HANDOFF_FILE + STOP).
GATE_HANDOFF="${gate_handoff:-true}"
HANDOFF_FILE="${handoff_file:-.gate-handoff}"

# Déploiement live (optionnel, générique) : TA commande, injectée dans le prompt de la codeuse.
DEPLOY_CMD="${deploy_cmd:-}"
HEALTH_URL="${health_url:-}"

JQ="$(command -v jq || true)"

# Formate le flux stream-json en sortie lisible (texte + nom des outils) ; repli brut sans jq.
# Gère le style Claude (.type=="assistant", .message.content[]) ET le style OpenAI/Vibe/Kimi
# (.role=="assistant", .content + .tool_calls[]) → une seule vue quel que soit le provider.
fmt() {
  if [ -n "$JQ" ]; then
    "$JQ" --unbuffered -Rrj 'fromjson? | if (type!="object") then ""
      elif .type=="assistant" then
        (if (.message.content|type)=="string" then ((.message.content // "")
          + (if (.message.tool_calls|type)=="array" then ([.message.tool_calls[]? | (.function.name // .name // "?")] | map("\n  → "+.) | join("")) + "\n" else "" end))
        else (.message.content[]?
          | if .type=="text" then .text
            elif .type=="tool_use" then "\n  → "+.name+"\n"
            else "" end) end)
      elif .role=="assistant" then ((.content // "")
        + (if (.tool_calls|type)=="array" then ([.tool_calls[]? | (.function.name // "?")] | map("\n  → "+.) | join("")) + "\n" else "" end))
      elif .role=="meta" then (if .type=="turn.step.retrying" then ("\n  ⟳ retry "+((.next_attempt // 0)|tostring)+"/"+((.max_attempts // 0)|tostring)+" — "+(.error_name // "erreur provider")+"\n") else "" end)
      elif .type=="text" then (.data // "")
      elif .type=="result" then "\n[✓ itération terminée]\n"
      else "" end'
  else
    cat
  fi
}

# --- Prompts de rôle ---------------------------------------------------------
# CODEUSE : PROMPT_FILE custom > fichier de rôle > prompt de repli intégré (renforcé).
if [ -f "$PROMPT_FILE" ]; then
  CODER_PROMPT="$(cat "$PROMPT_FILE")"
elif [ -f "$CODER_PROMPT_FILE" ]; then
  CODER_PROMPT="$(cat "$CODER_PROMPT_FILE")"
else
  echo "⚠️  $CODER_PROMPT_FILE (et $PROMPT_FILE) absents → prompt de repli minimal. Copie le dossier prompts/." >&2
  read -r -d '' CODER_PROMPT <<PROMPT
You are an autonomous coding agent. On EVERY iteration:
1. Read GOAL.md (the Definition of Done) and PROGRESS.md (the state) BEFORE anything.
2. Then read $INJECT_FILE (the user's real-time channel): handle active requests FIRST, then MOVE the
   processed entries to .loop/inject-archive.md (append, keep order) — never leave them in the channel.
3. Take the NEXT unchecked box in PROGRESS.md, implement it FULLY, test it. ONE batch per iteration.
4. Check a box ONLY if its PROGRESS.md Journal entry contains a PROOF block: the exact command(s) you ran
   + the last ~5 lines of their REAL output. No PROOF = box stays unchecked. Then git commit ('wip: <task>')
   with TARGETED staging (git add the batch files one by one — NEVER git add -A). No AI-tool mention.
5. Create $DONE_FILE only when the WHOLE DoD is met AND tests are green — and in controlled mode ONLY if the
   last verdict ($VERDICT_FILE) is PASS.
PROMPT
fi

# CONTRÔLEUSE : fichier de rôle > prompt de repli intégré (JSON strict).
if [ -f "$REVIEWER_PROMPT_FILE" ]; then
  REVIEWER_PROMPT="$(cat "$REVIEWER_PROMPT_FILE")"
else
  read -r -d '' REVIEWER_PROMPT <<PROMPT
You are the QUALITY REVIEWER — READ-ONLY review. You modify NO code, commit NOTHING, check/uncheck
NOTHING. Sole deliverable = a verdict file. Adversarial: rediscover the diff cold. RE-VERIFY every claim
('tests green', 'deployed') with YOUR OWN tool results — never on trust.
0. FIRST ACTION — read the existing $VERDICT_FILE and NOTE its .head (anchor of the range to review:
last REAL review → HEAD), then overwrite it as {"head":"<the PREVIOUS .head, copied — NOT current
HEAD; current sha only if no file existed>","verdict":"CHANGES_REQUESTED","provisional":true,
"blocking":["review in progress"]} ; REFINE it into the final verdict (WITHOUT "provisional", and
only THAT one carries the new HEAD sha) — a provisional verdict surviving your death beats no verdict.
1. Read GOAL.md (DoD + rules). 2. \`git show --stat HEAD\` then \`git show HEAD\` (the diff) +
the last PROGRESS.md Journal entry. 3. Read $CTL_DIR/log.md (previous verdicts).
4. VERIFY: green tests (RUN them), DoD actually met, anti-hardcoding/DRY, hygiene (clear commit, no secret,
no AI-tool mention, GOAL.md rules). 5. WRITE $VERDICT_FILE as STRICT JSON ONLY — no markdown fence, no prose,
it MUST parse with \`jq .\`:
{"head":"<sha>","verdict":"PASS"|"CHANGES_REQUESTED","tests":"green"|"red"|"harness-error"|"not-run",
"blocking":[…],"advisory":[…],"summary":"…"} (CHANGES_REQUESTED as soon as ≥1 blocker). Each blocking point
PRESCRIPTIVE (file:line + concrete fix + validation criterion). Also append a dated section to $CTL_DIR/log.md
(🟢/🟡/🔴, file:line). FIX NOTHING.
6. TURN BUDGET: you have a HARD turn cap — WRITE the verdict file BEFORE reaching it. Large range
(multi-commit catch-up)? Verify the essentials (tests, DoD, hygiene) and write EARLY; what you could NOT
verify goes in 'blocking' ("not verified: …"). A review that dies without a verdict is worse than a
partial one.
PROMPT
fi

# --- run_agent : UNE exécution, statut de l'AGENT renvoyé (pas de fmt) -------
# $1 label · $2 prompt · $3 jsonl · $4 max-turns · $5 modèle. Routage insensible à la casse.
#   kimi → Kimi Code (pas de --max-turns exposé par ce CLI : tours non bornés côté kimi → gardes de boucle)
#   mistral|vibe|devstral|mistral-local → Mistral Vibe   ·   yumi[:<modèle>] → CLI yumi (clone Go iso claude)
#   run_custom (loop.conf) → CLI custom
#   sinon → claude (--allowedTools si allowed_tools défini, sinon --dangerously-skip-permissions)
# stderr → fichier .err (JAMAIS dans le .jsonl : il peut contenir des fragments de secrets). stdin coupé.
run_agent() {  # shlint-ok (affichage direct du flux, jamais capturée par $(...))
  local label="$1" prompt="$2" jsonl="$3" turns="$4" model="${5:-}"
  echo; echo "── $label · modèle=${model:-défaut} · $(date '+%H:%M:%S') ──────────────"
  local m; m="$(printf '%s' "$model" | tr '[:upper:]' '[:lower:]')"
  local cmd=()
  if [ "$m" = kimi ] || [ "${m#kimi:}" != "$m" ]; then
    # Convention par instance : <rôle>_model=kimi:<modèle> (prioritaire sur kimi_model global).
    # Alias lisibles → clés du registre kimi (~/.kimi-code/config.toml) :
    #   k2.7 (256k) → kimi-code/kimi-for-coding · k3 (1M) → kimi-code/k3 · k3-256k → kimi-code/k3-256k
    #   (registre renommé kimi-for-coding/* → kimi-code/* avec kimi 0.32 : anciennes clés remappées)
    cmd=("${kimi_bin:-$HOME/.kimi-code/bin/kimi}" --output-format stream-json)
    local kmodel="${kimi_model:-}"
    case "$model" in *:*) kmodel="${model#*:}";; esac
    case "$(printf '%s' "$kmodel" | tr '[:upper:]' '[:lower:]')" in
      k2.7|k27|k2)              kmodel="kimi-code/kimi-for-coding";;
      k3)                       kmodel="kimi-code/k3";;
      k3-256k|k3-256)           kmodel="kimi-code/k3-256k";;
      highspeed|k2.7-highspeed) kmodel="kimi-code/kimi-for-coding-highspeed";;
      # Clés COMPLÈTES de l'ancien registre (loop.conf de la flotte figés avant kimi 0.32) → remap :
      kimi-for-coding/kimi-for-coding)           kmodel="kimi-code/kimi-for-coding";;
      kimi-for-coding/k3)                        kmodel="kimi-code/k3";;
      kimi-for-coding/kimi-for-coding-highspeed) kmodel="kimi-code/kimi-for-coding-highspeed";;
    esac
    [ -n "$kmodel" ] && cmd+=(-m "$kmodel")
    cmd+=(-p "$prompt")
  elif [ "$m" = grok ]; then
    # CLI Grok (xAI) — calque les conventions Claude Code. --always-approve = autonomie (auto-approve
    # des outils), --cwd "$PWD" PIN le repo courant. streaming-json = format PROPRE à grok
    # ({"type":"thought|text|end"}), rendu par fmt() ; pas de télémétrie tokens/coût émise (cf. monitor).
    local gbin="${grok_bin:-$(command -v grok 2>/dev/null || echo "$HOME/.local/bin/grok")}"
    cmd=("$gbin" -p "$prompt" --output-format streaming-json --max-turns "$turns" --always-approve --cwd "$PWD")
    [ -n "${grok_model:-}" ] && cmd+=(-m "$grok_model")
  elif [ "$m" = mistral ] || [ "$m" = vibe ] || [ "$m" = devstral ] || [ "$m" = mistral-local ]; then
    local vbin="${vibe_bin:-$(command -v vibe 2>/dev/null || echo "$HOME/.local/bin/vibe")}"
    local vmodel="${vibe_model:-}"
    if [ -z "$vmodel" ]; then case "$m" in
        devstral)      vmodel=devstral-small;;
        mistral-local) vmodel=local;;
        *)             vmodel=mistral-medium-3.5;;
      esac; fi
    # --workdir "$PWD" PIN le repo courant (SANS ça Vibe peut résoudre le contexte vers un autre repo).
    cmd=(env "VIBE_ACTIVE_MODEL=$vmodel" VIBE_INCLUDE_COMMIT_SIGNATURE=false \
      "$vbin" -p "$prompt" --output streaming --max-turns "$turns" --yolo --trust --workdir "$PWD")
    [ -n "${vibe_max_price:-}" ] && cmd+=(--max-price "$vibe_max_price")
  elif [ "$m" = yumi ] || [ "${m#yumi:}" != "$m" ]; then
    # CLI yumi (clone Go iso Claude Code — repo yumi-cli) : mêmes flags/stream-json que claude,
    # ~10x moins de RAM par session, mêmes credentials (lecture seule) et même quota.
    # Convention : <rôle>_model=yumi:<modèle> (alias haiku/sonnet/opus/fable résolus par yumi comme
    # le vrai client) ; `yumi` seul = modèle par défaut du CLI. Émet total_cost_usd → max_cost/dash OK.
    local ybin="${yumi_bin:-$(command -v yumi 2>/dev/null || echo "$HOME/.local/bin/yumi")}"
    cmd=("$ybin" --dangerously-skip-permissions)
    local ymodel=""; case "$model" in *:*) ymodel="${model#*:}";; esac
    [ -n "$ymodel" ] && cmd+=(--model "$ymodel")
    cmd+=(--max-turns "$turns" --output-format stream-json --verbose -p "$prompt")
  elif type run_custom >/dev/null 2>&1; then
    # Hook générique loop.conf : run_custom() lit AGENT_PROMPT/AGENT_MODEL/AGENT_TURNS ; doit sortir du
    # JSON en streaming (style Claude ou OpenAI, fmt() gère les deux). Ex. Qwen/Ollama/gateway maison.
    export AGENT_PROMPT="$prompt" AGENT_MODEL="$model" AGENT_TURNS="$turns"
    cmd=(run_custom)
  else
    if [ -n "${allowed_tools:-}" ]; then cmd=(claude --allowedTools "$allowed_tools")
    else cmd=(claude --dangerously-skip-permissions); fi
    # Opus 5 est dispo EN PARALLÈLE d'Opus 4.8 (même tarif, buckets de rate-limit séparés) :
    # 'opus' seul = alias du CLI (résout vers Opus 5) ; pour ÉPINGLER une version, alias lisibles
    # opus-5 / opus-4.8 (ou sonnet-5) → ids complets. Mix par instance possible (codeuse opus-5 +
    # contrôleuse opus-4.8 = buckets distincts, double headroom).
    local cmodel="$model"
    case "$(printf '%s' "$cmodel" | tr '[:upper:]' '[:lower:]')" in
      opus-5|opus5)                    cmodel="claude-opus-5";;
      opus-4.8|opus-4-8|opus48)       cmodel="claude-opus-4-8";;
      sonnet-5|sonnet5)                cmodel="claude-sonnet-5";;
    esac
    [ -n "$cmodel" ] && cmd+=(--model "$cmodel")
    cmd+=(--max-turns "$turns" --output-format stream-json --verbose -p "$prompt")
  fi
  "${cmd[@]}" < /dev/null 2>"$MONITOR_DIR/${label}.err" | tee -a "$jsonl" | fmt
  return "${PIPESTATUS[0]}"
}

# --- Failover crédit/panne provider (fallback_models) ------------------------
# provider_of : famille de CLI d'un mot-clé modèle (pour savoir si la contrôleuse partage le
# provider en panne de la codeuse et doit basculer avec elle).
provider_of() { case "$(printf '%s' "${1:-}" | tr '[:upper:]' '[:lower:]')" in
  kimi|kimi:*) echo kimi;; grok) echo grok;; mistral|vibe|devstral|mistral-local) echo vibe;;
  yumi|yumi:*) echo yumi;; *) echo claude;; esac; }
# fb_pick N : Nième modèle (1-based) de FALLBACK_MODELS (liste de mots — pas de tableau bash : 3.2).
fb_pick() { local n="$1" c=0 m; for m in $FALLBACK_MODELS; do c=$((c+1)); [ "$c" -eq "$n" ] && { printf '%s' "$m"; return 0; }; done; }
# probe_model M : UNE requête minimale (1 tour, sortie jetée) — 0 = le provider répond (crédit OK).
probe_model() { run_agent "PROBE" "Reply with exactly: ok" /dev/null 1 "$1" >/dev/null 2>/dev/null; }

# --- Notes injectées EN TÊTE du prompt codeuse selon la config (génériques) --
CODER_EXTRA=""
if [ -n "$DEPLOY_CMD" ]; then
  CODER_EXTRA="$CODER_EXTRA
LIVE DEPLOYMENT (configured) — after a green TEST, DEPLOY with: \`$DEPLOY_CMD\`."
  [ -n "$HEALTH_URL" ] && CODER_EXTRA="$CODER_EXTRA Then GATE the live: wait for HTTP 200 on $HEALTH_URL BEFORE checking off."
  CODER_EXTRA="$CODER_EXTRA Live broken/not deployed → ROLLBACK (last green commit) and DO NOT check off."
fi
if is_true "$GATE_HANDOFF"; then
  CODER_EXTRA="$CODER_EXTRA
VISUAL/DEVICE GATE — if the DoD needs a browser/device check you CANNOT do alone (no Chrome MCP, physical device…): leave the box UNCHECKED, add a Journal line 'GATE PENDING: <box> — <URL/checklist>', do NOT create $DONE_FILE, write $HANDOFF_FILE (URL + checklist), then STOP (hand off to the human). On resume (handoff file gone) if a box is complete except its visual/device gate AND a matching 'GATE PENDING' line exists, treat the human as having PASSED it: check it off (Journal 'GATE PASS (human)'), don't redo the work. NEVER bypass, never indirect proof via bundle/screenshot."
fi

# WATCHDOG.md présent → préambule STEP 0 en TÊTE du prompt (garanti même avec un prompt custom).
WATCHDOG_NOTE=""
[ -f WATCHDOG.md ] && WATCHDOG_NOTE="STEP 0 — read WATCHDOG.md FIRST: it describes the autonomous device you run inside (loop + watchdog auto-restart + $MONITOR_DIR/.lock lock + roles) and its hard rules — don't break the watchdog/lock, don't start a 2nd loop, create $DONE_FILE ONLY when everything is finished AND verified (it cleanly stops both loop and watchdog). Respect it before anything else.

"

# --- Récapitulatif de config (affiché au démarrage / --dry-run) -------------
print_config() {  # shlint-ok (affichage pur)
  local mode; mode=$(is_true "$reviewer" && echo 'coder+reviewer' || echo 'coder-only')
  echo "── config · mode=$mode · jq=$([ -n "$JQ" ] && echo oui || echo 'NON(sortie brute)') · gate_handoff=$GATE_HANDOFF"
  printf '   coder=%s(model=%s,turns=%s) · reviewer=%s(model=%s,turns=%s) · max_iters=%s\n' \
    "$coder" "${coder_model:-défaut}" "$MAX_TURNS" "$reviewer" "${reviewer_model:-défaut}" "$REVIEWER_MAX_TURNS" "$MAX_ITERS"
  printf '   gardes: max_fails=%s max_stale=%s max_cr=%s max_review_retry=%s%s\n' "$MAX_FAILS" "$MAX_STALE" "$MAX_CR" "$MAX_REVIEW_RETRY" \
    "$([ -n "${max_cost:-}" ] && echo " · budget=\$$max_cost" || echo "")"
  [ -n "$DEPLOY_CMD" ] && printf '   deploy=%s · health=%s\n' "$DEPLOY_CMD" "${HEALTH_URL:-aucun}"
  [ -x ./verify.sh ] && echo '   verify.sh → gate mécanique actif'
  type run_custom >/dev/null 2>&1 && echo '   run_custom (provider custom via loop.conf) actif'
}

# --dry-run : montre la config + un aperçu du prompt codeuse, sans rien lancer ni écrire.
if [ "$DRY_RUN" = 1 ]; then
  print_config
  echo; echo "--- DRY RUN · aperçu prompt CODEUSE (12 premières lignes) ---"
  printf '%s\n' "$CODER_PROMPT" | sed -n '1,12p'
  exit 0
fi

# --- Runtime : dossiers, verrou, traps, seed monitor, .env, préflight -------
if ! is_true "$coder" && ! is_true "$reviewer"; then
  echo "loop.conf : coder ET reviewer à false — rien à faire."; exit 1
fi

mkdir -p "$MONITOR_DIR" "$CTL_DIR"

# Verrou une-boucle-par-repo (mkdir atomique, portable bash 3.2). Nettoyé par le trap EXIT.
LOCK="$MONITOR_DIR/.lock"
if [ -f "$LOCK/pid" ] && [ "$(cat "$LOCK/pid" 2>/dev/null)" = "$$" ]; then
  : # auto-update : exec conserve le PID → ce verrou est DÉJÀ le nôtre, on le garde tel quel.
elif ! mkdir "$LOCK" 2>/dev/null; then
  _op="$(cat "$LOCK/pid" 2>/dev/null || echo '?')"
  echo "⛔ Une boucle tourne déjà dans ce repo ($LOCK, pid=$_op)." >&2
  echo "   Si c'est un résidu (process mort) : rm -rf $LOCK" >&2; exit 1
fi
echo $$ > "$LOCK/pid"   # PID de la boucle → permet un stop/restart propre (hub, loop-agent)
cleanup() { rm -f "$LOCK/pid" 2>/dev/null; rmdir "$LOCK" 2>/dev/null || true; }
trap 'cleanup' EXIT
trap 'echo; echo "⏹ interrompu — état sauvé (PROGRESS.md + git). Relance ./loop.sh pour continuer."; exit 130' INT TERM

# Réinitialise le flux d'un rôle et l'AMORCE avec le modèle configuré (libellé + fenêtre de contexte
# corrects dès le départ, même pour kimi/vibe qui n'émettent pas leur modèle). Modèle vide → le vrai
# stream-json claude fournit le modèle exact (tag [1m] éventuel).
seed_jsonl() {  # $1 = fichier jsonl · $2 = modèle configuré (peut être vide)
  : > "$1"
  [ -n "${2:-}" ] && printf '{"type":"system","subtype":"init","model":"%s"}\n' "$2" >> "$1"
}
json_str() {  # échappe une valeur pour un champ JSON (bash 3.2 : pattern substitution suffit)
  local s=${1//\\/\\\\}; s=${s//\"/\\\"}; s=${s//$'\n'/ }; s=${s//$'\r'/ }; s=${s//$'\t'/ }
  printf '%s' "$s"
}
# Après un auto-update (LOOP_RESUME), on NE retronque PAS les jsonl : la télémétrie du run
# (coût cumulé, contexte) survit à la bascule de version.
if [ -z "${LOOP_RESUME:-}" ]; then
  is_true "$coder"    && seed_jsonl "$MONITOR_DIR/coder-main.jsonl" "$coder_model"
  is_true "$reviewer" && seed_jsonl "$MONITOR_DIR/reviewer.jsonl"   "$reviewer_model"
fi
mkdir -p "$(dirname "$INJECT_FILE")"; touch "$INJECT_FILE"

# Secrets/config locaux : .env à la racine est PARSÉ (KEY=VALUE), jamais SOURCÉ → pas d'exécution de
# shell (pas de RCE si .env hostile). Lignes non KEY=VALUE et commentaires ignorés. Ne committe jamais .env.
if [ -f .env ]; then
  while IFS= read -r _l || [ -n "$_l" ]; do
    case "$_l" in ''|[[:space:]]*\#*|\#*) continue;; *=*) ;; *) continue;; esac
    _k="${_l%%=*}"; _v="${_l#*=}"
    _v="${_v%\"}"; _v="${_v#\"}"; _v="${_v%\'}"; _v="${_v#\'}"   # retire une paire de guillemets
    case "$_k" in *[!A-Za-z0-9_]*) continue;; esac              # nom de var valide seulement
    export "$_k=$_v"
  done < .env
fi

# ATTRIBUTION boucle → agent (owner) : si l'agent qui ARME la boucle exporte LOOP_OWNER_ID (identité
# gateway OPAQUE, copiée verbatim — jamais dérivée localement), on écrit le MIROIR local
# $MONITOR_DIR/owner.json (ATOMIQUE : tmp + mv) lu par scan.mjs/hub.mjs (« lancé par X : N boucles »).
# Optionnels : LOOP_OWNER_LABEL (affichage), LOOP_OWNER_SOURCE (déf. env), LOOP_OWNER_CONTEXT
# (contextId A2A, futur orchestrateur). Sémantique : owner = QUI A ARMÉ la boucle (durable) — env
# absent = fichier INTACT (relances watchdog/remote/--fresh sans env ne l'effacent jamais) ;
# LOOP_RESUME (auto-update, même run) ne réécrit pas started_at. L'agent lanceur peut aussi écrire
# le fichier lui-même (voie compatible avec tout loop.sh) : même contrat, écriture atomique exigée.
if [ -n "${LOOP_OWNER_ID:-}" ] && [ -z "${LOOP_RESUME:-}" ]; then
  {
    printf '{"agent_id":"%s","source":"%s"' "$(json_str "$LOOP_OWNER_ID")" "$(json_str "${LOOP_OWNER_SOURCE:-env}")"
    [ -n "${LOOP_OWNER_LABEL:-}" ]   && printf ',"label":"%s"'      "$(json_str "$LOOP_OWNER_LABEL")"
    [ -n "${LOOP_OWNER_CONTEXT:-}" ] && printf ',"context_id":"%s"' "$(json_str "$LOOP_OWNER_CONTEXT")"
    printf ',"started_at":"%s"}\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  } > "$MONITOR_DIR/.owner.tmp" && mv -f "$MONITOR_DIR/.owner.tmp" "$MONITOR_DIR/owner.json" \
    && echo "👤 owner.json : boucle armée par ${LOOP_OWNER_LABEL:-$LOOP_OWNER_ID}."
fi

# Préflight : échoue TÔT plutôt qu'au bout de MAX_ITERS.
[ -f "$DONE_FILE" ] && { echo "Déjà terminé ($DONE_FILE). Supprime-le pour relancer."; exit 0; }
for f in GOAL.md PROGRESS.md; do
  [ -f "$f" ] || { echo "❌ $f manquant — copie les gabarits (GOAL.template.md / PROGRESS.template.md)."; exit 1; }
done
for v in MAX_ITERS MAX_TURNS REVIEWER_MAX_TURNS MAX_FAILS MAX_STALE MAX_CR MAX_REVIEW_RETRY PROBE_EVERY INJECT_WARN_LINES PROGRESS_WARN_BYTES; do
  eval "_n=\$$v"; case "$_n" in ''|*[!0-9]*) echo "❌ $v='$_n' : entier attendu (vérifie loop.conf/env)."; exit 1;; esac
done
resolve_bin() { case "$(printf '%s' "${1:-}" | tr '[:upper:]' '[:lower:]')" in
  kimi|kimi:*) echo "${kimi_bin:-$HOME/.kimi-code/bin/kimi}";;
  grok) echo "${grok_bin:-$(command -v grok 2>/dev/null || echo "$HOME/.local/bin/grok")}";;
  mistral|vibe|devstral|mistral-local) echo "${vibe_bin:-$(command -v vibe 2>/dev/null || echo "$HOME/.local/bin/vibe")}";;
  yumi|yumi:*) echo "${yumi_bin:-$(command -v yumi 2>/dev/null || echo "$HOME/.local/bin/yumi")}";;
  *) command -v claude 2>/dev/null || echo claude;;
esac; }
check_role() {  # $1 = libellé · $2 = modèle
  local b; b="$(resolve_bin "$2")"
  [ -x "$b" ] || command -v "$b" >/dev/null 2>&1 || { echo "❌ $1 : binaire introuvable pour modèle='${2:-claude}' ($b)."; exit 1; }
  case "$(printf '%s' "${2:-}" | tr '[:upper:]' '[:lower:]')" in
    ''|kimi|kimi:*|grok|mistral|vibe|devstral|mistral-local|yumi|yumi:*|opus|sonnet|haiku|fable) ;;
    *[-0-9]*) ;;   # ressemble à un id de modèle (tiret/chiffre) → laissé passer
    *) echo "⚠️  $1 : modèle '$2' inconnu (ni alias ni id plausible) → routé en 'claude --model $2', risque d'échec." >&2;;
  esac
}
if ! type run_custom >/dev/null 2>&1; then
  is_true "$coder"    && check_role CODEUSE "$coder_model"
  is_true "$reviewer" && check_role CONTRÔLEUSE "$reviewer_model"
fi

# --- Boucle : état + reprise auto-update ------------------------------------
# (AVANT le préflight handoff : handoff_wait_review et VERIFY_STATE doivent survivre à l'exec,
#  sinon un gate SUSPENDU — handoff présent sans verdict réel — partirait chez l'humain non revu.)
i=0; fails=0; stale=0; turncap=0; cr_streak=0; last_cr_head=""; review_retry=0; handoff_wait_review=0; VERIFY_STATE=""; STATE=stopped
# Reprise après auto-update : restaure les compteurs transmis par l'ancienne version (cf. bloc
# PROTOCOLE AUTO-UPDATE dans la boucle) — la bascule de version est invisible pour les gardes.
if [ -n "${LOOP_RESUME:-}" ]; then
  eval "$LOOP_RESUME"; unset LOOP_RESUME
  echo "↻ auto-update : reprise sur la NOUVELLE version de loop.sh (itération $i conservée, compteurs restaurés)."
fi

# Gate-handoff déjà en attente ? En mode contrôlé, la main n'est rendue à l'humain que si le
# verdict couvrant le handoff est un PASS RÉEL (ni provisoire, ni synthétique stale) — sinon
# (arrêt/restart/auto-update pendant une suspension, abort MAX_REVIEW_RETRY avec handoff sur
# disque…) le gate reste SUSPENDU : la contrôleuse repasse d'abord, l'humain ne reçoit que du
# code revu (garantie 088259c durcie — elle n'était tenue qu'en mémoire, pas entre deux runs).
if is_true "$GATE_HANDOFF" && [ -f "$HANDOFF_FILE" ]; then
  _reviewed=1
  if is_true "$reviewer" && [ -n "$JQ" ]; then
    # (sans jq : verdict invérifiable → comportement historique, le fail-closed exige jq)
    _reviewed=0
    [ -f "$VERDICT_FILE" ] \
      && [ "$("$JQ" -r '.verdict // ""' "$VERDICT_FILE" 2>/dev/null)" = PASS ] \
      && [ "$("$JQ" -r '.provisional // .stale // false' "$VERDICT_FILE" 2>/dev/null)" = false ] \
      && _reviewed=1
  fi
  if [ "$_reviewed" = 1 ] && [ "${handoff_wait_review:-0}" != 1 ]; then
    echo "⏸ $HANDOFF_FILE présent (gate visuel/device en attente humain). Contenu :"
    cat "$HANDOFF_FILE" 2>/dev/null
    echo "→ Fais le gate puis supprime $HANDOFF_FILE pour relancer."; exit 0
  else
    handoff_wait_review=1
    echo "⏸ $HANDOFF_FILE présent SANS verdict PASS réel → gate SUSPENDU : la contrôleuse repasse d'abord (l'humain ne reçoit que du code revu)."
  fi
fi

print_config
# Failover : mémorise les modèles PRIMAIRES (ceux de la conf) et taille de la liste de secours.
# (Après un auto-update, on repart volontairement sur le primaire : il sera re-sondé de fait.)
primary_coder_model="$coder_model"; primary_reviewer_model="$reviewer_model"
fb_count=0; for _m in $FALLBACK_MODELS; do fb_count=$((fb_count+1)); done
fb_i=-1; fb_cycles=0
while [ ! -f "$DONE_FILE" ] && [ "$i" -lt "$MAX_ITERS" ] \
      && { ! is_true "$GATE_HANDOFF" || [ ! -f "$HANDOFF_FILE" ] || [ "${handoff_wait_review:-0}" = 1 ]; }; do
  # PROTOCOLE AUTO-UPDATE : un sync-kit pendant le run dépose loop.sh.new → la boucle l'active
  # ELLE-MÊME au point sûr (frontière d'itération, aucun agent en vol) et ré-exec : même PID donc
  # même verrou (adopté au redémarrage), compteurs via LOOP_RESUME, jsonl préservés.
  # auto_update=false dans loop.conf pour désactiver (forks à merge manuel notamment).
  if is_true "${auto_update:-true}" && [ -f loop.sh.new ]; then
    mv -f loop.sh.new loop.sh && { chmod +x loop.sh 2>/dev/null || true; }
    echo "↻ auto-update : loop.sh.new détecté → activé à la frontière d'itération, bascule à chaud."
    LOOP_RESUME="i=$i;fails=$fails;stale=$stale;turncap=$turncap;cr_streak=$cr_streak;review_retry=$review_retry;last_cr_head='$last_cr_head';handoff_wait_review=${handoff_wait_review:-0};VERIFY_STATE='$VERIFY_STATE'" exec "$0"
  fi
  i=$((i + 1))
  echo; echo "========== itération $i/$MAX_ITERS ($(date '+%H:%M:%S')) =========="
  # Hygiène de contexte : au-delà des seuils, avertit ET injecte la consigne d'archivage à la
  # codeuse (le canal ne doit contenir que de l'ACTIONNABLE ; le Journal ancien s'archive).
  hygiene=""
  if [ -s "$INJECT_FILE" ]; then
    _il="$(wc -l < "$INJECT_FILE" | tr -d ' ')"
    echo "📨 $INJECT_FILE détecté ($_il lignes)"
    if [ "${_il:-0}" -gt "$INJECT_WARN_LINES" ] 2>/dev/null; then
      echo "   ⚠ hygiène : $INJECT_FILE = $_il lignes (seuil $INJECT_WARN_LINES) — relu par les DEUX agents à CHAQUE tour ; consigne d'archivage injectée à la codeuse (→ .loop/inject-archive.md)."
      hygiene="${hygiene}CONTEXT HYGIENE — $INJECT_FILE holds $_il lines (over the $INJECT_WARN_LINES-line threshold) and BOTH agents re-read it WHOLE every turn. FIRST move every already-processed or stale entry to .loop/inject-archive.md (append, keep order): the channel must hold ACTIONABLE requests only. Then handle what remains.

"
    fi
  fi
  if [ -f PROGRESS.md ]; then
    _pb="$(wc -c < PROGRESS.md | tr -d ' ')"
    if [ "${_pb:-0}" -gt "$PROGRESS_WARN_BYTES" ] 2>/dev/null; then
      echo "   ⚠ hygiène : PROGRESS.md = $(( _pb / 1024 )) Ko (seuil $(( PROGRESS_WARN_BYTES / 1024 )) Ko) — consigne d'archivage du Journal injectée à la codeuse (→ PROGRESS-archive.md, cases + entrées récentes conservées)."
      hygiene="${hygiene}CONTEXT HYGIENE — PROGRESS.md weighs $(( _pb / 1024 )) KB (over the $(( PROGRESS_WARN_BYTES / 1024 )) KB threshold) and is re-read WHOLE every turn. FIRST archive the oldest Journal entries into PROGRESS-archive.md (append, chronological): PROGRESS.md keeps ALL the checkboxes and only the ~10 most recent Journal entries. Commit that move on its own ('chore: archive journal'), then continue the batch.

"
    fi
  fi
  # Marqueur d'itération pour le dashboard (compteur iter/max).
  for _jf in "$MONITOR_DIR/coder-main.jsonl" "$MONITOR_DIR/reviewer.jsonl"; do
    [ -f "$_jf" ] && printf '{"type":"loop","iter":%d,"max":%d}\n' "$i" "$MAX_ITERS" >> "$_jf"
  done

  # FAILOVER actif → sonde périodique du modèle PRIMAIRE ; s'il répond à nouveau (crédit revenu),
  # on lui REND la main immédiatement (codeuse + contrôleuse).
  if [ "$fb_i" -ge 1 ] && [ $(( i % PROBE_EVERY )) -eq 0 ]; then
    # Cible de sonde = le primaire réellement EN PANNE : si la codeuse est restée sur son primaire
    # (failover déclenché par la CONTRÔLEUSE seule, providers différents), sonder le primaire codeuse
    # — sain — rendrait la main à un provider contrôleuse toujours mort (ping-pong de bascules).
    _probe="$primary_coder_model"
    [ "$coder_model" = "$primary_coder_model" ] && _probe="$primary_reviewer_model"
    if probe_model "$_probe"; then
      echo "🔀 FAILOVER : le primaire (${_probe:-défaut claude}) répond à nouveau → retour aux modèles primaires."
      coder_model="$primary_coder_model"; reviewer_model="$primary_reviewer_model"; fb_i=-1; fb_cycles=0; fails=0
    else
      echo "   (sonde ${_probe:-défaut claude} : toujours indisponible — on reste sur secours)"
    fi
  fi

  # Revue précédente sans verdict frais (contrôleuse morte/illisible) : la codeuse n'a RIEN à corriger
  # — on saute son tour et on relance directement la contrôleuse sur la même plage.
  if { [ "$review_retry" -gt 0 ] || [ "${handoff_wait_review:-0}" = 1 ]; } && is_true "$coder"; then
    if [ "$review_retry" -eq 0 ]; then
      echo "⟲ gate-handoff SUSPENDU (verdict réel manquant) — codeuse SAUTÉE, la contrôleuse tranche d'abord."
    else
      echo "⟲ revue précédente sans verdict frais — codeuse SAUTÉE ce tour, la contrôleuse repasse directement (tentative $((review_retry+1))/$MAX_REVIEW_RETRY)."
    fi
  elif is_true "$coder"; then
    pre="$hygiene"
    [ "$VERIFY_STATE" = red ] && pre="${pre}LAST verify.sh FAILED (red) — see $CTL_DIR/verify.log. FIX the failing checks BEFORE checking any box or creating $DONE_FILE.

"
    # Itération précédente morte en plafond de tours SANS commit → consigne de reprise/checkpoint
    # (sinon la codeuse repart de zéro à contexte neuf et re-meurt au même endroit : thrash max_turns).
    [ "$turncap" -ge 1 ] && pre="${pre}PREVIOUS ITERATION DIED AT ITS TURN CAP (error_max_turns) WITHOUT COMMITTING — the batch is likely OVERSIZED. Do NOT restart from scratch: run git status / git diff FIRST, KEEP what is valid on disk, verify it, COMMIT it as a checkpoint ('wip: … — checkpoint', targeted staging) BEFORE anything else, then continue in SMALLER increments (commit by HALF your turn budget; split the batch: helper/dependency first, then the tool, then the test).

"
    if is_true "$reviewer" && [ -f "$VERDICT_FILE" ]; then
      pre="${pre}BEFORE ANYTHING — read $VERDICT_FILE (previous review verdict). While verdict==CHANGES_REQUESTED you may work ONLY on its 'blocking' items (commits 'fix: …'): do NOT check any new box, do NOT create $DONE_FILE. EXCEPTION: the CONTEXT HYGIENE archiving above (and its 'chore:' commit) and handling/archiving user injections remain REQUIRED even under CHANGES_REQUESTED — do them first, then work ONLY the blockers. For each blocker, paste PROOF (command + real output) that it now passes. NEVER write or edit anything under $CTL_DIR/ (reviewer channel — tampering = build failed).

"
    fi
    before="$(git rev-parse HEAD 2>/dev/null || echo none)"
    run_agent "CODEUSE" "$WATCHDOG_NOTE$pre$CODER_PROMPT$CODER_EXTRA" "$MONITOR_DIR/coder-main.jsonl" "$MAX_TURNS" "$coder_model"; rc=$?
    after="$(git rev-parse HEAD 2>/dev/null || echo none)"
    # PROGRÈS réel = nouveau commit OU .done OU handoff déposé. Le provider "marche" alors, quel que soit
    # son code retour (certains CLI renvoient !=0 même après un travail utile, ex. « max turns reached »).
    progress=0
    { [ "$before" != "$after" ] || [ -f "$DONE_FILE" ] || { is_true "$GATE_HANDOFF" && [ -f "$HANDOFF_FILE" ]; }; } && progress=1
    if [ "$progress" = 1 ]; then
      fails=0; stale=0; turncap=0
    else
      stale=$((stale+1))
      # CAUSE du non-progrès : une codeuse morte en max_turns SANS commit n'est PAS un agent bloqué —
      # c'est un lot SURDIMENSIONNÉ (elle relit tout à froid et épuise ses tours avant d'atteindre un
      # commit). On lit le subtype du dernier result du jsonl pour distinguer les deux.
      if [ -n "$JQ" ]; then
        _sub="$("$JQ" -Rr 'fromjson? | select(type=="object" and .type=="result") | .subtype // empty' \
          "$MONITOR_DIR/coder-main.jsonl" 2>/dev/null | tail -1 || true)"
        case "$_sub" in
          *max_turns*) turncap=$((turncap+1))
            echo "   ⚠ codeuse plafonnée en tours (error_max_turns) sans commit (${turncap}x) — lot trop gros ? Consigne de checkpoint/découpe injectée au prochain tour.";;
          *) turncap=0;;
        esac
      fi
      # Un plafond de tours n'est pas un échec provider (le CLI a travaillé) → pas compté dans fails.
      [ "$rc" -ne 0 ] && [ "$turncap" -eq 0 ] && { fails=$((fails+1)); echo "⚠️  CODEUSE rc=$rc, aucun progrès (échec #$fails/$MAX_FAILS) — voir $MONITOR_DIR/CODEUSE.err"; }
      if [ "$fails" -ge "$MAX_FAILS" ]; then
        # FAILOVER (fallback_models) : crédit épuisé / provider mort ≠ fin de mission — rotation sur
        # la liste de secours jusqu'à trouver un provider qui répond. La contrôleuse suit seulement
        # si elle partage le provider du primaire en panne. Abort après 2 tours COMPLETS de liste.
        if [ "$fb_count" -gt 0 ]; then
          fb_i=$((fb_i<1 ? 1 : fb_i+1))
          if [ "$fb_i" -gt "$fb_count" ]; then
            fb_i=1; fb_cycles=$((fb_cycles+1))
            [ "$fb_cycles" -ge 2 ] && { echo "⛔ FAILOVER épuisé : aucun provider de « $FALLBACK_MODELS » ne répond ($fb_cycles tours de liste complets) → arrêt."; exit 1; }
          fi
          coder_model="$(fb_pick "$fb_i")"
          [ "$(provider_of "$primary_reviewer_model")" = "$(provider_of "$primary_coder_model")" ] && reviewer_model="$coder_model"
          echo "🔀 FAILOVER : provider en échec ${fails}x (crédit épuisé / binaire / token ?) → bascule sur $coder_model$([ "$reviewer_model" = "$coder_model" ] && printf ' (contrôleuse aussi)') ; sonde du primaire (${primary_coder_model:-défaut claude}) toutes les $PROBE_EVERY itérations."
          fails=0; stale=0
        else
          echo "⛔ $fails échecs provider consécutifs sans progrès → abandon (binaire/modèle/token ?)."; exit 1
        fi
      fi
      if [ "$stale" -ge "$MAX_STALE" ]; then
        if [ "$turncap" -ge 2 ]; then
          echo "⛔ codeuse plafonnée en tours SANS commit $turncap fois → arrêt : lot SURDIMENSIONNÉ (thrash max_turns), pas un agent bloqué."
          echo "   Remède : committer le WIP s'il est vert (checkpoint, staging ciblé), puis injecter une découpe du lot + un commit à mi-tours (cf. SKILL.md, « Lot surdimensionné »)."
        else
          echo "⛔ $stale itérations sans progrès → arrêt (agent bloqué ?)."
        fi
        # Du travail exploitable traîne peut-être sur le disque : le signaler AVANT de mourir.
        if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
          if [ "$VERIFY_STATE" = green ]; then
            echo "   ⚠ TRAVAIL VERT NON COMMITÉ présent (verify.sh vert + working tree modifié) — checkpointe-le (git add ciblé + commit) au lieu de le perdre."
          else
            echo "   ⚠ working tree modifié non commité ($(git status --porcelain 2>/dev/null | wc -l | tr -d ' ') fichier(s)) — inspecte-le avant de relancer."
          fi
        fi
        exit 1
      fi
    fi

    # Gate MÉCANIQUE optionnel : verify.sh à la racine DOIT passer (déterministe, ≠ un LLM qui hallucine).
    VERIFY_STATE=""
    if [ -x ./verify.sh ]; then
      if ./verify.sh > "$CTL_DIR/verify.log" 2>&1; then VERIFY_STATE=green; else VERIFY_STATE=red; fi
      echo "   ⚙️  verify.sh = $VERIFY_STATE (log: $CTL_DIR/verify.log)"
    fi

    # .done ne doit PAS court-circuiter la revue ni survivre à un verify rouge.
    if [ -f "$DONE_FILE" ] && [ "$VERIFY_STATE" = red ]; then
      rm -f "$DONE_FILE"; echo "⚠ $DONE_FILE retiré : verify.sh rouge — pas de fin sur un test cassé."
    fi
    # Codeuse seule (pas de contrôleuse) : .done accepté seulement si verify ≠ rouge → fin.
    if [ -f "$DONE_FILE" ] && ! is_true "$reviewer"; then STATE=done; break; fi

    if is_true "$GATE_HANDOFF" && [ -f "$HANDOFF_FILE" ]; then
      if is_true "$reviewer"; then
        # REVUE AVANT LE GATE HUMAIN : un handoff n'est PAS un laissez-passer. La contrôleuse passe
        # sur ce commit dans CETTE itération ; on ne cède la main à l'humain que sur verdict PASS
        # (voir bloc contrôleuse) — sinon le handoff est retiré et le flux CR normal corrige d'abord.
        echo "⏸ $HANDOFF_FILE déposé par la codeuse → la contrôleuse passe D'ABORD ; gate humain seulement si verdict PASS."
      else
        echo "⏸ $HANDOFF_FILE déposé par la codeuse → gate visuel/device requis (elle cède la main)."; STATE=handoff; break
      fi
    fi
  fi

  if is_true "$reviewer"; then
    # Marqueur de FRAÎCHEUR : un verdict n'est valable que s'il est PLUS RÉCENT que ce fichier. Sans ça,
    # une contrôleuse morte AVANT d'écrire (max-turns, crash, kill) laisse l'ANCIEN verdict en place —
    # lisible, donc pris pour frais : des lots entiers passeraient « PASS » sans revue réelle.
    # + SNAPSHOT de l'ancre .head AVANT la revue : si la contrôleuse écrit un provisoire avec le
    # mauvais head (HEAD courant au lieu du dernier verdict réel) puis meurt, on peut la RÉTABLIR —
    # sinon la plage à revoir s'effondre en HEAD..HEAD et des commits échappent à la revue.
    prev_vhead=""
    [ -n "$JQ" ] && [ -f "$VERDICT_FILE" ] && prev_vhead="$("$JQ" -r '.head // empty' "$VERDICT_FILE" 2>/dev/null || true)"
    : > "$CTL_DIR/.review-started"
    # ESCALADE du budget de tours en relance de revue : retenter N fois au MÊME budget répète N fois
    # la même cause d'échec (contrôleuse tuée en max-turns avant d'écrire). ×1,5 par tentative,
    # plafonné à ×3 du budget de base. (État dérivé de review_retry → survit à l'auto-update.)
    rt_turns=$REVIEWER_MAX_TURNS
    if [ "$review_retry" -ge 1 ]; then
      _i=0; while [ "$_i" -lt "$review_retry" ]; do rt_turns=$(( rt_turns * 3 / 2 )); _i=$((_i+1)); done
      _cap=$(( REVIEWER_MAX_TURNS * 3 )); [ "$rt_turns" -gt "$_cap" ] && rt_turns=$_cap
      echo "   ↑ budget contrôleuse ESCALADÉ : $rt_turns tours (base $REVIEWER_MAX_TURNS, tentative $((review_retry+1))/$MAX_REVIEW_RETRY)."
    fi
    run_agent "CONTRÔLEUSE" "$REVIEWER_PROMPT" "$MONITOR_DIR/reviewer.jsonl" "$rt_turns" "$reviewer_model"; rrc=$?
    [ "$rrc" -ne 0 ] && echo "⚠️  CONTRÔLEUSE rc=$rrc — voir $MONITOR_DIR/CONTRÔLEUSE.err"
    if [ -n "$JQ" ]; then
      retry_reason=""
      # Subtype du dernier result de la contrôleuse : distingue max-turns (elle a TRAVAILLÉ) d'une
      # panne provider (rc≠0 sans max-turns) — utilisé par le diagnostic ET par le failover ci-dessous.
      _sub="$("$JQ" -Rr 'fromjson? | select(type=="object" and .type=="result") | .subtype // empty' \
        "$MONITOR_DIR/reviewer.jsonl" 2>/dev/null | tail -1 || true)"
      if [ -f "$VERDICT_FILE" ] && ! [ "$VERDICT_FILE" -nt "$CTL_DIR/.review-started" ]; then
        # Fail-closed : verdict PÉRIMÉ — la contrôleuse s'est arrêtée sans écrire. On PRÉSERVE .head
        # (ancrage de la plage à revoir : dernier verdict RÉEL → HEAD) et on synthétise un
        # CHANGES_REQUESTED "stale" ; la revue est relancée au tour suivant SANS repasser par la codeuse.
        vprev="$("$JQ" -r '.head // "?"' "$VERDICT_FILE" 2>/dev/null || echo '?')"
        _diag=""; case "$_sub" in *max_turns*) _diag=" (max-turns $rt_turns atteint)";; esac
        # Diagnostic : « revue faite, verdict non sérialisé » ≠ « contrôleuse muette » — si log.md a
        # bien reçu sa section datée pendant CE run, le travail de revue a EU LIEU ; seul le JSON manque.
        if [ -f "$CTL_DIR/log.md" ] && [ "$CTL_DIR/log.md" -nt "$CTL_DIR/.review-started" ]; then
          retry_reason="revue FAITE (log.md mis à jour) mais verdict NON SÉRIALISÉ$_diag — la contrôleuse a travaillé puis est morte avant d'écrire le JSON"
        else
          retry_reason="verdict périmé (contrôleuse arrêtée sans écrire$_diag)"
        fi
        printf '{"head":"%s","verdict":"CHANGES_REQUESTED","stale":true,"blocking":["review not delivered: reviewer stopped before writing the verdict (max-turns?). Last REAL verdict: head=%s — every commit beyond it is UNREVIEWED. Do NOT code: the review is re-run automatically."]}\n' \
          "$vprev" "$vprev" > "$VERDICT_FILE"
      elif [ ! -f "$VERDICT_FILE" ] || ! "$JQ" -e '.verdict' "$VERDICT_FILE" >/dev/null 2>&1; then
        # Fail-closed : verdict illisible/absent (modèle faible qui enveloppe le JSON) = CHANGES_REQUESTED.
        printf '{"verdict":"CHANGES_REQUESTED","stale":true,"blocking":["review not delivered: verdict JSON unreadable or missing — the review will be re-run automatically; do NOT code"]}\n' > "$VERDICT_FILE"
        # Même diagnostic que la branche « périmé » : log.md mis à jour pendant CE run = la revue a EU
        # LIEU, seul le JSON manque (première revue d'une boucle neuve, ou JSON enveloppé de prose).
        if [ -f "$CTL_DIR/log.md" ] && [ "$CTL_DIR/log.md" -nt "$CTL_DIR/.review-started" ]; then
          retry_reason="revue FAITE (log.md mis à jour) mais verdict NON SÉRIALISÉ (JSON illisible/absent)"
        else
          retry_reason="verdict illisible/absent"
        fi
      elif [ "$("$JQ" -r '.provisional // false' "$VERDICT_FILE" 2>/dev/null)" = "true" ]; then
        # Verdict PROVISOIRE (écrit en DÉBUT de revue, jamais raffiné) = contrôleuse morte À MI-REVUE.
        # Le travail partiel est exploitable (log.md), le verdict final manque : relance avec budget
        # escaladé, codeuse sautée. Fail-closed déjà en place (le provisoire est CHANGES_REQUESTED).
        # ANCRE : si le provisoire porte un head ≠ dernier verdict réel (contrôleuse qui a mis HEAD
        # courant malgré la consigne), on RÉTABLIT l'ancre snapshotée — la plage à revoir reste
        # dernier-verdict-RÉEL → HEAD pour la relance et pour la branche « périmé » suivante.
        if [ -n "${prev_vhead:-}" ] && [ "$("$JQ" -r '.head // ""' "$VERDICT_FILE" 2>/dev/null)" != "$prev_vhead" ]; then
          "$JQ" --arg h "$prev_vhead" '.head=$h' "$VERDICT_FILE" > "$VERDICT_FILE.tmp" 2>/dev/null \
            && mv -f "$VERDICT_FILE.tmp" "$VERDICT_FILE" \
            && echo "   ↺ ancre .head du verdict provisoire rétablie sur le dernier verdict RÉEL ($prev_vhead)."
        fi
        retry_reason="verdict PROVISOIRE non raffiné (contrôleuse interrompue à mi-revue — travail partiel dans log.md)"
      fi
      verdict="$("$JQ" -r '.verdict // "?"' "$VERDICT_FILE" 2>/dev/null || echo '?')"
      vhead="$("$JQ" -r '.head // "?"' "$VERDICT_FILE" 2>/dev/null || echo '?')"
      if [ -n "$retry_reason" ]; then
        # Pas de revue réelle ce tour : on relance la contrôleuse (codeuse sautée) au lieu de laisser la
        # codeuse « corriger » un blocker qui n'en est pas un. Verdict synthétique = fail-closed quand même
        # (.done refusé, verdict CHANGES_REQUESTED tant que la revue n'est pas rendue).
        review_retry=$((review_retry+1))
        echo "   ⚠ $retry_reason → fail-closed CHANGES_REQUESTED ; revue relancée au prochain tour ($review_retry/$MAX_REVIEW_RETRY)."
        if [ "$review_retry" -ge "$MAX_REVIEW_RETRY" ]; then
          # Panne PROVIDER de la contrôleuse (rc≠0 SANS max-turns, aucun verdict) + liste de secours
          # → même FAILOVER que la codeuse au lieu d'un arrêt sec : crédit épuisé ≠ fin de mission.
          # (Sans signature provider — contrôleuse qui répond mais n'écrit pas — l'arrêt reste juste.)
          _psig=0; [ "$rrc" -ne 0 ] && case "${_sub:-}" in *max_turns*) ;; *) _psig=1;; esac
          if [ "$_psig" = 1 ] && [ "$fb_count" -gt 0 ]; then
            fb_i=$((fb_i<1 ? 1 : fb_i+1))
            if [ "$fb_i" -gt "$fb_count" ]; then
              fb_i=1; fb_cycles=$((fb_cycles+1))
              [ "$fb_cycles" -ge 2 ] && { echo "⛔ FAILOVER épuisé : aucun provider de « $FALLBACK_MODELS » ne répond ($fb_cycles tours de liste complets) → arrêt."; exit 1; }
            fi
            reviewer_model="$(fb_pick "$fb_i")"
            [ "$(provider_of "$primary_coder_model")" = "$(provider_of "$primary_reviewer_model")" ] && coder_model="$reviewer_model"
            echo "🔀 FAILOVER (contrôleuse) : $review_retry revues sans verdict avec échec provider → bascule sur $reviewer_model$([ "$coder_model" = "$reviewer_model" ] && printf ' (codeuse aussi)') ; sonde du primaire toutes les $PROBE_EVERY itérations."
            review_retry=1   # pas 0 : la codeuse reste sautée, la revue repart DIRECT sur le NOUVEAU provider
          else
            echo "⛔ $review_retry revues consécutives sans verdict frais → arrêt (reviewer_max_turns=$REVIEWER_MAX_TURNS trop bas ? contrôleuse en panne ?)."; exit 1
          fi
        fi
        # Un handoff en attente ne part PAS chez l'humain sans verdict réel : gate suspendu, la
        # relance de revue (codeuse sautée) tranchera PASS → gate / CR → correction d'abord.
        if is_true "$GATE_HANDOFF" && [ -f "$HANDOFF_FILE" ]; then
          handoff_wait_review=1
          echo "   ⏸ gate-handoff SUSPENDU en attente d'un verdict réel — l'humain ne recevra que du code revu."
        fi
      else
        review_retry=0
        echo "   ⟲ verdict : $verdict"
        vtests="$("$JQ" -r '.tests // "?"' "$VERDICT_FILE" 2>/dev/null || echo '?')"
        # Défense en profondeur : PASS avec tests=harness-error est CONTRADICTOIRE (le test n'a pas
        # TOURNÉ → rien n'a été validé) — rétrogradé en CHANGES_REQUESTED, fichier RÉÉCRIT (la codeuse
        # lit ce fichier : il doit dire la même chose que la boucle). Sans ça, un tel PASS gardait
        # .done et cédait un handoff à l'humain comme « code VALIDÉ » alors que rien n'a tourné.
        if [ "$verdict" = PASS ] && [ "$vtests" = "harness-error" ]; then
          "$JQ" '.verdict="CHANGES_REQUESTED" | .blocking=((.blocking // []) + ["PASS with tests:harness-error is contradictory — the test did NOT run, so nothing was validated: fix the HARNESS, re-run the tests, then re-review"])' \
            "$VERDICT_FILE" > "$VERDICT_FILE.tmp" 2>/dev/null && mv -f "$VERDICT_FILE.tmp" "$VERDICT_FILE"
          verdict=CHANGES_REQUESTED
          echo "   ⚠ verdict PASS avec tests=harness-error : contradictoire (test jamais exécuté) → rétrogradé CHANGES_REQUESTED (réparer le harnais d'abord)."
        fi
        # Anti ping-pong : N CHANGES_REQUESTED d'affilée sur le même HEAD → arrêt (blocage stérile).
        # (Les verdicts synthétiques "stale" n'alimentent PAS ce compteur : ce ne sont pas des revues.
        #  tests=harness-error non plus : le test n'a pas TOURNÉ — échec du BANC, pas du produit ; le
        #  blocker attendu est « réparer le harnais », et max_stale reste le garde-fou si rien ne bouge.)
        if [ "$verdict" = CHANGES_REQUESTED ] && [ "$vtests" = "harness-error" ]; then
          echo "   ⚠ tests=harness-error : le test n'a pas TOURNÉ (banc/outillage en panne) — AUCUNE conclusion produit possible ; réparer le HARNAIS puis rejouer. (non compté dans l'anti ping-pong)"
        elif [ "$verdict" = CHANGES_REQUESTED ] && [ "$vhead" = "$last_cr_head" ]; then cr_streak=$((cr_streak+1))
        elif [ "$verdict" = CHANGES_REQUESTED ]; then cr_streak=1; last_cr_head="$vhead"
        else cr_streak=0; last_cr_head=""; fi
        [ "$cr_streak" -ge "$MAX_CR" ] && { echo "⛔ $cr_streak revues CHANGES_REQUESTED d'affilée sur $vhead → arrêt (ping-pong)."; exit 1; }
        # GATE-HANDOFF : la main n'est cédée à l'humain QUE sur verdict PASS (le commit du handoff a
        # été revu dans CE tour). Sinon : handoff RETIRÉ, flux CR normal — la codeuse corrige les
        # blockers au tour suivant et re-déposera le handoff une fois la correction commitée.
        handoff_wait_review=0
        if is_true "$GATE_HANDOFF" && [ -f "$HANDOFF_FILE" ]; then
          if [ "$verdict" = PASS ]; then
            echo "⏸ verdict PASS sur le commit du handoff → gate humain (code VALIDÉ par la revue)."; STATE=handoff; break
          else
            rm -f "$HANDOFF_FILE"
            echo "↩ verdict $verdict sur le commit du handoff → $HANDOFF_FILE RETIRÉ : correction d'abord (flux CR normal), le handoff sera re-déposé après."
          fi
        fi
      fi
      # .done accepté seulement si la revue indépendante a validé (PASS).
      if [ -f "$DONE_FILE" ] && [ "$verdict" != PASS ]; then
        rm -f "$DONE_FILE"; echo "⚠ $DONE_FILE retiré : verdict=$verdict (≠ PASS) — pas de fin sans revue verte."
      fi
    else
      # Sans jq, impossible de valider le verdict → on ne se fie pas à un .done créé en mode contrôlé.
      [ -f "$DONE_FILE" ] && { rm -f "$DONE_FILE"; echo "⚠ $DONE_FILE retiré : jq absent → verdict non validable en mode contrôlé."; }
    fi
  fi

  # Plafond de coût (optionnel) : somme les 'result' des jsonl (claude émet la télémétrie ; kimi/vibe = 0).
  if [ -n "$JQ" ] && [ -n "${max_cost:-}" ]; then
    spent="$("$JQ" -rs 'map(select(type=="object" and .type=="result") | .total_cost_usd // 0) | add // 0' \
      "$MONITOR_DIR/coder-main.jsonl" "$MONITOR_DIR/reviewer.jsonl" 2>/dev/null || echo 0)"
    if [ "$(awk -v a="$spent" -v b="$max_cost" 'BEGIN{print (a+0>=b+0)?1:0}')" = 1 ]; then
      echo "⏹ budget atteint (\$$spent ≥ \$$max_cost) — arrêt propre."; STATE=budget; break
    fi
  fi

  echo; echo "---------- fin itération $i ----------"
done

# Statut final + notification passive (cloche + hook notify_cmd optionnel).
[ -f "$DONE_FILE" ] && STATE=done
# Un handoff SUSPENDU (pas de verdict réel) ne s'annonce PAS « cédé la main » : l'humain ne doit
# pas gater du code non revu — la relance re-suspendra et fera trancher la contrôleuse d'abord.
if [ "$STATE" != done ] && is_true "$GATE_HANDOFF" && [ -f "$HANDOFF_FILE" ] && [ "${handoff_wait_review:-0}" != 1 ]; then STATE=handoff; fi
case "$STATE" in
  done)    echo "✅ terminé ($DONE_FILE) en $i itérations.";;
  handoff) echo "⏸ CÉDÉ LA MAIN ($HANDOFF_FILE) — gate visuel/device requis. Contenu :"; cat "$HANDOFF_FILE" 2>/dev/null;;
  budget)  echo "⏹ arrêté sur budget à $i itérations — relance (ou augmente max_cost) pour continuer.";;
  *)       echo "⏹ arrêté à $i itérations (MAX_ITERS ou interruption) — relance pour continuer.";;
esac
printf '\a'   # cloche terminal : signal passif de fin
[ -n "${notify_cmd:-}" ] && { export LOOP_STATE="$STATE" LOOP_ITERS="$i"; eval "$notify_cmd" >/dev/null 2>&1 || true; }
