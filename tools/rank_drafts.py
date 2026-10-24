#!/usr/bin/env python3
"""rank_drafts.py - score every nonmatching draft the way tools/permute.py does, smallest first.

  python3 tools/rank_drafts.py [--out build/permute/ranked.txt] [--jobs 8]

Each line of the output: score (aligned differing instructions), size difference, function, C file. 9999 marks a
file that does not compile, 9998 a function that could not be scored. The phase lists in tools/permute_lists/ were
cut from this ranking. Compiles are batched; scores in a batch can come from another compiler state (HANDOFF step
3), so a match here is confirmed fresh (permute.confirm)."""
import os, sys, csv, tempfile, shutil, argparse
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
import cc, permute


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('--out', default=os.path.join(ROOT, 'build', 'permute', 'ranked.txt'))
    ap.add_argument('--jobs', type=int, default=8)
    a = ap.parse_args()
    os.chdir(ROOT)
    permute.cdiff.need_build('rank_drafts.py')
    rows = [r for r in csv.DictReader(open('tools/c_functions.csv', newline='')) if r['status'] == 'nonmatching']
    files = sorted(set(r['c_file'] for r in rows))
    work = tempfile.mkdtemp(prefix='rank_')
    try:
        items = [(f, os.path.join(work, f.replace('/', '_') + '.obj'), '') for f in files]
        oks = dict(zip(files, cc.compile_parallel(items, a.jobs)))
        obj = {f: o for f, o, _ in items}
        out = []
        for r in rows:
            f = r['c_file']
            if not oks.get(f): out.append((9999, 0, r['function'], f)); continue
            try:
                s = permute.score(f, obj[f], r['function'], f)
                if s[2]: s = permute.confirm(f, obj[f], r['function'], f) or (9998, 0, False, 0)
                out.append((s[0], s[1], r['function'], f))
            except (SystemExit, Exception):
                out.append((9998, 0, r['function'], f))
    finally:
        shutil.rmtree(work, ignore_errors=True)
    out.sort()
    os.makedirs(os.path.dirname(os.path.abspath(a.out)), exist_ok=True)
    with open(a.out, 'w') as fo:
        for s, d, fn, f in out: fo.write('%d %d %s %s\n' % (s, d, fn, f))
    print('%s: %d drafts ranked, %d scored' % (os.path.relpath(a.out, ROOT), len(out), sum(1 for x in out if x[0] < 9998)))


if __name__ == '__main__':
    main()
