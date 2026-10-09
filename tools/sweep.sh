#!/bin/bash
# sweep.sh VER "FLAGS" : compile t1..tN test files with FLAGS and compare with EXE
REPO=$(cd "$(dirname "$0")/.." && pwd)
mkdir -p "$REPO/build/cc" && cd "$REPO/build/cc" && cp -n ../../tools/cc_tests/*.c ../../tools/cc_tests/targets.txt . 2>/dev/null
VER=$1; FL="$2"
TAG=$(echo "$FL" | tr -c 'A-Za-z0-9\n' '_'); [ -z "$TAG" ] && TAG=default
tot=0; ok=0; out=""
while read t targets; do
  [ -z "$t" ] && continue
  ../../tools/wc10.sh $VER $t.c "$FL" >/dev/null 2>&1 || true
  r=$(python3 ../../tools/cmpobj.py $VER/$t.obj $targets 2>&1 | awk '{print $1":"$4}' | tr '\n' ' ')
  out="$out $r"
done < targets.txt
echo "$VER [$FL] => $out"
