#!/bin/sh
# Build the Linux host: the asm sources as i386 ELF objects (make CBUILD=0) plus port/*.c -> build/hockey-linux
# Needs gcc-multilib and the i386 SDL2 development files (libsdl2-dev:i386).
cd "$(dirname "$0")/.." || exit 1
export PKG_CONFIG_PATH=/usr/lib/i386-linux-gnu/pkgconfig:$PKG_CONFIG_PATH
make CBUILD=0 -j8 >/dev/null || exit 1
sh port/fetch-deps.sh || exit 1
# Munt (the MT-32 emulator) as a 32-bit static library; its ROMs are not included
CXX="g++ -m32" sh port/munt-build.sh build/munt-linux "" || exit 1
rm -f build/hockey-linux
O=$(sh port/objorder.sh build/obj0)
# Overbar, the host menu and scaler: the git submodule port/overbar (git submodule update --init)
[ -f port/overbar/sources.txt ] || { echo "no Overbar at port/overbar: git submodule update --init" >&2; exit 1; }
OVERBAR_SRCS=$(tr -d '\r' < port/overbar/sources.txt | sed 's|^|port/overbar/|')
gcc -m32 -no-pie -g -O1 -Wall -Wno-format-truncation -DOB_SDL_BASE -Iport/overbar/include -o build/hockey-linux port/host.c port/stats.c port/emu.c port/ports.c port/dos.c port/video.c port/bindings.c port/input.c port/shell.c \
  port/irq.c port/audio.c port/dma.c port/speaker.c port/opl.c port/sb.c port/mpu.c port/gus.c port/sound_ports.c port/soundtest.c -lm port/third_party/nuked-opl3/opl3.c \
  port/overbar_client.c port/season.c port/netplay.c port/snap.c $OVERBAR_SRCS \
  -DHAVE_MUNT -Ibuild/munt-linux/inc -Iport/third_party/munt/mt32emu/src port/cstart.c port/overrides.c port/osk_hook.c port/feel.c port/lines.c port/goalie.c port/skill.c port/sides.c port/lineup.c port/fight/hooks.c port/fight/rules.c port/fight/rom93.c port/fight/punch.c port/plat_linux.c $O $(pkg-config --cflags --libs sdl2) build/munt-linux/libmt32emu.a -lstdc++ -lm -lpthread 2>&1 \
  | grep -v "warning: \(relocation\|creating\)\|GNU-stack\|NOTE: This"
test -x build/hockey-linux
