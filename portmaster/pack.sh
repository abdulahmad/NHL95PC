#!/bin/bash
# Assemble nhl95pc.zip (PortMaster layout). Knulli-optimized docs; zip is CFW-generic.
# Optional aarch64 binary: the desktop trap host is i386 and must not be passed in.
#   ./portmaster/pack.sh [path/to/nhl95pc.aarch64]
# Never packs gamedata/ or cd/ contents (user copies HOCKEY.EXE / CD files).
set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="${OUT:-$ROOT/build/nhl95pc.zip}"
STAGE="$ROOT/build/portmaster-nhl95pc"
BIN="${1:-}"

if [ -n "$BIN" ]; then
  case "$(basename "$BIN")" in
    hockey-linux|hockey-win32.exe|hockey-win32)
      echo "refusing i386/Win32 trap host as nhl95pc.aarch64: $BIN" >&2
      exit 1
      ;;
  esac
fi

rm -rf "$STAGE"
mkdir -p "$STAGE/nhl95pc/gamedata" "$STAGE/nhl95pc/cd" "$STAGE/nhl95pc/conf" \
         "$STAGE/nhl95pc/libs.aarch64" "$STAGE/nhl95pc/licenses"
cp "$ROOT/portmaster/NHL 95 PC.sh" "$STAGE/"
chmod +x "$STAGE/NHL 95 PC.sh"
cp "$ROOT/portmaster/nhl95pc/port.json" "$ROOT/portmaster/nhl95pc/gameinfo.xml" \
   "$ROOT/portmaster/nhl95pc/nhl95pc.gptk" "$ROOT/portmaster/nhl95pc/README.md" "$STAGE/nhl95pc/"
cp "$ROOT/portmaster/nhl95pc/licenses/"* "$STAGE/nhl95pc/licenses/"
if [ -f "$ROOT/portmaster/nhl95pc/screenshot.png" ]; then
  cp "$ROOT/portmaster/nhl95pc/screenshot.png" "$STAGE/nhl95pc/"
fi
if [ -n "$BIN" ]; then
  cp "$BIN" "$STAGE/nhl95pc/nhl95pc.aarch64"
  chmod +x "$STAGE/nhl95pc/nhl95pc.aarch64"
fi
mkdir -p "$(dirname "$OUT")"
rm -f "$OUT"
(cd "$STAGE" && zip -rq "$OUT" "NHL 95 PC.sh" nhl95pc)
echo "wrote $OUT"
