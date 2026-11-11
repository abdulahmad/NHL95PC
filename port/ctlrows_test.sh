#!/bin/sh
# Player 1 / 2 control rows (port/ctlrows.c).
cd "$(dirname "$0")/.." || exit 1
mkdir -p build
gcc -O1 -g -Wall -Wextra -DCTLROWS_TEST -Iport -o build/ctlrows_test port/ctlrows_test.c port/ctlrows.c || exit 1
build/ctlrows_test
