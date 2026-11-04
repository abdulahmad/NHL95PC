#!/bin/sh
# One-command build without make: HOCKEY.EXE from src/ + sha1 check.  Usage: ./build.sh [path/to/HOCKEY.EXE]
# Same steps as the Makefile: extract stubs/LE metadata from your EXE, nasm every src/*.asm, link, sha1 check.
set -e
cd "$(dirname "$0")"
EXE="${1:-retail/HOCKEY.EXE}"
PY="${PYTHON:-python3}"
NASM="${NASM:-nasm}"
if [ ! -f "$EXE" ] && [ -f HOCKEY.EXE ]; then EXE=HOCKEY.EXE; fi
[ -f "$EXE" ] || { echo "HOCKEY.EXE not found: expected retail/HOCKEY.EXE (root HOCKEY.EXE is a pointer) or pass a path" >&2; exit 1; }
command -v "$NASM" >/dev/null || { echo "nasm not found (apt install nasm / brew install nasm)" >&2; exit 1; }
"$PY" tools/rebuild_exe.py extract "$EXE" build/parts
JOBS="$(getconf _NPROCESSORS_ONLN 2>/dev/null || echo 4)"
echo "assembling $(find src/engine src/front src/pc src/lib src/data -name '*.asm' | wc -l) files with $JOBS jobs"
find src/engine src/front src/pc src/lib src/data -name '*.asm' | sort | xargs -P "$JOBS" -I{} sh -c '
  o="build/obj/${1#src/}"; o="${o%.asm}.o"; mkdir -p "$(dirname "$o")"
  '"$NASM"' -O0 -f elf32 -I src/inc/ -o "$o" "$1"' _ {}
"$PY" tools/link_src.py --obj build/obj --parts build/parts --out build/HOCKEY.EXE
