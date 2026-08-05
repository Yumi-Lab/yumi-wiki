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

- [ ] **Lot 2** Corriger les fences `'''` → ```` ``` ```` dans `docs/PRINTERS/SIDEWINDER_X1.md`
  (ligne ~157-159) et `docs/PRINTERS/SIDEWINDER_X2.md` (ligne ~204-206). — test :
  `grep -c "'''" docs/PRINTERS/SIDEWINDER_X1.md docs/PRINTERS/SIDEWINDER_X2.md` = 0 partout ;
  `./verify.sh` vert.
- [ ] **Lot 3** Dans `docs/SmartPI/SmartPi_One_specifications.md` : corriger le titre collé
  `###SmartPione Cases` (espace manquant après `###`, il ne rend pas comme un titre), et
  remplacer le `<p align="center"><img width="1000">` par une image Markdown standard
  `![alt](/img/...)` qui respecte le plafond CSS existant. — test : `grep -n "^### "`
  retrouve bien le titre ; plus de `<img width="1000"` dans le fichier ; `./verify.sh` vert.
- [ ] **Lot 4** Listes qui fusionnent en paragraphe faute de tiret markdown, dans
  `docs/Yumi_C_Series/YUMI_C_SERIES.md` (~lignes 36-41) et
  `docs/KlipperSmartPad/SmartPad_specifications.md` — ajouter les `-` manquants. — test :
  relecture du rendu (`mkdocs build` + diff visuel du HTML généré si possible), sinon
  vérification que chaque item de liste commence bien par `- ` dans le source.
- [ ] **Lot 5** Corrections ponctuelles éparses : item de liste numéroté "32." aberrant dans
  `docs/KlipperSmartPad/Calibration/Adxl_calibration.md` ; `//img/` (double slash) dans
  `docs/PRINTERS/PRUSA_MK3.md:43` ; fence de code cassée autour de `passwd` dans
  `docs/SmartPI/SmartPi_Change_Password.md`. — test : les trois patterns fautifs ont disparu
  (grep ciblé sur chacun) ; `./verify.sh` vert.

## Priorité 3 — orphelins et doublons de fichiers

- [ ] **Lot 6** Supprimer `docs/KlipperSmartPad/Remote_multi_printers.md` (doublon identique
  à `docs/KlipperSmartPad/Tuto/Remote_multi_printers.md` — vérifie avec `diff` avant de
  supprimer). Dans la version conservée (`Tuto/`), corriger la commande invalide
  `nano cd ~/printer_data/config/KlipperScreen.conf` (scinder en `cd` puis `nano`, et vérifier
  le vrai nom de fichier de config KlipperScreen). Vérifie qu'aucune page ni `mkdocs.yml` ne
  référence encore le chemin supprimé. — test : `diff` confirmé vide avant suppression ;
  `grep -r "KlipperSmartPad/Remote_multi_printers.md" docs/ mkdocs.yml` ne retourne rien
  après ; `./verify.sh` vert.
- [ ] **Lot 7** Fusionner `docs/SmartPI/SmartPi_Home_Assistant.md` et
  `docs/SmartPI/SmartPi_Home_Assistant adnrobotics save.md` : compare les deux, le "save" est
  a priori plus à jour — garde le meilleur contenu combiné dans le fichier principal
  (nom sans espace, celui qui est dans `mkdocs.yml`), rapatrie les images hotlinkées en local
  sous `/img/SmartPI/...` si les sources sont accessibles (sinon laisse une note dans le
  Journal listant celles qui restent externes), puis supprime le fichier "save". — test :
  fichier "save" supprimé ; `grep -c "githubusercontent\|raw=true" docs/SmartPI/SmartPi_Home_Assistant.md`
  a diminué ou est à 0 ; `./verify.sh` vert.
- [ ] **Lot 8** Rattacher `docs/Yumi_L_Series/Yumi_L_Series_Troubleshooting.md` à la nav dans
  `mkdocs.yml` sous la section `3.2 DOCS` (contenu déjà fini, juste orphelin), en continuant
  la numérotation existante. — test : `grep "Yumi_L_Series_Troubleshooting" mkdocs.yml`
  retourne une ligne ; `./verify.sh` vert.
- [ ] **Lot 9** Publier `docs/SmartPI/Sensors&Modules/SmartPi_Flame_Sensor_Control.md` :
  corriger la contradiction de pin VCC relevée dans l'audit, puis décommenter/ajouter son
  entrée dans `mkdocs.yml` sous `4.1 SMART PI ONE` (section capteurs), à la suite des pages
  capteurs existantes. — test : entrée active dans `mkdocs.yml` ; `./verify.sh` vert.
- [ ] **Lot 10** Publier `docs/SmartPI/Sensors&Modules/SmartPi_IR_Presence_Detector_Control.md`
  de la même façon (page déjà complète d'après l'audit — relis-la et corrige ce qui saute
  aux yeux avant de publier). — test : entrée active dans `mkdocs.yml` ; `./verify.sh` vert.

## Priorité 4 — fusion des deux arbres de maintenance

- [ ] **Lot 11** Dans `docs/c-series/maintenance/`, ajouter une page `fan_cleaning.md` au
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
