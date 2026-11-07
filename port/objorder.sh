#!/bin/sh
# The game's objects in link order for the native builds: by the lowest address of their sections (s_<address>).
# build-win.sh folds every section into .text / .data and build.sh lets ld place the s_ sections as they come, so the
# objects must be given to the linker in the game's own address order. The folder order (sort of src/{engine,front,pc,lib,data})
# is not that order since the tree was recut, and a build in folder order crashes before the first screen.
#   sh port/objorder.sh <object dir>      (run from the repository root; prints one .o path a line)
OBJ=${1:?object dir}
find src/engine src/front src/pc src/lib src/data -name '*.asm' | while read -r f; do
    a=$(grep -oE '^section s_[0-9A-F]+' "$f" | sed 's/^section s_//' | LC_ALL=C sort | head -1)
    [ -n "$a" ] || { echo "objorder: no s_ section in $f" >&2; exit 1; }
    rel=${f#src/}
    echo "$a $OBJ/${rel%.asm}.o"
done | LC_ALL=C sort | cut -d' ' -f2
