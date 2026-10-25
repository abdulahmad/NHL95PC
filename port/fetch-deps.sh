#!/bin/sh
# Download the two sound libraries the port uses into port/third_party (not committed):
#   Nuked-OPL3 (LGPL 2.1+): the Yamaha OPL2/OPL3 chip of the AdLib and Sound Blaster
#   Munt libmt32emu (LGPL 2.1+): the Roland MT-32 (needs your MT32_CONTROL.ROM and MT32_PCM.ROM at run time)
set -e
cd "$(dirname "$0")"
mkdir -p third_party
cd third_party
[ -d nuked-opl3 ] || GIT_LFS_SKIP_SMUDGE=1 git clone -q --depth 1 https://github.com/nukeykt/Nuked-OPL3 nuked-opl3
[ -d munt ] || GIT_LFS_SKIP_SMUDGE=1 git clone -q --depth 1 https://github.com/munt/munt munt
echo "dependencies are in port/third_party"
