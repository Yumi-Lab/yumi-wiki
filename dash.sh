#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# Dashboard terminal : MONITOR en haut + BOUCLE de codage en bas, une seule
# fenêtre tmux.
#
# Usage :  ./dash.sh
# Navigation tmux :
#   Ctrl+B puis ↑/↓   changer de panneau
#   Ctrl+B z          zoom plein écran du panneau courant
#   Ctrl+B d          détacher (la boucle continue en arrière-plan)
#   tmux attach -t loop   ré-attacher après détachement
# ─────────────────────────────────────────────────────────────────────────────
set -uo pipefail
cd "$(dirname "$0")"

command -v tmux >/dev/null 2>&1 || { echo "tmux requis : brew install tmux"; exit 1; }

S="${TMUX_SESSION:-loop}"
MON_ROWS="${MON_ROWS:-14}"     # hauteur (lignes) du panneau monitor en haut
# Fenêtre de contexte pour la jauge du monitor. Les comptes de la maison ont le
# contexte étendu 1M sur claude : la table interne du monitor (200k) affiche des
# faux 100 %. Override possible : CTX_WINDOW=200000 ./dash.sh
CTX_WINDOW="${CTX_WINDOW:-1000000}"

# Une boucle tourne déjà dans cette session (on s'est détaché avec Ctrl+B d) → on s'y RÉ-ATTACHE
# au lieu de la TUER. Reset explicite : FRESH=1 ./dash.sh (repart d'une session neuve).
if [ "${FRESH:-0}" != 1 ] && tmux has-session -t "$S" 2>/dev/null; then
  echo "Session '$S' déjà active (boucle en cours ?) → ré-attache. Repartir de zéro : FRESH=1 ./dash.sh"
  exec tmux attach -t "$S"
fi
# --fresh : met le kit + CE projet à jour AVANT de lancer quoi que ce soit (monitor inclus,
# sinon le panneau 0 démarrerait sur l'ancien monitor.mjs). Même mécanique que loop.sh --fresh.
if [ "${1:-}" = "--fresh" ]; then
  KIT_DIR="${KIT_DIR:-$HOME/Documents/GitHub/autonomous-loop-kit}"
  if [ -d "$KIT_DIR" ]; then
    git -C "$KIT_DIR" pull --ff-only 2>/dev/null | tail -1 || true
    [ -x "$KIT_DIR/sync-kit.sh" ] && "$KIT_DIR/sync-kit.sh" "$PWD" | tail -2
    [ -f loop.sh.new ] && mv -f loop.sh.new loop.sh && chmod +x loop.sh
    echo "↻ --fresh : kit $(git -C "$KIT_DIR" log -1 --format=%h 2>/dev/null || echo '?') synchronisé."
  else
    echo "⚠ --fresh : kit introuvable ($KIT_DIR) — définis KIT_DIR=… ; lancement sur la version locale." >&2
  fi
fi

tmux kill-session -t "$S" 2>/dev/null || true
tmux new-session -d -s "$S"

# Panneau 0 (HAUT) = monitor temps réel (jauge calée sur CTX_WINDOW)
tmux send-keys -t "$S":0.0 "CTX_WINDOW=${CTX_WINDOW} node monitor.mjs" C-m

# Split horizontal → panneau 1 (BAS) = boucle de codage
tmux split-window -v -t "$S":0.0
tmux send-keys -t "$S":0.1 './loop.sh' C-m

# Haut compact ; ré-épinglé à chaque resize de la fenêtre.
tmux resize-pane -t "$S":0.0 -y "$MON_ROWS" 2>/dev/null || true
tmux set-hook -t "$S" client-resized "resize-pane -t ${S}:0.0 -y ${MON_ROWS}" 2>/dev/null || true
tmux set-hook -t "$S" window-resized "resize-pane -t ${S}:0.0 -y ${MON_ROWS}" 2>/dev/null || true
tmux select-pane -t "$S":0.1

tmux attach -t "$S"
