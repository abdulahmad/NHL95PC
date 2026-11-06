#!/bin/bash
# Assemble nhl95pc.zip from this tree. Optional: copy an aarch64 binary in.
#   ./portmaster/pack.sh [path/to/nhl95pc.aarch64]
set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="${OUT:-$ROOT/build/nhl95pc.zip}"
STAGE="$ROOT/build/portmaster-nhl95pc"
BIN="${1:-}"

rm -rf "$STAGE"
mkdir -p "$STAGE/nhl95pc/gamedata" "$STAGE/nhl95pc/cd" "$STAGE/nhl95pc/conf" \
         "$STAGE/nhl95pc/libs.aarch64" "$STAGE/nhl95pc/licenses"
cp "$ROOT/portmaster/NHL 95 PC.sh" "$STAGE/"
chmod +x "$STAGE/NHL 95 PC.sh"
cp "$ROOT/portmaster/nhl95pc/port.json" "$ROOT/portmaster/nhl95pc/gameinfo.xml" \
   "$ROOT/portmaster/nhl95pc/nhl95pc.gptk" "$ROOT/portmaster/nhl95pc/README.md" "$STAGE/nhl95pc/"
cp "$ROOT/portmaster/nhl95pc/licenses/NOTICE.txt" "$STAGE/nhl95pc/licenses/"
cp "$ROOT/portmaster/NHL 95 PC.sh" "$STAGE/nhl95pc/"
if [ -n "$BIN" ]; then
  cp "$BIN" "$STAGE/nhl95pc/nhl95pc.aarch64"
  chmod +x "$STAGE/nhl95pc/nhl95pc.aarch64"
fi
mkdir -p "$(dirname "$OUT")"
(cd "$STAGE" && zip -rq "$OUT" "NHL 95 PC.sh" nhl95pc)
echo "wrote $OUT"
