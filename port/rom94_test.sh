#!/bin/sh
# The NHL 94 ROM reader (port/rom94_test.c). Set NHL94_ROM_DIR to a folder with the ROM; skipped without.
cd "$(dirname "$0")/.." || exit 1
mkdir -p build
gcc -O1 -g -Wall -Wextra -Iport -o build/rom94_test port/rom94_test.c port/rom94.c port/fight/rom93.c || exit 1
build/rom94_test
