// ─────────────────────────────────────────────────────────────────────────────
// actions.mjs — LES VERBES BORNÉS. Surface de pilotage distant COMPLÈTE : ce fichier est la
// frontière de sécurité. Tout ce qu'un ordre venu du réseau peut déclencher est ici, et RIEN d'autre.
//
// RÈGLES ABSOLUES (ne pas assouplir sans mesurer le risque) :
//   1. Ensemble FINI de verbes (VERBS). Aucun verbe = aucune exécution.
//   2. AUCUN texte libre n'atteint jamais le prompt d'un agent. Pas d'écriture dans .loop/inject.md.
//      → Un canal de texte libre vers un agent auto-approuvé = exécution de code arbitraire à distance.
//   3. La cible d'un ordre est TOUJOURS validée contre les boucles RÉELLEMENT découvertes par le scan
//      local (snapshot). Un chemin arbitraire venu du réseau est refusé — le distant ne peut désigner
//      que ce que la machine a elle-même trouvé.
//   4. Aucun argument libre n'est passé à un shell (spawn sans shell, argv fixe).
//
// Pire cas si le serveur distant est compromis : on relance / arrête / débloque des boucles. Pas de
// prise de contrôle de la machine.
// ─────────────────────────────────────────────────────────────────────────────
import { spawn, execFileSync } from "node:child_process";
import { existsSync, readFileSync, rmSync, openSync } from "node:fs";
import { join, resolve, sep, basename } from "node:path";
import { snapshot } from "./scan.mjs";
import { MONITOR_DIR, LOCK_DIR, CTL_DIR, VERDICT_FILE } from "./kit-paths.mjs";

export const VERBS = ["gate.validate", "loop.start", "loop.stop", "loop.restart"];

// Nom canonique du script de boucle du kit. UNE SEULE source (utilisée par startLoop) — mais
// l'IDENTITÉ d'un process ne repose JAMAIS sur ce nom : scan.mjs découvre une boucle par la
// présence de .monitor/*.jsonl, donc tout fork (run-vN.sh) est une boucle de premier rang.
const LOOP_SCRIPT = "loop.sh";

// Résout la boucle ciblée UNIQUEMENT parmi celles que le scan local a réellement trouvées.
function resolveLoop(path) {
  const loop = snapshot().loops.find((l) => l.path === path);
  if (!loop) throw new Error("cible inconnue (non découverte par le scan local) : " + path);
  return loop;
}

// Ligne de commande d'un pid ("" si mort/inconnu). Linux : /proc/<pid>/cmdline est la source
// d'identité DIRECTE du noyau — indépendante de ps (procps peut tronquer selon versions) ; les
// champs sont séparés par NUL. BSD/macOS : pas de /proc → `ps -o command=` (POSIX).
// execFileSync sans shell : argv fixe, aucune interpolation (règle 4).
function cmdline(pid) {
  try { return readFileSync(`/proc/${pid}/cmdline`, "utf8").replace(/\0/g, " ").trim(); } catch {}
  try { return execFileSync("ps", ["-p", String(pid), "-o", "command="], { encoding: "utf8" }).trim(); }
  catch { return ""; }
}

// Le pid est-il une boucle du repo ciblé ? Identité par CHEMIN du SEUL token en position de
// script EXÉCUTÉ : on saute tout préfixe `env` (avec ses options `-x` et ses VAR=val — le
// shebang réel du kit est #!/usr/bin/env bash) puis tout shell (basename ∈ sh|bash|dash|zsh|ksh,
// avec ses options `-x`), sinon on prend argv[0]. Ce token unique doit être un .sh existant DANS
// le repo — démarrage absolu (`sh /repo/run-v7.sh`) ou relatif (`sh run-v7.sh` depuis le repo —
// resolve() contre loop.path). Un .sh en position d'ARGUMENT est REFUSÉ : un éditeur/visionneuse
// ouvert sur un fichier du repo (`tail -f run-v7.sh`, `vim loop.sh`) est INNOCENT et ne doit
// jamais recevoir le SIGTERM (c'est le scénario exact que C2 doit empêcher : pid réutilisé
// après reboot + verrou résiduel).
// (Exportée pour les tests unitaires du sandbox — fonction pure, sans effet de bord.)
const SHELLS = /^(sh|bash|dash|zsh|ksh)$/;
export function isLoopProcess(loop, cmd) {
  if (!cmd) return false;
  const toks = cmd.split(/\s+/).map((t) => t.replace(/^["']|["']$/g, "")).filter(Boolean);
  let i = 0;
  for (;;) {
    const b = basename(toks[i] || "");
    if (b === "env") { i++; while (toks[i] && (toks[i].startsWith("-") || toks[i].includes("="))) i++; continue; }
    if (SHELLS.test(b)) { i++; while (toks[i]?.startsWith("-")) i++; continue; }
    break;
  }
  const t = toks[i];
  if (!t || !t.endsWith(".sh")) return false;
  const p = resolve(loop.path, t);
  return p.startsWith(loop.path + sep) && existsSync(p);
}

function stopLoop(loop) {
  if (!loop.pid) return "aucun pid (boucle non gérée par ce kit ou déjà arrêtée)";
  // Jamais de SIGTERM à un pid NON IDENTIFIÉ : après reboot/coupure le verrou survit (résidu
  // documenté) et l'OS RÉUTILISE les pid → le clic « ■ Arrêter » tuerait un process innocent
  // (IDE, navigateur). Le verrou n'écrit que le pid du script de boucle (echo $$) : on n'arrête
  // que ça — quel qu'en soit le nom (forks inclus).
  const cmd = cmdline(loop.pid);
  if (!isLoopProcess(loop, cmd))
    return `refus : pid ${loop.pid} n'est PAS une boucle de ${loop.path} (${cmd || "process mort"})` +
      ` — verrou résiduel ? rm -rf ${join(loop.path, MONITOR_DIR, LOCK_DIR)}`;
  try { process.kill(loop.pid, "SIGTERM"); } catch (e) { return "kill impossible : " + e.code; }
  return `SIGTERM envoyé au pid ${loop.pid}`;
}

function startLoop(loop) {
  const sh = join(loop.path, LOOP_SCRIPT);
  if (!existsSync(sh)) throw new Error(LOOP_SCRIPT + " absent dans " + loop.path);
  if (loop.locked) return "déjà en cours (verrou présent) — rien à faire";
  const out = openSync(join(loop.path, MONITOR_DIR, "loop.out"), "a");
  // spawn SANS shell : argv fixe, aucune interpolation → aucune injection possible.
  const p = spawn(sh, [], { cwd: loop.path, detached: true, stdio: ["ignore", out, out] });
  p.unref();
  return `boucle relancée (pid ${p.pid})`;
}

export async function execute(verb, path) {
  if (!VERBS.includes(verb)) throw new Error("verbe non autorisé : " + verb);
  const loop = resolveLoop(path);

  switch (verb) {
    case "gate.validate": {
      // L'humain a fait le contrôle visuel/device → on retire la sentinelle. La boucle peut repartir.
      const gf = join(loop.path, ".gate-handoff");
      if (!existsSync(gf)) return "aucun gate en attente";
      // M2 : en mode contrôlé (un verdict existe), REFUSER sans PASS RÉEL ancré sur le HEAD
      // courant (M4) — sinon l'UI distante valide du code jamais revu (contrôleuse morte ×N →
      // handoff + verdict stale sur disque). Même sémantique que verdict_real_pass de loop.sh.
      // Hors mode contrôlé (coder-only, pas de verdict) : suppression directe historique.
      const vf = join(loop.path, CTL_DIR, VERDICT_FILE);
      if (existsSync(vf)) {
        let why = null;
        try {
          const v = JSON.parse(readFileSync(vf, "utf8"));
          const rev = (ref) => {
            try {
              return execFileSync("git", ["rev-parse", "--verify", "--quiet", ref + "^{commit}"],
                { cwd: loop.path, encoding: "utf8", stdio: ["ignore", "pipe", "ignore"] }).trim() || null;
            } catch { return null; }
          };
          if (v?.verdict !== "PASS") why = "verdict=" + (v?.verdict ?? "illisible");
          else if (v.provisional === true || v.stale === true) why = "verdict provisoire/stale (pas une revue réelle)";
          else if (typeof v.head !== "string" || rev(v.head) === null || rev(v.head) !== rev("HEAD"))
            why = `verdict ancré sur ${v.head ?? "?"} ≠ HEAD courant (périmé)`;
        } catch (e) { why = "verdict illisible : " + e.message; }
        if (why) return `refus : mode contrôlé sans PASS réel ancré sur HEAD (${why}) — la contrôleuse doit d'abord valider le commit du handoff`;
      }
      rmSync(gf, { force: true });
      return "gate validé (.gate-handoff retiré) — relance la boucle pour continuer";
    }
    case "loop.stop":
      return stopLoop(loop);
    case "loop.start":
      return startLoop(loop);
    case "loop.restart": {
      const s = stopLoop(loop);
      await new Promise((r) => setTimeout(r, 1500));           // laisse le trap EXIT nettoyer le verrou
      const fresh = snapshot().loops.find((l) => l.path === path) || loop;
      return s + " ; " + startLoop({ ...fresh, locked: false });
    }
  }
}
