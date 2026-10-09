#!/usr/bin/env python3
"""struct_operands.py - write player-structure displacements as field names ([byte ecx+06Ah] -> [byte ecx+SCnum]).

  python3 tools/struct_operands.py MODULE [MODULE ...] [--apply] [--min-fields 3] [--verbose]
  python3 tools/struct_operands.py --group engine [--apply]

Fields, PC offsets and access sizes come from src/inc/structs.inc ('Name equ NNh ; size b|w|d; ...'). A 'size d'
field also matches a word access at +2 (the integer word of a 16.16 value) as Name+2.
Only the displacement text changes, never the size hint, so the bytes cannot change; --apply still runs make and
restores the files unless it prints MATCH.

Which operands: an access [byte REG+NNh] (REG not esp) inside one function is a candidate when its offset and
operand size fit a field: a byte field read as byte, a word field as word, a dword field as dword, or the Watcom
-5r short load of a word field (mov r32, [REG+field-2] followed by sar/shr r32, 10h). A (function, register) pair
is taken as a player pointer only when it hits at least --min-fields different fields and at least half of its
[byte REG+NNh] accesses below 80h fit a field. That is a heuristic: a structure with the same layout as the
player structure would be named too, and a register reused for another structure in the same function can
still pass. Check the result in review; names from it are field names, not proof the routine is a player
routine.

Team structure: fields with a 'tsize' tag (b/w/d, 'w array' for the per-player word arrays) are applied on a
register only while it holds a team pointer: after mov REG, hmtmstruct / awtmstruct or mov REG, [x+tmptr] /
[x+optmptr] (also the raw 06Ch / 070h), until REG is written again, a call (eax), or any label (merging control
flow). Those accesses are left out of the player pass, so a team access no longer passes as a player field.
--no-team turns this off."""
import os, re, sys, argparse, subprocess
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
from link_src import read_layout
SRC = os.path.join(ROOT, 'src')
ACC = re.compile(r'(?:(byte|word|dword) )?\[byte (e[a-z]{2})\+0([0-9A-F]+)h\]')
INSN = re.compile(r'^([a-z]+) (.*?)\t; ([0-9A-F]{5})')
LABEL = re.compile(r'^([A-Za-z_?][\w$#@~?.]*):')

def fields():
    """{offset: [(name, size)]} from structs.inc ('Name equ NNh ; ... ;size w' or the size table below)"""
    out = {}
    for ln in open(os.path.join(SRC, 'inc/structs.inc')):
        m = re.match(r'^(\w+)\s+equ\s+([0-9A-Fa-f]+)h\s*;.*?\bsize ([bwd])\b', ln)
        if m:
            o = int(m.group(2), 16); out.setdefault(o, []).append((m.group(1), m.group(3)))
            if m.group(3) == 'd': out.setdefault(o + 2, []).append((m.group(1) + '+2', 'w'))   # integer word of a 16.16 value
    return out

def team_fields():
    """[(name, offset, size, is_array)] from the 'tsize' tags in structs.inc"""
    out = []
    for ln in open(os.path.join(SRC, 'inc/structs.inc')):
        m = re.match(r'^(\w+)\s+equ\s+([0-9A-Fa-f]+)h\s*;.*?\btsize ([bwd])( array)?\b', ln)
        if m: out.append((m.group(1), int(m.group(2), 16), m.group(3), bool(m.group(4))))
    return out

TACC = re.compile(r'(?:(byte|word|dword) )?\[(?:byte|dword) (e[a-z]{2})((?:\+e[a-z]{2}(?:\*[1248])?)?)\+0?([0-9A-F]+)h\]')
ANYLABEL = re.compile(r'^[.\w$?@#~]+:')
TEAMSRC = re.compile(r'^(?:dword )?(?:hmtmstruct|awtmstruct)$|^dword \[(?:byte |dword )?e[a-z]{2}\+(?:tmptr|optmptr|06Ch|070h)\]$')
SUB = {'al': 'eax', 'ah': 'eax', 'ax': 'eax', 'bl': 'ebx', 'bh': 'ebx', 'bx': 'ebx', 'cl': 'ecx', 'ch': 'ecx', 'cx': 'ecx',
       'dl': 'edx', 'dh': 'edx', 'dx': 'edx', 'si': 'esi', 'di': 'edi', 'bp': 'ebp'}
WRITES = {'mov', 'movsx', 'movzx', 'lea', 'add', 'sub', 'xor', 'and', 'or', 'inc', 'dec', 'shl', 'sal', 'sar', 'shr', 'imul',
          'pop', 'neg', 'not', 'xchg', 'adc', 'sbb', 'rol', 'ror', 'rcl', 'rcr'}

NAMED = re.compile(r'\[(?:byte |dword )?(e[a-z]{2})(?:\+e[a-z]{2}(?:\*[1248])?)?\+([A-Za-z_]\w*)(?:[-+]\w+)?\]')
SUSPECT = []; TNAMES = set()

def team_plan(lines, s, e, TF):
    """team-struct accesses in lines[s:e]: ({line: [(a0, a1, old, new)]}, set of (line, a0) taken)"""
    edits = {}; taken = set(); tp = set()
    for i in range(s, e):
        ln = lines[i]
        if ANYLABEL.match(ln): tp.clear(); continue
        mi = INSN.match(ln)
        if not mi:
            m0 = re.match(r'^([a-z]+)\b', ln); mn = m0.group(1) if m0 else ''
            if mn in ('cwde', 'cdq', 'cwd'): tp.discard('eax' if mn == 'cwde' else 'edx')
            continue
        mn, ops_s = mi.group(1), mi.group(2)
        code = ln.split('\t;')[0]
        ops = [o.strip() for o in ops_s.split(',')]
        for m in TACC.finditer(code):
            sz, reg, idx, off = m.group(1), m.group(2), m.group(3), int(m.group(4), 16)
            if reg not in tp: continue
            if sz is None:
                other = [o for o in ops if not o.startswith(('[', 'byte', 'word', 'dword'))]
                if mn == 'lea' or not other or not re.fullmatch(r'e?[a-d][xlh]|e?[sd]i|e?bp', other[0]): continue
                sz_ = reg_size(other[0])
            else: sz_ = sz[0]
            cand = None
            for name, fo, fs, arr in TF:
                span = 0x38 if arr else 0
                if fo == off and (fs == sz_ or (fs == 'w' and arr and sz_ == 'w')): cand = name
                elif arr and fo < off < fo + span and sz_ == 'w' and (off - fo) % 2 == 0: cand = '%s+%Xh' % (name, off - fo) if off - fo > 9 else '%s+%d' % (name, off - fo)
                if cand: break
            if cand is None and sz_ == 'd' and mn in ('mov', 'movsx'):
                dst = ops[0]
                nxt = next((lines[k] for k in range(i + 1, min(i + 4, e)) if INSN.match(lines[k])), '')
                if re.match(r'^(sar|shr) %s, 10h\t' % re.escape(dst), nxt):
                    for name, fo, fs, arr in TF:
                        if fs == 'w' and (fo == off + 2 or (arr and fo <= off + 2 < fo + 0x38)):
                            k = off + 2 - fo; cand = name + ('+%Xh' % k if k > 9 else '+%d' % k if k else '') + '-2'; break
            taken.add((i, m.start()))
            if cand:
                txt = m.group(0); new = txt[:txt.rindex('+')] + '+' + cand + ']'
                edits.setdefault(i, []).append((m.start(), m.end(), txt, new))
        for m in NAMED.finditer(code):
            if m.group(1) in tp and m.group(2) not in TNAMES and m.group(2) not in ('tmptr', 'optmptr'):
                SUSPECT.append('%s: %s' % (mi.group(3), code.strip()))
        # register state after the instruction
        dst = ops[0] if ops and mn in WRITES else None
        if mn == 'call': tp.discard('eax')
        if mn == 'xchg' and len(ops) == 2:
            for o in ops: tp.discard(SUB.get(o, o))
        if dst and re.fullmatch(r'e?[a-d][xlh]|e?[sd]i|e?bp', dst):
            r = SUB.get(dst, dst)
            if mn == 'mov' and r == dst and len(ops) == 2 and TEAMSRC.match(ops[1]): tp.add(r)
            else: tp.discard(r)
    return edits, taken

def reg_size(reg):
    return {'e': 'd'}.get(reg[0], 'w') if len(reg) == 3 else ('b' if reg[-1] in 'lh' else 'w')

def functions(lines, fentry):
    """split a code file into functions: [(name, first line, last line)]"""
    starts = [i for i, l in enumerate(lines) if (m := LABEL.match(l)) and m.group(1) in fentry]
    return [(LABEL.match(lines[s]).group(1), s, (starts[k + 1] if k + 1 < len(starts) else len(lines))) for k, s in enumerate(starts)]

def function_entries(text):
    """function entry labels: sub_ names plus every label name_map_94.csv lists as a function"""
    import csv
    nm = {r['pc_address'].lstrip('0') for r in csv.DictReader(open(os.path.join(ROOT, 'name_map_94.csv'))) if r['method'] != 'data'}
    lines = text.split('\n'); out = set()
    for i, l in enumerate(lines):
        m = LABEL.match(l)
        if not m: continue
        n = m.group(1)
        if n.startswith('sub_'): out.add(n); continue
        for j in range(i + 1, min(i + 6, len(lines))):
            mm = INSN.match(lines[j])
            if mm:
                if mm.group(3).lstrip('0') in nm: out.add(n)
                break
            if LABEL.match(lines[j]) and not lines[j].split(':')[0].startswith('.'): continue
    return out

def plan(path, F, min_fields, verbose=False, TF=None):
    text = open(path).read(); lines = text.split('\n')
    fe = function_entries(text)
    edits = {}; report = []
    for fname, s, e in functions(lines, fe):
        taken = set()
        if TF:
            te, taken = team_plan(lines, s, e, TF)
            nt = sum(len(v) for v in te.values())
            if nt or (verbose and taken): report.append('%-28s team %3d accesses, %3d named' % (fname, len(taken), nt))
            for i, es in te.items(): edits.setdefault(i, []).extend(es)
        per = {}
        for i in range(s, e):
            code = lines[i].split('\t;')[0]
            for m in ACC.finditer(code):
                if (i, m.start()) in taken or (i, m.start() - 5) in taken or (i, m.start() - 6) in taken: continue
                sz, reg, off = m.group(1), m.group(2), int(m.group(3), 16)
                if reg == 'esp' or off >= 0x80: continue
                mi = INSN.match(lines[i]); mn = mi.group(1) if mi else ''
                if sz is None:   # size from the register operand (lea has none)
                    if mn == 'lea': continue
                    ops = [o.strip() for o in code.split(' ', 1)[1].split(',')] if ' ' in code else []
                    other = [o for o in ops if not o.startswith(('[', 'byte', 'word', 'dword'))]
                    if not other or not re.fullmatch(r'e?[a-d][xlh]|e?[sd]i|e?bp', other[0]): continue
                    s_ = reg_size(other[0])
                else: s_ = sz[0]
                cand = None
                for name, fs in F.get(off, []):
                    if fs == s_: cand = name
                if cand is None and s_ == 'd' and (off + 2) in F and mn in ('mov', 'movsx'):
                    # -5r short load: mov r32, [REG+field-2] / sar r32, 10h
                    dst = code.split(' ', 1)[1].split(',')[0].strip()
                    nxt = next((lines[k] for k in range(i + 1, min(i + 4, e)) if INSN.match(lines[k])), '')
                    if re.match(r'^(sar|shr) %s, 10h\t' % re.escape(dst), nxt):
                        ws = [n for n, fs in F[off + 2] if fs == 'w']
                        if ws: cand = ws[0] + '-2'
                per.setdefault(reg, []).append((i, m.start(), m.end(), off, cand, m.group(0)))
        for reg, acc in per.items():
            hit = {re.split(r'[-+]', c)[0] for *_, c, _ in acc if c}
            nhit = sum(1 for *_, c, _ in acc if c)
            ok = len(hit) >= min_fields and nhit * 2 >= len(acc)
            if verbose or ok: report.append('%-28s %-4s %3d accesses, %3d fit, fields %s%s' % (fname, reg, len(acc), nhit, ','.join(sorted(hit)), '' if ok else '  (not taken)'))
            if not ok: continue
            for i, a0, a1, off, cand, txt in acc:
                if cand: edits.setdefault(i, []).append((a0, a1, txt, txt[:txt.rindex('+')] + '+' + cand + ']'))
    return text, lines, edits, report

def apply_edits(lines, edits):
    n = 0
    for i, es in edits.items():
        code, sep, com = lines[i].partition('\t;')
        for a0, a1, old, new in sorted(es, reverse=True):
            assert code[a0:a1] == old, (lines[i], old)
            code = code[:a0] + new + code[a1:]; n += 1
        lines[i] = code + sep + com
    return n

def main():
    ap = argparse.ArgumentParser(); ap.add_argument('mods', nargs='*'); ap.add_argument('--group')
    ap.add_argument('--apply', action='store_true'); ap.add_argument('--min-fields', type=int, default=3); ap.add_argument('--verbose', action='store_true')
    ap.add_argument('--no-team', action='store_true')
    a = ap.parse_args()
    segs = [s for s in read_layout() if s['obj'] == 1]
    if a.group:
        import json
        grp = {x['module']: x['group'] for x in json.load(open(os.path.join(ROOT, 'segmap95pc.json')))['cseg01']}
        segs = [s for s in segs if grp.get(s['module']) == a.group]
    else:
        segs = [s for s in segs if s['module'] in a.mods or '%05X' % s['start'] in a.mods]
    if not segs: sys.exit('no segments')
    F = fields(); TNAMES.update(n for n, *_ in team_fields())
    if not F: sys.exit('src/inc/structs.inc has no fields with a size tag')
    backup = {}; total = 0
    for sg in segs:
        p = os.path.join(SRC, sg['src'])
        text, lines, edits, report = plan(p, F, a.min_fields, a.verbose, None if a.no_team else team_fields())
        for r in report: print('  ' + r)
        n = apply_edits(lines, edits)
        print('%s: %d operands%s' % (sg['src'], n, '' if a.apply else ' (dry run)'))
        total += n
        if a.apply and n: backup[p] = text; open(p, 'w').write('\n'.join(lines))
    print('total %d operands' % total)
    if SUSPECT:
        print('player field names on a register that holds a team pointer (check by hand):')
        for x in SUSPECT: print('  ' + x)
    if a.apply and backup:
        r = subprocess.run(['make', '-s'], cwd=ROOT, capture_output=True, text=True)
        if r.returncode or not os.path.exists(os.path.join(ROOT, 'build/HOCKEY.EXE')):
            for p, t in backup.items(): open(p, 'w').write(t)
            sys.exit('build failed, files restored:\n' + r.stdout[-1500:] + r.stderr[-1500:])
        print('MATCH')

if __name__ == '__main__':
    main()
