#!/bin/sh
# Floppy pack Import Databases > Player reads, and installing it as the guest league.
cd "$(dirname "$0")/.." || exit 1
mkdir -p build
gcc -O1 -g -Wall -Wextra -Iport -o build/season_test port/season_test.c port/season_floppy.c || exit 1
build/season_test
