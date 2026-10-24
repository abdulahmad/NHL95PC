#!/usr/bin/env python3
"""draft_causes.py - fill the cause column of tools/c_functions.csv for every nonmatching draft.

  python3 tools/draft_causes.py [--jobs 8] [--list]

Each draft is compiled (fresh), aligned with the EXE as tools/classify_diff.py does, and every differing
instruction is put in one class:
  register  the same instruction with another register
  slot      the same instruction with another stack slot
  branch    a jump that differs (another condition, target or form) or an extra / missing jump inside the
            function: the branch layout
  tail      a jump that leaves the function (into another function's shared exit) or the final pops / ret: the exit
  size      other extra / missing / changed instructions: a real source difference (often the size differs too)
The cause is the class with the most instructions (ties in that order); a draft that does not compile or score
gets `error`. The counts go into the csv too (cause column: `register 12/15`). c_progress.py keeps the column.
--list prints the drafts by cause. Batch the work by cause: register / slot for the permuter and the slot solver,
tail for tools/module_try.py, branch and size by hand."""
import argparse, csv, difflib, io, os, re, sys, tempfile, shutil, collections
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
import cc, cdiff, classify_diff as cd

CLASSES = ['register', 'slot', 'branch', 'tail', 'size']


def is_jump(t):
    return t.split(' ')[0].startswith('j')


def leaves(t):
    """a jump whose target is named outside the function (the cdiff text carries `; Label` then)"""
    return is_jump(t) and '  ; ' in t


def classify(C, O):
    """{class: count} for one draft's aligned instruction lists"""
    k = collections.Counter()
    sm = difflib.SequenceMatcher(None, [cd.key(x) for x in C], [cd.key(x) for x in O], autojunk=False)
    nO = len(O)
    for tag, i1, i2, j1, j2 in sm.get_opcodes():
        n = min(i2 - i1, j2 - j1)
        for a, b, j in zip(C[i1:i1 + n], O[j1:j1 + n], range(j1, j1 + n)):
            kind = cd.kind(a, b)
            if kind == 'same': continue
            if leaves(a) or leaves(b) or j >= nO - 6 and (b.startswith('pop') or b.startswith('ret')): k['tail'] += 1
            elif is_jump(a) or is_jump(b): k['branch'] += 1
            elif kind == 'stack': k['slot'] += 1
            elif kind == 'register': k['register'] += 1
            else: k['size'] += 1
        for t in C[i1 + n:i2] + O[j1 + n:j2]:
            if leaves(t): k['tail'] += 1
            elif is_jump(t): k['branch'] += 1
            else: k['size'] += 1
    return k


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('--jobs', type=int, default=8); ap.add_argument('--list', action='store_true')
    a = ap.parse_args()
    os.chdir(ROOT)
    path = os.path.join(ROOT, 'tools/c_functions.csv')
    rows = list(csv.DictReader(open(path, newline='')))
    fields = list(rows[0].keys())
    if 'cause' not in fields: fields.append('cause')
    drafts = [r for r in rows if r['status'] == 'nonmatching']
    files = sorted(set(r['c_file'] for r in drafts))
    cdiff.need_build('draft_causes.py')
    work = tempfile.mkdtemp(prefix='causes_')
    try:
        items = [(f, os.path.join(work, f.replace('/', '_') + '.obj'), '') for f in files]
        oks = dict(zip(files, cc.compile_parallel(items, a.jobs)))
        obj = {f: o for f, o, _ in items}
        for r in rows:
            if r['status'] != 'nonmatching': r['cause'] = ''; continue
            f = r['c_file']
            if not oks.get(f): r['cause'] = 'error'; continue
            try:
                c = cdiff.compare(f, obj[f], r['function'])
                k = classify(c['ctexts'], c['otexts'])
            except (SystemExit, Exception):
                r['cause'] = 'error'; continue
            tot = sum(k.values())
            if not tot: r['cause'] = 'tail 0/0'; continue
            best = max(CLASSES, key=lambda x: (k[x], -CLASSES.index(x)))
            r['cause'] = '%s %d/%d' % (best, k[best], tot)
    finally:
        shutil.rmtree(work, ignore_errors=True)
    out = io.StringIO()
    w = csv.DictWriter(out, fieldnames=fields, lineterminator='\n'); w.writeheader()
    for r in rows: w.writerow({x: r.get(x, '') for x in fields})
    open(path, 'w', newline='').write(out.getvalue())
    by = collections.defaultdict(list)
    for r in rows:
        if r['status'] == 'nonmatching': by[r['cause'].split(' ')[0]].append(r['function'])
    print('causes: ' + ', '.join('%s %d' % (x, len(by[x])) for x in CLASSES + ['error'] if by.get(x)))
    if a.list:
        for x in CLASSES + ['error']:
            if by.get(x): print('%s: %s' % (x, ' '.join(sorted(by[x]))))


if __name__ == '__main__':
    main()
