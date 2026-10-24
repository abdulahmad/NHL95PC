#!/usr/bin/env python3
"""splice.py - a split function piece by piece: where each piece sits, how far it is from the EXE, which pieces are C.

  python3 tools/splice.py src/c/<seg>/<File>.c FUNC [--obj OBJ] [--mark] [--diff]

Watcom can split a function: its entry follows a function that falls into it, and the rest stays where the function
was defined (chkprogress: entry after PenaltyManager, chkprogress_go / chkprogress_x after InProgress; LoadRosterList:
entry after LoadBothRosterLists, LoadRosterList_fa / LoadRosterList_team after ShellSortBytes). Each piece is its own
asm block in the EXE layout, so each one can be marked (built from C) on its own while the others stay asm.

The pieces are FUNC's entry and permute.py's pieces (labels FUNC_* outside the entry's range that start code, plus a
`pieces of FUNC:` comment). Each is placed in the compiled object like cc.py frag places a marked block (cc.anchor):
its public, a public inside it, else by the branches that reach it (cc.flow_anchor: the file's code aligned with the
original, every branch into the piece votes), else by the nearest public. Then each piece is compared with the
original (cdiff.compare; differing instructions as permute.py counts them).

  --diff   print cdiff's rows of every piece that differs
  --mark   mark every matching piece that is not marked yet (cc.py mark --func PIECE); run make / make fullcheck after

c_progress.py counts the function as matched once its entry and every piece are in marked blocks."""
import os, sys, argparse
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
import cc, cdiff, cobj, permute


def marked_in(src, label):
    """the marked block (function name) of this C file that holds label, else None"""
    asm = cc.c_paths(src, label)[2]
    a = cc.label_addr(asm, label)
    for f in cc.file_blocks(src):
        s, e, labs, body = cc.block(src, f)
        if cc.c_paths(src, f)[2] == asm and s <= a < e: return f
    return None


def main():
    ap = argparse.ArgumentParser(description=__doc__.split('\n')[0])
    ap.add_argument('src'); ap.add_argument('func'); ap.add_argument('--obj')
    ap.add_argument('--mark', action='store_true'); ap.add_argument('--diff', action='store_true')
    a = ap.parse_args()
    src = a.src
    obj = a.obj or os.path.join(ROOT, 'build', os.path.relpath(os.path.splitext(os.path.abspath(src))[0], os.path.join(ROOT, 'src')) + '.obj')
    if not a.obj and not cc.compile_c(src, obj): sys.exit(2)
    r = cobj.parse(obj, set())
    names = [a.func] + permute.pieces(src, a.func)
    print('%s: %d piece(s)' % (a.func, len(names)))
    total = 0; allc = True; tomark = []
    for n in names:
        s, e = cc.asm_range(src, n)
        try:
            off = cc.anchor(src, r, n, s, e) if n not in r['pubs'] else r['pubs'][n]
            sc = permute.score1(src, obj, n, src)
            c = cdiff.compare(src, obj, n)
        except SystemExit as x:
            print('  %-28s %05X-%05X %4d bytes  not placed: %s' % (n, s, e, e - s, x)); allc = False; total += 9998; continue
        blk = marked_in(src, n)
        st = 'C (%s)' % blk if blk else 'match, asm' if sc[2] else 'asm'
        print('  %-28s %05X-%05X %4d bytes  obj +%-5X compiled %4d  differing %3d  %s'
              % (n, s, e, e - s, off, c['n'], sc[0], st))
        total += sc[0]
        if not blk:
            allc = False
            if sc[2]: tomark.append(n)
        if a.diff and not sc[2]:
            for m, o, ct_, ot_ in c['rows']:
                if m != '  ': print('    %s %05X+%03X %-44s %s' % (m, c['addr'], o, ct_[:44], ot_[:60]))
    print('total differing %d; %s' % (total, 'every piece is C (counts as matched)' if allc else
                                      'pieces still asm: the function counts as a draft'))
    if a.mark:
        for n in tomark:
            if n == a.func and n not in cc.file_blocks(src):
                print('mark the entry with its file: python3 tools/cc.py mark %s%s' % (src, '' if n == cc.c_paths(src)[1] else ' --func ' + n))
                continue
            cc.mark(src, func=n)
        if tomark: print('now run make and make fullcheck')


if __name__ == '__main__':
    main()
