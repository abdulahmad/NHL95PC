#!/bin/sh
# Build the 32-bit Windows program (build/win/hockey-win32.exe + SDL2.dll) with mingw-w64 from Linux or WSL.
#   sudo apt install gcc-mingw-w64-i686 nasm make python3
set -e
cd "$(dirname "$0")/.."
# Where SDL2 for 32-bit Windows is: SDL2_MINGW (the i686-w64-mingw32 directory of SDL2-devel-*-mingw), a copy unpacked next to the
# repository, or the MSYS2 MINGW32 package (pkg-config).
SDL2_MINGW=${SDL2_MINGW:-$(ls -d SDL2-*/i686-w64-mingw32 ../SDL2-*/i686-w64-mingw32 2>/dev/null | head -1)}
if [ -n "$SDL2_MINGW" ] && [ -d "$SDL2_MINGW/include/SDL2" ]; then
    SDL_CFLAGS="-I$SDL2_MINGW/include/SDL2"
    SDL_LIBS="-L$SDL2_MINGW/lib -lSDL2"
    SDL_DLL="$SDL2_MINGW/bin/SDL2.dll"
elif pkg-config --exists sdl2 2>/dev/null; then
    SDL_CFLAGS=$(pkg-config --cflags sdl2 | sed 's/-Dmain=SDL_main//')
    SDL_LIBS=$(pkg-config --libs sdl2 | sed 's/-lmingw32//; s/-lSDL2main//; s/-mwindows//')
    SDL_DLL="$(pkg-config --variable=prefix sdl2)/bin/SDL2.dll"
else
    echo "SDL2 for 32-bit Windows not found: set SDL2_MINGW to the i686-w64-mingw32 directory of SDL2-devel-*-mingw, or install" >&2
    echo "mingw-w64-i686-SDL2 in an MSYS2 MINGW32 shell" >&2
    exit 1
fi
OUT=build/win
rm -rf "$OUT/src" "$OUT/obj"
mkdir -p "$OUT/src" "$OUT/obj"
cp -r src/inc "$OUT/src/inc"

# The sources name their sections s_<address> with ELF attributes. A Windows image may have only 96 sections, so code, data and BSS
# are folded into .text and .data (the linker keeps the order of the objects). The uninitialized sections go to .data too, as
# zeros: the game's data segment has to stay one contiguous block in the original order (a GUS table is cleared from one symbol up to
# the next, and the first is initialized data, the second zero-filled), which separate .data and .bss sections would break.
# Layout follows Makefile SRCS: src/{engine,front,pc,lib,data} (the cseg01/dseg02 trees were recut).
find src/engine src/front src/pc src/lib src/data -name '*.asm' | sort | while read -r f; do
    rel=${f#src/}
    mkdir -p "$OUT/src/$(dirname "$rel")"
    sed -e 's/^section s_[0-9A-F]* progbits alloc exec nowrite align=1/section .text align=1/' \
        -e 's/^section s_[0-9A-F]* progbits alloc noexec write align=1/section .data align=1/' \
        -e 's/^section s_[0-9A-F]* nobits alloc noexec write align=1/section .data align=1/' "$f" > "$OUT/src/$rel"
done
find "$OUT/src" -name '*.asm' | sort | xargs -P 8 -I{} sh -c \
    'rel=${1#'"$OUT"'/src/}; mkdir -p "'"$OUT"'/obj/$(dirname "$rel")"; nasm -O0 -f win32 --gprefix _ -I '"$OUT"'/src/inc/ "$1" -o "'"$OUT"'/obj/${rel%.asm}.o"' _ {}

sh port/fetch-deps.sh
# Munt (the MT-32 emulator) needs a C++ compiler: mingw-w64's g++ (gcc-mingw-w64-i686 plus g++-mingw-w64-i686)
CXXW=${CXXW:-i686-w64-mingw32-g++}
command -v "$CXXW" >/dev/null 2>&1 || CXXW=g++
ARW=${ARW:-i686-w64-mingw32-ar}
command -v "$ARW" >/dev/null 2>&1 || ARW=ar           # MSYS2 MINGW32 has only ar
CXX=$CXXW AR=$ARW sh port/munt-build.sh build/munt-win "-static"

CC=${CC:-i686-w64-mingw32-gcc}
command -v "$CC" >/dev/null 2>&1 || CC=gcc
# DOS memory (0x10000-0xFFFFF) must be free, but Windows fills it before main runs. Linked at 0x10000 with ld's default script plus an
# uninitialized section .lowmem in front of .text, the program's own image covers 0x11000-0xFFFFF: the loader maps it first.
$CC -Wl,--verbose 2>/dev/null | sed -n '/^======/,/^======/p' | sed '1d;$d' | sed \
    's/^  \.text  __image_base__ + ( __section_alignment__ < 0x1000 ? \. : __section_alignment__ ) :/  .lowmem __image_base__ + __section_alignment__ (NOLOAD) : { . = . + 0xEF000; }\n  .text ALIGN(__section_alignment__) :/' \
    > "$OUT/lowmem.ld"
grep -q '^  \.lowmem' "$OUT/lowmem.ld" || { echo "could not add .lowmem to the linker script" >&2; exit 1; }
# the program's icon (resource 1, which SDL uses for the window as well)
WINDRES=${WINDRES:-i686-w64-mingw32-windres}
command -v "$WINDRES" >/dev/null 2>&1 || WINDRES=windres
$WINDRES -O coff port/icon/icon.rc -o "$OUT/icon.o"
# Overbar, the host menu and scaler: the git submodule port/overbar (git submodule update --init)
[ -f port/overbar/sources.txt ] || { echo "no Overbar at port/overbar: git submodule update --init" >&2; exit 1; }
OVERBAR_SRCS=$(tr -d '\r' < port/overbar/sources.txt | sed 's|^|port/overbar/|')
# the build, for online play's check that both machines run the same one
NHL95_BUILD=$(git describe --always --dirty 2>/dev/null || echo unknown)
$CC -O1 -g -mstackrealign -Wall -Wno-format-truncation -DSDL_MAIN_HANDLED -DNHL95_BUILD="\"$NHL95_BUILD\"" $SDL_CFLAGS \
    -DOB_SDL_BASE -Iport/overbar/include -Ibuild/munt-win/inc -Iport/third_party/munt/mt32emu/src \
    -o "$OUT/hockey-win32.exe" port/host.c port/shell.c port/bindings.c port/bindings_win.c -DHAVE_GL port/stats.c port/emu.c port/ports.c port/dos.c port/video.c port/input.c port/irq.c port/audio.c port/dma.c port/speaker.c port/opl.c port/sb.c port/mpu.c port/gus.c port/sound_ports.c \
    port/overbar_client.c port/season.c port/season_floppy.c port/season_h2h.c port/netplay.c port/snap.c $OVERBAR_SRCS \
    port/soundtest.c port/third_party/nuked-opl3/opl3.c -DHAVE_MUNT port/cstart.c \
    port/overrides.c port/osk_hook.c port/feel.c port/lines.c port/goalie.c port/pads4.c port/rom94.c port/skill.c port/sides.c port/lineup.c port/fight/hooks.c port/fight/rules.c port/fight/rom93.c port/fight/punch.c port/plat_win.c "$OUT/icon.o" $(sh port/objorder.sh "$OUT/obj") \
    build/munt-win/libmt32emu.a $SDL_LIBS -lopengl32 -lpdh -lcomctl32 -lgdi32 -lws2_32 -static-libgcc -Wl,-Bstatic -lstdc++ -lpthread -Wl,-Bdynamic -lm -Wl,--subsystem,console \
    -Wl,--disable-dynamicbase -Wl,--image-base=0x10000 -Wl,-T,"$OUT/lowmem.ld"
cp "$SDL_DLL" "$OUT/"
rm -rf "$OUT/mister" && cp -r port/overbar/mister "$OUT/mister"       # the MiSTer filter files the "MiSTer filters" menus list
echo "built $OUT/hockey-win32.exe (run it in the game's folder, or set NHL95_ROOT)"
