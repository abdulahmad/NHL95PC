#!/bin/sh
# 95 PC select-sides seat table (port/sides_test.c).
cd "$(dirname "$0")/.." || exit 1
mkdir -p build
gcc -O1 -g -Wall -Wextra -DSIDES_TEST -Iport -o build/sides_test port/sides_test.c port/sides.c || exit 1
build/sides_test
