#!/usr/bin/env python3
"""first_pick.py - where a draft first goes wrong, and on which source line.

  python3 tools/first_pick.py src/c/<seg>/<File>.c FUNC [-n 8] [--all]

Compiles the file with -d1 (line numbers only; the code is the same), aligns the function's instructions with the
EXE's (tools/classify_diff.py's alignment: registers and stack slots folded) and prints the first N differences, each
with its kind (reg, stack, operand, opcode, extra, missing), both instructions and the C line that produced the
compiled one. With --all it also prints the register renaming over all register-only differences (compiled ->
EXE, with counts), which shows a shift in Watcom's register cycle (C_MATCHING: the register cycle for short-lived
temporaries): when every pick after one point is one step off, the source has one temporary more or less before it."""
import argparse, collections, difflib, os, re, sys, tempfile
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
import cc, cdiff, cobj, classify_diff, slot_solver

REG = re.compile(r'\b(e?[abcd]x|[abcd][lh]|e?[sd]i|e?[sb]p)\b')
FULL = {'al': 'eax', 'ah': 'eax', 'ax': 'eax', 'bl': 'ebx', 'bh': 'ebx', 'bx': 'ebx', 'cl': 'ecx', 'ch': 'ecx',
        'cx': 'ecx', 'dl': 'edx', 'dh': 'edx', 'dx': 'edx', 'si': 'esi', 'di': 'edi', 'bp': 'ebp', 'sp': 'esp'}


def main():
    ap = argparse.ArgumentParser(); ap.add_argument('src'); ap.add_argument('func')
    ap.add_argument('-n', type=int, default=8); ap.add_argument('--all', action='store_true')
    a = ap.parse_args()
    os.chdir(ROOT)
    src = a.src; lines = open(src).read().split('\n')
    tmp = tempfile.mkdtemp(prefix='fp_'); obj = os.path.join(tmp, 'f.obj')
    if not cc.compile_c(src, obj, '-d1'): raise SystemExit('compile failed')
    c = cdiff.compare(src, obj, a.func)
    C, O = c['ctexts'], c['otexts']
    c0 = cobj.parse(obj, None)['pubs'].get(a.func, 0)
    ln = slot_solver.linnum(obj)
    offs = [x[1] for x in c['rows']]

    def line_of(i):
        if i >= len(offs): return None
        best = None
        for o, l in ln:
            if o <= c0 + offs[i]: best = l
            else: break
        return best

    sm = difflib.SequenceMatcher(None, [classify_diff.key(x) for x in C], [classify_diff.key(x) for x in O], autojunk=False)
    diffs = []; ren = collections.Counter()
    for tag, i1, i2, j1, j2 in sm.get_opcodes():
        if tag == 'equal':
            for i, j in zip(range(i1, i2), range(j1, j2)):
                k = classify_diff.kind(C[i], O[j])
                if k != 'same': diffs.append((k, i, C[i], O[j]))
                if k == 'register':
                    for x, y in zip(REG.findall(C[i].split('  ; ')[0]), REG.findall(O[j].split('  ; ')[0])):
                        x, y = FULL.get(x, x), FULL.get(y, y)
                        if x != y: ren[(x, y)] += 1
            continue
        n = min(i2 - i1, j2 - j1)
        for i, j in zip(range(i1, i1 + n), range(j1, j1 + n)): diffs.append((classify_diff.kind(C[i], O[j]), i, C[i], O[j]))
        for i in range(i1 + n, i2): diffs.append(('extra', i, C[i], ''))
        for j in range(j1 + n, j2): diffs.append(('missing', i1 + n, '', O[j]))
    diffs.sort(key=lambda d: d[1])
    print('%s: %d differences (compiled %d bytes, EXE %s)' % (a.func, len(diffs), c['n'], c['olen']))
    for k, i, ct, ot in diffs[:a.n]:
        l = line_of(i)
        src_l = lines[l - 1].strip() if l and l <= len(lines) else '?'
        print('  %-8s +%03X  %-36s | %-36s  L%s: %s' % (k, offs[i] if i < len(offs) else 0, ct[:36], ot[:36], l, src_l[:70]))
    if a.all and ren:
        print('register renaming (compiled -> EXE):', ', '.join('%s->%s x%d' % (x, y, n) for (x, y), n in ren.most_common()))


if __name__ == '__main__':
    main()
