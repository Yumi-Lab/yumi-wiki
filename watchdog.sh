#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# watchdog.sh — RELANCE AUTOMATIQUE d'une boucle TOMBÉE (crash / incident modèle / max_iters).
#
# Complémentaire de monitor-watch.sh : le monitor te RÉVEILLE (gate/arrêt/heartbeat) ; le watchdog,
# lui, REDÉMARRE la boucle tout seul. À lancer par cron toutes les 5 min.
#
#   */5 * * * * /chemin/watchdog.sh /chemin/repo      (ou : ./watchdog.sh --install /chemin/repo)
#
# IDEMPOTENT — ne fait RIEN si :
#   • la boucle TOURNE déjà (pgrep)  • .done existe (fini)  • .gate-handoff en attente (gate humain).
# Sinon (tombée, pas finie, pas de gate) → nettoie le VERROU résiduel + relance. Journal : .monitor/watchdog.log
#
# Env : LOOP_SCRIPT=loop.sh · LAUNCH_CMD='./loop.sh' (forks : './run-v7.sh') · DONE_FILE=.done
#       HANDOFF_FILE=.gate-handoff · MONITOR_DIR=.monitor
# ─────────────────────────────────────────────────────────────────────────────
set -uo pipefail

# ── Installateur de cron (*/5) ───────────────────────────────────────────────
# Capture les réglages passés en ENV à l'install et les GRAVE dans la ligne cron (cron n'hérite pas de
# ton shell). Une commande pour un fork :
#   LOOP_SCRIPT=run-v7.sh DONE_FILE=.done-v7 LAUNCH_CMD=./run-v7.sh ./watchdog.sh --install <repo>
if [ "${1:-}" = "--install" ]; then
  shift
  REPO="$(cd "${1:-.}" && pwd)" || { echo "repo introuvable" >&2; exit 2; }
  SELF="$(cd "$(dirname "$0")" && pwd)/$(basename "$0")"
  ENVP=""
  for v in LOOP_SCRIPT LAUNCH_CMD DONE_FILE HANDOFF_FILE MONITOR_DIR; do
    eval "val=\${$v:-}"
    [ -n "$val" ] && ENVP="$ENVP $v=$(printf '%q' "$val")"
  done
  LINE="*/5 * * * *${ENVP} $SELF $REPO # autonomous-loop watchdog $(basename "$REPO")"
  ( crontab -l 2>/dev/null | grep -vF "$SELF $REPO"; echo "$LINE" ) | crontab - \
    && echo "✅ cron installé : $LINE" || { echo "échec crontab" >&2; exit 1; }
  [ -n "$ENVP" ] && echo "   env gravé dans la ligne :${ENVP}"
  echo "   (désinstaller : crontab -l | grep -vF '$SELF $REPO' | crontab -)"
  exit 0
fi

REPO="${1:-.}"; cd "$REPO" 2>/dev/null || { echo "watchdog: repo introuvable: $REPO" >&2; exit 2; }
LOOP_SCRIPT="${LOOP_SCRIPT:-loop.sh}"
LAUNCH_CMD="${LAUNCH_CMD:-./$LOOP_SCRIPT}"
DONE_FILE="${DONE_FILE:-.done}"
HANDOFF_FILE="${HANDOFF_FILE:-.gate-handoff}"
MONITOR_DIR="${MONITOR_DIR:-.monitor}"
mkdir -p "$MONITOR_DIR"
LOG="$MONITOR_DIR/watchdog.log"
log() { echo "$(date '+%F %T') $*" >> "$LOG"; }

# ── Idempotence : ne rien faire si terminé / en attente de gate / déjà en cours ─
for d in "$DONE_FILE" "$DONE_FILE"-*; do [ -e "$d" ] && exit 0; done   # .done ou .done-v7 → fini
[ -f "$HANDOFF_FILE" ] && exit 0                                        # gate humain en attente
# pgrep -f "$LOOP_SCRIPT" seul est un piège double : (1) matche N'IMPORTE QUEL
# loop.sh d'un autre repo (d'où le filtre cwd) ; (2) matche aussi tout process
# dont la ligne de commande MENTIONNE juste "loop.sh" sans l'exécuter — ex. un
# monitor-watch.sh lancé avec LOOP_SCRIPT=loop.sh en argument matche le pattern
# alors qu'il ne fait que surveiller. D'où le pattern resserré à l'invocation
# réelle "bash ./loop.sh", pas une mention en passant.
alive() { for p in $(pgrep -f "bash \./$LOOP_SCRIPT" 2>/dev/null); do d=$(lsof -a -p "$p" -d cwd -Fn 2>/dev/null | sed -n 's/^n//p'); [ "$d" = "$PWD" ] && return 0; done; return 1; }
if alive; then exit 0; fi                                               # tourne déjà (CE repo) → rien à faire

# ── La boucle est TOMBÉE → nettoie le verrou résiduel + relance (détaché) ─────
[ -d "$MONITOR_DIR/.lock" ] && { rm -rf "$MONITOR_DIR/.lock" 2>/dev/null; log "verrou résiduel .lock nettoyé"; }
log "boucle absente (ni .done, ni gate) → relance : $LAUNCH_CMD"
nohup bash -c "cd $(printf '%q' "$PWD") && exec $LAUNCH_CMD" >> "$MONITOR_DIR/watchdog-launch.out" 2>&1 < /dev/null &
log "relancée (pid $!)"
