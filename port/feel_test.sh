#!/bin/sh
# The feel options' C copies against the game's own playeracc and stopna (port/feel_test.c). Needs gcc-multilib.
cd "$(dirname "$0")/.." || exit 1
make CBUILD=0 -j8 >/dev/null || exit 1
O=$(sh port/objorder.sh build/obj0)
gcc -m32 -no-pie -O1 -g -Wall -Iport/overbar/include -o build/feel_test port/feel_test.c port/feel.c port/overbar/src/game.c $O 2>&1 \
  | grep -v "warning: \(relocation\|creating\)\|GNU-stack\|NOTE: This"
test -x build/feel_test && build/feel_test
