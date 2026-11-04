#!/usr/bin/env python3
"""reshape_modules.py - move the code segments to the module layout in docs/module_map.csv (step F2b of the
alignment plan) and rewrite every path and stem that names them.

  python3 tools/reshape_modules.py [--dry-run]

docs/module_map.csv maps each old segment stem (NNN_ADDR_topic) to a module path: engine/<95G module>,
front/<module>, pc/<DOS-only job>, lib/<library>. For every row whose old files still exist:
  src/cseg01/<old>.asm  -> src/cseg01/<module>.asm
  src/c/<old>/          -> src/c/<module>/
and in every tracked text file the old stem becomes the module path. The link order stays in src/segments.txt.
It is idempotent: after a merge from main brings files under an old stem, run it again. Run `make fullcheck` after.
"""
import os, sys
import argparse, csv, os, re, subprocess
HERE = os.path.dirname(os.path.abspath(__file__))
_td = HERE
while os.path.basename(_td) != 'tools' and _td != os.path.dirname(_td):
    _td = os.path.dirname(_td)
if _td not in sys.path:
    sys.path.insert(0, _td)
import paths
ROOT = paths.ROOT
TEXT = ('.asm', '.inc', '.c', '.h', '.py', '.md', '.csv', '.json', '.txt', '.sh', '.mdc', '.yml', '.mk')

def git(*a):
    return subprocess.run(['git'] + list(a), cwd=ROOT, check=True, capture_output=True, text=True).stdout

def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('--dry-run', action='store_true')
    a = ap.parse_args()
    rows = list(csv.DictReader(open(os.path.join(ROOT, 'docs/module_map.csv'), newline='')))
    m = {r['old_stem']: r['module'] for r in rows}
    moved = 0
    for old, new in m.items():
        for src, dst in (('src/cseg01/%s.asm' % old, 'src/cseg01/%s.asm' % new), ('src/c/%s' % old, 'src/c/%s' % new)):
            s, d = os.path.join(ROOT, src), os.path.join(ROOT, dst)
            if not os.path.exists(s): continue
            moved += 1
            if a.dry_run: print('mv', src, dst); continue
            os.makedirs(os.path.dirname(d), exist_ok=True)
            if os.path.isdir(s) and os.path.isdir(d):     # a merge added files under the old stem
                for f in sorted(os.listdir(s)): git('mv', os.path.join(src, f), os.path.join(dst, f))
            else:
                git('mv', src, dst)
    pat = re.compile(r'(?<![\w])(' + '|'.join(re.escape(o) for o in sorted(m, key=len, reverse=True)) + r')(?![\w])')
    changed = 0
    # append-only logs (merge=union in .gitattributes) keep the paths they were written with: rewriting them would
    # duplicate every row on the next union merge. Their readers key on the function, not the path.
    skip = {'docs/module_map.csv'} | {l.split()[0] for l in open(os.path.join(ROOT, '.gitattributes'))
                                      if 'merge=union' in l} if os.path.exists(os.path.join(ROOT, '.gitattributes')) else {'docs/module_map.csv'}
    for f in git('ls-files').split('\n'):
        if not f.endswith(TEXT) or f in skip or f.startswith('docs/archive/'): continue
        p = os.path.join(ROOT, f)
        if not os.path.isfile(p): continue
        try: s = open(p, encoding='utf-8', newline='').read()
        except UnicodeDecodeError: continue
        t = pat.sub(lambda x: m[x.group(1)], s)
        if t != s:
            changed += 1
            if not a.dry_run: open(p, 'w', encoding='utf-8', newline='').write(t)
    print('%d paths moved, %d files rewritten%s' % (moved, changed, ' (dry run)' if a.dry_run else ''))

if __name__ == '__main__':
    main()
