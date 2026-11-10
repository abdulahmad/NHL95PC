#!/bin/sh
# Four players: seats to slots, who a pad may switch to, the pad byte (port/pads4_test.c).
cd "$(dirname "$0")/.." || exit 1
mkdir -p build
gcc -O1 -g -Wall -Wextra -DPADS4_TEST -Iport -o build/pads4_test port/pads4_test.c port/pads4.c || exit 1
build/pads4_test
