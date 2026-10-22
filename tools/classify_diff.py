#!/usr/bin/env python3
"""classify_diff.py - sort a draft's differences from the EXE by kind.

  python3 tools/classify_diff.py src/c/<seg>/<File>.c:FUNC [...]

Compiles each file (fresh, as make does), aligns its instructions with the EXE's (difflib over the cdiff texts,
registers and stack slots folded for the alignment) and counts, per aligned pair: same; stack (only an [ebp/esp+n]
slot differs); reg (only a register differs); operand (another constant or symbol); opcode (another mnemonic);
then extra (instructions only the draft has) and missing (only the EXE has). posdiff is cdiff's positional count,
which shifts after the first inserted instruction. Mostly reg / stack: a few register or slot choices repeated in
every instruction that touches the variable. extra / missing / opcode: a real source difference."""
import difflib, os, re, sys, tempfile
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
import cc, cdiff

REG = r'\b(e?[abcd]x|[abcd][lh]|e?[sd]i|e?[sb]p)\b'
STK = r'\[(?:ebp|esp)(?: [-+] (?:0x[0-9a-f]+|\d+))?\]'


def base(s):
    """(instruction with addresses / relocations / jump targets folded, stack slots, symbol)"""
    ins, _, sym = s.partition('  ; ')
    sym = re.sub(r'\+[0-9A-F]+$', '', sym)   # name+off -> name
    stk = re.findall(STK, ins)
    ins = re.sub(STK, 'S', ins)
    if sym or ins.split(' ')[0].startswith('j') or ins.startswith('call'):
        ins = re.sub(r' [-+] (?:0x[0-9a-f]+|\d+)\]', ']', ins)
        ins = re.sub(r'\[(?:0x[0-9a-f]+|\d+)\]', '[A]', ins)
        ins = re.sub(r'^(j\w+|call) 0x[0-9a-f]+', r'\1 T', ins)
        if sym and '[' not in ins:     # an address loaded as an immediate (mov r, offset x / push offset x)
            ins = re.sub(r'(0x[0-9a-f]+|\b\d+)$', 'A', ins)
    return ins, stk, sym if not ins.startswith('j') else ''


def kind(a, b):
    (ia, sa, ya), (ib, sb, yb) = base(a), base(b)
    if ia == ib and ya == yb:
        return 'same' if sa == sb else 'stack'
    if ia.split(' ')[0] != ib.split(' ')[0]:
        return 'opcode'
    if re.sub(REG, 'R', ia) == re.sub(REG, 'R', ib) and ya == yb:
        return 'register'
    return 'operand'


def key(s):   # alignment key: opcode + operand shape, registers and stack slots folded
    ins, _, sym = base(s)
    return re.sub(REG, 'R', ins) + '|' + sym


def classify(src, func):
    """{'ins', 'bytes', 'posdiff', 'same', 'stack', 'register', 'operand', 'opcode', 'extra', 'missing'} or None"""
    obj = tempfile.mktemp(suffix='.obj')
    try:
        if not cc.compile_c(src, obj): return None
        c = cdiff.compare(src, obj, func)
    finally:
        if os.path.exists(obj): os.remove(obj)
    C, O = c['ctexts'], c['otexts']
    sm = difflib.SequenceMatcher(None, [key(x) for x in C], [key(x) for x in O], autojunk=False)
    k = dict(same=0, stack=0, register=0, operand=0, opcode=0, extra=0, missing=0)
    for tag, i1, i2, j1, j2 in sm.get_opcodes():
        n = min(i2 - i1, j2 - j1)
        for a, b in zip(C[i1:i1 + n], O[j1:j1 + n]):
            k[kind(a, b)] += 1
        k['extra'] += (i2 - i1) - n
        k['missing'] += (j2 - j1) - n
    k.update(ins=len(O), bytes=c['n'] - (c['olen'] or 0), posdiff=sum(1 for r in c['rows'] if r[0] != '  '))
    return k


def main():
    if len(sys.argv) < 2: raise SystemExit(__doc__)
    os.chdir(ROOT)
    for spec in sys.argv[1:]:
        src, func = spec.rsplit(':', 1)
        k = classify(src, func)
        if k is None: print('%-22s compile failed' % func); continue
        print('%-22s ins=%4d bytes=%+4d posdiff=%4d | same=%4d stack=%3d reg=%3d operand=%3d opcode=%3d extra=%3d '
              'missing=%3d' % (func, k['ins'], k['bytes'], k['posdiff'], k['same'], k['stack'], k['register'],
                               k['operand'], k['opcode'], k['extra'], k['missing']), flush=True)


if __name__ == '__main__':
    main()
