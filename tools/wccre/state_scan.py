#!/usr/bin/env python3
"""state_scan.py - score C functions in the fresh compiler state and in a "warm" one, in the emulator.

  python3 tools/wccre/state_scan.py [--status nonmatching|matched|all] [--fill 0x40] [--jobs 8] [FILE.c ...]

wcc386 reads one field it never sets: BlkTooBig (GA +38F97, Open Watcom makeblk.c) compares InsId with the id
(+34h) of the first instruction of the current block, and an instruction that starts a block without passing
through AddIns keeps whatever its memory held. Fresh memory (zeros, as `make` compiles) makes the code generator
split such a block once the function passes 75 instructions; a large positive leftover (memory of an earlier
program in the same DOS session, as in the original build; or an id from an earlier function of the same file)
does not. --fill 0x40 gives every fresh block of memory the "warm" value. For every function of the chosen
status in tools/c_functions.csv this compiles its C file both ways and prints the two permute.py scores
(differing instructions) where they differ, and MATCH where one matches."""
import argparse, csv, functools, os, sys, tempfile
from collections import defaultdict
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(os.path.dirname(HERE))
sys.path.insert(0, HERE); sys.path.insert(0, os.path.join(ROOT, 'tools'))


def scan_file(item, fill):
    os.chdir(ROOT)
    import emucc, permute, cc
    src, funcs = item
    out = []
    objs = {}
    try:
        for label, f in (('fresh', None), ('warm', fill)):
            obj = tempfile.mktemp(suffix='.obj')
            ok, msg, emu = emucc.compile_c(src, obj, cc.src_flags(src), fill=f)
            objs[label] = obj if ok else None
        for fn in funcs:
            res = {}
            for label, obj in objs.items():
                if obj is None:
                    res[label] = 'fail'; continue
                try:
                    nd, sz, ok, first = permute.score(src, obj, fn, src)
                    res[label] = 'MATCH' if ok else '%d%s' % (nd, '' if not sz else '/%+d' % sz)
                except (SystemExit, Exception) as e:
                    res[label] = 'err'
            out.append((src, fn, res['fresh'], res['warm']))
    finally:
        for o in objs.values():
            if o and os.path.exists(o): os.remove(o)
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('files', nargs='*')
    ap.add_argument('--status', default='nonmatching')
    ap.add_argument('--fill', type=lambda x: int(x, 0), default=0x40)
    ap.add_argument('--jobs', type=int, default=8)
    a = ap.parse_args()
    by_file = defaultdict(list)
    for r in csv.DictReader(open(os.path.join(ROOT, 'tools/c_functions.csv'))):
        if not r['c_file'] or (a.status != 'all' and r['status'] != a.status):
            continue
        src = os.path.join(ROOT, r['c_file'])
        if a.files and not any(os.path.abspath(f) == src for f in a.files):
            continue
        by_file[src].append(r['function'])
    from multiprocessing import Pool
    changed = 0
    with Pool(a.jobs) as pool:
        for rows in pool.imap_unordered(functools.partial(scan_file, fill=a.fill), sorted(by_file.items())):
            for src, fn, fresh, warm in rows:
                if fresh != warm:
                    changed += 1
                    print('%-28s %-8s -> %-8s %s' % (fn, fresh, warm, os.path.relpath(src, ROOT)), flush=True)
    print('%d functions in %d files; %d score differently warm' % (sum(len(v) for v in by_file.values()), len(by_file), changed))


if __name__ == '__main__':
    main()
