#!/bin/sh
# Manual goalie helpers (port/goalie_test.c).
cd "$(dirname "$0")/.." || exit 1
mkdir -p build
gcc -O1 -g -Wall -Wextra -DGOALIE_TEST -Iport -o build/goalie_test port/goalie_test.c port/goalie.c || exit 1
build/goalie_test
