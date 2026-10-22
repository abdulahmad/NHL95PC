#!/bin/bash
# permute_batch.sh LISTFILE [permute.py options]: run tools/permute.py --write-match on each function named in
# LISTFILE (one per line; lists in tools/permute_lists/), its C file from tools/c_functions.csv. Each run's output
# goes to build/permute/runs/FUNC.txt and its last line to build/permute/summary.txt, which ends with DONE.
# A "written to FILE" line is a match (confirmed fresh by permute.py): mark it with cc.py mark.
# Run it in the background: (setsid nohup tools/permute_batch.sh LIST > build/permute/batch.log 2>&1 < /dev/null &)
# To stop after the current function, empty LISTFILE (keep a copy): the read loop then ends.
list=$(readlink -f "$1"); shift
cd "$(dirname "$(readlink -f "$0")")/.." || exit 1
out=build/permute
mkdir -p $out/runs

while read -r f; do
  [ -z "$f" ] && continue
  file=$(python3 -c "import csv,sys; r=[x for x in csv.reader(open('tools/c_functions.csv', newline='')) if x[0]==sys.argv[1]]; print(r[0][4] if r and r[0][5]=='nonmatching' else '')" "$f")
  if [ -z "$file" ]; then echo "$f: not a draft" >> $out/summary.txt; continue; fi
  python3 tools/permute.py "$file" "$f" --write-match "$@" > $out/runs/$f.txt 2>&1
  grep -v -i "warning" $out/runs/$f.txt | tail -1 >> $out/summary.txt
done < "$list"
echo DONE >> $out/summary.txt
