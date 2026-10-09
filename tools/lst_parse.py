#!/usr/bin/env python3
"""Index an IDA .lst (HOCKEY.EXE.lst) into tools/lst_index.pkl.
Extracts: symbol definitions (name->addr), functions (proc/endp + collapsed library
functions with sizes), per-address items (instruction/data) with mnemonic and operand
text, references (src_addr -> symbol) and owner function of each code reference,
string literals in dseg02 (reconstructed from db lines), and IDA comments xrefs.
Usage: lst_parse.py HOCKEY.EXE.lst tools/lst_index.pkl"""
import re, sys, pickle
from collections import defaultdict

LINE = re.compile(r'^(cseg01|dseg02):([0-9A-F]{8})(?: (.*))?$')
DEF  = re.compile(r'^([A-Za-z_?@$.][\w?@$.]*)(:|\s+(proc|endp|db|dw|dd|dq|dt|=|struc|ends|segment))(\s|$)')
COLL = re.compile(r'^; \[([0-9A-F]+) BYTES: COLLAPSED FUNCTION (.*)\. PRESS')
IDENT = re.compile(r'[A-Za-z_?@$.][\w?@$.]*')
DIRECTIVES = {'db','dw','dd','dq','dt','align','assume','public','extrn','org','end','segment','ends','.686p','.mmx','.model'}

def split_comment(s):
    # strip ';' comment outside quotes
    q = None
    for i, ch in enumerate(s):
        if q:
            if ch == q: q = None
        elif ch in "'\"": q = ch
        elif ch == ';': return s[:i], s[i+1:]
    return s, ''

def parse(path):
    syms = {}            # name -> (seg, addr)
    funcs = []           # dict(name,start,end,kind)
    items = {}           # addr -> (seg, kind, mnem, operands)  first item per address
    refs = []            # (src_addr, name, mnem)
    strings = {}         # addr -> text (dseg02 db with quoted strings)
    cur_proc = None
    pending_str = None
    for ln in open(path, encoding='latin1'):
        ln = ln.rstrip('\n')
        m = LINE.match(ln)
        if not m: continue
        seg, addr, rest = m.group(1), int(m.group(2), 16), m.group(3) or ''
        body, cmt = split_comment(rest)
        if not body.strip():
            c = COLL.match(rest.strip())
            if c:
                funcs.append(dict(name=c.group(2), start=addr, end=addr+int(c.group(1), 16), kind='collapsed'))
            continue
        name = None
        if not body.startswith(' '):  # label / definition in column 0
            d = DEF.match(body)
            if d:
                name = d.group(1)
                syms.setdefault(name, (seg, addr))
                kw = d.group(3)
                if kw == 'proc':
                    cur_proc = dict(name=name, start=addr, end=None, kind='proc'); funcs.append(cur_proc); continue
                if kw == 'endp':
                    if cur_proc and cur_proc['name'] == name: cur_proc['end_line_addr'] = addr
                    cur_proc = None; continue
                if kw in ('segment', 'ends', 'struc'): continue
                if kw == '=': continue  # stack var
                if d.group(2) == ':':
                    body = body[d.end(2):]
                else:
                    body = body[len(name):]
        toks = body.split(None, 1)
        if not toks: continue
        mnem = toks[0]; ops = toks[1] if len(toks) > 1 else ''
        if mnem in ('assume', 'public', 'extrn') or mnem.startswith('.') or mnem.startswith(';org'): continue
        kind = 'data' if mnem in ('db','dw','dd','dq','dt') else ('align' if mnem == 'align' else 'insn')
        if addr not in items or (items[addr][1] == 'align' and kind != 'align'):
            items[addr] = (seg, kind, mnem, ops, name)
        elif name:
            items[addr] = (seg, items[addr][1], items[addr][2], items[addr][3], name)
        # references
        if kind != 'align':
            for t in IDENT.findall(re.sub(r"'[^']*'", '', ops)):
                if t in ('offset','dword','word','byte','ptr','near','far','short','large','dup','qword','fword','tbyte','st'): continue
                refs.append((addr, t, mnem, seg))
        if seg == 'dseg02' and kind == 'data' and mnem == 'db':
            if name: pending_str = addr
            if "'" in ops and pending_str is not None:
                strings.setdefault(pending_str, []).append(ops)
    # finalize proc ends: end = next item address after endp line address
    addrs = sorted(items)
    import bisect
    for f in funcs:
        if f['kind'] == 'proc':
            e = f.get('end_line_addr', f['start'])
            # endp line address == address of the last instruction; end = next item addr > e
            i = bisect.bisect_right(addrs, e)
            f['end'] = addrs[i] if i < len(addrs) else e+1
    funcs.sort(key=lambda f: f['start'])
    # decode string ops
    def dec(opslist):
        out = []
        for ops in opslist:
            for part in re.findall(r"'[^']*'|[0-9A-Fa-f]+h?", ops):
                if part.startswith("'"): out.append(part[1:-1])
                else:
                    try:
                        v = int(part[:-1], 16) if part.endswith('h') else int(part)
                        if v == 0: break
                        out.append(chr(v) if 32 <= v < 127 else '\\x%02x' % v)
                    except ValueError: pass
        return ''.join(out)
    strings = {a: dec(v) for a, v in strings.items()}
    return dict(syms=syms, funcs=funcs, items=items, refs=refs, strings=strings)

if __name__ == '__main__':
    idx = parse(sys.argv[1])
    pickle.dump(idx, open(sys.argv[2], 'wb'))
    print('syms', len(idx['syms']), 'funcs', len(idx['funcs']), 'items', len(idx['items']), 'refs', len(idx['refs']), 'strings', len(idx['strings']))
