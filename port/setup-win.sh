#!/bin/sh
# Set up and build the 32-bit Windows program from Linux or WSL (Ubuntu / Debian). The result is build/win/hockey-win32.exe plus
# SDL2.dll: copy the build/win folder to Windows, or run it from WSL (cd to the game folder first, or set NHL95_ROOT).
# From MSYS2 instead: open the "MSYS2 MINGW32" shell, run
#   pacman -S --needed mingw-w64-i686-gcc mingw-w64-i686-SDL2 nasm make python
# and then port/build-win.sh.
set -e
cd "$(dirname "$0")/.."
SUDO=""
[ "$(id -u)" -ne 0 ] && SUDO="sudo"
$SUDO apt-get update
$SUDO apt-get install -y gcc-mingw-w64-i686 nasm make python3 curl
if [ ! -d SDL2-2.30.9/i686-w64-mingw32 ]; then
    curl -L -o /tmp/sdl2-mingw.tgz https://github.com/libsdl-org/SDL/releases/download/release-2.30.9/SDL2-devel-2.30.9-mingw.tar.gz
    tar xzf /tmp/sdl2-mingw.tgz
fi
SDL2_MINGW="$(pwd)/SDL2-2.30.9/i686-w64-mingw32" port/build-win.sh
