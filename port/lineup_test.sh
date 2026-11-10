#!/bin/sh
# Tonight's Lineup helpers (port/lineup_test.c).
cd "$(dirname "$0")/.." || exit 1
mkdir -p build
gcc -O1 -g -Wall -Wextra -DLINEUP_TEST -Iport -o build/lineup_test port/lineup_test.c port/lineup.c || exit 1
build/lineup_test
