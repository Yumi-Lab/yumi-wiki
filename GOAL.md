# GOAL — Corriger le wiki YUMI-LAB (audit du 2026-08-05)

> La boucle relit ce fichier à chaque itération. Contexte : un audit croisé (exploration
> Kimi K3 + vérification indépendante par diff/grep/curl sur le site en prod) a identifié
> des bugs de rendu, du contenu trompeur, des doublons structurels et des pages orphelines
> sur wiki.yumi-lab.com. `PROGRESS.md` détaille les lots ; ce fichier fixe le cadre.

## Contexte du dépôt — à savoir AVANT de toucher quoi que ce soit
- Ce repo est **en production**. Un push sur `main` déclenche un **auto-déploiement** (cron
  5 min sur le serveur DE) qui republie immédiatement wiki.yumi-lab.com.
- Tu travailles sur la branche **`wiki-audit-fixes`**, PAS `main`. **Ne fais jamais**
  `git checkout main`, ne merge jamais, et **ne pousse jamais** (`git push`) — tu commits en
  local uniquement. Le merge vers `main` est une décision humaine, hors de cette boucle.
- `docs/img` est un **symlink** vers `img/` à la racine — ajoute les images sous `img/...`,
  jamais `git add docs/img/...` (échoue : "beyond a symbolic link").
- Build de référence : `~/.cache/yumi-wiki-mkdocs-venv/bin/mkdocs build` (venv déjà installé,
  n'en recrée pas un autre). `./verify.sh` l'encapsule — lance-le après CHAQUE lot.

## Definition of Done
- [ ] Tous les lots de `PROGRESS.md` sont cochés, chacun avec un bloc PROOF au Journal.
- [ ] `./verify.sh` est vert sur le dernier commit — **PROOF cmd** : `./verify.sh`
- [ ] Aucun nouveau warning `mkdocs build` introduit par rapport à l'état de départ (compare
      `/tmp/verify-mkdocs.log` avant/après un lot si le nombre de lignes INFO/WARNING grimpe
      de façon suspecte sur un fichier que tu n'as pas touché — signal d'une régression).
- [ ] Le dernier lot (revue visuelle) a été gaté via `.gate-handoff` et validé par l'humain.
- **Quand TOUT est coché ET `./verify.sh` vert ET le gate visuel final validé → créer `.done`.**
  Tant que ce n'est pas le cas : commit + STOP, jamais `.done`.

## Règles absolues
- 🔒 **Aucune mention d'outil IA nulle part** — pas de `Co-Authored-By`, pas de "Claude"/"Kimi"/
  "generated with" dans les commits, le contenu des pages, ou les messages de commit. Les
  commits doivent lire comme écrits par un humain.
- ✅ **Preuve avant de cocher** : bloc PROOF au Journal (commande lancée + sortie réelle, pas
  résumée). Pas de preuve = pas de coche.
- 🚫 **N'invente aucun fait.** Si une info manque pour compléter une page (specs produit,
  contenu réel du PenScreen, etc.), cherche-la ailleurs dans le repo (`grep -r` sur le nom du
  produit) plutôt que de la fabriquer. Si elle n'existe nulle part, laisse un texte honnête et
  court plutôt qu'un paragraphe inventé — jamais de chiffre, date ou capacité non vérifiable.
- 🖼️ **Images toujours en chemin absolu** `/img/...` dans les pages Markdown (jamais
  `../../img/...`, jamais de `<img>` HTML brut sauf cas déjà justifié dans le repo). Alt text
  toujours descriptif du contenu réel de l'image — jamais copié d'une autre page.
- 🚫 **Zéro emoji** dans le contenu ou les labels de nav (`mkdocs.yml`) — règle du projet,
  déjà violée section 8 "Maintenance", à corriger là où tu la croises.
- 🌐 **Zéro dépendance Google/CDN externe non hébergé** — pas de Google Fonts, pas de script
  tiers non vendorisé. Les images externes existantes (i.ibb.co, GitHub raw, Dropbox) doivent
  être rapatriées en local sous `/img/...` quand un lot les touche.
- 📐 **Style du gabarit établi** (voir `docs/SmartPI/OS/index.md` et `docs/SmartPI/AI/index.md`
  comme référence) : sections numérotées `## N. Titre`, admonitions `!!! note`/`!!! warning`/
  `!!! danger` là où c'est pertinent (pas de gras "Attention:" à la place), pas de `<style>`
  inline (tout va dans `css/extra.css` s'il faut vraiment un ajout).
- 🍏 **Ne fais QUE ce que le lot demande.** Pas de refactor opportuniste hors-lot, pas de
  réécriture totale d'une page quand le lot ne demande qu'un correctif ciblé.
- **Staging ciblé** : `git add <fichier>` un par un, jamais `git add -A` ni `git add .`.
- Avance **UN lot par itération** ; mets à jour `PROGRESS.md` + commit à chaque lot.
- Secrets jamais committés (aucun attendu dans ce repo, mais reste vigilant sur d'éventuels
  tokens collés par erreur dans un correctif).

## Gate final (obligatoire avant `.done`)
Une fois tous les lots cochés et `verify.sh` vert : écris **`.gate-handoff`** listant les
5-8 pages les plus modifiées (chemins + ce qui a changé) pour une relecture humaine dans un
navigateur, puis **STOP**. Ne crée `.done` qu'après suppression de `.gate-handoff` par
l'humain (= validation reçue).
