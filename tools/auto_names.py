#!/usr/bin/env python3
"""auto_names.py - list the IDA-style auto names (sub_, loc_, dword_ ...) a segment file still has.

  python3 tools/auto_names.py MODULE|ADDR|FILE [--all]     one segment (e.g. engine_skating, 5E16D)
  python3 tools/auto_names.py --summary                     counts for every segment in src/segments.txt

For one segment it prints the auto names DEFINED in the file (these must all be named before the queue row is
marked done), the auto names it USES from data segments (dseg02; name them in the same session), and the auto
names it uses from other code segments (name them when the routine is identified, else when their segment comes up).
Also counts structure-style operands ([byte reg+NNh]) that do not use a structs.inc name yet."""
import os, re, sys, argparse
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
from link_src import read_layout
from update_symbols import decl_lists
AUTO = re.compile(r'\b((?:sub|loc|locret|nullsub|j_sub|unk|off|asc|byte|word|dword|qword|tbyte|jpt|stru|algn)_[0-9A-F]{5,8})\b')
DEF = re.compile(r'^([A-Za-z_?][\w$#@~?.]*)(?::|\s+equ\b)')
STRUCT_OP = re.compile(r'\[(?:byte|dword) e(?:ax|bx|cx|dx|si|di|bp)\+0[0-9A-F]+h\]')

def analyse(sg, segs):
    t = open(os.path.join(ROOT, 'src', sg['src'])).read()
    code = [l.split(';')[0] for l in t.split('\n')]
    defined = [m.group(1) for l in code for m in [DEF.match(l)] if m and AUTO.fullmatch(m.group(1))]
    g, e = decl_lists(t)
    starts = [(s['start'], s['end'], s['obj']) for s in segs]
    def obj_of(n):
        a = int(n.split('_')[-1], 16)
        return next((o for s0, s1, o in starts if s0 <= a < s1), 0)
    ext = sorted({n for n in e if AUTO.fullmatch(n)})
    data = [n for n in ext if obj_of(n) == 2]; codex = [n for n in ext if obj_of(n) == 1]
    sops = sum(len(STRUCT_OP.findall(l)) for l in code)
    return defined, data, codex, sops

def main():
    ap = argparse.ArgumentParser(); ap.add_argument('seg', nargs='?'); ap.add_argument('--summary', action='store_true')
    ap.add_argument('--all', action='store_true', help='print every name, not the first 40 of each list')
    a = ap.parse_args()
    segs = read_layout()
    if a.summary or not a.seg:
        print('%-46s %8s %8s %8s %8s' % ('file', 'defined', 'data', 'code', 'reg+NNh'))
        for sg in segs:
            if sg['obj'] != 1: continue
            d, da, c, so = analyse(sg, segs)
            print('%-46s %8d %8d %8d %8d' % (sg['src'], len(d), len(da), len(c), so))
        return
    k = a.seg
    sg = next((s for s in segs if k in (s['module'], '%05X' % s['start'], s['src'], os.path.basename(s['src'])) or s['src'].endswith(k)), None)
    if not sg: sys.exit('no segment %s in src/segments.txt' % k)
    d, da, c, so = analyse(sg, segs)
    lim = None if a.all else 40
    print('%s (%s %05X-%05X)' % (sg['src'], sg['module'], sg['start'], sg['end'] - 1))
    for title, l in (('auto names defined here', d), ('auto data names used (dseg02)', da), ('auto code names used from other segments', c)):
        print('%s: %d' % (title, len(l)))
        if l: print('   ' + ' '.join(l[:lim]) + (' ...' if lim and len(l) > lim else ''))
    print('[reg+NNh] operands without a field name: %d' % so)

if __name__ == '__main__':
    main()
