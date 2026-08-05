#!/bin/bash
# Gate mécanique de la boucle autonome : le site doit toujours builder proprement.
# Rouge → .done refusé (voir GOAL.md). Lancé par la codeuse après chaque lot.
set -euo pipefail
cd "$(dirname "$0")"

VENV=~/.cache/yumi-wiki-mkdocs-venv
if [ ! -x "$VENV/bin/mkdocs" ]; then
  echo "FAIL: venv mkdocs introuvable à $VENV — ne pas en recréer un autre, corriger le chemin"
  exit 1
fi

OUT=$(mktemp -d)
if ! "$VENV/bin/mkdocs" build -d "$OUT" 2>&1 | tee /tmp/verify-mkdocs.log; then
  echo "FAIL: mkdocs build a levé une erreur — voir /tmp/verify-mkdocs.log"
  rm -rf "$OUT"
  exit 1
fi
rm -rf "$OUT"

echo "OK: mkdocs build réussi"
