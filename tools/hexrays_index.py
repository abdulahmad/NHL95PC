#!/usr/bin/env python3
"""hexrays_index.py - pull an IDA Hex-Rays draft of one function, renamed to this repo's labels.

  python3 tools/hexrays_index.py [--c HOCKEY.EXE.c] get ADDR|NAME [--raw]   print the draft of one function
  python3 tools/hexrays_index.py [--c HOCKEY.EXE.c] list [LO HI]            functions (address, our name, lines)

The input is a PRIVATE file you make yourself and must never commit: in IDA (with HOCKEY.EXE loaded and the
segments as in this repo), File > Produce file > Create C file... (Ctrl+F5) writes the whole decompilation. Pass
it with --c or the HEXRAYS_C environment variable. Functions are split at IDA's `//----- (ADDR) ---` headers
and keyed by address; IDA's address names (sub_X, dword_X, byte_X, word_X, unk_X, off_X, asc_X, stru_X, loc_X,
j_sub_X) are replaced by our label at that address (from build/obj, so run `make` first). It is only a drafting
aid: the code segment is read-only to IDA, so jump/lookup tables in cseg01 appear as constants, and the types and
control flow need the usual work to match wcc386 output."""
import os, re, sys, argparse
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)

HDR = re.compile(r'^//----- \(([0-9A-F]{8})\) -+$')
IDN = re.compile(r'\b(?:j_)?(sub|dword|byte|word|unk|off|asc|stru|loc|qword|flt|dbl)_([0-9A-F]{4,8})\b')

def split(path):
    """{addr: [lines]} of every function in the Hex-Rays file"""
    out = {}; cur = None
    for l in open(path, encoding='latin1'):
        m = HDR.match(l.rstrip())
        if m: cur = int(m.group(1), 16); out[cur] = []; continue
        if cur is not None: out[cur].append(l.rstrip('\n'))
    for a, L in out.items():   # drop the blank tail / file trailer after the last function body
        while L and not L[-1].strip(): L.pop()
    return out

_rev = None
def names():
    global _rev
    if _rev is None:
        from cdiff import load_labels
        _rev = load_labels()[1]
    return _rev

def rename(text):
    rev = names()
    def f(m):
        a = int(m.group(2), 16)
        return rev.get(a, m.group(0))
    return IDN.sub(f, text)

def main():
    ap = argparse.ArgumentParser(); ap.add_argument('--c', default=os.environ.get('HEXRAYS_C'))
    ap.add_argument('cmd'); ap.add_argument('args', nargs='*'); ap.add_argument('--raw', action='store_true')
    a = ap.parse_args()
    if not a.c or not os.path.exists(a.c): sys.exit('no Hex-Rays file: pass --c PATH or set HEXRAYS_C (private, see the docstring)')
    fn = split(a.c)
    if a.cmd == 'list':
        lo, hi = (int(x, 16) for x in a.args) if a.args else (0, 1 << 32)
        rev = names()
        for ad in sorted(fn):
            if lo <= ad < hi: print('%05X %-32s %d' % (ad, rev.get(ad, '?'), len(fn[ad])))
    elif a.cmd == 'get':
        key = a.args[0]
        try: ad = int(key, 16) if re.match(r'^[0-9A-Fa-f]{5,8}$', key) else None
        except ValueError: ad = None
        if ad is None:
            ad = next((x for x, n in names().items() if n == key), None)
            if ad is None: sys.exit('unknown name %s' % key)
        if ad not in fn:
            prev = max((x for x in fn if x < ad), default=None)
            sys.exit('%05X: not a Hex-Rays function start (IDA has no function there; the previous one starts at %05X %s)'
                     % (ad, prev or 0, names().get(prev, '?')))
        t = '\n'.join(fn[ad])
        print(t if a.raw else rename(t))
    else: sys.exit(__doc__)

if __name__ == '__main__':
    main()
