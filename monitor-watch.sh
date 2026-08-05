#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# monitor-watch.sh — surveillance d'une boucle autonome DÉTACHÉE, avec HEARTBEAT OBLIGATOIRE.
#
# Une boucle lancée en `nohup ./loop.sh &` ne t'envoie AUCUN message : le SEUL moyen de te
# réveiller pour reprendre la main est de la SURVEILLER. Ce script surveille TROIS signaux —
# dont un battement périodique inconditionnel, seul capable de détecter :
#   • une boucle qui TOURNE mais N'AVANCE PLUS (même HEAD depuis des heures → elle patine) ;
#   • la session superviseuse qui MEURT sans que personne ne soit réveillé.
# (Les deux échappent aux signaux « .gate-handoff » et « process mort ».)
#
# Il ÉCRIT sur stdout (tail-le, ou fais-en la condition d'un Monitor du harnais) et SORT (exit 0)
# sur une condition terminale (gate / done / arrêt) — ce qui sert de réveil.
#
# Usage :  ./monitor-watch.sh [REPO]
#   REPO   racine du projet surveillé (défaut : .)
# Env (optionnels) :
#   LOOP_SCRIPT=loop.sh     nom du script de boucle (repli pgrep si lock-alive.sh absent)
#   HEARTBEAT=1800          intervalle du battement en secondes (défaut 30 min — OBLIGATOIRE, pas 0)
#   POLL=30                 fréquence de scrutation en secondes
#   STALL_HB=2              battements consécutifs avec HEAD FIGÉ avant l'alerte « patine »
#   HANDOFF_FILE=.gate-handoff   DONE_FILE=.done   MONITOR_DIR=.monitor
#   HB_CYCLE_CMD='…'        commande custom imprimant le nb de cycles (sinon auto-détecté)
# ─────────────────────────────────────────────────────────────────────────────
set -uo pipefail
REPO="${1:-.}"; cd "$REPO" || { echo "monitor-watch: repo introuvable: $REPO" >&2; exit 2; }

LOOP_SCRIPT="${LOOP_SCRIPT:-loop.sh}"
HEARTBEAT="${HEARTBEAT:-1800}"
POLL="${POLL:-30}"
STALL_HB="${STALL_HB:-2}"
HANDOFF_FILE="${HANDOFF_FILE:-.gate-handoff}"
DONE_FILE="${DONE_FILE:-.done}"
MONITOR_DIR="${MONITOR_DIR:-.monitor}"

# Vitalité du verrou : helper COMMUN lock-alive.sh (pid du verrou + identité ancrée au repo —
# fin du pgrep global multi-projets, M10 : « BOUCLE ARRÊTÉE » se déclenche même si une boucle
# d'un AUTRE projet tourne). Repli si absent (vieux kit) : pgrep historique — dégradé, sûr.
_LA="$(cd "$(dirname "$0")" 2>/dev/null && pwd -P)/lock-alive.sh"
if [ -f "$_LA" ]; then . "$_LA"; else lock_alive() { pgrep -f "$LOOP_SCRIPT" >/dev/null 2>&1; }; fi

# Nb de cycles/itérations effectués (auto) : marqueurs d'itération du kit ({"type":"loop"}), sinon
# "CYCLE" dans un log de boucle (forks run-vN.sh), sinon nb de commits. Override : HB_CYCLE_CMD.
cycles() {  # shlint-ok (branches if/return EXCLUSIVES : une seule valeur émise par appel)
            # Jamais « cmd || echo 0 » ici : grep -c imprime 0 ET sort en rc=1 sur zéro match,
            # le || doublerait la sortie → capture $() cassée (« integer expression expected »).
  local n
  if [ -n "${HB_CYCLE_CMD:-}" ]; then n="$(eval "$HB_CYCLE_CMD" 2>/dev/null || true)"; echo "${n:-0}"; return; fi
  n="$(cat "$MONITOR_DIR"/*.jsonl 2>/dev/null | grep -c '"type":"loop"' || true)"
  [ "${n:-0}" -gt 0 ] 2>/dev/null && { echo "$n"; return; }
  local out; out="$(ls -1t "$MONITOR_DIR"/*.out 2>/dev/null | head -1)"
  if [ -n "$out" ]; then n="$(grep -c "CYCLE" "$out" 2>/dev/null || true)"; echo "${n:-0}"; return; fi
  n="$(git rev-list --count HEAD 2>/dev/null || true)"; echo "${n:-0}"
}
head_sha() { git rev-parse --short HEAD 2>/dev/null || echo none; }

echo "🩺 monitor-watch · repo=$(pwd) · loop=$LOOP_SCRIPT · heartbeat=${HEARTBEAT}s · poll=${POLL}s"
last=0; prev_head="$(head_sha)"; stale=0; gate_susp_noted=0
while true; do
  # ── Signal 1 : gate visuel/device requis ────────────────────────────────
  if [ -f "$HANDOFF_FILE" ]; then
    # M2 : en mode contrôlé (un verdict existe), ne réveiller l'humain que sur PASS RÉEL ancré
    # sur le HEAD courant (même sémantique que verdict_real_pass de loop.sh) — sinon le gate est
    # SUSPENDU (revue en cours / contrôleuse en panne) : on note UNE fois et on continue de
    # surveiller au lieu de réveiller pour du code non revu. Coder-only (pas de verdict) ou jq
    # absent (invérifiable) : réveil immédiat historique conservé.
    VERDICT_FILE=".loop/control/last-verdict.json"   # miroir du défaut CTL_DIR de loop.sh
    _wake=1
    if [ -f "$VERDICT_FILE" ] && command -v jq >/dev/null 2>&1; then
      _wake=0
      _v="$(jq -r '.verdict // ""' "$VERDICT_FILE" 2>/dev/null)"
      _ps="$(jq -r '.provisional // .stale // false' "$VERDICT_FILE" 2>/dev/null)"
      _vh="$(jq -r '.head // ""' "$VERDICT_FILE" 2>/dev/null)"
      _hv="$(git rev-parse --verify --quiet "$_vh^{commit}" 2>/dev/null)"
      if [ "$_v" = PASS ] && [ "$_ps" = false ] && [ -n "$_hv" ] \
        && [ "$_hv" = "$(git rev-parse HEAD 2>/dev/null)" ]; then _wake=1; fi
    fi
    if [ "$_wake" = 1 ]; then
      echo "🚦 $(date '+%H:%M') GATE-HANDOFF → gate visuel/device requis ($HANDOFF_FILE). Contenu :"
      cat "$HANDOFF_FILE" 2>/dev/null; exit 0
    fi
    if [ "$gate_susp_noted" = 0 ]; then
      echo "⏸ $(date '+%H:%M') gate SUSPENDU (verdict non-PASS ou périmé — revue en cours), surveillance continue."
      gate_susp_noted=1
    fi
  fi
  # ── Signal 2 : boucle terminée / arrêtée ────────────────────────────────
  if [ -f "$DONE_FILE" ]; then echo "✅ $(date '+%H:%M') DONE ($DONE_FILE) → boucle terminée."; exit 0; fi
  if ! lock_alive .; then
    echo "⏹ $(date '+%H:%M') BOUCLE ARRÊTÉE (fin/crash/max_cycles — verrou mort ou absent) → inspecte $MONITOR_DIR (logs + .err + verdict)."; exit 0
  fi
  # ── Signal 3 : HEARTBEAT inconditionnel (cycles + HEAD) ──────────────────
  now=$(date +%s)
  if [ $((now - last)) -ge "$HEARTBEAT" ]; then
    C="$(cycles)"; H="$(head_sha)"
    if [ "$H" = "$prev_head" ]; then stale=$((stale + 1)); else stale=0; prev_head="$H"; fi
    if [ "$stale" -ge "$STALL_HB" ]; then
      echo "🛑 $(date '+%H:%M') PATINE : HEAD FIGÉ ($H) sur $stale battements alors que cycles=$C montent → la boucle n'avance plus, INTERVIENS (inspecte, ré-injecte ou stoppe)."
    else
      echo "💓 $(date '+%H:%M') HEARTBEAT · cycles=$C · HEAD=$H"
    fi
    last=$now
  fi
  sleep "$POLL"
done
