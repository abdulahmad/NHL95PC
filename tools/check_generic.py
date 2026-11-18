#!/usr/bin/env python3
"""check_generic.py - fails on generic names, stubs and address-named files in the PC source (src/, plus port/ when it exists).

  python3 tools/check_generic.py [--summary] [--list-allow]        (same file in NHL94PC and NHL95PC)

Rules:
  [ida]     IDA auto names: sub_ loc_ off_ byte_ word_ dword_ unk_ asc_ jpt_ stru_ nullsub_ flt_ qword_ algn_ (any case)
  [stub]    a name or file called stub/Stub (empty routines get a name for what they are: Null<Where>Hook, <Routine>Tail)
  [addr]    a name that ends in an address (_1D024, _8C20D): name it after what it is. Value names (str_<text>, fp_<number>)
            are allowed; so are the names listed in ALLOW below
  [place]   placeholder names: data/var/unk/unknown/label/func/proc/misc/routine + digits only (data1, func2)
  [file]    a source file or folder named stub_*, sub_*, loc_*, an address, or a number
Comments are scanned too (a comment that quotes an auto name is a stale name). Exit status 1 when anything is reported.
Segment build stubs (src/stubinc/*_stub.asm in 94 PC, written by tools/make_stubs.py) are generated linker helpers and skipped.
Not checked: numeric local labels (.1 .2 inside a routine) and NASM section names (s_<address>, which tools/build reads)."""
import os, re, sys, collections
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if os.path.basename(os.path.dirname(os.path.abspath(__file__))) != 'tools': ROOT = os.path.dirname(ROOT)
EXT = ('.asm', '.inc', '.c', '.h', '.s')
ALLOW = set()   # names that look like addresses but are real values
IDA = re.compile(r'\b(sub|loc|off|byte|word|dword|qword|unk|asc|jpt|stru|nullsub|flt|algn)_[0-9A-Fa-f]{2,}\b', re.I)
STUB = re.compile(r'\b\w*stub\w*\b', re.I)
ADDR = re.compile(r'\b([A-Za-z]\w*?)_([0-9A-F]{4,6})\b')
PLACE = re.compile(r'\b(data|var|unk|unknown|label|func|proc|misc|routine|thing|stuff)\d+\b')
VALUE_PREFIX = ('str_', 'fp_', 's_')
FILE_BAD = re.compile(r'^(?i:stub|sub|loc|unk|seg|part)[_-]?[0-9A-Fa-f]*$|^(?=\w*\d)[0-9A-F]{4,6}$|_[0-9A-F]{5,6}$|^\d+$')

def files():
    for top in ('src', 'port'):
        for d, ds, fs in os.walk(os.path.join(ROOT, top)):
            ds[:] = [x for x in ds if x != 'stubinc']
            for f in fs:
                yield d, f

def main():
    summary = '--summary' in sys.argv
    bad = collections.defaultdict(list)
    for d, f in files():
        p = os.path.join(d, f); rel = os.path.relpath(p, ROOT)
        stem = os.path.splitext(f)[0]
        if FILE_BAD.search(stem) or any(FILE_BAD.search(x) for x in rel.split(os.sep)[1:-1]):
            bad['file'].append((rel, 0, stem))
        if not f.endswith(EXT): continue
        for i, ln in enumerate(open(p, errors='replace'), 1):
            code = ln.split(';')[0] if f.endswith(('.asm', '.inc')) and False else ln
            for m in IDA.finditer(code): bad['ida'].append((rel, i, m.group(0)))
            for m in STUB.finditer(code):
                if rel.startswith('port') or m.group(0).lower() in ('stub', 'stubs', 'stubbed', 'stubinc', 'make_stubs'): continue
                bad['stub'].append((rel, i, m.group(0)))
            for m in ADDR.finditer(code):
                if m.group(0) in ALLOW or m.group(1).startswith(VALUE_PREFIX) or IDA.match(m.group(0)): continue
                if m.group(1) + '_' in VALUE_PREFIX: continue
                bad['addr'].append((rel, i, m.group(0)))
            for m in PLACE.finditer(code):
                if re.search(r'\d', m.group(0)) and m.group(0) not in ALLOW: bad['place'].append((rel, i, m.group(0)))
    # info only: numeric local labels (.1 .2) inside routines; not a failure (12k+ of them, local to one routine)
    nloc = 0
    for d, f in files():
        if f.endswith(('.asm', '.inc')):
            nloc += sum(1 for ln in open(os.path.join(d, f), errors='replace') if re.match(r'^\.\d+:', ln))
    print('info: %d numeric local labels (.N) in routines, not counted as problems' % nloc)
    n = 0
    for rule, items in sorted(bad.items()):
        n += len(items)
        if summary:
            print('%-6s %5d  %s' % (rule, len(items), ', '.join(sorted(set(x[2] for x in items))[:8])))
        else:
            for rel, i, w in items: print('%s:%d: [%s] %s' % (rel, i, rule, w))
    print('check_generic: %s' % ('%d problem(s)' % n if n else 'OK'))
    sys.exit(1 if n else 0)
main()
