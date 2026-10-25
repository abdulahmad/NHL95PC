#!/bin/sh
# Compile libmt32emu (the Munt MT-32 emulator, LGPL) into $1/libmt32emu.a with the C++ compiler given by $CXX and the flags in $2.
# Usage: munt-build.sh OUTDIR "extra flags"
set -e
OUT=$1; FLAGS=$2
SRC="$(cd "$(dirname "$0")" && pwd)/third_party/munt/mt32emu/src"
CXX=${CXX:-g++}; AR=${AR:-ar}
[ -f "$OUT/libmt32emu.a" ] && exit 0
mkdir -p "$OUT/inc" "$OUT/obj"
cat > "$OUT/inc/config.h" <<'C'
#ifndef MT32EMU_CONFIG_H
#define MT32EMU_CONFIG_H
#define MT32EMU_VERSION_MAJOR 2
#define MT32EMU_VERSION_MINOR 7
#define MT32EMU_VERSION_PATCH 1
#define MT32EMU_VERSION "2.7.1"
#define MT32EMU_EXPORTS_TYPE 3
#define MT32EMU_WITH_VERSION_TAGGING 0
#endif
C
for f in "$SRC"/*.cpp "$SRC"/sha1/*.cpp "$SRC"/c_interface/*.cpp; do
    echo "$CXX -O2 -w -I$OUT/inc -I$SRC $FLAGS -c $f -o $OUT/obj/$(basename "$f" .cpp).o"
done | xargs -P 8 -I{} sh -c '{}'
rm -f "$OUT/libmt32emu.a"; $AR rcs "$OUT/libmt32emu.a" "$OUT"/obj/*.o
