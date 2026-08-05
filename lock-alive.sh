#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# lock-alive.sh — VITALITÉ d'un verrou de boucle. UNE source pour tout le kit (🔒 DRY) :
# sourcé par loop.sh, watchdog.sh, monitor-watch.sh, sync-kit.sh — jamais exécuté seul.
#
#   lock_alive <repo>   rc 0 = le verrou de <repo> désigne une boucle VIVANTE de CE repo
#                       rc 1 = verrou absent, pid mort, pid RÉUTILISÉ par un process innocent
#                             (reboot/coupure), ou process vivant d'un AUTRE repo.
#
# Direction du doute : on ne TUE jamais rien ici. Un faux « vivant » retarde une relance
# (sûr) ; un faux « mort » peut DOUBLER une boucle (dangereux). L'identité est donc LENIENTE :
# UN token .sh de la cmdline résolvant DANS le repo suffit (absolu, ou relatif résolu contre
# le repo — miroir assoupli d'actions.mjs isLoopProcess, qui lui doit être STRICT : il envoie
# SIGTERM). Conséquence assumée : un innocent avec un .sh du repo ouvert (`vim loop.sh`) dont
# le pid aurait été réutilisé est vu « vivant » → verrou conservé, pas de double boucle.
#
# Course au démarrage : le gagnant du mkdir écrit .lock/pid quelques ms APRÈS — si le dossier
# existe sans fichier pid, on attend jusqu'à ~1 s avant de conclure « résidu ».
# ─────────────────────────────────────────────────────────────────────────────

lock_alive() {  # $1 = racine du repo · rc 0 = boucle vivante, rc 1 = verrou mort/absent
  local repo lock pid cmd tok p d ok w
  repo="$(cd "$1" 2>/dev/null && pwd -P)" || return 1
  lock="$repo/${MONITOR_DIR:-.monitor}/.lock"
  [ -d "$lock" ] || return 1
  w=0; while [ ! -f "$lock/pid" ] && [ "$w" -lt 10 ]; do sleep 0.1 2>/dev/null || sleep 1; w=$((w+1)); done
  pid="$(cat "$lock/pid" 2>/dev/null)"
  case "$pid" in ''|*[!0-9]*) return 1 ;; esac
  kill -0 "$pid" 2>/dev/null || return 1
  # Cmdline : /proc est la source DIRECTE du noyau sous Linux (procps peut tronquer ; busybox ps
  # n'a pas -o command=) ; repli ps POSIX (BSD/macOS) — miroir de cmdline() dans actions.mjs.
  if [ -r "/proc/$pid/cmdline" ]; then cmd="$(tr '\0' ' ' < "/proc/$pid/cmdline" 2>/dev/null)"
  else cmd="$(ps -p "$pid" -o command= 2>/dev/null)"; fi
  [ -n "$cmd" ] || return 1
  ok=1
  set -f; set -- $cmd; set +f    # mots de la cmdline, globbing coupé (chemins avec * préservés)
  for tok in "$@"; do
    tok="${tok%\"}"; tok="${tok#\"}"; tok="${tok%\'}"; tok="${tok#\'}"
    case "$tok" in
      *.sh)
        case "$tok" in /*) p="$tok" ;; *) p="$repo/$tok" ;; esac
        # Canonise le DOSSIER (pwd -P) : /tmp → /private/tmp sur macOS, tout symlink de dossier —
        # l'identité compare des chemins RÉELS des deux côtés (repo est déjà en pwd -P).
        d="${p%/*}"; [ -n "$d" ] || d="/"
        d="$(cd "$d" 2>/dev/null && pwd -P)" || continue
        p="$d/${p##*/}"
        case "$p" in "$repo"/*) [ -f "$p" ] && { ok=0; break; } ;; esac
        ;;
    esac
  done
  return $ok
}
