#!/bin/sh
# 96 Genesis skill-level helpers (port/skill_test.c).
cd "$(dirname "$0")/.." || exit 1
mkdir -p build
gcc -O1 -g -Wall -Wextra -DSKILL_TEST -Iport -o build/skill_test port/skill_test.c port/skill.c || exit 1
build/skill_test
