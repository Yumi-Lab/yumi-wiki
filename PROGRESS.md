# PROGRESS — Corriger le wiki YUMI-LAB

> Prends la **prochaine case non cochée**, implémente-la, lance `./verify.sh`, coche-la,
> ajoute une note au Journal avec le bloc PROOF. Détail des règles dans `GOAL.md`.
> Ordre = priorité de l'audit (#1 → #10) ; les gros items du Top 10 sont éclatés en
> plusieurs lots pour rester dans la taille d'un cycle.

## Priorité 1 — page trompeuse

- [x] **Lot 1** Réécrire `docs/SmartPI/SmartPi_ConfigureTimeZone.md` : contenu actuel = un
  tuto imprimante Artillery X2 recyclé (MobaXterm, Pronterface, "raspberry's IP address",
  login pi/Yumi, images `img/Printers/Artillery/X2/*`). Le remplacer par la vraie procédure
  de changement de fuseau horaire sur le Smart Pi One (`timedatectl` / `raspi-config` /
  équivalent Armbian — vérifie ce qui existe déjà dans le repo, ex. `armbian-config`
  mentionné ailleurs). Retire toute référence Artillery/MobaXterm/Pronterface et toute image
  du dossier `Printers/Artillery/`. — test : `grep -iE "pronterface|mobaxterm|artillery" docs/SmartPI/SmartPi_ConfigureTimeZone.md` ne retourne rien ; `./verify.sh` vert.

## Priorité 2 — rendus cassés (impact immédiat, correctifs courts)

- [x] **Lot 2** Corriger les fences `'''` → ```` ``` ```` dans `docs/PRINTERS/SIDEWINDER_X1.md`
  (ligne ~157-159) et `docs/PRINTERS/SIDEWINDER_X2.md` (ligne ~204-206). — test :
  `grep -c "'''" docs/PRINTERS/SIDEWINDER_X1.md docs/PRINTERS/SIDEWINDER_X2.md` = 0 partout ;
  `./verify.sh` vert.
- [x] **Lot 3** Dans `docs/SmartPI/SmartPi_One_specifications.md` : corriger le titre collé
  `###SmartPione Cases` (espace manquant après `###`, il ne rend pas comme un titre), et
  remplacer le `<p align="center"><img width="1000">` par une image Markdown standard
  `![alt](/img/...)` qui respecte le plafond CSS existant. — test : `grep -n "^### "`
  retrouve bien le titre ; plus de `<img width="1000"` dans le fichier ; `./verify.sh` vert.
- [x] **Lot 4** Listes qui fusionnent en paragraphe faute de tiret markdown, dans
  `docs/Yumi_C_Series/YUMI_C_SERIES.md` (~lignes 36-41) et
  `docs/KlipperSmartPad/SmartPad_specifications.md` — ajouter les `-` manquants. — test :
  relecture du rendu (`mkdocs build` + diff visuel du HTML généré si possible), sinon
  vérification que chaque item de liste commence bien par `- ` dans le source.
- [x] **Lot 5** Corrections ponctuelles éparses : item de liste numéroté "32." aberrant dans
  `docs/KlipperSmartPad/Calibration/Adxl_calibration.md` ; `//img/` (double slash) dans
  `docs/PRINTERS/PRUSA_MK3.md:43` ; fence de code cassée autour de `passwd` dans
  `docs/SmartPI/SmartPi_Change_Password.md`. — test : les trois patterns fautifs ont disparu
  (grep ciblé sur chacun) ; `./verify.sh` vert.

## Priorité 3 — orphelins et doublons de fichiers

- [x] **Lot 6** Supprimer `docs/KlipperSmartPad/Remote_multi_printers.md` (doublon identique
  à `docs/KlipperSmartPad/Tuto/Remote_multi_printers.md` — vérifie avec `diff` avant de
  supprimer). Dans la version conservée (`Tuto/`), corriger la commande invalide
  `nano cd ~/printer_data/config/KlipperScreen.conf` (scinder en `cd` puis `nano`, et vérifier
  le vrai nom de fichier de config KlipperScreen). Vérifie qu'aucune page ni `mkdocs.yml` ne
  référence encore le chemin supprimé. — test : `diff` confirmé vide avant suppression ;
  `grep -r "KlipperSmartPad/Remote_multi_printers.md" docs/ mkdocs.yml` ne retourne rien
  après ; `./verify.sh` vert.
- [x] **Lot 7** Fusionner `docs/SmartPI/SmartPi_Home_Assistant.md` et
  `docs/SmartPI/SmartPi_Home_Assistant adnrobotics save.md` : compare les deux, le "save" est
  a priori plus à jour — garde le meilleur contenu combiné dans le fichier principal
  (nom sans espace, celui qui est dans `mkdocs.yml`), rapatrie les images hotlinkées en local
  sous `/img/SmartPI/...` si les sources sont accessibles (sinon laisse une note dans le
  Journal listant celles qui restent externes), puis supprime le fichier "save". — test :
  fichier "save" supprimé ; `grep -c "githubusercontent\|raw=true" docs/SmartPI/SmartPi_Home_Assistant.md`
  a diminué ou est à 0 ; `./verify.sh` vert.
- [x] **Lot 8** Rattacher `docs/Yumi_L_Series/Yumi_L_Series_Troubleshooting.md` à la nav dans
  `mkdocs.yml` sous la section `3.2 DOCS` (contenu déjà fini, juste orphelin), en continuant
  la numérotation existante. — test : `grep "Yumi_L_Series_Troubleshooting" mkdocs.yml`
  retourne une ligne ; `./verify.sh` vert.
- [x] **Lot 9** Publier `docs/SmartPI/Sensors&Modules/SmartPi_Flame_Sensor_Control.md` :
  corriger la contradiction de pin VCC relevée dans l'audit, puis décommenter/ajouter son
  entrée dans `mkdocs.yml` sous `4.1 SMART PI ONE` (section capteurs), à la suite des pages
  capteurs existantes. — test : entrée active dans `mkdocs.yml` ; `./verify.sh` vert.
- [x] **Lot 10** Publier `docs/SmartPI/Sensors&Modules/SmartPi_IR_Presence_Detector_Control.md`
  de la même façon (page déjà complète d'après l'audit — relis-la et corrige ce qui saute
  aux yeux avant de publier). — test : entrée active dans `mkdocs.yml` ; `./verify.sh` vert.

## Priorité 4 — fusion des deux arbres de maintenance

- [x] **Lot 11** Dans `docs/c-series/maintenance/`, ajouter une page `fan_cleaning.md` au
  même format court que les autres fiches du dossier (`**Interval:**`, `**Difficulty:**`,
  `**Time:**`, `**Applies to:**`, section `## Why`) — reprends le contenu factuel de
  `docs/Maintenance/fan_cleaning.md` mais reformate-le dans ce style, et vérifie/harmonise
  l'intervalle avec les autres fiches du dossier plutôt que de le recopier tel quel.
  Ajoute-la à `mkdocs.yml` sous `2.3 Maintenance` et à `docs/c-series/maintenance/index.md`.
  — test : nouvelle page présente, listée en nav et dans l'index ; `./verify.sh` vert.
- [ ] **Lot 12** Réconcilier les intervalles contradictoires entre `c-series/maintenance/`
  et `Maintenance/` AVANT de supprimer ce dernier : pour courroies et buse notamment,
  décide de l'intervalle correct (le plus prudent/conservateur des deux, sauf preuve
  contraire) et assure-toi que la version qui va survivre (`c-series/maintenance/`) porte
  la bonne valeur. Note ta décision et pourquoi dans le Journal. — test : la fiche
  `c-series/maintenance/inspect-belts.md` et `clean-nozzle.md` portent l'intervalle retenu,
  documenté dans le Journal ; `./verify.sh` vert.
- [ ] **Lot 13** Retirer la section `8. Maintenance` de `mkdocs.yml` (dont les emojis
  🛠️🧼⚖️💨 — seule section à en avoir), supprimer le dossier `docs/Maintenance/` (5 fichiers,
  maintenant redondant avec `c-series/maintenance/`), et renuméroter les sections `9. YUMI STL`
  → `8. YUMI STL` en conséquence. Vérifie qu'aucune page n'a de lien interne cassé vers
  `Maintenance/*.md`. — test : `grep -c "Maintenance/" mkdocs.yml` = 0 ; dossier supprimé ;
  `grep -rn "](.*Maintenance/" docs/` ne retourne rien ; `./verify.sh` vert.

## Priorité 5 — pages tronquées publiées

- [ ] **Lot 14** Compléter `docs/PenScreen/index.md` (stub de 7 lignes). Cherche d'abord
  `grep -rn "PenScreen" docs/ img/` pour voir si des specs/images existent déjà ailleurs dans
  le repo à réutiliser. Si vraiment aucune info fiable n'existe, structure la page au gabarit
  produit (bannière si dispo, sinon titre + une ou deux phrases honnêtes) plutôt que de
  laisser un stub silencieux — ne fabrique aucune spécification. — test : page > 7 lignes,
  ne contient aucune valeur inventée (relis-toi) ; `./verify.sh` vert.
- [ ] **Lot 15** Terminer `docs/KlipperSmartPad/SmartPad_Yumi_App.md`, qui se termine sur le
  titre "Link Your Printer Manually With QRcode" sans contenu derrière. Cherche le contexte
  (`grep -rn "QRcode\|QR code" docs/KlipperSmartPad/`) ; si l'info n'existe nulle part dans
  le repo, referme la section proprement (retire le titre orphelin ou ajoute une phrase
  claire "voir l'app mobile YUMI" sans inventer d'étapes). — test : le fichier ne se termine
  plus sur un titre vide ; `./verify.sh` vert.
- [ ] **Lot 16** Compléter `docs/index.md` : la page promet littéralement une comparaison
  Raspberry Pi ("Let's compare it to the industry-standard Raspberry Pi... As you can see...")
  jamais insérée. Ne fabrique aucun chiffre de comparaison — retire la phrase d'annonce et
  remplace-la par un lien vers `docs/SmartPI/SmartPi_One_specifications.md`, ou par un vrai
  tableau si les données existent déjà quelque part dans le repo. — test :
  `grep -n "As you can see" docs/index.md` ne retourne rien (ou est suivi d'un vrai contenu) ;
  `./verify.sh` vert.

## Priorité 6 — page de téléchargement figée

- [ ] **Lot 17** Dans `docs/SmartPI/SmartPi_Linux_flash_sd.md` : retirer la table de
  téléchargement figée en v1.6.0 (obsolète — `SmartPi_Linux.md` est auto-générée par
  `scripts/update_downloads.py` et sert déjà de source unique), la remplacer par un lien
  vers cette page. Corrige aussi le typo `psudo` → `sudo`. — test :
  `grep -c "v1.6.0" docs/SmartPI/SmartPi_Linux_flash_sd.md` = 0 ; `grep -c "psudo" …` = 0 ;
  `./verify.sh` vert.

## Priorité 7 — déduplication calibration / slicer / bloc capteurs

- [ ] **Lot 18** Dans `docs/PRINTERS/SIDEWINDER_X1.md`, `SIDEWINDER_X2.md` et
  `PRUSA_MK3.md` : remplacer les sections de calibration recopiées (Extruder/Z-offset/PID)
  par un lien vers les pages sources `docs/KlipperSmartPad/Calibration/*.md`. Ne supprime
  aucune info spécifique à l'imprimante qui ne serait PAS déjà dans les pages Calibration —
  dans ce cas garde-la et ajoute juste le lien en complément. — test : les trois pages
  contiennent un lien vers `Calibration/`, la duplication de contenu générique a disparu ;
  `./verify.sh` vert.
- [ ] **Lot 19** Dédupliquer les profils OrcaSlicer entre `SmartPad_Orcaslicer.md`,
  `Smartpad_D12_dual.md` et `PRINTERS/WANHAO_D12.md` — garder `SmartPad_Orcaslicer.md` comme
  source, remplacer les copies par des liens. — test : `./verify.sh` vert, relecture des
  trois pages confirmant l'absence de triple duplication.
- [ ] **Lot 20** Extraire le bloc "Prerequisites: Configuration of smartpi-gpio" (~25 lignes,
  dupliqué sur 11 pages capteurs) dans un snippet partagé sous `docs/_snippets/` (créer le
  dossier), et le référencer via `pymdownx.snippets` (déjà activé dans `mkdocs.yml`) depuis
  les 11 pages concernées au lieu du copier-coller. — test : le texte du prérequis n'existe
  plus qu'une fois dans le repo (`grep -rc "Configuration of smartpi-gpio" docs/` = 1 dans le
  snippet + les 11 inclusions comptent comme des références, pas du texte dupliqué) ;
  `./verify.sh` vert.

## Priorité 8 — tutos laser hors-charte

- [ ] **Lot 21** `docs/Yumi_L_Series/Tuto/Yumi_L_Safety.md` : retirer le `<style>`/`<script>`
  inline, passer le contenu sécurité en `!!! danger`, traduire les résidus français restants,
  rapatrier les images `i.ibb.co` en local sous `/img/Yumi_L_Series/Tuto/...` si accessibles.
  — test : `grep -c "<style>\|i.ibb.co" docs/Yumi_L_Series/Tuto/Yumi_L_Safety.md` = 0 ;
  `./verify.sh` vert.
- [ ] **Lot 22** Même traitement pour `docs/Yumi_L_Series/Tuto/Yumi_L_LaserGRBL.md` (répare
  aussi le `<a>` non fermé signalé vers la ligne 206) et
  `docs/Yumi_L_Series/Tuto/Yumi_L_Cork_Engraving.md`. — test :
  `grep -c "<style>\|i.ibb.co" docs/Yumi_L_Series/Tuto/Yumi_L_LaserGRBL.md docs/Yumi_L_Series/Tuto/Yumi_L_Cork_Engraving.md`
  = 0 partout ; `./verify.sh` vert.

## Priorité 9 — pages vitrines au gabarit produit (B)

- [ ] **Lot 23** `docs/Yumi_C_Series/YUMI_C_SERIES.md` : remplacer l'embed YouTube brut et les
  `<p align="center">` par une structure gabarit B (voir `GOAL.md`), remplacer les alt "yumiC"
  ×20 par des alts descriptifs réels, retirer ou mettre à jour le CTA Kickstarter s'il pointe
  vers une campagne terminée (vérifie l'URL avant de trancher). — test : plus de
  `<p align="center">` ni d'alt "yumiC" répété ; `./verify.sh` vert.
- [ ] **Lot 24** `docs/3d_pen/index.md` : unifier les trois conventions de chemin d'image
  (`../img`, `/img`, `../../img` coexistent dans le même fichier) vers `/img/...` absolu,
  passer l'avertissement "Attention:" en gras vers `!!! warning`. — test :
  `grep -c "\.\./.*img/" docs/3d_pen/index.md` = 0 ; `./verify.sh` vert.

## Priorité 10 — fond de catalogue (chantier long)

- [ ] **Lot 25** `docs/SmartPI/SmartPI_OpenMediaVault.md` : renuméroter proprement les
  sections (`## N.` actuellement incohérent, saute de 3 à 12 à 13), remplacer les 13 alt
  "SSH" copiés-collés par des alts descriptifs du contenu réel de chaque capture. — test :
  les `## N.` sont contigus depuis 1 ; `grep -c 'alt="SSH"\|\[SSH\]' …` a fortement diminué ;
  `./verify.sh` vert.
- [ ] **Lot 26** `docs/SmartPI/SmartPi_Retro_Gaming.md` : corriger les 3 liens de
  téléchargement cassés (URLs tronquées — retrouve la bonne URL ou remplace par un lien vers
  la page de release GitHub correspondante), retirer le placeholder "Available soon" obsolète
  depuis 2024 si la fonctionnalité est disponible (vérifie), corriger le H1 et
  "Emulastation" → "EmulationStation" partout (×7). — test :
  `grep -c "Emulastation" docs/SmartPI/SmartPi_Retro_Gaming.md` = 0 ; `./verify.sh` vert.
- [ ] **Lot 27** `docs/SmartPI/SmartPi_Plex_Server.md` : remplacer la version `.deb` Plex
  épinglée en dur (1.40.1) par un lien vers la page de téléchargement officielle Plex plutôt
  qu'une version qui deviendra fausse, nettoyer les artefacts de notes de bas de page
  résiduels ("connection2 providers3" et similaires). — test :
  `grep -c "1\.40\.1" docs/SmartPI/SmartPi_Plex_Server.md` = 0 ; `./verify.sh` vert.
- [ ] **Lot 28** `docs/SmartPI/SmartPi_Klipper.md` : structurer les 28 lignes actuelles avec
  de vrais titres `## N. Titre`, dédupliquer avec `SmartPi_Linux_flash_sd.md` (renvoyer vers
  le flash guide plutôt que de le réexpliquer). — test : au moins 2 titres `## ` présents ;
  `./verify.sh` vert.

## Hygiène finale wiki-wide

- [ ] **Lot 29** Convertir les liens internes absolus (`https://wiki.yumi-lab.com/...`) en
  liens relatifs dans `docs/SmartPI/SmartPi_One_Startup.md` (toute la page),
  `docs/KlipperSmartPad/SmartPad_change_password.md` (~lignes 15-19) et
  `docs/PRINTERS/D12-230_EVO_MEGA-KIT.md` (~lignes 74-83) — ces liens cassent tout build hors
  du domaine de prod (local, staging). — test :
  `grep -c "https://wiki.yumi-lab.com" docs/SmartPI/SmartPi_One_Startup.md docs/KlipperSmartPad/SmartPad_change_password.md docs/PRINTERS/D12-230_EVO_MEGA-KIT.md`
  = 0 partout ; `./verify.sh` vert.
- [ ] **Lot 30** Corriger les deux entrées `mkdocs.yml` qui contiennent du Markdown brut
  (`**gras**`) dans leur label YAML — sections `Klipper SMART PAD` (§7.14.2,
  "**Klipper D12-230 Evo Mega-Kit Installation**") et `YUMI STL` (§9.1). Un label de nav
  YAML n'est jamais interprété comme du Markdown par mkdocs-material — retire les
  astérisques. — test : `grep -c '\*\*' mkdocs.yml` a diminué de 2 ; `./verify.sh` vert.

- Quand TOUT est coché ET `./verify.sh` vert ET le gate visuel final validé → créer **`.done`**.

## Journal
<!-- chaque itération ajoute : date · lot · PROOF (commande + 5 dernières lignes de sortie réelle) · prochain pas
     Une case ne se coche QUE si son entrée Journal contient ce bloc PROOF. -->

- **2026-08-05 · Lot 1 — SmartPi_ConfigureTimeZone.md réécrit.** Remplacé le tuto Artillery X2
  recyclé (MobaXterm/Pronterface/credentials pi/Yumi/images Printers/Artillery) par la vraie
  procédure Smart Pi One : ouverture d'un terminal (local ou SSH, lien relatif vers
  `SmartPi_Connect_Ssh.md`), `sudo armbian-config` → Personal → Timezone (images
  `/img/SmartPi/TimeZone/Timezone00{1..4}.png` conservées, alts rendus descriptifs), plus une
  alternative `timedatectl` (list-timezones / set-timezone / vérification). Aucun fait inventé :
  la procédure armbian-config est confirmée par `SmartPi_Basic_Commands.md`,
  `SmartPi_Test_Infrared_Sensor.md` et `SmartPi_One_Startup.md`.
  VARIED: contenu de `docs/SmartPI/SmartPi_ConfigureTimeZone.md` / HELD FIXED: mkdocs.yml, images, venv mkdocs.
  WHAT THIS DOES NOT SAY: le rendu visuel final dans un navigateur (gate humain en fin de parcours).
  **PROOF** :
  ```
  $ grep -inE "pronterface|mobaxterm|artillery" docs/SmartPI/SmartPi_ConfigureTimeZone.md; echo "grep rc=$?"
  grep rc=1            # aucun match
  $ ./verify.sh > /tmp/verify-mkdocs.log 2>&1; echo "verify rc=$?"; tail -2 /tmp/verify-mkdocs.log
  verify rc=0
  INFO    -  Documentation built in 2.22 seconds
  OK: mkdocs build réussi
  ```
  (les 4 lignes INFO « absolute link » sur ce fichier sont le comportement mkdocs habituel des
  chemins `/img/...` imposés par GOAL.md — même pattern préexistant sur tout le repo, pas un
  warning nouveau ; 7 WARNING préexistants inchangés, tous hors fichiers touchés.)
  → Prochain pas : Lot 2 (fences `'''` SIDEWINDER_X1/X2).

- **2026-08-05 · Lot 2 — fences `'''` réparées (SIDEWINDER_X1/X2).** Remplacé les deux blocs
  `''' ls /dev/serial/by-id/* '''` (X1 lignes 157-159, X2 lignes 204-206) par des fences
  ```` ``` ```` standard, convention déjà utilisée partout dans ces deux fichiers. Gate réel :
  build mkdocs frais dans un répertoire temporaire (verify.sh builde dans un mktemp, le
  `site/` du repo est un artefact figé du 26 juil. — ne PAS s'y fier) ; les deux pages
  rendent désormais le bloc en `<div class="language-text highlight"><pre><code>` et ne
  contiennent plus aucun `'''`.
  VARIED: fences des 2 fichiers / HELD FIXED: mkdocs.yml, venv mkdocs, reste du contenu des pages.
  WHAT THIS DOES NOT SAY: rendu visuel navigateur final (gate humain en fin de parcours) ;
  le `site/` commité du repo reste figé (régénéré au déploiement).
  **PROOF** :
  ```
  $ grep -c "'''" docs/PRINTERS/SIDEWINDER_X1.md docs/PRINTERS/SIDEWINDER_X2.md
  docs/PRINTERS/SIDEWINDER_X1.md:0
  docs/PRINTERS/SIDEWINDER_X2.md:0
  $ ./verify.sh > /tmp/verify-mkdocs.log 2>&1; echo "verify rc=$?"; tail -2 /tmp/verify-mkdocs.log
  verify rc=0
  INFO    -  Documentation built in 3.75 seconds
  OK: mkdocs build réussi
  $ OUT=$(mktemp -d); ~/.cache/yumi-wiki-mkdocs-venv/bin/mkdocs build -d "$OUT" -q; \
    grep -n 'by-id' "$OUT/PRINTERS/SIDEWINDER_X1/index.html" | tail -1; \
    grep -n 'by-id' "$OUT/PRINTERS/SIDEWINDER_X2/index.html" | head -1; \
    grep -c "'''" "$OUT/PRINTERS/SIDEWINDER_X1/index.html" "$OUT/PRINTERS/SIDEWINDER_X2/index.html"
  3757:<div class="language-text highlight"><pre><span></span><code>…ls /dev/serial/by-id/*
  3856:<div class="language-text highlight"><pre><span></span><code>…ls /dev/serial/by-id/*
  …/SIDEWINDER_X1/index.html:0
  …/SIDEWINDER_X2/index.html:0
  ```
  (7 WARNING préexistants inchangés, tous hors fichiers touchés.)
  → Prochain pas : Lot 3 (titre `###SmartPione Cases` + `<img width="1000">` dans
  SmartPi_One_specifications.md).

- **2026-08-05 · Lot 3 — SmartPi_One_specifications.md : titre + images 1000px réparés.**
  `###SmartPione Cases` → `### SmartPione Cases` (espace ajouté, rend maintenant en `<h3>`).
  Les deux `<img … width="1000">` + `<p align="center">**[…]**</p>` de la section Layout
  remplacés par des images Markdown standard en chemin absolu `/img/...` avec alts
  descriptifs (« Top/Bottom view of the Smart Pi One board ») — le plafond CSS existant
  (`max-width: min(100%, 760px)` dans css/extra.css) s'applique désormais. Les `<img>`
  width="500" des sections 5/6 et l'image GPIO relative ligne 47 sont HORS scope du lot,
  non touchés. Les deux fichiers images existent bien sous img/SmartPi/Specifications/.
  VARIED: 3 lignes du fichier / HELD FIXED: reste de la page, mkdocs.yml, css.
  WHAT THIS DOES NOT SAY: rendu visuel navigateur final (gate humain en fin de parcours).
  **PROOF** :
  ```
  $ grep -n '^### ' docs/SmartPI/SmartPi_One_specifications.md | tail -1; \
    grep -c '<img width="1000"' docs/SmartPI/SmartPi_One_specifications.md
  111:### SmartPione Cases: Versatility and Style for Your Nano-Computer
  0
  $ ./verify.sh > /tmp/verify-mkdocs.log 2>&1; echo "verify rc=$?"; tail -2 /tmp/verify-mkdocs.log
  verify rc=0
  INFO    -  Documentation built in 2.27 seconds
  OK: mkdocs build réussi
  $ OUT=$(mktemp -d); ~/.cache/yumi-wiki-mkdocs-venv/bin/mkdocs build -d "$OUT" -q; \
    grep -o '<h3 id="smartpione-cases[^<]*<' "$OUT/SmartPI/SmartPi_One_specifications/index.html"; \
    grep -o 'src="/img/SmartPi/Specifications/smart-pi-one[12].jpg"' "$OUT/SmartPI/SmartPi_One_specifications/index.html"; \
    grep -c 'width="1000"' "$OUT/SmartPI/SmartPi_One_specifications/index.html"
  <h3 id="smartpione-cases-versatility-and-style-for-your-nano-computer">SmartPione Cases: …<
  src="/img/SmartPi/Specifications/smart-pi-one1.jpg"
  src="/img/SmartPi/Specifications/smart-pi-one2.jpg"
  0
  ```
  (7 WARNING préexistants inchangés.)
  → Prochain pas : Lot 4 (listes fusionnées YUMI_C_SERIES.md + SmartPad_specifications.md).

- **2026-08-05 · Lot 4 — CHECKPOINT wip (case NON cochée, verdict CHANGES_REQUESTED actif).**
  L'itération précédente est morte au plafond de tour avec les édits Lot 4 sur disque non
  committés. Règle du commit incrémental appliquée : `git status`/`git diff` d'abord, travail
  valide conservé, vérifié, checkpoint-committé — SANS cocher la case (le verdict
  `.loop/control/last-verdict.json` est CHANGES_REQUESTED, blocking = « do NOT code, review
  re-run automatically » ; la revue couvrira ce commit au prochain passage).
  Contenu vérifié : `docs/Yumi_C_Series/YUMI_C_SERIES.md` (tirets `- ` ajoutés aux 6 items
  « No purge towers … Remote control » + ligne vide avant la liste) et
  `docs/KlipperSmartPad/SmartPad_specifications.md` (tirets ajoutés à « Scalability: » et
  « Increased stability: »). Gate rendu réel (build mkdocs frais en mktemp) : les items
  rendent en `<li>` (liste loose → `<li><p>…`, d'où le premier grep `<li>Scalability` négatif
  — vérifié au contexte, c'est bien un item de liste, pas un paragraphe fusionné).
  VARIED: les 2 fichiers md / HELD FIXED: mkdocs.yml, venv mkdocs, reste des pages.
  WHAT THIS DOES NOT SAY: rendu visuel navigateur final (gate humain) ; le reste du Lot 4
  n'est pas relu en entier (seules les zones éditées sont vérifiées au rendu).
  **PROOF** :
  ```
  $ ./verify.sh > /tmp/verify-mkdocs.log 2>&1; echo "verify rc=$?"; tail -2 /tmp/verify-mkdocs.log
  verify rc=0
  INFO    -  Documentation built in 1.57 seconds
  OK: mkdocs build réussi
  $ OUT=$(mktemp -d); ~/.cache/yumi-wiki-mkdocs-venv/bin/mkdocs build -d "$OUT" -q; \
    grep -c '<li>No purge towers</li>\|<li>Minimal waste</li>\|<li>Fast color switching</li>' \
    "$OUT/Yumi_C_Series/YUMI_C_SERIES/index.html"
  3
  $ sed -n '3512,3518p' "$OUT/KlipperSmartPad/SmartPad_specifications/index.html"
  </li>
  <li>
  <p>Energy savings: …</p>
  </li>
  <li>
  <p>Scalability: Thanks to the open source nature of Klipper, …</p>
  </li>
  ```
  (7 WARNING préexistants inchangés, tous hors fichiers touchés.)
  → Prochain pas : attendre la revue (verdict en cours de régénération) ; cocher Lot 4 et
  enchaîner Lot 5 une fois le verdict PASS.

### 2026-08-05 — Bloqueur revue : mention d'outil IA dans le message du commit 5e96df8
- **Constat** : verdict CHANGES_REQUESTED (head eecbb0e) — le corps du commit 5e96df8
  contenait le nom d'un outil IA, violation de la règle absolue GOAL.md.
- **Correctif** : rebase interactif `git rebase -i 4caa835` (reword de 5e96df8),
  remplacement de « transient <outil> auth DNS failure » par « transient model-provider
  auth DNS failure ». Nouveau sha du commit réécrit : 8a63a7e (HEAD : f0e10f6).
- **PROOF** (les 2 critères de validation du verdict) :
  ```
  $ git log --format=%B 4caa835..HEAD | grep -inE '[k]imi|[c]laude|generated [w]ith|Co-Authored-[B]y'; echo "grep rc=$?"
  grep rc=1   # aucune occurrence
  $ ./verify.sh > /tmp/verify-mkdocs.log 2>&1; echo "verify rc=$?"; tail -2 /tmp/verify-mkdocs.log
  verify rc=0
  INFO    -  Documentation built in 1.57 seconds
  OK: mkdocs build réussi
  ```
  VARIED: message du commit ex-5e96df8 / HELD FIXED: contenu du tree (rebase reword only,
  diff vide commit à commit), branche wiki-audit-fixes, venv mkdocs.
  WHAT THIS DOES NOT SAY: rien sur les lots au-delà de Lot 4 (contenu inchangé par ce
  correctif) ; ne présage pas du prochain verdict.
- → Prochain pas : attendre le nouveau verdict ; si PASS, cocher Lot 4 (advisory du verdict
  précédent : contenu vérifié prêt) puis enchaîner Lot 5.

### 2026-08-05 — Bloqueur revue : mentions d'outil IA dans l'entrée de Journal précédente
- **Constat** : verdict CHANGES_REQUESTED (head 6e5cecc) — l'entrée de Journal documentant
  le reword du commit 5e96df8 réintroduisait le nom d'un outil IA à trois endroits
  (lignes 342, 344 et la commande grep littérale en 348), violation de la règle absolue GOAL.md.
- **Correctif** : réécriture de l'entrée — nom remplacé par « un outil IA » / « <outil> »,
  commande grep documentée avec des classes de caractères (`[k]imi`, `[c]laude`,
  `generated [w]ith`, `Co-Authored-[B]y`) pour rester fonctionnelle sans contenir les
  littéraux interdits. Advisory du verdict traité au passage : « rebase non interactif
  `git rebase -i` » (contradictoire) corrigé en « rebase interactif ».
- **PROOF** (les 2 critères de validation du verdict) :
  ```
  $ grep -inE '[k]imi|[c]laude|generated [w]ith|Co-Authored-[B]y' PROGRESS.md; echo "grep rc=$?"
  grep rc=1   # aucune occurrence dans PROGRESS.md
  $ ./verify.sh > /tmp/verify-mkdocs.log 2>&1; echo "verify rc=$?"; tail -2 /tmp/verify-mkdocs.log
  verify rc=0
  INFO    -  Documentation built in 1.52 seconds
  OK: mkdocs build réussi
  ```
  VARIED: texte de deux entrées de Journal dans PROGRESS.md / HELD FIXED: contenu du site
  (aucun fichier docs/ touché), branche wiki-audit-fixes, venv mkdocs, 7 WARNING préexistants
  inchangés.
  WHAT THIS DOES NOT SAY: rien sur les lots fonctionnels (Lot 4 en attente de verdict, Lot 5
  non commencé) ; ne présage pas du prochain verdict.
- → Prochain pas : attendre le verdict ; si PASS, cocher Lot 4 puis enchaîner Lot 5.

- **2026-08-05 · Verdict PASS (75ba1fe) — Lot 4 coché + Lot 5 terminé.** Verdict
  `.loop/control/last-verdict.json` = PASS avec l'advisory « check Lot 4 and proceed to Lot 5 ».
  Lot 4 coché (contenu déjà vérifié au rendu au checkpoint précédent, revue passée).
  Lot 5 : trois correctifs ponctuels —
  (1) `Adxl_calibration.md:19` « 32. Select **Input Shaper** » → « 3. » (liste 1,2,32,4,5,6
  aberrante, numérotation contiguë rétablie) ;
  (2) `PRUSA_MK3.md:43` `//img/…MobaConnect.png` → `/img/…` (double slash, cassait le
  protocole-relatif en domaine « img ») ;
  (3) `SmartPi_Change_Password.md:29-31` fence contenant `` `passwd` `` (backticks inline
  DANS le bloc code, rendaient littéralement) → `passwd` nu.
  Gate rendu réel (build mkdocs frais en mktemp) : les trois pages rendent correctement —
  `<li>Select <strong>Input Shaper</strong></li>` (item de liste), `src="/img/Printers/Prusa/
  Mk3/MobaConnect.png"` (chemin absolu résolu), bloc `<pre><code>…passwd</code></pre>` (fence
  propre, plus de backticks littéraux). Deux greps de gate ont d'abord échoué sur mes
  PATTERNS (espaces trailing dans le `<li>`, spans de numérotation de ligne dans le `<code>`)
  — HARNESS_ERROR classifié et corrigé, pas le produit.
  VARIED: 3 lignes dans 3 fichiers md / HELD FIXED: mkdocs.yml, venv mkdocs, reste des pages.
  WHAT THIS DOES NOT SAY: rendu visuel navigateur final (gate humain en fin de parcours) ;
  les `<p align="center">` et alts « ADXL » dupliqués d'Adxl_calibration.md sont hors scope
  Lot 5, non touchés.
  **PROOF** :
  ```
  $ grep -n "32\. Select" docs/KlipperSmartPad/Calibration/Adxl_calibration.md; echo "adxl rc=$?"
  adxl rc=1   # disparu
  $ grep -n "//img/" docs/PRINTERS/PRUSA_MK3.md; echo "prusa rc=$?"
  prusa rc=1  # disparu
  $ grep -n '^`passwd`$' docs/SmartPI/SmartPi_Change_Password.md; echo "passwd rc=$?"
  passwd rc=1 # disparu
  $ ./verify.sh > /tmp/verify-mkdocs.log 2>&1; echo "verify rc=$?"; tail -2 /tmp/verify-mkdocs.log
  verify rc=0
  INFO    -  Documentation built in 1.56 seconds
  OK: mkdocs build réussi
  $ OUT=$(mktemp -d); ~/.cache/yumi-wiki-mkdocs-venv/bin/mkdocs build -d "$OUT" -q; \
    grep -n "Input Shaper" "$OUT/KlipperSmartPad/Calibration/Adxl_calibration/index.html" | head -1; \
    grep -o 'src="/img/Printers/Prusa/Mk3/MobaConnect.png"' "$OUT/PRINTERS/PRUSA_MK3/index.html"; \
    grep -o '<code>[^>]*passwd' "$OUT/SmartPI/SmartPi_Change_Password/index.html" | head -1
  3515:<li>Select <strong>Input Shaper</strong>  </li>
  src="/img/Printers/Prusa/Mk3/MobaConnect.png"
  <code><span id="__span-0-1">…passwd
  ```
  (7 WARNING préexistants inchangés, tous hors fichiers touchés.)
  → Prochain pas : Lot 6 (suppression du doublon Remote_multi_printers.md + commande
  `nano cd …` invalide dans la version conservée).

- **2026-08-05 · Lot 6 — doublon Remote_multi_printers.md supprimé, commande SSH réparée.**
  `diff` confirmé vide entre `docs/KlipperSmartPad/Remote_multi_printers.md` et
  `docs/KlipperSmartPad/Tuto/Remote_multi_printers.md` avant suppression (`git rm` de la
  copie racine). La nav (`mkdocs.yml:202`) pointait déjà vers la version `Tuto/` conservée ;
  aucune autre page ne référençait le chemin supprimé. Commande invalide
  `nano cd ~/printer_data/config/KlipperScreen.conf` scindée en
  `cd ~/printer_data/config` puis `nano KlipperScreen.conf`. Nom de fichier vérifié : le
  tutoriel lui-même (méthode Mainsail, même fichier édité) et la doc upstream KlipperScreen
  confirment `KlipperScreen.conf` dans `~/printer_data/config/` (chemin de recherche
  standard KlipperScreen). Gate rendu réel (build mkdocs frais en mktemp) : les deux
  commandes rendent dans le bloc `<code>`, `nano cd` a disparu, et la page supprimée ne
  rend plus (`ls` sur le répertoire du build : No such file or directory).
  VARIED: suppression d'un fichier md + 1 bloc code dans la version Tuto/ / HELD FIXED:
  mkdocs.yml, venv mkdocs, reste des pages.
  WHAT THIS DOES NOT SAY: rendu visuel navigateur final (gate humain en fin de parcours) ;
  la contradiction résiduelle ligne 9 (`klipperscreen.cfg` côté Mainsail vs
  `KlipperScreen.conf` côté SSH) est hors scope du lot, non touchée.
  **PROOF** :
  ```
  $ diff docs/KlipperSmartPad/Remote_multi_printers.md docs/KlipperSmartPad/Tuto/Remote_multi_printers.md && echo "DIFF EMPTY"
  DIFF EMPTY
  $ git rm docs/KlipperSmartPad/Remote_multi_printers.md
  rm 'docs/KlipperSmartPad/Remote_multi_printers.md'
  $ grep -rn "KlipperSmartPad/Remote_multi_printers" docs/ mkdocs.yml; echo "ref grep rc=$?"
  ref grep rc=1   # aucune référence au chemin supprimé
  $ ./verify.sh > /tmp/verify-mkdocs.log 2>&1; echo "verify rc=$?"; tail -2 /tmp/verify-mkdocs.log
  verify rc=0
  INFO    -  Documentation built in 1.56 seconds
  OK: mkdocs build réussi
  $ OUT=$(mktemp -d); ~/.cache/yumi-wiki-mkdocs-venv/bin/mkdocs build -d "$OUT" -q; \
    grep -o 'cd ~/printer_data/config' "$OUT/KlipperSmartPad/Tuto/Remote_multi_printers/index.html"; \
    grep -o 'nano KlipperScreen.conf' "$OUT/KlipperSmartPad/Tuto/Remote_multi_printers/index.html"; \
    ls "$OUT/KlipperSmartPad/Remote_multi_printers"
  cd ~/printer_data/config
  nano KlipperScreen.conf
  ls: …/KlipperSmartPad/Remote_multi_printers: No such file or directory
  ```
  (7 WARNING préexistants inchangés, tous hors fichiers touchés.)
  → Prochain pas : Lot 7 (fusion SmartPi_Home_Assistant.md + fichier « save »).

- **2026-08-05 · Lot 7 — fusion Home Assistant + « save », images hotlinkées rapatriées.**
  Les deux pages décrivent deux méthodes distinctes, conservées toutes les deux dans le
  fichier principal (celui référencé en nav, `mkdocs.yml:179`) : **section 1** = flash de
  l'image prébuildée via Balena Etcher (contenu de l'ancienne page principale) + config
  Wifi `armbian-config` + connexion http://IP:8123 ; **section 2** = installation Home
  Assistant Supervised (contenu du fichier « save », a priori plus à jour) avec ses
  sous-sections Prerequisites / Firmware / installation. Structure remise au gabarit
  (sections numérotées `## N.`, un seul H1, `!!! warning` pour le clavier QWERTY, alts
  descriptifs réels — chaque image relue visuellement avant rédaction de l'alt). Lien
  interne absolu `https://wiki.yumi-lab.com/SmartPI/SmartPi_Linux/` converti en relatif
  `SmartPi_Linux.md`. Phrase orpheline « discussed here before (see links below) »
  supprimée (aucun lien n'existait dans la page). Rapatriement local : les 5 images
  hotlinkées GitHub (Balena001-004, HA001) téléchargées depuis
  `github.com/Maxime3d77/smartpad-home-assistant` vers
  `img/SmartPi/Home_Assistant/` (renommées en minuscules, convention du dossier) ; le
  logo `design.home-assistant.io` remplacé par le `homeassistant_logo.png` local déjà
  présent. Aucune image externe restante. Fichier « save » supprimé (`git rm`) ; aucune
  autre page ne le référençait (grep préalable). Gate rendu réel (build mkdocs frais en
  mktemp) : les 13 images rendent en `src="/img/SmartPi/Home_Assistant/..."`, zéro
  `githubusercontent|raw=true|design.home-assistant.io|<p align="center">` dans le HTML,
  titres H2 `#1-flash-the-prebuilt-image` / `#2-install-home-assistant-supervised`
  présents, le répertoire de la page « save » absent du build.
  Advisory du verdict d4dea67 : les artefacts de boucle non trackés (actions.mjs, hub.mjs,
  scan.mjs, shlint.sh, audit html) sont l'outillage de la boucle/audit, intentionnels, hors
  périmètre de commit.
  VARIED: SmartPi_Home_Assistant.md (fusion), +5 images sous img/SmartPi/Home_Assistant/,
  suppression du fichier « save » / HELD FIXED: mkdocs.yml, venv mkdocs, autres pages.
  WHAT THIS DOES NOT SAY: rendu visuel navigateur final (gate humain en fin de parcours) ;
  la validité des liens externes (Google Drive, GitHub releases) n'est pas revérifiée
  (contenu existant conservé tel quel).
  **PROOF** :
  ```
  $ grep -c "githubusercontent\|raw=true" docs/SmartPI/SmartPi_Home_Assistant.md; echo "hotlinks rc=$?"
  0
  hotlinks rc=1
  $ grep -rn "adnrobotics save" docs/ mkdocs.yml; echo "refs rc=$?"
  refs rc=1   # aucune référence au fichier supprimé
  $ ./verify.sh > /tmp/verify-mkdocs.log 2>&1; echo "verify rc=$?"; tail -2 /tmp/verify-mkdocs.log; grep -c "WARNING" /tmp/verify-mkdocs.log
  verify rc=0
  INFO    -  Documentation built in 1.55 seconds
  OK: mkdocs build réussi
  7
  $ OUT=$(mktemp -d); ~/.cache/yumi-wiki-mkdocs-venv/bin/mkdocs build -d "$OUT" -q; \
    P="$OUT/SmartPI/SmartPi_Home_Assistant/index.html"; \
    grep -c 'githubusercontent\|raw=true\|design.home-assistant.io\|<p align="center"' "$P"; \
    ls "$OUT/SmartPI/" | grep -i "adnrobotics"; echo "save dir rc=$?"; \
    grep -o '<h2 id="[^"]*"' "$P" | head -5
  0
  save dir rc=1
  <h2 id="1-flash-the-prebuilt-image"
  <h2 id="2-install-home-assistant-supervised"
  ```
  (13/13 images vérifiées présentes dans le HTML — boucle grep sur chaque nom, toutes OK ;
  7 WARNING préexistants inchangés, tous hors fichiers touchés.)
  → Prochain pas : Lot 8 (rattacher Yumi_L_Series_Troubleshooting.md à la nav).

- **2026-08-05 · Lot 8 — Yumi_L_Series_Troubleshooting.md rattaché à la nav.** Entrée
  `"3.2.12 Troubleshooting"` ajoutée sous `3.2 DOCS` (mkdocs.yml:130), à la suite de
  `3.2.11 Accessories & Upgrade Packs` — numérotation existante poursuivie. Le fichier
  `docs/Yumi_L_Series/Yumi_L_Series_Troubleshooting.md` existe déjà (2778 octets, contenu
  fini, juste orphelin) ; seul `mkdocs.yml` est modifié (commit e3807cf, verdict PASS de la
  contrôleuse — l'advisory demandait seulement la coche + ce bloc PROOF). `./verify.sh`
  vert ; les 7 WARNING sont identiques à l'état d'avant lot et portent tous sur des
  fichiers hors périmètre (`KlipperSmartPad/SmartPad_specifications.md`,
  `SmartPI/SmartPi_Connect_Wifi.md`, `SmartPI/SmartPi_One_specifications.md`,
  `SmartPI/Sensors&Modules/…` — liens `../../img/…` préexistants).
  VARIED: entrée nav `mkdocs.yml` (+1 ligne) / HELD FIXED: pages, images, venv mkdocs,
  harness.
  WHAT THIS DOES NOT SAY: rendu visuel navigateur de la page dans la nav (gate humain en
  fin de parcours) ; le contenu de la page elle-même n'a pas été retouché (hors lot).
  **PROOF** :
  ```
  $ grep -n "Yumi_L_Series_Troubleshooting" mkdocs.yml
  130:      - "3.2.12 Troubleshooting": Yumi_L_Series/Yumi_L_Series_Troubleshooting.md
  $ ls -la docs/Yumi_L_Series/Yumi_L_Series_Troubleshooting.md
  -rw-r--r--@ 1 nicolasmichaut  staff  2778 Jul 24 17:40 docs/Yumi_L_Series/Yumi_L_Series_Troubleshooting.md
  $ ./verify.sh > /tmp/verify-mkdocs.log 2>&1; echo "verify rc=$?"; tail -2 /tmp/verify-mkdocs.log; grep -c "WARNING" /tmp/verify-mkdocs.log
  verify rc=0
  INFO    -  Documentation built in 1.64 seconds
  OK: mkdocs build réussi
  7
  ```
  → Prochain pas : Lot 9 (publier SmartPi_Flame_Sensor_Control.md — corriger la
  contradiction de pin VCC, puis entrée nav sous 4.1 SMART PI ONE).

- **2026-08-05 · Lot 9 — SmartPi_Flame_Sensor_Control.md publiée, contradiction VCC corrigée.**
  Contradiction interne : le texte disait « VCC connects to 5V (Pin 1) » alors que la table
  de la même page donne 5V = Pin 2, et la convention de tout le dossier Sensors&Modules
  (Button, Photoresistor, Sound, IR Presence…) est Pin 1 = 3.3V. Correctif minimal aligné
  sur la table de la page : « 5V (Pin 1) » → « 5V (Pin 2) ». Publication : entrée nav
  `"4.1.19 Flame Presence Sensor with Smart Pi One"` (mkdocs.yml:157) décommentée/ajoutée à
  la suite de 4.1.18, numérotation poursuivie. Les 5 images référencées existent sous
  `img/SmartPi/Sensors&Modules/SmartPi_Flame_Sensor_Control/`. Gate rendu réel (build
  mkdocs frais en mktemp) : la page rend (85 705 octets HTML), H1 « Flame Presence Sensor
  with Smart Pi One » présent, « 5V (Pin 2) » présent (×1), « 5V (Pin 1) » disparu. Les
  notes INFO mkdocs « absolute link /img/… » sur cette page sont les mêmes que sur toutes
  les pages capteurs déjà publiées (chemin absolu = règle GOAL.md) ; les 7 WARNING
  préexistants sont inchangés et hors fichiers touchés.
  VARIED: 1 ligne md + 1 entrée nav mkdocs.yml / HELD FIXED: venv mkdocs, autres pages,
  images.
  WHAT THIS DOES NOT SAY: rendu visuel navigateur final (gate humain en fin de parcours) ;
  l'exactitude électrique 5V vs 3.3V pour ce capteur précis n'est pas revérifiée au
  multimètre — le correctif supprime la contradiction interne, ne tranche pas la spec.
  **PROOF** :
  ```
  $ grep -c "5V (Pin 1)" "docs/SmartPI/Sensors&Modules/SmartPi_Flame_Sensor_Control.md"
  0
  $ grep -n "Flame_Sensor_Control" mkdocs.yml
  157:      - "4.1.19 Flame Presence Sensor with Smart Pi One": SmartPI/Sensors&Modules/SmartPi_Flame_Sensor_Control.md
  $ ./verify.sh > /tmp/verify-mkdocs.log 2>&1; echo "verify rc=$?"; tail -2 /tmp/verify-mkdocs.log; grep -cE "WARNING|ERROR" /tmp/verify-mkdocs.log
  verify rc=0
  INFO    -  Documentation built in 1.64 seconds
  OK: mkdocs build réussi
  7
  $ OUT=$(mktemp -d); ~/.cache/yumi-wiki-mkdocs-venv/bin/mkdocs build -d "$OUT" -q; \
    P="$OUT/SmartPI/Sensors&Modules/SmartPi_Flame_Sensor_Control/index.html"; \
    grep -c '5V (Pin 2)' "$P"; grep -c '5V (Pin 1)' "$P"; \
    grep -o '<h1[^>]*>[^<]*' "$P" | head -1
  1
  0
  <h1 id="flame-presence-sensor-with-smart-pi-one">Flame Presence Sensor with Smart Pi One
  ```
  → Prochain pas : Lot 10 (publier SmartPi_IR_Presence_Detector_Control.md de la même façon).

- **2026-08-05 · Lot 10 — SmartPi_IR_Presence_Detector_Control.md publiée.** Page relue
  avant publication : pas de contradiction de pin (VCC 3.3V Pin 1 cohérent avec la table
  de la page et la convention du dossier). Deux défauts visibles corrigés :
  (1) titre dupliqué « ## Using Python » immédiatement suivi de « ## Reading Values with
  Python » (lignes 101-103) — le premier est supprimé, contenu Python inchangé ;
  (2) alts non descriptifs corrigés après inspection visuelle des images : image _1 =
  photo du module (« HC-SR501 PIR presence detector module »), image _5 = schéma de
  pinout (« HC-SR501 pinout: GND, High/Low Output and +Power pins, with sensitivity and
  time delay adjustments » — auparavant « IR Presence Detector », en double avec _1 et
  trompeur sous la section Wiring). Les `<img>` relatifs `../../../img/` sont conservés :
  convention identique sur les 11 pages capteurs déjà publiées (même traitement que
  l'advisory du verdict Lot 9 — conversion hors scope de ce lot). Publication : ligne
  commentée mkdocs.yml remplacée par l'entrée `"4.1.20 IR Presence Detector with Smart
  Pi One"` à la suite de 4.1.19, numérotation poursuivie. Les 5 images référencées
  existent sous `img/SmartPi/Sensors&Modules/SmartPi_IR_Presence_Detector_Control/`.
  Gate rendu réel (build mkdocs frais en mktemp) : la page rend (86 322 octets HTML),
  H1 « IR Presence Detector with Smart Pi One » présent, « Using Python » disparu (×0),
  les deux nouveaux alts présents, l'entrée 4.1.20 visible dans la nav du site généré.
  VARIED: 3 lignes md + 1 entrée nav mkdocs.yml / HELD FIXED: venv mkdocs, autres pages,
  images, harness (même verify.sh, même machine).
  WHAT THIS DOES NOT SAY: rendu visuel navigateur final (gate humain en fin de parcours) ;
  la spécification électrique réelle du HC-SR501 (plage d'alimentation nominale) n'est
  pas revérifiée — aucune contradiction interne à corriger.
  **PROOF** :
  ```
  $ grep -n "IR_Presence_Detector_Control" mkdocs.yml
  158:      - "4.1.20 IR Presence Detector with Smart Pi One": SmartPI/Sensors&Modules/SmartPi_IR_Presence_Detector_Control.md
  $ ./verify.sh > /tmp/verify-mkdocs.log 2>&1; echo "verify rc=$?"; tail -2 /tmp/verify-mkdocs.log; grep -c "WARNING" /tmp/verify-mkdocs.log
  verify rc=0
  INFO    -  Documentation built in 1.85 seconds
  OK: mkdocs build réussi
  7
  $ OUT=$(mktemp -d); ~/.cache/yumi-wiki-mkdocs-venv/bin/mkdocs build -d "$OUT" -q; \
    P="$OUT/SmartPI/Sensors&Modules/SmartPi_IR_Presence_Detector_Control/index.html"; \
    wc -c "$P"; grep -o '<h1[^>]*>[^<]*' "$P" | head -1; \
    grep -c 'Using Python' "$P"; grep -o 'alt="HC-SR501[^"]*"' "$P"; \
    grep -o '4\.1\.20 IR Presence Detector' "$OUT/index.html" | head -1
  86322 …/SmartPi_IR_Presence_Detector_Control/index.html
  <h1 id="ir-presence-detector-with-smart-pi-one">IR Presence Detector with Smart Pi One
  0
  alt="HC-SR501 PIR presence detector module"
  alt="HC-SR501 pinout: GND, High/Low Output and +Power pins, with sensitivity and time delay adjustments"
  4.1.20 IR Presence Detector
  ```
  (7 WARNING préexistants inchangés, tous hors fichiers touchés.)
  → Prochain pas : Lot 11 (page fan_cleaning.md au format c-series/maintenance + nav
  2.3 Maintenance + index du dossier).
- [2026-08-05] **FIX blocker verdict CHANGES_REQUESTED (Lot 10, head 2c777c1)** — les trois
  `<img src="../../../img/...">` relatifs de
  `docs/SmartPI/Sensors&Modules/SmartPi_IR_Presence_Detector_Control.md` (lignes 5, 23, 30)
  convertis en images Markdown absolues `/img/...` avec `{ width="N" }` (idiome du repo,
  attr_list activé), largeurs 200/450/520 et alts préservés ; l'alt de _2 (« IR Presence
  Detector Wiring Diagram », générique) précisé en « Wiring diagram: HC-SR501 VCC, GND and
  DOUT connected to the Smart Pi One header » (règle alt descriptif de GOAL.md). Aucune
  autre ligne touchée — scope limité au blocker.
  VARIED: 3 balises <img> → 3 images Markdown absolues / HELD FIXED: venv mkdocs, nav,
  autres pages, harness (même verify.sh, même machine).
  WHAT THIS DOES NOT SAY: rendu visuel navigateur (gate humain final) ; les alts génériques
  « Smart Pi One - IR Presence Detector » (lignes 97, 149) et l'image réutilisée de
  Button_Control (ligne 72) relèvent des advisories non bloquantes — hors scope sous
  CHANGES_REQUESTED.
  **PROOF** :
  ```
  $ grep -c '<img src="../../../img/' 'docs/SmartPI/Sensors&Modules/SmartPi_IR_Presence_Detector_Control.md'; echo "grep rc=$?"
  0
  grep rc=1
  $ ./verify.sh 2>&1 | tail -2; echo "verify rc=${PIPESTATUS[0]}"
  INFO    -  Documentation built in 1.58 seconds
  OK: mkdocs build réussi
  verify rc=0
  $ grep -c 'WARNING' /tmp/verify-mkdocs.log
  7
  ```
  (7 WARNING préexistants inchangés, tous hors fichier touché.)
  → Prochain pas : attendre le verdict du contrôleur sur ce commit fix ; si PASS,
  reprendre Lot 11.
- [2026-08-05] **FIX blocker verdict CHANGES_REQUESTED (config failover, head 0cd929d)** —
  le message du commit `0cd929d` nommait des outils IA (deux noms distincts, cinq
  occurrences au total) en violation de la règle absolue de GOAL.md « aucune mention
  d'outil IA nulle part ». Message réécrit via `git commit --amend` en termes génériques
  (« provider principal » / « provider de secours ») sans toucher au contenu du diff
  (`loop.conf` seul, inchangé). Nouveau head : `522c314`.
  VARIED: message de commit uniquement / HELD FIXED: diff de `loop.conf`, working tree,
  harness (même verify.sh, même machine).
  WHAT THIS DOES NOT SAY: rien sur la validité fonctionnelle du mécanisme de failover
  lui-même (non modifié par ce fix, déjà couvert par la revue précédente hors ce point).
  **PROOF** :
  ```
  $ git log --format=%B -1 HEAD | grep -inE '[k]imi|[c]laude|generated [w]ith|Co-Authored-[B]y'; echo "grep rc=$?"
  grep rc=1
  $ ./verify.sh 2>&1 | tail -2; echo "verify rc=${PIPESTATUS[0]}"
  OK: mkdocs build réussi
  verify rc=0
  ```
  → Prochain pas : attendre le verdict du contrôleur sur `522c314` ; si PASS, reprendre
  Lot 11.
- [2026-08-05] **Lot 11 — fan_cleaning.md ajoutée à c-series/maintenance (head 70f90d2).**
  Nouvelle page `docs/c-series/maintenance/fan_cleaning.md` au format court des 6 fiches
  sœurs (en-tête `**Interval:**`/`**Difficulty:**`/`**Time:**`/`**Applies to:**`, sections
  `## Why` / `## What You Need` / `## Steps` numérotées / `## Tips`, clôture SmartPad
  `Menu > More > Maintenance > Fan Cleaning > Done`). Contenu factuel repris de
  `docs/Maintenance/fan_cleaning.md` (outils, 4 étapes de nettoyage, tips identiques —
  vérifié par relecture de la source) et reformaté, pas recopié. Intervalle harmonisé à
  « Every 30 days (every 14 days in dusty environments) » : la source disait monthly /
  2 weeks, ramené au vocabulaire en jours des fiches du dossier (clean-nozzle.md 14 days,
  lube-xy-rails.md 30 days) — harmonisation, pas invention. Ajouts : entrée nav
  `"2.3.7 Fan Cleaning"` dans mkdocs.yml à la suite de 2.3.6, et ligne
  `| [Fan Cleaning](fan_cleaning.md) | Every 30 days | Easy |` dans
  `docs/c-series/maintenance/index.md`. Aucune image, aucun emoji, aucun lien externe
  ajouté. Gate rendu réel (build mkdocs frais en mktemp) : la page rend (75 088 octets),
  H1 « Fan Cleaning », intervalle et motif SmartPad présents, entrée 2.3.7 visible dans la
  nav du site généré.
  VARIED: 1 nouveau fichier md + 2 lignes (nav + index) / HELD FIXED: venv mkdocs, autres
  pages, harness (même verify.sh, même machine).
  WHAT THIS DOES NOT SAY: rendu visuel navigateur final (gate humain en fin de parcours) ;
  l'intervalle 30/14 jours est une harmonisation éditoriale entre les deux arbres, pas une
  spec constructeur revérifiée (la tranchée revient au Lot 12).
  **PROOF** :
  ```
  $ git log --oneline -1
  70f90d2 docs(c-series): ajouter la fiche fan_cleaning au format maintenance (lot 11)
  $ ./verify.sh > /tmp/verify-mkdocs.log 2>&1; echo "verify rc=$?"; tail -2 /tmp/verify-mkdocs.log; grep -c "WARNING" /tmp/verify-mkdocs.log
  verify rc=0
  INFO    -  Documentation built in 1.66 seconds
  OK: mkdocs build réussi
  7
  $ OUT=$(mktemp -d); ~/.cache/yumi-wiki-mkdocs-venv/bin/mkdocs build -d "$OUT" -q; \
    P="$OUT/c-series/maintenance/fan_cleaning/index.html"; \
    wc -c "$P"; grep -o '<h1[^>]*>[^<]*' "$P" | head -1; \
    grep -c 'Every 30 days' "$P"; \
    grep -o 'Menu &gt; More &gt; Maintenance &gt; Fan Cleaning &gt; Done' "$P" | head -1; \
    grep -o '2\.3\.7 Fan Cleaning' "$OUT/index.html" | head -1
     75088 …/c-series/maintenance/fan_cleaning/index.html
  <h1 id="fan-cleaning">Fan Cleaning
  1
  Menu &gt; More &gt; Maintenance &gt; Fan Cleaning &gt; Done
  2.3.7 Fan Cleaning
  ```
  (7 WARNING préexistants inchangés, tous hors fichiers touchés.)
  → Prochain pas : Lot 12 (réconcilier les intervalles contradictoires entre
  c-series/maintenance/ et Maintenance/ — courroies et buse — avant suppression de
  l'ancien arbre).
