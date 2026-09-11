#!/usr/bin/env bash
set -euo pipefail

GODOT_BIN="${GODOT_BIN:-godot}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$ROOT/web/build"

mkdir -p "$OUT"
cd "$ROOT"

"$GODOT_BIN" --headless --path "$ROOT" --editor --quit >/dev/null 2>&1 || true
"$GODOT_BIN" --headless --path "$ROOT" --export-release "Web" "$OUT/index.html"

echo "Web build criada em: $OUT"
