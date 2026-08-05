// kit-paths.mjs — chemins canoniques du kit, UNE SEULE source (règle 🔒 zéro hardcodage / DRY).
// Importé par scan.mjs, actions.mjs, monitor.mjs. (Les scripts shell reçoivent MONITOR_DIR par
// env avec le même défaut ".monitor" — pas d'import commun possible en bash 3.2.)
export const MONITOR_DIR = ".monitor";
export const LOCK_DIR = ".lock";
// Canal contrôleuse → codeuse (miroir du défaut CTL_DIR de loop.sh). Un seul endroit pour le
// chemin du verdict : scan.mjs (statut GATE-REVIEW) et actions.mjs (refus gate.validate) — M2.
export const CTL_DIR = ".loop/control";
export const VERDICT_FILE = "last-verdict.json";
