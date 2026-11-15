#!/usr/bin/env python3
"""format_asm.py - lay out the .asm sources the way the style rules in CONTRIBUTING.md ask (source cleanup, phase 1).

  python3 tools/build/format_asm.py [--check] [FILE...]      (default: every src/{engine,front,pc,lib,data} file)

What it does to each file (only text changes; the bytes NASM makes stay the same):
  * takes the address off every instruction (`mov ebp, eax\\t; 51128` -> `mov ebp, eax`); tools/build/asmaddr.py
    gives the address of any line back, and the routine header keeps the address of the routine
  * an instruction kept as bytes keeps its text as `; insn: sub eax,3E8h`
  * indents instructions and data by 8 spaces; labels, comments, % lines and the file header stay at column 0
  * puts the comment of a commented instruction at column 48
  * is idempotent: a formatted file comes out unchanged

--check: change nothing, list the files that would change, exit 1 if any.
After a run, `python3 tools/build/format_asm.py --verify OLDREV` checks that asmaddr.legacy_lines() of every file
gives back the file as it was at git revision OLDREV, line for line (comment lines aside: headers are added).
"""
import os, re, subprocess, sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import asmaddr

IND = ' ' * 8
COL = 48
OLD_CODE = re.compile(r'^(?P<code>[^;]*?\S)\t; [0-9A-F]{5}(?:\t; (?P<com>.*)| (?P<txt>\S.*))?$')
COMMENTED = re.compile(r'^(?P<code>[^;]*?\S)\s*;\s?(?P<com>.*)$')


def col0(l):
    s = l.strip()
    return (not s or s.startswith((';', '%', '[')) or asmaddr.LABEL.match(s) is not None
            or re.match(r'^(bits|section|segment|extern|global|common|cpu|org|default)\b', s) is not None
            or re.match(r'^[A-Za-z_][\w.$?@]*\s+equ\b', s, re.I) is not None)


def put(code, com):
    t = IND + code
    if com is None: return t
    return t.ljust(COL - 1) + ' ; ' + com if len(t) < COL - 1 else t + ' ; ' + com


def fmt_line(l):
    if col0(l): return l
    m = OLD_CODE.match(l)
    if m:
        code = m.group('code').strip()
        if m.group('txt') is not None:     # instruction kept as bytes, with its text
            return put(code, 'insn: ' + m.group('txt').strip())
        return put(code, m.group('com').strip() if m.group('com') is not None else None)
    m = COMMENTED.match(l)
    if m and asmaddr.is_code(l) and not asmaddr.INSN_MARK.match(l.strip()):
        return put(m.group('code').strip(), m.group('com').strip() or None)
    if asmaddr.INSN_MARK.match(l.strip()):
        x = asmaddr.INSN_MARK.match(l.strip())
        return put(x.group(1).strip(), 'insn: ' + x.group(2).strip())
    return IND + l.lstrip()


def fmt(text):
    L = text.split('\n')
    return '\n'.join(fmt_line(l) if l.strip() else '' for l in L)


# ---- routine headers (--headers) ----
RULE = ';' + '-' * 77
NAMEREF = os.path.join(asmaddr.ROOT, 'docs', 'name_map.csv')
GAME_DIRS = ('engine', 'front', 'pc')
NOFALL = ('ret', 'retn', 'retf', 'jmp', 'iret', 'iretd', 'hlt')


def current_names():
    """{address: label} from src/inc/symbols.inc, to bring the old sub_XXXXX names in name_map evidence up to date"""
    out = {}
    for ln in open(os.path.join(asmaddr.SRC, 'inc', 'symbols.inc'), encoding='latin1'):
        p = ln[1:].split()
        if ln.startswith(';') and len(p) >= 2 and re.fullmatch(r'[0-9A-F]{5}', p[0]): out[int(p[0], 16)] = p[1]
    return out


def name_sources():
    """{address: (tag, description)} from docs/name_map.csv: where the routine's name comes from (the naming
    hierarchy) and the evidence written when it was named"""
    import csv
    out = {}
    cur = current_names()
    old = lambda m: cur.get(int(m.group(2), 16), m.group(0))
    for r in csv.DictReader(open(NAMEREF, newline='')):
        try: a = int(r['pc_address'], 16)
        except ValueError: continue
        g, f94, conf = r['source_game'], r['94_source_file'], r['confidence']
        if g in ('93G', '94G') and f94: tag = '94G ' + f94
        elif g == '93G': tag = '93G ' + r['source_file']
        elif g == '95G': tag = '95G ' + (r['source_file'] or '')
        elif g == 'library': tag = 'library'
        else: tag = '95 PC'
        if conf in ('medium', 'low', 'none') and g != 'library': tag += ', %s confidence' % conf
        ev = ''
        if r['method'] in ('manual-trace', 'role', 'asstab+content') and g != 'library':
            ev = re.sub(r'\s*\[reviewed[^\]]*\]', '', r['evidence']).strip()
            ev = re.sub(r'\b(sub|loc|dword|word|byte|off|unk)_([0-9A-F]{5})\b', old, ev)
        out[a] = (tag.strip(), ev, r['method'] != 'data')
    return out


def wrap(text, width=77):
    import textwrap
    return ['; ' + x for x in textwrap.wrap(text, width - 2, break_long_words=False, break_on_hyphens=False)]


def routine_starts(L, known=None, A=None):
    """indices of the labels that start a routine: not local, not an alias of the label before, not a label the
    code before runs into, not Func_x of the routine before; a label at an address of docs/name_map.csv (known)
    always starts one (Watcom lets a routine run into the next, e.g. into SprSort)"""
    import bisect
    out = []; cur = None; seen = set()
    idx = sorted(A) if A else []
    for k, l in enumerate(L):
        m = re.match(r'^([A-Za-z_][\w$?@]*):\s*$', l)
        if not m: continue
        name = m.group(1)
        prev = None
        for j in range(k - 1, -1, -1):
            s = L[j].strip()
            if not s or s.startswith(';') or s.startswith('%'): continue
            prev = j; break
        if prev is None: start = True
        else:
            ps = L[prev].strip()
            if re.match(r'^[A-Za-z_.][\w.$?@]*:', ps): start = False          # alias / label run
            elif re.match(r'^(extern|global|section|bits)\b', ps): start = True
            elif asmaddr.is_code(L[prev]) or asmaddr.INSN_MARK.match(ps):
                x = asmaddr.INSN_MARK.match(ps)
                op = (x.group(2) if x else ps).split()[0].lower()
                start = op in NOFALL
            else: start = True                                                   # data before (jump table, padding)
        if start and cur and name.startswith(cur + '_'): start = False
        if start:                                                                # data label (strings, tables)?
            nxt = None
            for j in range(k + 1, len(L)):
                s = L[j].strip()
                if not s or s.startswith(';') or s.startswith('%') or re.match(r'^[A-Za-z_.][\w.$?@]*:', s): continue
                nxt = L[j]; break
            if nxt is None or not (asmaddr.is_code(nxt) or asmaddr.INSN_MARK.match(nxt.strip())): start = False
        if known is not None and idx:
            j = bisect.bisect_left(idx, k)
            a = A[idx[j]] if j < len(idx) else None
            if a in known and a not in seen and not name.startswith('.'): start = True
            if start: seen.add(a)
        if start: out.append(k); cur = name
    return out


def add_headers(path, srcs):
    L = open(path, encoding='latin1').read().split('\n')
    A = asmaddr.addrs(path)
    idx = sorted(A)
    import bisect
    ins = []
    for k in routine_starts(L, {a for a, v in srcs.items() if v[2]}, A):
        name = L[k].strip()[:-1]
        j = bisect.bisect_left(idx, k)
        if j == len(idx): continue
        a = A[idx[j]]
        # walk up over the C switch and the routine's own comment block
        top = k
        while top > 0 and (L[top - 1].strip() in ('%else', '%ifdef CBUILD') or L[top - 1].startswith('%include "c/')
                           or L[top - 1].startswith('; C: ')):
            top -= 1
        c = top
        while c > 0 and L[c - 1].startswith(';') and not L[c - 1].startswith(RULE) \
                and not re.match(r'^;\s*(extern|global)\b', L[c - 1]):
            c -= 1
        if c > 0 and L[c - 1].startswith(RULE): continue                        # has a header already
        if c < top and c > 0 and not L[c - 1].strip() == '' and not re.match(r'^(extern|global|section|bits|%include)', L[c - 1]) \
                and L[c - 1].startswith(';'):
            pass
        # a file-header comment (first lines of the file) is not the routine's description
        if c == 0: c = top
        desc = L[c:top]
        if desc:
            d0 = re.match(r'^;\s*' + re.escape(name) + r'\s*[:\-]\s*(.*)$', desc[0])
            if d0: desc = (['; ' + d0.group(1)] if d0.group(1).strip() else []) + desc[1:]
        tag, ev, _ = srcs.get(a, ('95 PC' if os.path.relpath(path, asmaddr.SRC).split(os.sep)[0] in GAME_DIRS else '', '', True))
        if not desc and ev: desc = wrap(ev[0].upper() + ev[1:])
        right = '%05X  %s' % (a, tag)
        head = '; ' + name
        line2 = head + ' ' * max(2, 78 - len(head) - len(right)) + right
        ins.append((c, top, [RULE, line2] + desc + [RULE]))
    if not ins: return False
    for c, top, block in reversed(ins):
        L[c:top] = block
    open(path, 'w', encoding='latin1').write('\n'.join(L))
    return True


def files(args):
    return [os.path.abspath(a) for a in args] if args else asmaddr.asm_files()


def verify(rev):
    bad = 0
    root = asmaddr.ROOT
    for f in asmaddr.asm_files():
        rel = os.path.relpath(f, root)
        r = subprocess.run(['git', 'show', '%s:%s' % (rev, rel)], cwd=root, capture_output=True, text=True, encoding='latin1')
        if r.returncode: continue
        keep = lambda L: [(k, l) for k, l in enumerate(L) if not l.startswith(';')]   # comments may change
        old = keep(r.stdout.split('\n')); new = keep(asmaddr.legacy_lines(f))
        if len(old) != len(new):
            print('%s: %d non-comment lines, was %d' % (rel, len(new), len(old))); bad += 1; continue
        d = [k for k in range(len(old)) if old[k][1] != new[k][1]]
        if d:
            bad += 1
            k = d[0]
            print('%s:%d: %d lines differ, first:\n  was %r\n  now %r' % (rel, new[k][0] + 1, len(d), old[k][1], new[k][1]))
    print('verify: %s' % ('OK' if not bad else '%d files differ' % bad))
    return bad == 0


def main(argv):
    if argv[:1] == ['--verify']:
        sys.exit(0 if verify(argv[1] if len(argv) > 1 else 'HEAD') else 1)
    if argv[:1] == ['--headers']:
        srcs = name_sources()
        fs = files(argv[1:]) if argv[1:] else [f for f in asmaddr.asm_files()
                                                 if os.path.relpath(f, asmaddr.SRC).split(os.sep)[0] in GAME_DIRS]
        n = sum(add_headers(f, srcs) for f in fs)
        print('headers: %d files' % n); return
    check = '--check' in argv
    args = [a for a in argv if a != '--check']
    changed = []
    for f in files(args):
        t = open(f, encoding='latin1').read()
        n = fmt(t)
        if n != t:
            changed.append(f)
            if not check: open(f, 'w', encoding='latin1').write(n)
    for f in changed: print(('would change ' if check else 'formatted ') + os.path.relpath(f, asmaddr.ROOT))
    if check and changed: sys.exit(1)


if __name__ == '__main__':
    main(sys.argv[1:])
