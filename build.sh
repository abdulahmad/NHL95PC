#!/bin/sh
# One-command build without make: HOCKEY.EXE from src/ + sha1 check.  Usage: ./build.sh [path/to/HOCKEY.EXE]
# Same steps as the Makefile: extract stubs/LE metadata from your EXE, nasm every src/*.asm, link, sha1 check.
set -e
cd "$(dirname "$0")"
EXE="${1:-HOCKEY.EXE}"
PY="${PYTHON:-python3}"
NASM="${NASM:-nasm}"
[ -f "$EXE" ] || { echo "HOCKEY.EXE not found: copy your retail NHL 95 PC HOCKEY.EXE to the repo root or pass its path" >&2; exit 1; }
command -v "$NASM" >/dev/null || { echo "nasm not found (apt install nasm / brew install nasm)" >&2; exit 1; }
"$PY" tools/rebuild_exe.py extract "$EXE" build/parts
JOBS="$(getconf _NPROCESSORS_ONLN 2>/dev/null || echo 4)"
echo "assembling $(ls src/cseg01/*.asm src/dseg02/*.asm | wc -l) files with $JOBS jobs"
ls src/cseg01/*.asm src/dseg02/*.asm | xargs -P "$JOBS" -I{} sh -c '
  o="build/obj/${1#src/}"; o="${o%.asm}.o"; mkdir -p "$(dirname "$o")"
  '"$NASM"' -O0 -f elf32 -I src/inc/ -o "$o" "$1"' _ {}
"$PY" tools/link_src.py --obj build/obj --parts build/parts --out build/HOCKEY.EXE
