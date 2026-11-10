#!/bin/sh
# 96 PC Auto line-change CompLine helper (port/lines_test.c).
cd "$(dirname "$0")/.." || exit 1
mkdir -p build
gcc -O1 -g -Wall -Wextra -DLINES_TEST -Iport -o build/lines_test port/lines_test.c port/lines.c || exit 1
build/lines_test
