#!/usr/bin/env python3
"""cmpobj.py OBJ name=ADDR [name=ADDR...] : compare each public function's bytes in OBJ against HOCKEY.EXE at ADDR
(fixup bytes masked). Prints per function: size, #diff bytes, verdict."""
import sys, os
sys.path.insert(0, os.path.dirname(__file__)); import omf
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
d = open(os.path.join(ROOT, 'HOCKEY.EXE'), 'rb').read()
def exe(a, n): o = 0x5F254 + a - 0x10000; return d[o:o + n]
def funcs(obj):
    m = omf.parse_lib(obj)[0]
    t = [s for s in m['segs'] if s['name'] == '_TEXT'][0]
    pubs = sorted((off, nm) for nm, seg, off in m['pubs'] if seg == '_TEXT')
    out = {}
    for i, (off, nm) in enumerate(pubs):
        end = pubs[i + 1][0] if i + 1 < len(pubs) else len(t['data'])
        out[nm] = (t['data'][off:end], t['mask'][off:end])
    return out
def compare(obj, targets):
    F = funcs(obj); res = {}
    for nm, addr in targets.items():
        data, mask = F[nm]; e = exe(addr, len(data))
        diff = [i for i in range(len(data)) if not mask[i] and data[i] != e[i]]
        res[nm] = (len(data), len(diff), diff[:8])
    return res
if __name__ == '__main__':
    t = dict((a.split('=')[0], int(a.split('=')[1], 16)) for a in sys.argv[2:])
    for nm, (n, nd, dd) in compare(sys.argv[1], t).items():
        print('%-14s %4dB diff=%3d %s' % (nm, n, nd, 'EXACT' if nd == 0 else dd))
