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
- [x] **Lot 12** Réconcilier les intervalles contradictoires entre `c-series/maintenance/`
  et `Maintenance/` AVANT de supprimer ce dernier : pour courroies et buse notamment,
  décide de l'intervalle correct (le plus prudent/conservateur des deux, sauf preuve
  contraire) et assure-toi que la version qui va survivre (`c-series/maintenance/`) porte
  la bonne valeur. Note ta décision et pourquoi dans le Journal. — test : la fiche
  `c-series/maintenance/inspect-belts.md` et `clean-nozzle.md` portent l'intervalle retenu,
  documenté dans le Journal ; `./verify.sh` vert.
- [x] **Lot 13** Retirer la section `8. Maintenance` de `mkdocs.yml` (dont les emojis
  🛠️🧼⚖️💨 — seule section à en avoir), supprimer le dossier `docs/Maintenance/` (5 fichiers,
  maintenant redondant avec `c-series/maintenance/`), et renuméroter les sections `9. YUMI STL`
  → `8. YUMI STL` en conséquence. Vérifie qu'aucune page n'a de lien interne cassé vers
  `Maintenance/*.md`. — test : `grep -c "Maintenance/" mkdocs.yml` = 0 ; dossier supprimé ;
  `grep -rn "](.*Maintenance/" docs/` ne retourne rien ; `./verify.sh` vert.

## Priorité 5 — pages tronquées publiées

- [x] **Lot 14** Compléter `docs/PenScreen/index.md` (stub de 7 lignes). Cherche d'abord
  `grep -rn "PenScreen" docs/ img/` pour voir si des specs/images existent déjà ailleurs dans
  le repo à réutiliser. Si vraiment aucune info fiable n'existe, structure la page au gabarit
  produit (bannière si dispo, sinon titre + une ou deux phrases honnêtes) plutôt que de
  laisser un stub silencieux — ne fabrique aucune spécification. — test : page > 7 lignes,
  ne contient aucune valeur inventée (relis-toi) ; `./verify.sh` vert.
- [x] **Lot 15** Terminer `docs/KlipperSmartPad/SmartPad_Yumi_App.md`, qui se termine sur le
  titre "Link Your Printer Manually With QRcode" sans contenu derrière. Cherche le contexte
  (`grep -rn "QRcode\|QR code" docs/KlipperSmartPad/`) ; si l'info n'existe nulle part dans
  le repo, referme la section proprement (retire le titre orphelin ou ajoute une phrase
  claire "voir l'app mobile YUMI" sans inventer d'étapes). — test : le fichier ne se termine
  plus sur un titre vide ; `./verify.sh` vert.
- [x] **Lot 16** Compléter `docs/index.md` : la page promet littéralement une comparaison
  Raspberry Pi ("Let's compare it to the industry-standard Raspberry Pi... As you can see...")
  jamais insérée. Ne fabrique aucun chiffre de comparaison — retire la phrase d'annonce et
  remplace-la par un lien vers `docs/SmartPI/SmartPi_One_specifications.md`, ou par un vrai
  tableau si les données existent déjà quelque part dans le repo. — test :
  `grep -n "As you can see" docs/index.md` ne retourne rien (ou est suivi d'un vrai contenu) ;
  `./verify.sh` vert.

## Priorité 6 — page de téléchargement figée

- [x] **Lot 17** Dans `docs/SmartPI/SmartPi_Linux_flash_sd.md` : retirer la table de
  téléchargement figée en v1.6.0 (obsolète — `SmartPi_Linux.md` est auto-générée par
  `scripts/update_downloads.py` et sert déjà de source unique), la remplacer par un lien
  vers cette page. Corrige aussi le typo `psudo` → `sudo`. — test :
  `grep -c "v1.6.0" docs/SmartPI/SmartPi_Linux_flash_sd.md` = 0 ; `grep -c "psudo" …` = 0 ;
  `./verify.sh` vert.

## Priorité 7 — déduplication calibration / slicer / bloc capteurs

- [x] **Lot 18** Dans `docs/PRINTERS/SIDEWINDER_X1.md`, `SIDEWINDER_X2.md` et
  `PRUSA_MK3.md` : remplacer les sections de calibration recopiées (Extruder/Z-offset/PID)
  par un lien vers les pages sources `docs/KlipperSmartPad/Calibration/*.md`. Ne supprime
  aucune info spécifique à l'imprimante qui ne serait PAS déjà dans les pages Calibration —
  dans ce cas garde-la et ajoute juste le lien en complément. — test : les trois pages
  contiennent un lien vers `Calibration/`, la duplication de contenu générique a disparu ;
  `./verify.sh` vert.
- [x] **Lot 19** Dédupliquer les profils OrcaSlicer entre `SmartPad_Orcaslicer.md`,
  `Smartpad_D12_dual.md` et `PRINTERS/WANHAO_D12.md` — garder `SmartPad_Orcaslicer.md` comme
  source, remplacer les copies par des liens. — test : `./verify.sh` vert, relecture des
  trois pages confirmant l'absence de triple duplication.
- [x] **Lot 20** Extraire le bloc "Prerequisites: Configuration of smartpi-gpio" (~25 lignes,
  dupliqué sur 11 pages capteurs) dans un snippet partagé sous `docs/_snippets/` (créer le
  dossier), et le référencer via `pymdownx.snippets` (déjà activé dans `mkdocs.yml`) depuis
  les 11 pages concernées au lieu du copier-coller. — test : le texte du prérequis n'existe
  plus qu'une fois dans le repo (`grep -rc "Configuration of smartpi-gpio" docs/` = 1 dans le
  snippet + les 11 inclusions comptent comme des références, pas du texte dupliqué) ;
  `./verify.sh` vert.

## Priorité 8 — tutos laser hors-charte

- [x] **Lot 21** `docs/Yumi_L_Series/Tuto/Yumi_L_Safety.md` : retirer le `<style>`/`<script>`
  inline, passer le contenu sécurité en `!!! danger`, traduire les résidus français restants,
  rapatrier les images `i.ibb.co` en local sous `/img/Yumi_L_Series/Tuto/...` si accessibles.
  — test : `grep -c "<style>\|i.ibb.co" docs/Yumi_L_Series/Tuto/Yumi_L_Safety.md` = 0 ;
  `./verify.sh` vert.
- [x] **Lot 22** Même traitement pour `docs/Yumi_L_Series/Tuto/Yumi_L_LaserGRBL.md` (répare
  aussi le `<a>` non fermé signalé vers la ligne 206) et
  `docs/Yumi_L_Series/Tuto/Yumi_L_Cork_Engraving.md`. — test :
  `grep -c "<style>\|i.ibb.co" docs/Yumi_L_Series/Tuto/Yumi_L_LaserGRBL.md docs/Yumi_L_Series/Tuto/Yumi_L_Cork_Engraving.md`
  = 0 partout ; `./verify.sh` vert.

## Priorité 9 — pages vitrines au gabarit produit (B)

- [x] **Lot 23** `docs/Yumi_C_Series/YUMI_C_SERIES.md` : remplacer l'embed YouTube brut et les
  `<p align="center">` par une structure gabarit B (voir `GOAL.md`), remplacer les alt "yumiC"
  ×20 par des alts descriptifs réels, retirer ou mettre à jour le CTA Kickstarter s'il pointe
  vers une campagne terminée (vérifie l'URL avant de trancher). — test : plus de
  `<p align="center">` ni d'alt "yumiC" répété ; `./verify.sh` vert.
- [x] **Lot 24** `docs/3d_pen/index.md` : unifier les trois conventions de chemin d'image
  (`../img`, `/img`, `../../img` coexistent dans le même fichier) vers `/img/...` absolu,
  passer l'avertissement "Attention:" en gras vers `!!! warning`. — test :
  `grep -c "\.\./.*img/" docs/3d_pen/index.md` = 0 ; `./verify.sh` vert.

## Priorité 10 — fond de catalogue (chantier long)

- [x] **Lot 25** `docs/SmartPI/SmartPI_OpenMediaVault.md` : renuméroter proprement les
  sections (`## N.` actuellement incohérent, saute de 3 à 12 à 13), remplacer les 13 alt
  "SSH" copiés-collés par des alts descriptifs du contenu réel de chaque capture. — test :
  les `## N.` sont contigus depuis 1 ; `grep -c 'alt="SSH"\|\[SSH\]' …` a fortement diminué ;
  `./verify.sh` vert.
- [x] **Lot 26** `docs/SmartPI/SmartPi_Retro_Gaming.md` : corriger les 3 liens de
  téléchargement cassés (URLs tronquées — retrouve la bonne URL ou remplace par un lien vers
  la page de release GitHub correspondante), retirer le placeholder "Available soon" obsolète
  depuis 2024 si la fonctionnalité est disponible (vérifie), corriger le H1 et
  "Emulastation" → "EmulationStation" partout (×7). — test :
  `grep -c "Emulastation" docs/SmartPI/SmartPi_Retro_Gaming.md` = 0 ; `./verify.sh` vert.
- [x] **Lot 27** `docs/SmartPI/SmartPi_Plex_Server.md` : remplacer la version `.deb` Plex
  épinglée en dur (1.40.1) par un lien vers la page de téléchargement officielle Plex plutôt
  qu'une version qui deviendra fausse, nettoyer les artefacts de notes de bas de page
  résiduels ("connection2 providers3" et similaires). — test :
  `grep -c "1\.40\.1" docs/SmartPI/SmartPi_Plex_Server.md` = 0 ; `./verify.sh` vert.
- [x] **Lot 28** `docs/SmartPI/SmartPi_Klipper.md` : structurer les 28 lignes actuelles avec
  de vrais titres `## N. Titre`, dédupliquer avec `SmartPi_Linux_flash_sd.md` (renvoyer vers
  le flash guide plutôt que de le réexpliquer). — test : au moins 2 titres `## ` présents ;
  `./verify.sh` vert.

## Hygiène finale wiki-wide

- [x] **Lot 29** Convertir les liens internes absolus (`https://wiki.yumi-lab.com/...`) en
  liens relatifs dans `docs/SmartPI/SmartPi_One_Startup.md` (toute la page),
  `docs/KlipperSmartPad/SmartPad_change_password.md` (~lignes 15-19) et
  `docs/PRINTERS/D12-230_EVO_MEGA-KIT.md` (~lignes 74-83) — ces liens cassent tout build hors
  du domaine de prod (local, staging). — test :
  `grep -c "https://wiki.yumi-lab.com" docs/SmartPI/SmartPi_One_Startup.md docs/KlipperSmartPad/SmartPad_change_password.md docs/PRINTERS/D12-230_EVO_MEGA-KIT.md`
  = 0 partout ; `./verify.sh` vert.
- [x] **Lot 30** Corriger les deux entrées `mkdocs.yml` qui contiennent du Markdown brut
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

### 2026-08-05 — Lot 12 : réconciliation des intervalles de maintenance (courroies, buse)
  Comparatif exhaustif des 5 paires de fiches en doublon entre `c-series/maintenance/`
  (arbre survivant) et `docs/Maintenance/` (arbre à supprimer au Lot 13) :
  - Courroies : `inspect-belts.md` disait « Every 90 days » ; `Maintenance/belt_tension_check.md`
    disait 2 mois (usage occasionnel) / 3–4 semaines (usage intensif). CONTRADICTION réelle —
    les deux bras de l'ancienne fiche sont plus fréquents que 90 jours. Décision (règle du lot :
    le plus prudent/conservateur sauf preuve contraire) : intervalle retenu = bras intensif,
    « Every 3–4 weeks (every 2 months at most for occasional use) » — aucune valeur inventée,
    les deux bornes viennent de la table source. Fiche + ligne de l'index
    `c-series/maintenance/index.md` mises à jour.
  - Buse : `clean-nozzle.md` dit « Every 14 days (every 5 spools PLA/PETG, every 2 spools CF) » ;
    `Maintenance/Clean_nozzle.md` dit 2 mois (occasionnel) / 1 mois (régulier) / 2 semaines
    (intensif). La valeur survivante (14 jours) égale déjà le bras le plus prudent (intensif)
    et ajoute une condition par bobine plus fine — AUCUN changement nécessaire, valeur conservée.
  - Plateau : 7 jours côté c-series vs weekly/« every 1 week » côté Maintenance — cohérent, rien.
  - Lubrification X/Y : 30 days vs 1 mois/300 h — cohérent. Z : 90 days vs 3 mois/500 h — cohérent.
  - Ventilateurs : harmonisé au Lot 11 (30/14 jours) vs monthly/2 weeks — cohérent.
  Gate rendu réel (build mkdocs frais en mktemp) : la fiche courroies rend le nouvel intervalle,
  zéro occurrence résiduelle de « Every 90 days » sur sa page, l'index porte « Every 3–4 weeks »,
  la fiche buse rend toujours son intervalle 14 jours inchangé.
  VARIED: 1 ligne d'intervalle (fiche + index) / HELD FIXED: venv mkdocs, autres fiches, harness
  (même verify.sh, même machine).
  WHAT THIS DOES NOT SAY: les intervalles retenus sont une réconciliation éditoriale entre les
  deux arbres existants (bras le plus prudent), pas une spec constructeur revérifiée ; rendu
  visuel navigateur final réservé au gate humain de fin de parcours.
  **PROOF** :
  ```
  $ ./verify.sh > /tmp/verify-mkdocs.log 2>&1; echo "verify rc=$?"; tail -2 /tmp/verify-mkdocs.log; grep -c "WARNING" /tmp/verify-mkdocs.log
  verify rc=0
  INFO    -  Documentation built in 1.59 seconds
  OK: mkdocs build réussi
  7
  $ OUT=$(mktemp -d); ~/.cache/yumi-wiki-mkdocs-venv/bin/mkdocs build -d "$OUT" -q; \
    P="$OUT/c-series/maintenance/inspect-belts/index.html"; \
    grep -o 'Every 3–4 weeks (every 2 months at most for occasional use)' "$P" | head -1; \
    grep -c 'Every 90 days' "$P"; \
    grep -o 'Every 3–4 weeks' "$OUT/c-series/maintenance/index.html" | head -1; \
    grep -o 'Every 14 days (every 5 spools PLA/PETG, every 2 spools CF)' "$OUT/c-series/maintenance/clean-nozzle/index.html" | head -1
  Every 3–4 weeks (every 2 months at most for occasional use)
  0
  Every 3–4 weeks
  Every 14 days (every 5 spools PLA/PETG, every 2 spools CF)
  ```
  (7 WARNING préexistants inchangés, tous hors fichiers touchés.)
  → Prochain pas : Lot 13 (retirer la section 8. Maintenance de mkdocs.yml, supprimer
  docs/Maintenance/, renuméroter 9. YUMI STL → 8.).

### 2026-08-05 — Lot 13 : suppression de la section 8. Maintenance (ancien arbre)
  Section « 8. Maintenance » (5 entrées, seules avec emojis 🛠️🧼⚖️💨) retirée de
  `mkdocs.yml`, dossier `docs/Maintenance/` (5 fichiers, redondant avec
  `c-series/maintenance/` après les lots 11-12) supprimé via `git rm -r`, sections
  renumérotées `9. YUMI STL` → `8. YUMI STL` et `9.1` → `8.1`. Audit préalable :
  aucun lien interne vers `Maintenance/*.md` dans `docs/` (les entrées nav
  « 2.3 Maintenance » et « 3.2.9 Diode Laser Maintenance » pointent vers
  `c-series/maintenance/` et `Yumi_L_Series/`, hors périmètre — inchangées).
  Gate rendu réel (build mkdocs frais en mktemp) : dossier `Maintenance/` absent du
  site généré, nav porte « 8. YUMI STL », zéro occurrence résiduelle des anciennes
  entrées Maintenance, la page YUMI STL rend toujours. Nb : le label « 8.1 **YUMI
  STL…** » contient du Markdown brut — préexistant, traité au Lot 30, pas ici.
  VARIED: 6 lignes nav mkdocs.yml + 5 fichiers supprimés / HELD FIXED: venv mkdocs,
  autres pages, harness (même verify.sh, même machine).
  WHAT THIS DOES NOT SAY: rendu visuel navigateur final (gate humain en fin de
  parcours) ; le contenu des 5 fiches supprimées survit dans
  `c-series/maintenance/` (réconcilié aux lots 11-12).
  **PROOF** :
  ```
  $ grep -c "Maintenance/" mkdocs.yml
  0
  $ ls docs/Maintenance/
  ls: docs/Maintenance/: No such file or directory
  $ grep -rn "](.*Maintenance/" docs/ ; echo "links rc=$?"
  links rc=1
  $ ./verify.sh > /tmp/verify-mkdocs.log 2>&1; echo "verify rc=$?"; tail -2 /tmp/verify-mkdocs.log; grep -c "WARNING" /tmp/verify-mkdocs.log
  verify rc=0
  INFO    -  Documentation built in 1.50 seconds
  OK: mkdocs build réussi
  7
  $ OUT=$(mktemp -d); ~/.cache/yumi-wiki-mkdocs-venv/bin/mkdocs build -d "$OUT" -q; \
    ls "$OUT/Maintenance" 2>&1 | head -1; \
    grep -o '8\. YUMI STL' "$OUT/index.html" | head -1; \
    grep -c 'Maintenance Guide: Lubricating' "$OUT/index.html"; \
    ls "$OUT/Yumi_stl/Printable_Accessories_and_Parts/index.html"
  ls: …/Maintenance: No such file or directory
  8. YUMI STL
  0
  …/Yumi_stl/Printable_Accessories_and_Parts/index.html
  ```
  (7 WARNING préexistants inchangés, tous hors fichiers touchés.)

- **2026-08-05 · Lot 14 — PenScreen/index.md complété honnêtement.** Le stub de 7 lignes
  (dont un titre vide "## Introducing the PenScreen") est devenu une page structurée au
  gabarit : titre, logo existant conservé, section `## 1. Introducing the PenScreen` avec
  le texte d'intro déjà présent (typo "tactil" → "tactile" corrigée au passage), plus une
  admonition `!!! note` annonçant que la documentation détaillée est en cours de rédaction.
  **Aucune spec fabriquée** : `grep -rn "PenScreen"` sur tout le repo ne retourne que la
  page elle-même, mkdocs.yml, README.md (mentions structurelles) et l'audit — aucune image
  (`img/PenScreen/` inexistant), aucune spec réutilisable n'existe. Conformément au lot, la
  page reste donc courte et honnête plutôt qu'inventée.
  VARIED: contenu de `docs/PenScreen/index.md` / HELD FIXED: mkdocs.yml, images, venv mkdocs.
  WHAT THIS DOES NOT SAY: le rendu visuel final dans un navigateur (gate humain en fin de parcours).
  **PROOF** :
  ```
  $ grep -rln "PenScreen" docs/ img/ --include="*.md" | grep -v "PenScreen/index.md"; echo "rc=$?"
  rc=1
  $ wc -l docs/PenScreen/index.md
        11 docs/PenScreen/index.md
  $ ./verify.sh > /tmp/verify-mkdocs.log 2>&1; echo "verify rc=$?"; tail -2 /tmp/verify-mkdocs.log; grep -c "WARNING" /tmp/verify-mkdocs.log
  verify rc=0
  INFO    -  Documentation built in 1.65 seconds
  OK: mkdocs build réussi
  7
  $ grep -i "penscreen" /tmp/verify-mkdocs.log
  INFO    -  Doc file 'PenScreen/index.md' contains an absolute link '/img/Yumi-logoyellow-white.png', it was left as is. Did you mean '../img/Yumi-logoyellow-white.png'?
  ```
  ATTRIBUTION : grep (BSD grep, GNU compatible) 2.6.0-FreeBSD ; mkdocs 1.6.1
  (venv `~/.cache/yumi-wiki-mkdocs-venv`, Python 3.14) ; commit 28b2302f2e5babdf0dd3c97274f5de0ec1d51bba ;
  macOS 15.2 arm64 ; user nicolasmichaut ; 2026-08-05T08:22Z.
  (INFO préexistant sur la ligne logo, déjà présente dans le stub ; règle projet = chemins
  `/img/...` absolus. 7 WARNING préexistants inchangés, hors fichiers touchés.)
  Prochain pas : Lot 15 (terminer `SmartPad_Yumi_App.md`, titre QRcode orphelin).

- **2026-08-05 · Lot 15 — titre orphelin "QRcode" retiré de SmartPad_Yumi_App.md.** La page
  se terminait sur `## Link Your Printer Manually With QRcode` suivi de 11 lignes vides, sans
  aucun contenu. Vérifications avant action : le titre est né vide (copie du fichier depuis
  `SmartPad_Orcaslicer.md` au commit 557d335, jamais rempli ensuite — `git log -p -S "QRcode"`
  ne montre aucune version avec du contenu), et `grep -rln "QRcode\|QR code\|QRCode\|qrcode"
  docs/ img/` ne retourne rien d'exploitable (la seule autre occurrence,
  `docs/c-series/maintenance/index.md:26`, parle de scanner un QR code de guide de maintenance,
  sans rapport avec le linking d'imprimante). Aucune étape inventée : conformément au lot, le
  titre orphelin et les lignes vides sont retirés ; la page se termine désormais sur la section
  complète "Launch the Link Printer wizard".
  VARIED: contenu de `docs/KlipperSmartPad/SmartPad_Yumi_App.md` / HELD FIXED: mkdocs.yml,
  images, venv mkdocs, autres pages.
  WHAT THIS DOES NOT SAY: rendu visuel navigateur final (gate humain en fin de parcours) ;
  existence éventuelle d'une fonction QR dans l'app mobile (hors repo, non vérifiable ici).
  **PROOF** :
  ```
  $ grep -rln "QRcode\|QR code\|QRCode\|qrcode" docs/ img/
  docs//KlipperSmartPad/SmartPad_Yumi_App.md
  docs//c-series/maintenance/index.md
  $ grep -n "QR" docs/c-series/maintenance/index.md
  26:3. Tap **"Guide"** next to any task to scan a QR code with your phone for step-by-step instructions
  $ tail -2 docs/KlipperSmartPad/SmartPad_Yumi_App.md
  The app will start scanning for the Klipper printer connected to the same local network.
  If a printer is found, simply click the "Link" button and the app will do the rest for you.
  $ ./verify.sh > /tmp/verify-mkdocs.log 2>&1; echo "verify rc=$?"; tail -2 /tmp/verify-mkdocs.log; grep -c "WARNING" /tmp/verify-mkdocs.log
  verify rc=0
  INFO    -  Documentation built in 1.53 seconds
  OK: mkdocs build réussi
  7
  ```
  ATTRIBUTION : grep (BSD grep) 2.6.0-FreeBSD ; mkdocs 1.6.1
  (venv `~/.cache/yumi-wiki-mkdocs-venv`, Python 3.14) ; commit c9c1eaa1330e8795f6016294a60194b4a5b4eca3 ;
  macOS 15.2 arm64 ; user nicolasmichaut ; 2026-08-05T08:30Z.
  (7 WARNING préexistants inchangés ; INFO préexistants sur les liens absolus `/img/...` de la
  page touchée — règle projet = chemins absolus, non modifiés.)
  Prochain pas : Lot 16 (compléter `docs/index.md`, promesse de comparaison Raspberry Pi).

- **2026-08-05 · Lot 16 — promesse de comparaison Raspberry Pi retirée de docs/index.md.**
  La page d'accueil annonçait « Let's compare it to the industry-standard Raspberry Pi: » puis
  enchaînait sur « As you can see, ... » sans aucun tableau entre les deux. Vérifications avant
  action : aucun tableau comparatif Smart Pi One vs Raspberry Pi n'existe dans le repo
  (`grep -ri "Raspberry Pi" docs/` — seules occurrences : `SmartPi_RPi_Imager.md`, qui traite de
  l'outil de flash, pas d'une comparaison hardware). Aucun chiffre fabriqué : conformément au
  lot, les deux phrases d'annonce sont remplacées par un lien relatif vers la page de specs
  réelle `SmartPI/SmartPi_One_specifications.md` (présente dans la nav, `mkdocs.yml:140`).
  Le reste de la page (sections "Unleash Your Creativity" etc.) est inchangé.
  VARIED: contenu de `docs/index.md` / HELD FIXED: mkdocs.yml, images, venv mkdocs, autres pages.
  WHAT THIS DOES NOT SAY: rendu visuel navigateur final (gate humain en fin de parcours) ;
  pertinence marketing du nouveau wording.
  **PROOF** :
  ```
  $ grep -n "As you can see\|Let's compare" docs/index.md; echo "grep rc=$?"
  grep rc=1
  $ ./verify.sh 2>&1 | tail -2
  INFO    -  Documentation built in 1.51 seconds
  OK: mkdocs build réussi
  ```
  ATTRIBUTION : grep (BSD grep) 2.6.0-FreeBSD ; mkdocs 1.6.1
  (venv `~/.cache/yumi-wiki-mkdocs-venv`, Python 3.14) ; commit b53abe8 (base de départ) ;
  macOS 15.2 arm64 ; user nicolasmichaut ; 2026-08-05T08:40Z.
  (grep rc=1 = aucune occurrence restante ; WARNING/INFO mkdocs préexistants inchangés, hors
  fichier touché ; le lien `SmartPI/SmartPi_One_specifications.md` est validé par le build,
  aucun warning de lien brisé sur index.md.)
  Prochain pas : Lot 17 (table de téléchargement figée v1.6.0 + typo `psudo` dans
  `SmartPi_Linux_flash_sd.md`).

- **2026-08-05 · Lot 17 — table v1.6.0 figée retirée de SmartPi_Linux_flash_sd.md + typo `psudo` corrigé.**
  La section « 2. Download » contenait une note « Latest release: v1.6.0 (March 1, 2026) » et une
  table de 5 lignes pointant vers des artefacts figés `releases/download/v1.6.0/...`, obsolète
  dès la release suivante. `docs/SmartPI/SmartPi_Linux.md` (nav « 4.2.1 Official Linux Image »,
  mkdocs.yml:164) est auto-générée par `scripts/update_downloads.py` et sert déjà de source
  unique — le lot demande de pointer vers elle, rien d'autre. Remplacé par une phrase + lien
  relatif `SmartPi_Linux.md` ; aucune autre section du tuto (Etcher, first boot, setup) touchée.
  Typo `psudo apt install` → `sudo apt install` (section 7).
  VARIED: contenu de `docs/SmartPI/SmartPi_Linux_flash_sd.md` / HELD FIXED: mkdocs.yml, images,
  SmartPi_Linux.md (auto-générée, non touchée), venv mkdocs, autres pages.
  WHAT THIS DOES NOT SAY: rendu visuel navigateur final (gate humain en fin de parcours) ;
  fraîcheur réelle des artefacts listés sur la page auto-générée.
  **PROOF** :
  ```
  $ grep -c "v1.6.0" docs/SmartPI/SmartPi_Linux_flash_sd.md
  0
  $ grep -c "psudo" docs/SmartPI/SmartPi_Linux_flash_sd.md
  0
  $ ./verify.sh 2>&1 | tail -2
  INFO    -  Documentation built in 1.51 seconds
  OK: mkdocs build réussi
  ```
  ATTRIBUTION : grep (BSD grep) 2.6.0-FreeBSD ; mkdocs 1.6.1
  (venv `~/.cache/yumi-wiki-mkdocs-venv`, Python 3.14) ; commit b53abe8 (base de départ) ;
  macOS 15.2 arm64 ; user nicolasmichaut ; 2026-08-05T08:50Z.
  (critère numérique : les deux grep retournent 0 occurrences ; WARNING mkdocs = 7, inchangés
  vs état de départ ; les INFO « absolute link » sur `/img/...` de ce fichier sont préexistants
  — convention du repo — et le lien relatif `SmartPi_Linux.md` est validé par le build, aucun
  warning de lien brisé.)
  Prochain pas : Lot 18 (déduplication calibration dans SIDEWINDER_X1/X2 et PRUSA_MK3).
- **2026-08-05 · Lot 18 — calibration recopiée remplacée par des liens vers Calibration/ (X1, X2, MK3).**
  Les sections Z-OFFSET (`G28`/`PROBE_CALIBRATE`/`TESTZ`/`ACCEPT`/`SAVE_CONFIG`) et Extruder
  (`M83`, marquage 10/12 cm, `G1 E100 F200`, formule `rotation_distance`) des trois pages
  PRINTERS étaient des copies quasi verbatim de `docs/KlipperSmartPad/Calibration/Z_Offset_calibration.md`
  et `Extruder_calibration.md` → supprimées, remplacées par un bloc de 3 liens relatifs
  `../KlipperSmartPad/Calibration/{PID,Z_Offset,Extruder}_calibration.md` sous le titre
  « N. Calibrating your printer » de chaque page. Les sections BED PID / HOTEND PID sont
  CONSERVÉES : elles décrivent les macros dashboard YumiOS (`BED PID 65`, `HOTEND 220 PID`),
  une procédure absente des pages Calibration (qui utilisent `PID_CALIBRATE` en console) —
  le lot impose de garder toute info non couverte par les pages sources, avec le lien en
  complément (fait dans le bloc d'intro). Titres renumérotés en séquence contiguë
  (X1 : 10→13, X2 : 13→17, MK3 : 11→14). Aucune info spécifique imprimante supprimée.
  VARIED: contenu des 3 pages PRINTERS / HELD FIXED: pages Calibration (sources), mkdocs.yml,
  images, venv mkdocs, autres pages.
  WHAT THIS DOES NOT SAY: rendu visuel navigateur final (gate humain en fin de parcours) ;
  exactitude technique des macros dashboard YumiOS conservées.
  **PROOF** :
  ```
  $ grep -c 'KlipperSmartPad/Calibration' docs/PRINTERS/SIDEWINDER_X1.md docs/PRINTERS/SIDEWINDER_X2.md docs/PRINTERS/PRUSA_MK3.md
  docs/PRINTERS/SIDEWINDER_X1.md:3
  docs/PRINTERS/SIDEWINDER_X2.md:3
  docs/PRINTERS/PRUSA_MK3.md:3
  $ grep -c 'TESTZ\|rotation_distance' docs/PRINTERS/SIDEWINDER_X1.md docs/PRINTERS/SIDEWINDER_X2.md docs/PRINTERS/PRUSA_MK3.md
  docs/PRINTERS/SIDEWINDER_X1.md:0
  docs/PRINTERS/SIDEWINDER_X2.md:0
  docs/PRINTERS/PRUSA_MK3.md:0
  $ grep -n '^## ' docs/PRINTERS/PRUSA_MK3.md | tail -4
  181:## 11. Calibrating your printer
  191:## 12. BED PID
  203:## 13. HOTEND PID
  213:## 14. Print
  $ ./verify.sh 2>&1 | tail -2
  INFO    -  Documentation built in 3.09 seconds
  OK: mkdocs build réussi
  ```
  ATTRIBUTION : grep (BSD grep) 2.6.0-FreeBSD ; mkdocs 1.6.1
  (venv `~/.cache/yumi-wiki-mkdocs-venv`, Python 3.14) ; base revue précédente e211afe
  (head du dernier verdict PASS) ; macOS 15.2 arm64 ; user nicolasmichaut ; 2026-08-05T09:00Z.
  (critère numérique : 3 liens Calibration par page, 0 occurrence TESTZ/rotation_distance,
  titres contigus ; WARNING mkdocs = 7, inchangés, tous dans des fichiers non touchés —
  les nouveaux liens relatifs ne produisent aucun warning de lien brisé.)
  Prochain pas : Lot 19 (déduplication profils OrcaSlicer).
- **2026-08-05 · Lot 19 — déduplication profils OrcaSlicer (source unique SmartPad_Orcaslicer.md).**
  Le paragraphe générique « Add the profile for the wanhao d12 300 to the predefined printers…
  It's an optimized profile… » était copié verbatim à 3 endroits : `PRINTERS/WANHAO_D12.md`
  (§3/§4) et `KlipperSmartPad/Smartpad_D12_dual.md` (sous-sections « Orcaslicer » ×2, versions
  sans/avec purge). `SmartPad_Orcaslicer.md` (source, §1-6 = procédure complète d'installation
  des profils D12) reste la référence ; les copies sont remplacées par un lien relatif vers elle.
  Infos spécifiques CONSERVÉES dans chaque page (absentes de la source) : variantes BLTouch /
  modèles 230-300-500 dans WANHAO_D12.md, note `bl` dans le nom pour le DUAL, et les 3 liens de
  téléchargement distincts (`WanhaoD12Orcaslicer.zip`, `D12-230DUAL.zip`,
  `Wanhao_D12_Profils_Orcaslicer_DUAL.zip` — les 3 zips existent bien dans
  `Profile_Slicer/Orcaslicer/`, vérifié par `ls`). Bonus structurel minimal : le titre vide
  « ## 3. Slicer profile » de WANHAO_D12.md (collé à « ## 4. Orcaslicer ») est fusionné en
  « ## 3. Orcaslicer » et « ## 5. Print » renuméroté « ## 4. Print » (titres contigus, comme lot 18).
  VARIED: contenu de WANHAO_D12.md et Smartpad_D12_dual.md / HELD FIXED: SmartPad_Orcaslicer.md
  (source, non modifiée), mkdocs.yml, zips Profile_Slicer/, venv mkdocs, autres pages.
  WHAT THIS DOES NOT SAY: rendu visuel navigateur final (gate humain en fin de parcours) ;
  validité des URLs Dropbox/GitHub raw externes (non retéléchargées).
  **PROOF** :
  ```
  $ grep -rn "Add the profile for the wanhao" docs/; echo "rc=$?"
  rc=1
  $ grep -rn "It's an optimized profile" docs/PRINTERS/WANHAO_D12.md docs/KlipperSmartPad/Smartpad_D12_dual.md; echo "rc=$?"
  rc=1
  $ ls Profile_Slicer/Orcaslicer/ | grep -iE "wanhao|d12"
  D12-230-PRO-M2-MONO-DUAL-BETA.zip
  D12-230DUAL.zip
  WanhaoD12Orcaslicer.zip
  Wanhao_D12-500_0.4_nozzle_DirectDrive_smartpad.zip
  Wanhao_D12_Profils_Orcaslicer_DUAL.zip
  profilesD1204032025.zip
  $ ./verify.sh > /tmp/verify-mkdocs.log 2>&1; echo "verify rc=$?"; tail -2 /tmp/verify-mkdocs.log
  verify rc=0
  INFO    -  Documentation built in 1.50 seconds
  OK: mkdocs build réussi
  ```
  ATTRIBUTION : grep (BSD grep) 2.6.0-FreeBSD ; mkdocs 1.6.1
  (venv `~/.cache/yumi-wiki-mkdocs-venv`, Python 3.14) ; base ac58d63 (head du verdict PASS
  couvrant le lot 18) ; macOS 15.2 arm64 ; user nicolasmichaut ; 2026-08-05T09:10Z.
  (critère numérique : 0 occurrence du texte dupliqué hors source, les 3 zips référencés
  présents dans le repo ; WARNING mkdocs = 7, inchangés, aucun sur les fichiers touchés —
  les nouveaux liens relatifs `../KlipperSmartPad/SmartPad_Orcaslicer.md` et
  `SmartPad_Orcaslicer.md` ne produisent aucun warning de lien brisé.)
  Prochain pas : Lot 20 (snippet partagé « Configuration of smartpi-gpio », 11 pages capteurs).

- **2026-08-05 · Lot 20 — bloc « Configuration of smartpi-gpio » extrait en snippet partagé.**
  Créé `docs/_snippets/smartpi-gpio-prerequisites.md` (titre `## ` + corps canonique repris de
  `SmartPi_LED_Control.md`, espaces trailing nettoyés, alt de l'image rendu fidèle au contenu
  réel de la capture — menu « Enable/Disable Interfaces » de `activate_interfaces.sh`, vérifié
  visuellement — le même PNG terminal était recopié avec 8 alts différents et faux par page).
  `mkdocs.yml` : `pymdownx.snippets` configuré avec `base_path: [docs]`, et `exclude_docs:
  _snippets/**` (mkdocs 1.6.1) pour que le snippet ne soit ni buildé en page orpheline ni
  signalé hors-nav. Les 11 pages capteurs référencent désormais
  `--8<-- "_snippets/smartpi-gpio-prerequisites.md"`. Cas particuliers traités honnêtement :
  `SmartPi_HC-SR04_Ultrasonic.md` avait un 2ᵉ titre `### Prerequisites: Configuration of
  smartpi-gpio` dont le corps était des étapes Python (nano/copier le script), pas le bloc
  d'installation — titre renommé `### Preparing the Python script` ; `SmartPi_Sound_Detection_
  Control.md` et `SmartPi_IR_Optocoupler_Control.md` avaient chacune une section `## Using
  Python` ne contenant QUE une redite du bloc (doublon intra-page) — section redondante
  supprimée ; pour IR_Optocoupler (dont la seule occurrence était ce doublon `###`), l'include
  a été inséré au niveau page avant `## Detecting Speed via CLI`, comme dans les autres pages.
  Aucun fait inventé : contenu du bloc strictement repris de l'existant.
  VARIED: les 11 pages Sensors&Modules + mkdocs.yml + nouveau docs/_snippets/ / HELD FIXED:
  toute autre page du wiki, img/, venv mkdocs, contenu du bloc (verbatim hors trailing spaces).
  WHAT THIS DOES NOT SAY: rendu visuel navigateur final (gate humain en fin de parcours) ;
  correction des chemins relatifs `../../../img` restants sur d'autres images de ces pages
  (hors lot — 2 warnings préexistants subsistent sur les schémas de câblage).
  **PROOF** :
  ```
  $ grep -rn "Configuration of smartpi-gpio" docs/
  docs//_snippets/smartpi-gpio-prerequisites.md:1:## Prerequisites: Configuration of smartpi-gpio
  $ grep -rn -- "--8<--" docs/ | wc -l
        11
  $ OUT=$(mktemp -d) && ~/.cache/yumi-wiki-mkdocs-venv/bin/mkdocs build -d "$OUT" >/dev/null 2>&1 \
    && grep -c "Prerequisites: Configuration of smartpi-gpio" "$OUT/SmartPI/Sensors&Modules/SmartPi_LED_Control/index.html"
  3
  $ grep -c "SmartPi_Button_Control_3.png" "$OUT/SmartPI/Sensors&Modules/SmartPi_LED_Control/index.html"
  1
  $ ls "$OUT" | grep -ci snippet; echo "rc=$?"
  rc=1
  $ ./verify.sh > /tmp/verify.log 2>&1; echo "verify rc=$?"; grep -c "^WARNING" /tmp/verify-mkdocs.log; tail -2 /tmp/verify.log
  verify rc=0
  5
  INFO    -  Documentation built in 1.57 seconds
  OK: mkdocs build réussi
  ```
  ATTRIBUTION : grep (BSD) macOS ; mkdocs 1.6.1 + pymdown-extensions 10.21.3
  (venv `~/.cache/yumi-wiki-mkdocs-venv`, Python 3.14) ; base 3f8afa7 (head du verdict PASS
  couvrant le lot 19) ; macOS 15.2 arm64 ; user nicolasmichaut ; 2026-08-05T09:31Z.
  (critère numérique : exactement 1 occurrence du texte du prérequis dans docs/ — le snippet —
  11 lignes d'inclusion ; HTML buildé contient bien le titre et l'image expansés ; WARNING
  mkdocs = 5 contre 7 au lot 19, baisse expliquée : 2 warnings de chemins relatifs supprimés
  avec le doublon d'image dans Photoresistor/Sound_Detection, AUCUN nouveau warning, aucun sur
  `_snippets`.)
  Prochain pas : Lot 21 (Yumi_L_Safety.md : retirer `<style>`/`<script>`, `!!! danger`,
  traduction résidus FR, rapatriement images i.ibb.co).

- **2026-08-05 · Lot 21 — `Yumi_L_Safety.md` remis au gabarit, images rapatriées.**
  Page réécrite (172 → 33 lignes) : le bloc `<style>` (108 lignes de CSS produit/lightbox) et le
  `<script>` de zoom maison supprimés — mkdocs-material fournit déjà le zoom via glightbox… sauf
  que le front-matter de la page le désactive (`glightbox: false`) ; choix assumé de le LAISSER
  désactivé car le contenu restant (3 vignettes d'accessoires vers wanhao-europe.com) n'a pas
  vocation à être zoomé, et la règle « zéro `<style>` inline » prime. Le paragraphe sécurité est
  passé en `!!! danger "Laser safety is not optional"` (titre honnête, pas inventé : il reformule
  le corps). Résidus français traduits : commentaires `<!-- Produit N - Lunettes -->` partis avec
  le HTML, alt « Lunettes de protection laser » et « Enclosure - Extracteur d'air » remplacés par
  des alts anglais descriptifs du contenu réel (vérifié sur les images téléchargées : plateau
  nid d'abeille, caisson avec extracteur, lunettes de protection). Les 3 images `i.ibb.co`
  (hôte externe non pérenne) rapatriées sous `img/Yumi_L_Series/Tuto/` (nouveau dossier) —
  téléchargement vérifié : JPEG 1000×1000 valides (`file`). Liens boutique wanhao-europe.com
  conservés tels quels (liens externes légitimes, pas des dépendances de rendu). Largeurs bornées
  à 300 px via `attr_list` (`{ width="300" }`), extension déjà active dans mkdocs.yml — les
  vignettes 1000 px sinon pleine page. Aucune grille CSS recréée : aucun usage `grid cards`
  dans le repo, Markdown simple suffit (règle KISS).
  VARIED: docs/Yumi_L_Series/Tuto/Yumi_L_Safety.md, img/Yumi_L_Series/Tuto/ (3 nouveaux JPEG) /
  HELD FIXED: tout autre fichier du wiki, mkdocs.yml, css/extra.css, venv mkdocs.
  WHAT THIS DOES NOT SAY: rendu visuel navigateur final (gate humain en fin de parcours) ;
  disponibilité future des URLs wanhao-europe.com (non retestées au-delà de leur reprise verbatim).
  **PROOF** :
  ```
  $ grep -c "<style>\|i.ibb.co" docs/Yumi_L_Series/Tuto/Yumi_L_Safety.md
  0
  $ grep -c "<script>" docs/Yumi_L_Series/Tuto/Yumi_L_Safety.md
  0
  $ file img/Yumi_L_Series/Tuto/*.jpg
  YLA4-HONEYCOMB400-X400.jpg: JPEG image data, progressive, precision 8, 1000x1000
  YUMLENCLOBOX-11.jpg:        JPEG image data, progressive, precision 8, 1000x1000
  lunette.jpg:                JPEG image data, Exif standard, progressive, precision 8, 1000x1000
  $ grep -n "Extracteur\|Lunettes" docs/Yumi_L_Series/Tuto/Yumi_L_Safety.md; echo "rc=$?"
  rc=1
  $ ./verify.sh > /tmp/verify.log 2>&1; echo "verify rc=$?"; grep -c "^WARNING" /tmp/verify-mkdocs.log; tail -2 /tmp/verify.log
  verify rc=0
  5
  INFO    -  Documentation built in 1.68 seconds
  OK: mkdocs build réussi
  ```
  ATTRIBUTION : grep/file (BSD) macOS ; curl 8.x pour le rapatriement ; mkdocs 1.6.1 +
  pymdown-extensions 10.21.3 (venv `~/.cache/yumi-wiki-mkdocs-venv`, Python 3.14) ; base bb4136e
  (head du verdict PASS couvrant le lot 20) ; macOS 15.2 arm64 ; user nicolasmichaut ;
  2026-08-05T09:47Z.
  (critère numérique : 0 occurrence `<style>`/`i.ibb.co`/`<script>` ; WARNING mkdocs = 5, identique
  au lot 20 — les 3 lignes INFO « absolute link … left as is » ajoutées sur cette page sont le
  comportement attendu de la convention `/img/...` imposée par GOAL.md, pas des warnings.)
  Prochain pas : Lot 22 (même traitement sur Yumi_L_LaserGRBL.md — dont le `<a>` non fermé
  ~ligne 206 — et Yumi_L_Cork_Engraving.md).

- **2026-08-05 · Lot 22 — `Yumi_L_LaserGRBL.md` + `Yumi_L_Cork_Engraving.md` remises au gabarit, 20 images rapatriées.**
  LaserGRBL (289 → 49 lignes) : les deux blocs `<style>` (grille produit + layout lasergrbl-row),
  le `<div id="zoom-viewer">` inline et le `<script>` de zoom maison supprimés ; le `<a>` non fermé
  ex-ligne 206 (lien « Download and install LaserGRBL » jamais refermé, qui absorbait le `</div>`
  suivant) disparaît avec le HTML — remplacé par un lien Markdown propre. Contenu restructuré en
  liste numérotée de 8 étapes avec images légendées. Cork_Engraving (401 → 63 lignes) : mêmes
  `<style>`×2 (dont le comparateur avant/après `.image-compare-container`), `<script>`×2 (zoom +
  slider de comparaison animé), divs résiduelles d'artefacts ChatGPT (`z-0 flex min-h-[46px]`,
  `pointer-events-none h-px w-px`, attributs `data-start`/`data-end`, `</strong>` orphelin,
  `<h7>` invalide, `<p> </p>` vides) supprimés ; le comparateur avant/après JS est remplacé par
  les deux photos côte à côte (vierge / gravée) — zéro JS inline, règle absolue. Le « Tip:The
  origin point » passe en `!!! tip "Origin point"`. Front-matter `glightbox: false` RETIRÉ sur
  les deux pages (différence assumée avec le lot 21) : ces pages sont des tutos pas-à-pas dont
  les captures gagnent à être zoomées, et glightbox (plugin global, mkdocs.yml:52) remplace
  exactement le zoom maison supprimé ; glightbox ignore les images déjà dans un lien, donc la
  bannière boutique reste un lien wanhao-europe.com. 20 images `i.ibb.co` rapatriées sous
  `img/Yumi_L_Series/Tuto/` (9 lasergrbl-*.jpg + yumi-l-a4-banner.jpg + 10 cork-*.jpg), toutes
  vérifiées visuellement une par une AVANT d'écrire les alts : chaque alt décrit le contenu
  réel (captures LaserGRBL v7.14.1 en français avec l'élément mis en évidence, tête laser
  YUMi 2.5W sur plateau nid d'abeille, sous-verre liège vierge vs gravé Mario Kart) — les
  anciens alts « Honeycomb »/« liege »/« Lunettes de protection laser » copiés-collés sans
  rapport sont remplacés. Largeurs bornées 300–360 px via `attr_list`. Lien boutique
  wanhao-europe.com conservé verbatim (externe légitime).
  VARIED: docs/Yumi_L_Series/Tuto/Yumi_L_LaserGRBL.md,
  docs/Yumi_L_Series/Tuto/Yumi_L_Cork_Engraving.md, img/Yumi_L_Series/Tuto/ (20 nouveaux JPEG) /
  HELD FIXED: tout autre fichier du wiki, mkdocs.yml, css/extra.css, venv mkdocs.
  WHAT THIS DOES NOT SAY: rendu visuel navigateur final (gate humain en fin de parcours) ;
  activation réelle du zoom glightbox sur ces pages (vérifiée au build, pas au navigateur) ;
  disponibilité future des URLs lasergrbl.com et wanhao-europe.com.
  **PROOF** :
  ```
  $ grep -c "<style>\|i.ibb.co" docs/Yumi_L_Series/Tuto/Yumi_L_LaserGRBL.md docs/Yumi_L_Series/Tuto/Yumi_L_Cork_Engraving.md
  docs/Yumi_L_Series/Tuto/Yumi_L_LaserGRBL.md:0
  docs/Yumi_L_Series/Tuto/Yumi_L_Cork_Engraving.md:0
  $ grep -c "<script>\|<a href\|</a>\|glightbox" docs/Yumi_L_Series/Tuto/Yumi_L_LaserGRBL.md docs/Yumi_L_Series/Tuto/Yumi_L_Cork_Engraving.md
  docs/Yumi_L_Series/Tuto/Yumi_L_LaserGRBL.md:0
  docs/Yumi_L_Series/Tuto/Yumi_L_Cork_Engraving.md:0
  $ file img/Yumi_L_Series/Tuto/lasergrbl-software.jpg img/Yumi_L_Series/Tuto/cork-coaster-engraved.jpg img/Yumi_L_Series/Tuto/yumi-l-a4-banner.jpg
  lasergrbl-software.jpg:     JPEG image data, Exif standard, progressive, precision 8, 829x488
  cork-coaster-engraved.jpg:  JPEG image data, Exif standard, progressive, precision 8, 1000x1000
  yumi-l-a4-banner.jpg:       JPEG image data, Exif standard, progressive, precision 8, 1920x886
  $ ./verify.sh 2>&1 | tail -2; grep -c 'WARNING' /tmp/verify-mkdocs.log
  INFO    -  Documentation built in 1.59 seconds
  OK: mkdocs build réussi
  5
  ```
  ATTRIBUTION : grep/file (BSD) macOS ; curl 8.x pour le rapatriement ; mkdocs 1.6.1 +
  pymdown-extensions 10.21.3 (venv `~/.cache/yumi-wiki-mkdocs-venv`, Python 3.14) ; base 47de297
  (head du verdict PASS couvrant le lot 21) ; macOS 15.2 arm64 ; user nicolasmichaut ;
  2026-08-05T10:05Z.
  (critère numérique : 0 occurrence `<style>`/`i.ibb.co`/`<script>`/`<a>` brut sur les deux
  fichiers ; WARNING mkdocs = 5, identique aux lots 20-21 — les lignes INFO « absolute link …
  left as is » sont le comportement attendu de la convention `/img/...` imposée par GOAL.md.)
  Prochain pas : Lot 23 (YUMI_C_SERIES.md : gabarit B, alts « yumiC » ×20, CTA Kickstarter à
  vérifier).

- **2026-08-05 · REPAIR — HEAD détaché rattacher à `wiki-audit-fixes`.**
  Constat en commitant le lot 22 : `HEAD detached from bb4136e`. Le reflog montre deux
  `checkout` à 17:38 (wiki-audit-fixes → 3f8afa7 → bb4136e, probablement la revue contrôlée)
  qui ont laissé HEAD détaché ; les commits 47de297 (lot 21) et 3a9b3e5 (lot 22) n'étaient
  rattachés à AUCUNE branche (la branche restait sur bb4136e). Réparation : `git checkout
  wiki-audit-fixes` + `git merge --ff-only 3a9b3e5` → fast-forward bb4136e..3a9b3e5, aucune
  réécriture, arbre identique (le build vert du lot 22 couvre exactement cet arbre). Aucun
  push, aucun merge de main. PROOF :
  ```
  $ git checkout wiki-audit-fixes && git merge --ff-only 3a9b3e5
  Switched to branch 'wiki-audit-fixes'
  Updating bb4136e..3a9b3e5
  Fast-forward
  $ git log --oneline -3
  3a9b3e5 fix: clean Yumi L LaserGRBL and cork engraving pages, localize tutorial images
  47de297 fix: clean Yumi L safety page, localize accessory images
  bb4136e fix: extract duplicated smartpi-gpio prerequisites block into shared snippet
  ```
  Vigilance aux prochaines itérations : vérifier `git status` (branche) AVANT de committer.

- **2026-08-05 · Advisory verdict PASS (head f726f84) — hygiène d'arbre (commit 2f63f4a).**
  Le verdict PASS du lot 22 signalait en advisory des changements non commités sur `loop.sh` et
  un `audit-wiki-2026-03-06.html` non suivi. Nettoyé AVANT le lot 23 : `loop.sh` commité en
  `chore:` (câblage du helper `lock-alive.sh` pour la vitalité du verrou + `verdict_real_pass`
  — un PASS n'ouvre le gate/.done que s'il est réel et ancré sur le HEAD courant ; syntaxe
  validée par `bash -n loop.sh`), et `audit-wiki-*.html` ajouté à `.gitignore` (artefact de
  travail local, non publié). Arbre propre, `git status` vide après commit.
  PROOF :
  ```
  $ bash -n loop.sh && echo SYNTAX-OK
  SYNTAX-OK
  $ git commit -m "chore: lock-alive helper wiring, verdict PASS ancre sur HEAD, ignore audit HTML"
  [wiki-audit-fixes 2f63f4a] chore: lock-alive helper wiring, verdict PASS ancre sur HEAD, ignore audit HTML
   2 files changed, 64 insertions(+), 22 deletions(-)
  $ git status --short
  (vide)
  ```

- **2026-08-05 · Lot 23 — `YUMI_C_SERIES.md` remise au gabarit B, alts réels ×19, CTA Kickstarter retiré.**
  Embed YouTube brut (`<div>` responsive + `<iframe youtube.com/embed>`) remplacé par un lien
  Markdown simple vers la vidéo (`youtube.com/watch?v=UCdwHCwixVY`, `target=_blank`) — zéro
  iframe/script tiers, règle GOAL.md « zéro dépendance externe non hébergée ». Les 19 blocs
  `<p align="center"><img alt="yumiC">` convertis en images Markdown `/img/...` absolues avec
  alts descriptifs réels : les 20 images ont été converties en JPEG (/tmp, sips) puis VUES une
  par une avant d'écrire chaque alt (lineup C235/C335/C435, tables de specs, têtes Chroma X12 /
  Direct Drive, modules YMS Lite/Pro, Hyper Drive 3P2L, accès Mainsail/YUMI LAB, équipe, usine,
  bénéfices environnementaux). CTA Kickstarter : URL vérifiée AVANT de trancher — la campagne
  est TERMINÉE (période de collecte 10 juil. → 8 sept. 2025, page marquée « 已結束 »/terminée,
  HK$ 4 277 449 / 810 contributeurs) ; les deux bannières « ORDER NOW » cliquables
  (YumiCSeries020.avif, haut et bas de page) sont RETIRÉES, sans URL de remplacement inventée.
  L'image 005 (pledge tiers / prix de lancement) est conservée comme contenu informatif avec un
  alt neutre « Launch configurations and pricing » — le lot ne demande pas sa suppression.
  Prose conservée verbatim (y compris les artefacts préexistants hors scope : « Three Build
  Sizes » en tête de §2, tirets « → », numérotation §3 vide).
  VARIED: docs/Yumi_C_Series/YUMI_C_SERIES.md (205 → 173 lignes) /
  HELD FIXED: tout autre fichier du wiki, mkdocs.yml, css/extra.css, img/ (aucun ajout), venv mkdocs.
  WHAT THIS DOES NOT SAY: rendu visuel navigateur final (gate humain en fin de parcours) ;
  disponibilité future de la vidéo YouTube liée ; pertinence éditoriale des prix de lancement
  affichés dans l'image 005 (contenu image, hors scope du lot).
  **PROOF** :
  ```
  $ grep -c 'p align="center"' docs/Yumi_C_Series/YUMI_C_SERIES.md; grep -c 'yumiC"' docs/Yumi_C_Series/YUMI_C_SERIES.md; grep -ci 'kickstarter\|iframe\|youtube.com/embed' docs/Yumi_C_Series/YUMI_C_SERIES.md; grep -c '<img' docs/Yumi_C_Series/YUMI_C_SERIES.md
  0
  0
  0
  0
  $ ./verify.sh 2>&1 | tail -2; grep -c 'WARNING' /tmp/verify-mkdocs.log
  INFO    -  Documentation built in 1.61 seconds
  OK: mkdocs build réussi
  5
  $ OUT=$(mktemp -d) && ~/.cache/yumi-wiki-mkdocs-venv/bin/mkdocs build -d "$OUT" && P="$OUT/Yumi_C_Series/YUMI_C_SERIES/index.html" && grep -c 'p align' "$P"; grep -c '<img' "$P"; grep -c iframe "$P"; grep -ci kickstarter "$P"; grep -o 'youtube[^"]*' "$P"
  0
  21
  0
  0
  youtube.com/watch?v=UCdwHCwixVY
  ```
  (gate sur build frais : 0 `p align`, 21 `<img>` = 19 images de contenu aux alts descriptifs
  + 2 logos du thème, 0 iframe, 0 kickstarter, lien YouTube watch présent ; WARNING mkdocs = 5,
  inchangé depuis les lots 20-22 ; les INFO « absolute link … left as is » sur les 19 images sont
  le comportement attendu de la convention `/img/...` — NOTE : `site/` à la racine est un build
  PÉRIMÉ, verify.sh builde dans un mktemp, ne pas gater sur `site/`.)
  ATTRIBUTION : grep (BSD) macOS ; sips pour la conversion avif→jpeg temporaire ; mkdocs 1.6.1
  + pymdown-extensions 10.21.3 (venv `~/.cache/yumi-wiki-mkdocs-venv`, Python 3.14) ; base
  2f63f4a (chore hygiène, lui-même sur f726f84 = head du verdict PASS lot 22) ; macOS 15.2
  arm64 ; user nicolasmichaut ; 2026-08-05T10:20Z.
  Prochain pas : Lot 24 (3d_pen/index.md : unification des chemins d'image vers /img absolu,
  « Attention: » gras → `!!! warning`).

- **2026-08-05 · Lot 24 — 3d_pen/index.md : chemins d'image unifiés vers /img absolu,
  warning admonition.** Les trois conventions (`../img`, `/img`, `../../img`) coexistaient ;
  les deux `<img>` HTML (lignes 3 et 46) sont convertis en Markdown `![alt](/img/...)` avec
  `{ width="..." }` (attr_list activé dans mkdocs.yml), alts descriptifs réels réécrits après
  lecture des deux images (photo produit 3 couleurs + filaments ; stylo bleu avec exemple de
  pot de fleurs dessiné) au lieu du générique « YUMI - 3D PEN » copié. L'image ligne 42 était
  déjà en `/img/...` Markdown (inchangée). Le paragraphe « **Attention:** » devient
  `!!! warning "Hot nozzle"` (texte conservé verbatim, indentation 4 espaces).
  VARIED: docs/3d_pen/index.md (3 éditions ciblées) /
  HELD FIXED: tout autre fichier, img/3d_pen/ (les 4 images existaient déjà), mkdocs.yml.
  WHAT THIS DOES NOT SAY: rendu visuel navigateur (gate humain final) ; pertinence
  éditoriale de la page (hors scope — correctif ciblé demandé par le lot uniquement).
  **PROOF** :
  ```
  $ grep -c "\.\./.*img/" docs/3d_pen/index.md; grep -c "<img\|Attention:" docs/3d_pen/index.md; grep -n "img/" docs/3d_pen/index.md
  0
  0
  3:![YUMI 3D Pen in pink, blue and white with colored filament strands](/img/3d_pen/YUMI-3D-PEN-1.webp){ width="400" }
  42:![YUMI 3D PEN - Pack](/img/3d_pen/YUMI-3D-PEN-3.png)
  46:![Blue YUMI 3D Pen with filament coil and a drawn flower pot example](/img/3d_pen/YUMI-3D-PEN-4.webp){ width="300" }
  $ ./verify.sh 2>&1 | tail -2; grep -c 'WARNING' /tmp/verify-mkdocs.log
  INFO    -  Documentation built in 1.51 seconds
  OK: mkdocs build réussi
  5
  ```
  (WARNING mkdocs = 5, inchangé depuis le lot 23 — tous préexistants sur d'autres pages ;
  les 3 INFO « absolute link … left as is » sur 3d_pen/index.md sont le comportement attendu
  de la convention `/img/...` comme au lot 23.)
  ATTRIBUTION : grep (BSD) macOS ; mkdocs 1.6.1 + pymdown-extensions 10.21.3 (venv
  `~/.cache/yumi-wiki-mkdocs-venv`, Python 3.14) ; base dbbd36 (= head du verdict PASS
  lot 23) ; macOS 15.2 arm64 ; user nicolasmichaut ; 2026-08-05T10:35Z.
  Prochain pas : Lot 25 (SmartPI_OpenMediaVault.md : renumérotation des sections, 13 alts
  « SSH » → descriptifs).

- **2026-08-05 · Lot 25 — SmartPI_OpenMediaVault.md : sections renumérotées 1-5 contigus,
  13 alts « SSH » → descriptifs.** Les lignes `## 4.` … `## 11.` n'étaient PAS des titres :
  c'étaient les commentaires du fichier `openmediavault.list` copiés-collés avec une
  numérotation parasite à l'intérieur du bloc code heredoc. Restaurés au format officiel du
  fichier OMV (`#` pour les lignes deb commentées, `##` pour les deux vraies lignes de
  commentaire, numéros parasites supprimés — contenu vérifiable contre la doc officielle
  openmediavault, aucune ligne `deb` active modifiée). Les vrais titres `## 12. connection
  to web interface` → `## 4. Connection to the web interface` et `## 13. Add Disk` →
  `## 5. Add a disk`. Les 13 alts « SSH » copiés-collés sont remplacés par des alts
  descriptifs réels après lecture de chaque capture (ReadMediaFile sur OMV001→OMV013 :
  session MobaXterm, page de login OMV, bandeau « Pending configuration changes », pages
  File Systems / Shared Folders / SMB-CIFS / permissions…).
  VARIED: docs/SmartPI/SmartPI_OpenMediaVault.md (6 éditions ciblées) /
  HELD FIXED: tout autre fichier, img/SmartPi/OMV/ (les 14 images existaient déjà,
  aucune ajoutée/supprimée), mkdocs.yml.
  WHAT THIS DOES NOT SAY: rendu visuel navigateur (gate humain final) ; exactitude de la
  procédure OMV elle-même (hors scope — le lot ne demandait que renumérotation + alts ;
  les mentions mobaxterm/putty ligne 17 sont préexistantes et hors lot).
  **PROOF** :
  ```
  $ grep -nE '^## [0-9]+\.' docs/SmartPI/SmartPI_OpenMediaVault.md; grep -c 'alt="SSH"\|\[SSH\]' docs/SmartPI/SmartPI_OpenMediaVault.md
  9:## 1. Prerequisites
  21:## 2. Update the smartpi
  27:## 3. Install
  68:## 4. Connection to the web interface
  82:## 5. Add a disk
  0
  $ ./verify.sh 2>&1 | tail -2; grep -c 'WARNING' /tmp/verify-mkdocs.log
  INFO    -  Documentation built in 1.57 seconds
  OK: mkdocs build réussi
  5
  ```
  (grep `^## [0-9]` hors titres = 0 : plus aucune ligne numérotée parasite dans le heredoc ;
  WARNING mkdocs = 5, inchangé — tous préexistants sur d'autres pages ; les 14 INFO
  « absolute link … left as is » sur cette page sont le comportement attendu de la
  convention `/img/...`, identiques avant/après — seuls les alts ont changé.)
  ATTRIBUTION : grep (BSD) macOS ; mkdocs 1.6.1 + pymdown-extensions 10.21.3 (venv
  `~/.cache/yumi-wiki-mkdocs-venv`, Python 3.14) ; base c907241 (= head du verdict PASS
  lot 24) ; macOS 15.2 arm64 ; user nicolasmichaut ; 2026-08-05T10:45Z.
  Prochain pas : Lot 26 (SmartPi_Retro_Gaming.md : 3 liens cassés, placeholder
  « Available soon », « Emulastation » → « EmulationStation » ×7).

- **2026-08-05 · Lot 26 — SmartPi_Retro_Gaming.md corrigé.** Les 3 liens gofile avaient
  leur token hors des parenthèses du lien Markdown (`…/67vGQ/` + `JYxrUDZA1` en texte
  parasite) : tokens fusionnés dans l'URL (`https://gofile.me/67vGQ/JYxrUDZA1`,
  `…/VREUvyEth`, `…/0bSQSSoCT`) — chaque URL vérifiée HTTP 200 par curl. Placeholder
  « Image for OS any SD card: Available soon » retiré : la v0.4 (2024-07-16, même page)
  « auto resize image for all TF cards minimum 16GB » livre cette fonctionnalité.
  H1 corrigé (« include optimised » → « includes optimized », grammaire + orthographe US
  cohérente avec le corps de page). « Emulastation » → « EmulationStation » (le ×7 de
  l'audit n'existe pas dans le fichier : 2 occurrences réelles, texte ligne 55 + nom de
  fichier image) ; image renommée `bootemulastation.png` → `bootemulationstation.png`
  (git mv), alt de cette image rendu descriptif au passage (la ligne était éditée de
  toute façon). Hors-lot laissé tel quel : lien absolu wiki.yumi-lab.com ligne 30
  (périmètre Lot 29, fichier non listé), alts « emula » des autres images.
  PROOF :
  ```
  $ for t in JYxrUDZA1 VREUvyEth 0bSQSSoCT; do curl -sI -o /dev/null -w '%{http_code}\n' -L --max-time 15 "https://gofile.me/67vGQ/$t"; done
  200
  200
  200
  $ grep -c "Emulastation" docs/SmartPI/SmartPi_Retro_Gaming.md; grep -c "Available soon" docs/SmartPI/SmartPi_Retro_Gaming.md
  0
  0
  $ grep -rn "bootemulastation" docs/ img/ ; echo rc=$?
  rc=1
  $ ./verify.sh 2>&1 | tail -2; grep -c 'WARNING' /tmp/verify-mkdocs.log
  INFO    -  Documentation built in 1.34 seconds
  OK: mkdocs build réussi
  5
  ```
  (WARNING mkdocs = 5, inchangé — tous préexistants sur d'autres pages ; l'INFO
  « absolute link … left as is » sur `bootemulationstation.png` confirme que l'image
  renommée est bien résolue par le build.)
  VARIED : contenu de SmartPi_Retro_Gaming.md + nom de bootemulationstation.png.
  HELD FIXED : venv mkdocs, mkdocs.yml, branche wiki-audit-fixes, base e47cc0e.
  WHAT THIS DOES NOT SAY : ne prouve pas que les images gofile téléchargées sont
  intègres (seulement que les pages de partage répondent 200) ; ne couvre pas le lien
  Dropbox v0.4 (hors périmètre des 3 liens cassés).
  ATTRIBUTION : curl macOS ; grep (BSD) macOS ; mkdocs 1.6.1 + pymdown-extensions
  10.21.3 (venv `~/.cache/yumi-wiki-mkdocs-venv`, Python 3.14) ; base e47cc0e (= head
  du verdict PASS lot 25) ; macOS 15.2 arm64 ; user nicolasmichaut ; 2026-08-05T10:55Z.
  Prochain pas : Lot 27 (SmartPi_Plex_Server.md : version .deb Plex épinglée 1.40.1,
  artefacts de notes de bas de page).

- **2026-08-05 · Lot 27 — SmartPi_Plex_Server.md corrigé.** La section « 3. Install »
  épinglait en dur `plexmediaserver_1.40.1.8227-c0dd5a73e_armhf.deb` (wget + dpkg) :
  remplacée par un renvoi vers la page de téléchargement officielle Plex
  (https://www.plex.tv/media-server-downloads/#plex-media-server, Linux → ARMv7) +
  commande d'installation générique `sudo dpkg -i plexmediaserver_<version>_armhf.deb`.
  Artefacts de notes de bas de page nettoyés : « Internet connection2 » → « connection »,
  « providers3 » → « providers », « promotions4 » → « promotions » (3 occurrences réelles
  dans le fichier). Hors-lot laissé tel quel : lien absolu wiki.yumi-lab.com ligne 17
  (périmètre Lot 29, fichier non listé), typo « recommanded », titre « 4. connection ».
  PROOF :
  ```
  $ grep -c "1\.40\.1" docs/SmartPI/SmartPi_Plex_Server.md; echo "rc=$?"
  0
  rc=1
  $ grep -nE "connection[0-9]|providers[0-9]|promotions[0-9]" docs/SmartPI/SmartPi_Plex_Server.md; echo "rc2=$?"
  rc2=1
  $ ./verify.sh 2>&1 | tail -2; grep -c 'WARNING' /tmp/verify-mkdocs.log
  INFO    -  Documentation built in 1.47 seconds
  OK: mkdocs build réussi
  5
  ```
  (grep rc=1 = aucune occurrence, critère du lot atteint ; WARNING mkdocs = 5, inchangé,
  tous préexistants sur d'autres pages.)
  VARIED : contenu de SmartPi_Plex_Server.md uniquement.
  HELD FIXED : venv mkdocs, mkdocs.yml, branche wiki-audit-fixes, base 3bd547c.
  WHAT THIS DOES NOT SAY : ne prouve pas que la page de téléchargement Plex propose
  actuellement un build ARMv7 (lien externe, contenu tiers hors de contrôle) ; ne couvre
  pas la validité des prix Plex Pass cités plus haut dans la page (hors périmètre du lot).
  ATTRIBUTION : grep (BSD) macOS ; mkdocs 1.6.1 + pymdown-extensions 10.21.3 (venv
  `~/.cache/yumi-wiki-mkdocs-venv`, Python 3.14) ; base 3bd547c (= head du verdict PASS
  lot 26) ; macOS 15.2 arm64 ; user nicolasmichaut ; 2026-08-05T11:05Z.
  Prochain pas : Lot 28 (SmartPi_Klipper.md : structurer avec de vrais titres ## N.,
  dédupliquer avec SmartPi_Linux_flash_sd.md).

- **2026-08-05 · Lot 28 — SmartPi_Klipper.md restructuré + dédupliqué.** Page passée de
  28 lignes sans titres à 3 sections numérotées (`## 1. Download YumiOS`,
  `## 2. Flash the image to your micro SD card`, `## 3. First boot`). Le pas-à-pas
  Balena Etcher (3 captures `Balena001/002/003.png` + 4 paragraphes) dupliquait le
  guide de flash : remplacé par un renvoi relatif vers
  [flash guide](SmartPi_Linux_flash_sd.md) (même convention de lien relatif que
  `SmartPi_Linux.md` dans ce guide). Le rappel « save your printer.cfg » devient une
  admonition `!!! warning` (style du gabarit GOAL.md). Alt du logo rendu descriptif
  (« YumiOS logo »). Les fichiers `img/SmartPi/klipper/Balena00*.png` deviennent
  orphelins : laissés sur disque (leur suppression n'est pas demandée par le lot).
  PROOF :
  ```
  $ grep -c '^## ' docs/SmartPI/SmartPi_Klipper.md
  3
  $ grep -n 'Balena00' docs/SmartPI/SmartPi_Klipper.md; echo "rc=$?"
  rc=1
  $ grep -i 'SmartPi_Klipper' /tmp/verify-mkdocs.log
  INFO    -  Doc file 'SmartPI/SmartPi_Klipper.md' contains an absolute link '/img/SmartPi/klipper/YumiOSLogo.jpeg', it was left as is.
  $ ./verify.sh 2>&1 | tail -2; grep -c 'WARNING' /tmp/verify-mkdocs.log
  INFO    -  Documentation built in 1.59 seconds
  OK: mkdocs build réussi
  5
  ```
  (3 titres `## ` ≥ 2 requis ; aucune WARNING sur SmartPi_Klipper.md — le lien relatif
  vers SmartPi_Linux_flash_sd.md est résolu par le build, sinon mkdocs l'aurait signalé ;
  WARNING total = 5, inchangé, tous préexistants.)
  VARIED : contenu de SmartPi_Klipper.md uniquement.
  HELD FIXED : venv mkdocs, mkdocs.yml, SmartPi_Linux_flash_sd.md, base 98a3334.
  WHAT THIS DOES NOT SAY : ne prouve pas le rendu visuel de l'admonition dans le
  navigateur (périmètre du gate visuel final) ; ne couvre pas la fraîcheur des releases
  YumiOS sur GitHub (contenu tiers).
  ATTRIBUTION : grep (BSD) macOS ; mkdocs 1.6.1 + pymdown-extensions 10.21.3 (venv
  `~/.cache/yumi-wiki-mkdocs-venv`, Python 3.14) ; base 98a3334 ; macOS 15.2 arm64 ;
  user nicolasmichaut ; 2026-08-05T11:10Z.
  Prochain pas : Lot 29 (liens absolus wiki.yumi-lab.com → relatifs dans
  SmartPi_One_Startup.md, SmartPad_change_password.md, D12-230_EVO_MEGA-KIT.md).

- **2026-08-05 · Lot 29 — liens internes absolus convertis en relatifs (3 fichiers).**
  24 liens `https://wiki.yumi-lab.com/...` convertis : 17 dans
  `SmartPI/SmartPi_One_Startup.md` (12 même dossier → `X.md`, 5 inter-dossiers →
  `../Yumi_Components/…`, `../Yumi_stl/…`), 3 dans `KlipperSmartPad/SmartPad_change_password.md`
  (→ `SmartPad_connect_ssh.md`), 4 dans `PRINTERS/D12-230_EVO_MEGA-KIT.md`
  (→ `../KlipperSmartPad/Calibration/….md`). Les 22 cibles distinctes ont été vérifiées
  présentes sur disque AVANT conversion (test `-f` sur chaque chemin). Le suffixe
  `{ target=_blank }` a été retiré des liens devenus internes (il ne concerne que les
  liens externes : wanhao-europe.com, cults3d.com — conservés tels quels). Transformation
  mécanique par sed BSD (3 expressions par fichier), diff relu intégralement : 24
  lignes modifiées, rien d'autre.
  PROOF :
  ```
  $ grep -c "https://wiki.yumi-lab.com" docs/SmartPI/SmartPi_One_Startup.md docs/KlipperSmartPad/SmartPad_change_password.md docs/PRINTERS/D12-230_EVO_MEGA-KIT.md
  docs/SmartPI/SmartPi_One_Startup.md:0
  docs/KlipperSmartPad/SmartPad_change_password.md:0
  docs/PRINTERS/D12-230_EVO_MEGA-KIT.md:0
  $ ./verify.sh 2>&1 | tail -2; grep -c 'WARNING' /tmp/verify-mkdocs.log
  INFO    -  Documentation built in 1.54 seconds
  OK: mkdocs build réussi
  5
  $ grep -iE 'One_Startup|change_password|D12-230_EVO' /tmp/verify-mkdocs.log | grep -i 'WARNING'; echo rc=$?
  rc=1
  ```
  (critère du lot = 0 partout, atteint ; aucune WARNING mkdocs sur les 3 fichiers —
  les 22 liens relatifs sont donc résolus par le build ; WARNING total = 5, inchangé.)
  VARIED : URLs des liens internes dans les 3 fichiers listés.
  HELD FIXED : venv mkdocs, mkdocs.yml, tous les autres fichiers docs/, base 0961c3c.
  WHAT THIS DOES NOT SAY : ne couvre PAS les liens absolus wiki.yumi-lab.com dans
  d'autres fichiers (ex. SmartPi_Retro_Gaming.md ligne 30, SmartPi_Plex_Server.md
  ligne 17 — explicitement hors périmètre du lot, qui ne liste que ces 3 fichiers) ;
  ne prouve pas le rendu visuel des liens dans le navigateur (gate final).
  ATTRIBUTION : sed/grep (BSD) macOS ; mkdocs 1.6.1 + pymdown-extensions 10.21.3 (venv
  `~/.cache/yumi-wiki-mkdocs-venv`, Python 3.14) ; base 0961c3c ; macOS 15.2 arm64 ;
  user nicolasmichaut ; 2026-08-05T11:15Z.
  Prochain pas : Lot 30 (mkdocs.yml : retirer le `**gras**` Markdown brut des 2 labels
  de nav, §7.14.2 et §9.1).

- **2026-08-05 · Lot 30 — mkdocs.yml : Markdown brut retiré des 2 labels de nav.**
  Astérisques `**…**` supprimés des labels « 7.14.2 Klipper D12-230 Evo Mega-Kit
  Installation » (ligne 216) et « 8.1 YUMI STL - 3D Printable Accessories and Parts »
  (ligne 221, section YUMI STL — la §9.1 de l'audit est devenue 8.1 après les lots
  précédents). La 3ᵉ occurrence de `\*\*` (`_snippets/**` ligne 11, glob `exclude`)
  n'est PAS un label : laissée telle quelle, comme prévu par le critère « diminué de 2 ».
  PROOF :
  ```
  $ grep -c '\*\*' mkdocs.yml   # avant : 3
  1
  $ grep -n '\*\*' mkdocs.yml
  11:  _snippets/**
  $ ./verify.sh 2>&1 | tail -2; grep -c 'WARNING' /tmp/verify-mkdocs.log
  INFO    -  Documentation built in 1.53 seconds
  OK: mkdocs build réussi
  5
  ```
  (critère du lot : `grep -c '\*\*' mkdocs.yml` diminué de 2 — 3 → 1 ✓ ; WARNING = 5,
  inchangé, tous préexistants.)
  VARIED : 2 labels de nav dans mkdocs.yml.
  HELD FIXED : venv mkdocs, docs/, base 320319e.
  WHAT THIS DOES NOT SAY : ne prouve pas le rendu visuel des labels dans la nav (gate
  visuel final) ; ne couvre pas d'autres astérisques légitimes ailleurs (glob d'exclusion).
  ATTRIBUTION : grep (BSD) macOS ; mkdocs 1.6.1 + pymdown-extensions 10.21.3 (venv
  `~/.cache/yumi-wiki-mkdocs-venv`, Python 3.14) ; base 320319e ; macOS 15.2 arm64 ;
  user nicolasmichaut ; 2026-08-05T11:20Z.
  Prochain pas : tous les lots cochés → vérification DoD complète (verify.sh vert),
  puis `.gate-handoff` pour la relecture visuelle humaine des pages modifiées.

- **2026-08-05 · Gate final — `.gate-handoff` écrit, passage de main à l'humain.**
  Tous les lots cochés (30/30), dernier verdict PASS (fd28af0, blocking=[]). Le DoD exige
  la relecture visuelle humaine avant `.done` : `.gate-handoff` créé avec les 8 pages/arbres
  les plus modifiés (ConfigureTimeZone réécrit, Home_Assistant fusionné, YUMI_C_SERIES
  restructuré, tutos Yumi L dédoublonnés, arbre maintenance fusionné, guides PRINTERS
  dédupliqués, pages Sensors&Modules republiées) + checklist par page. PROOF :
  ```
  $ grep -c '^\- \[x\]' PROGRESS.md; grep -c '^\- \[ \]' PROGRESS.md
  30
  0
  $ ./verify.sh 2>&1 | tail -2
  INFO    -  Documentation built in 1.55 seconds
  OK: mkdocs build réussi
  $ grep -c 'WARNING' /tmp/verify-mkdocs.log
  5
  $ git diff --stat main...wiki-audit-fixes -- docs/ | tail -1
   50 files changed, 506 insertions(+), 2314 deletions(-)
  ```
  VARIED : création de `.gate-handoff` (gitignoré) + cette entrée de Journal.
  HELD FIXED : branche wiki-audit-fixes @ fd28af0, docs/ inchangé depuis le verdict PASS.
  WHAT THIS DOES NOT SAY : ne prouve pas le rendu visuel dans un navigateur — c'est
  précisément l'objet du handoff humain. `.done` NON créé : il attend la suppression de
  `.gate-handoff` par l'humain.
  ATTRIBUTION : mkdocs 1.6.1 (venv ~/.cache/yumi-wiki-mkdocs-venv, Python 3.14) ; grep BSD ;
  macOS 15.2 arm64 ; user nicolasmichaut ; 2026-08-05T11:25Z.
  Prochain pas : STOP — attente validation humaine (suppression de `.gate-handoff`), puis
  création de `.done` au tour suivant.

- **2026-08-05 · GATE PASS (human) + correctif advisory verdict f3c2f58.**
  `.gate-handoff` supprimé par l'humain → relecture visuelle validée (DoD gate final rempli).
  Advisory du verdict PASS f3c2f58 corrigé : la commande PROOF du diff omettait `-- docs/`,
  le chiffre cité (50 fichiers) ne se reproduisait pas tel quel — commande réparée, sortie
  identique. Aucun changement sous `docs/` : le build ne peut pas régresser, vérifié quand même.
  PROOF :
  ```
  $ ls .gate-handoff .done
  ls: .done: No such file or directory
  ls: .gate-handoff: No such file or directory
  $ ./verify.sh 2>&1 | tail -2
  INFO    -  Documentation built in 1.54 seconds
  OK: mkdocs build réussi
  $ git diff --stat main...wiki-audit-fixes -- docs/ | tail -1
   50 files changed, 506 insertions(+), 2314 deletions(-)
  ```
  VARIED : PROGRESS.md uniquement (commande PROOF corrigée + cette entrée).
  HELD FIXED : branche wiki-audit-fixes, docs/ inchangé depuis f3c2f58, mkdocs 1.6.1
  (venv ~/.cache/yumi-wiki-mkdocs-venv, Python 3.14) ; macOS 15.2 arm64 ; user
  nicolasmichaut ; 2026-08-05T12:22Z.
  WHAT THIS DOES NOT SAY : ne re-prouve pas le rendu visuel — il a été validé par l'humain
  (suppression du handoff), pas re-testé ici.
  Prochain pas : verdict PASS sur ce commit → création de `.done` au tour suivant.

- **2026-08-05 · `.done` créé — mission terminée (bloqueur verdict CHANGES_REQUESTED b5bcf8a).**
  Le verdict exigeait la création de `.done` : les 30 lots sont cochés (chacun avec PROOF),
  `.gate-handoff` a été supprimé par l'humain (gate visuel validé), `verify.sh` est vert.
  `.done` (fichier vide) créé → arrêt propre de la boucle et du watchdog.
  PROOF :
  ```
  $ grep -c '^\- \[x\]' PROGRESS.md && grep -c '^\- \[ \]' PROGRESS.md
  30
  0
  $ ls .gate-handoff
  ls: .gate-handoff: No such file or directory
  $ ./verify.sh 2>&1 | tail -2
  INFO    -  Documentation built in 1.47 seconds
  OK: mkdocs build réussi
  $ touch .done && ls -la .done
  -rw-r--r--@ 1 nicolasmichaut  staff  0 Aug  5 20:26 .done
  ```
  VARIED : `.done` créé + cette entrée Journal — rien d'autre.
  HELD FIXED : branche wiki-audit-fixes, docs/ inchangé depuis b5bcf8a, mkdocs 1.6.1
  (venv ~/.cache/yumi-wiki-mkdocs-venv, Python 3.14) ; macOS 15.2 arm64 ; user
  nicolasmichaut ; 2026-08-05T12:26Z.
  WHAT THIS DOES NOT SAY : `.done` stoppe le dispositif ; le merge vers `main` reste une
  décision humaine, hors de cette boucle.
  Prochain pas : aucun — la boucle s'arrête sur `.done`.
