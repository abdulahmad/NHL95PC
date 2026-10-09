#!/bin/bash
# wc10.sh VERSION SRC.c "FLAGS..."   -> build/cc/<ver>/<name>.obj + .lst (wdis) ; runs historic wcc386 under headless dosbox
# Needs dosbox + the Watcom trees under $WATCOM_ROOT (default ~/watcom): w10a/WATCOM, dosla, w105, ow19/binl/wdis.
# VERSION: 10a (Watcom 10.0a, Sep 1994 CD) | la (10.0 Limited Edition prerelease, Mar 1994) | 105 (Watcom 10.5, Jul 1995)
set -e
VER=$1; SRC=$2; FLAGS=$3
REPO=$(cd "$(dirname "$0")/.." && pwd)
W=${WATCOM_ROOT:-$HOME/watcom}   # historic Watcom installs (not in the repo)
case $VER in
  10a) ROOT=$W/w10a/WATCOM; CC=BINB/WCC386.EXE; D4=BIN/DOS4GW.EXE ;;
  la)  ROOT=$W/dosla; CC=WCC386.EXE; D4=../w10a/WATCOM/BIN/DOS4GW.EXE ;;
  105) ROOT=$W/w105; CC=BINW/WCC386.EXE; D4=BINW/DOS4GW.EXE ;;
esac
OUT=$REPO/build/cc/$VER; mkdir -p $OUT
WORK=$(mktemp -d /tmp/wc10.XXXX)
cp $ROOT/$CC $WORK/WCC386.EXE; cp $ROOT/$D4 $WORK/DOS4GW.EXE; cp $W/w10a/WATCOM/BIN/W32RUN.EXE $WORK/ 2>/dev/null || true
mkdir -p $WORK/H; cp $W/w10a/WATCOM/H/*.H $WORK/H/ 2>/dev/null || true
N=$(basename $SRC .c); NU=$(echo $N | tr a-z A-Z | cut -c1-8)
cp $SRC $WORK/$NU.C
cat > $WORK/db.conf <<E
[sdl]
output=surface
[dosbox]
memsize=64
[cpu]
cycles=max
[autoexec]
mount c $WORK
c:
set DOS4G=QUIET
set PATH=C:\\
set INCLUDE=C:\\H
WCC386 $FLAGS $NU.C > ERR.TXT
exit
E
SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy timeout 120 dosbox -conf $WORK/db.conf -exit >/dev/null 2>&1 || true
cat $WORK/ERR.TXT | tr -d '\r' > $OUT/$N.err
if [ -f $WORK/$NU.OBJ ]; then cp $WORK/$NU.OBJ $OUT/$N.obj; $W/ow19/binl/wdis -a -l=$OUT/$N.lst $OUT/$N.obj >/dev/null 2>&1 || $W/ow19/binl/wdis $OUT/$N.obj > $OUT/$N.lst; else echo "compile failed"; cat $OUT/$N.err; fi
rm -rf $WORK
