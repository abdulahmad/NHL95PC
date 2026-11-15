#!/usr/bin/env python3
"""asmaddr.py - the address of every source line, now that the source no longer carries one on each line.

The .asm files used to end every instruction with its address (`mov ebp, eax\t; 51128`). The cleanup (2026-11-15,
tools/build/format_asm.py) took that noise out of the source; this module puts it back on request, from a NASM
listing of the file (CBUILD=0 assembly, cached in build/addr/), so the tools that walk the source by address
(cc.py, permute.py, c_progress.py, ...) keep working unchanged.

As a module:
  asmaddr.addrs(path)          {line index (0-based): address} for every line that emits code
  asmaddr.legacy_lines(path)   the file's lines in the old addressed form: one list entry per source line (same
                               indices as the file), instructions back at column 0 with `\\t; ADDR` after them,
                               `db ...  ; insn: sub eax,3E8h` back as `db ...\\t; ADDR sub eax,3E8h`
  asmaddr.legacy_text(path)    the same, joined with newlines

From the command line:
  python3 tools/build/asmaddr.py 51128                      file:line (and routine) of an address
  python3 tools/build/asmaddr.py src/engine/faceoff/faceoff.asm:40   address of that line
  python3 tools/build/asmaddr.py TakePlayerFromBox          address and file:line of a label
  python3 tools/build/asmaddr.py --show FILE [FROM [TO]]    print a file (or a line range) with addresses
  python3 tools/build/asmaddr.py --legacy FILE              print the old addressed form of a file
"""
import bisect, glob, os, re, subprocess, sys
HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(os.path.dirname(HERE))
SRC = os.path.join(ROOT, 'src')
CACHE = os.path.join(ROOT, 'build', 'addr')
NASM = os.environ.get('NASM', 'nasm')

NESTED = re.compile(r'^\s*\d+ (?:[0-9A-F]{8} \S+)?\s+<\d+> ')
LST = re.compile(r'^\s*(\d+) (?:([0-9A-F]{8}) )?')
SECTION = re.compile(r'^\s*section\s+s_([0-9A-Fa-f]+)\b')
ANYSECTION = re.compile(r'^\s*(?:section|segment)\s+(\S+)')
DIRECTIVE = re.compile(r'^\s*(db|dw|dd|dq|dt|times|resb|resw|resd|align|alignb|incbin)\b', re.I)
INSN_MARK = re.compile(r'^(\s*db\s[^;]*?)\s*;\s*insn:\s*(.*)$')
LABEL = re.compile(r'^[A-Za-z_.][\w.$?@]*:')


def _listing(path):
    path = os.path.abspath(path)
    rel = os.path.relpath(path, ROOT).replace(os.sep, '_')
    lst = os.path.join(CACHE, rel + '.lst')
    if not (os.path.isfile(lst) and os.path.getmtime(lst) >= os.path.getmtime(path)
            and all(os.path.getmtime(lst) >= os.path.getmtime(i) for i in glob.glob(os.path.join(SRC, 'inc', '*.inc')))):
        os.makedirs(CACHE, exist_ok=True)
        r = subprocess.run([NASM, '-O0', '-f', 'elf32', '-I', os.path.join(SRC, 'inc') + '/', '-l', lst + '.tmp',
                            '-o', os.devnull, path], capture_output=True, text=True)
        if r.returncode:
            raise SystemExit('asmaddr: nasm failed on %s:\n%s' % (path, r.stderr))
        os.replace(lst + '.tmp', lst)
    return lst


_cache = {}
def addrs(path):
    """{0-based line index: linear address} of the lines that emit bytes (code and data) in a CBUILD=0 assembly"""
    path = os.path.abspath(path)
    key = (path, os.path.getmtime(path))
    if key in _cache: return _cache[key]
    src = open(path, encoding='latin1').read().split('\n')
    out = {}
    base = None          # start of the current section
    top = None           # current top-level source line (0-based)
    for ln in open(_listing(path), encoding='latin1'):
        m = LST.match(ln)
        if not m: continue
        nested = NESTED.match(ln) is not None
        if not nested:
            top = int(m.group(1)) - 1
            s = src[top] if 0 <= top < len(src) else ''
            x = SECTION.match(s)
            if x: base = int(x.group(1), 16)
            elif ANYSECTION.match(s): base = None
        if m.group(2) and top is not None and base is not None and top not in out:
            out[top] = base + int(m.group(2), 16)
    _cache[key] = out
    return out


def is_code(line):
    """an instruction line (it carried an address in the old form): not a label, directive, comment or data"""
    s = line.split(';')[0].strip()
    if not s or s.startswith(('%', '[')) or LABEL.match(line): return False
    w = s.split()[0].lower()
    if w in ('bits', 'section', 'segment', 'extern', 'global', 'common', 'cpu', 'org', 'default') or w.endswith(':'):
        return False
    if re.match(r'^[A-Za-z_][\w.$?@]*\s+equ\b', s, re.I): return False
    return not DIRECTIVE.match(s)


def legacy_lines(path):
    """the file in the old one-address-per-instruction form, line for line (see the module docstring)"""
    L = open(path, encoding='latin1').read().split('\n')
    A = addrs(path)
    out = []
    for k, l in enumerate(L):
        a = A.get(k)
        m = INSN_MARK.match(l)
        if m and a is not None:
            out.append('%s\t; %05X %s' % (m.group(1).strip(), a, m.group(2).rstrip())); continue
        if a is not None and is_code(l):
            code, sep, com = l.partition(';')
            code = code.strip()
            out.append('%s\t; %05X%s' % (code, a, ('\t; ' + com.strip()) if com.strip() else '')); continue
        out.append(l.lstrip() if not l.startswith(';') else l)
    return out


def legacy_text(path):
    return '\n'.join(legacy_lines(path))


def asm_files():
    fs = []
    for d in ('engine', 'front', 'pc', 'lib', 'data'):
        fs += glob.glob(os.path.join(SRC, d, '**', '*.asm'), recursive=True)
    return sorted(fs)


def _symbols():
    """[(address, label, file, line)] of every non-local label"""
    out = []
    for f in asm_files():
        L = open(f, encoding='latin1').read().split('\n')
        A = addrs(f)
        idx = sorted(A)
        for k, l in enumerate(L):
            m = re.match(r'^([A-Za-z_][\w$?@]*):', l)
            if not m: continue
            j = bisect.bisect_left(idx, k)
            if j < len(idx): out.append((A[idx[j]], m.group(1), f, k + 1))
    return sorted(out)


def main(argv):
    if not argv: sys.exit(__doc__)
    if argv[0] == '--legacy':
        sys.stdout.write(legacy_text(argv[1])); return
    if argv[0] == '--show':
        f = argv[1]; L = open(f, encoding='latin1').read().split('\n'); A = addrs(f)
        lo = int(argv[2]) if len(argv) > 2 else 1; hi = int(argv[3]) if len(argv) > 3 else len(L)
        for k in range(lo - 1, min(hi, len(L))):
            print('%5d %s  %s' % (k + 1, ('%05X' % A[k]) if k in A else '     ', L[k]))
        return
    q = argv[0]
    if ':' in q:
        f, n = q.rsplit(':', 1); n = int(n) - 1; A = addrs(f)
        later = [k for k in sorted(A) if k >= n]
        if not later: sys.exit('no code at or after %s' % q)
        print('%05X  %s:%d' % (A[later[0]], f, later[0] + 1)); return
    S = _symbols()
    if re.fullmatch(r'[0-9A-Fa-f]{5,6}', q) and not any(s[1] == q for s in S):
        a = int(q, 16)
        for f in asm_files():
            A = addrs(f)
            for k, x in A.items():
                if x == a:
                    i = bisect.bisect_right([s[0] for s in S], a) - 1
                    print('%05X  %s:%d  (%s+%Xh)' % (a, os.path.relpath(f, ROOT), k + 1, S[i][1], a - S[i][0])); return
        i = bisect.bisect_right([s[0] for s in S], a) - 1
        if i >= 0: print('%05X  inside %s+%Xh (%s:%d)' % (a, S[i][1], a - S[i][0], os.path.relpath(S[i][2], ROOT), S[i][3]))
        return
    for a, n, f, k in S:
        if n == q: print('%05X  %s  %s:%d' % (a, n, os.path.relpath(f, ROOT), k)); return
    sys.exit('%s: no such label' % q)


if __name__ == '__main__':
    main(sys.argv[1:])
