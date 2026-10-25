#!/bin/sh
# Build the SDL2 host: the asm sources as i386 objects (make CBUILD=0) plus linux/*.c -> build/hockey-linux
# Needs gcc-multilib and the i386 SDL2 development files (libsdl2-dev:i386).
cd "$(dirname "$0")/.." || exit 1
export PKG_CONFIG_PATH=/usr/lib/i386-linux-gnu/pkgconfig:$PKG_CONFIG_PATH
make CBUILD=0 -j8 >/dev/null || exit 1
rm -f build/hockey-linux
O=$(find build/obj0 -name '*.o' | sort)
gcc -m32 -no-pie -g -O1 -Wall -Wno-format-truncation -o build/hockey-linux linux/*.c $O $(pkg-config --cflags --libs sdl2) -lpthread 2>&1 \
  | grep -v "warning: \(relocation\|creating\)\|GNU-stack\|NOTE: This"
test -x build/hockey-linux
