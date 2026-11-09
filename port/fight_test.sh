#!/bin/sh
# port/fight/rom93.c against your NHLPA 93 ROMs (port/fight/fight_test.c): sh port/fight_test.sh <folder with the ROMs>
cd "$(dirname "$0")/.." || exit 1
mkdir -p build
gcc -O1 -g -Wall -Wextra -o build/fight_test port/fight/fight_test.c port/fight/rom93.c || exit 1
build/fight_test "${1:-.}" || exit 1
gcc -O1 -g -Wall -Wextra -o build/rules_test port/fight/rules_test.c port/fight/rules.c || exit 1
build/rules_test
