#!/usr/bin/env python3
"""permute.py - search small source transforms of one C function for a byte match with the EXE.

  python3 tools/permute.py src/c/<seg>/<File>.c FUNC [--max 2000] [--minutes 30] [--stall 300] [--jobs 8]
                           [--round 64] [--seed N] [--write | --write-match] [--log tools/permute_log.csv] [--only T1,T2]

Each candidate is the current best text with one transform applied (once those are used up, two at random):
  type      an integer local's type (int, short, unsigned, unsigned short, char, unsigned char, signed char)
  swapdecl  two adjacent declarations of the function (frame slots, register order)
  movedecl  one scalar declaration moved anywhere else among the declarations
  scope     a local declared in the inner block that uses it (tools/scope_decls.py)
  swapstmt  two adjacent independent statements
  commute   the operands of + * & | ^ == != when both are simple
  cmpflip   a < b -> b > a, a <= b -> b >= a (and back)
  incdec    x++ / ++x / x += 1 (statements and for-loop steps), x-- / --x / x -= 1
  zero      !x <-> x == 0 and (x) <-> (x != 0) in conditions
  chain     a = b = e -> b = e; a = b; / b = e; a = e;  and two equal assignments merged into a chain
  ternary   x = c ? a : b; <-> if (c) x = a; else x = b;
  temp      a local used once inlined into its use (and the declaration dropped)
  rettype   the function's return type (int, short, unsigned short, unsigned char, char)
  paramtype an integer parameter's type (the prototypes in the file and the definition together)
  tempadd   a call-free subexpression a op b (or a whole right-hand side) computed into a new int temporary
  ifswap    if (c) A; else B; -> if (!(c)) B; else A;
  forchain  b = e; for (a = e; ...) <-> for (a = b = e; ...) (decides the jump to the loop test)
  lvinline  a scalar local assigned once from a simple lvalue (a global, *p, p->f, s.f, a[i]) and never written
            again: the lvalue at each use (and the local dropped). First-pass drafts copy globals and fields into
            locals where the original read them in place, and that changes the register picks
  inplace   v = E; followed by L = v; -> L = E; (later v -> L), and v = L op e; L = v; -> L op= e; / L++ / L--
The expression transforms parse each line with tools/cexpr.py:
  swap      any operands of + * & | ^ == != swapped, of < > <= >= flipped (parenthesized where needed)
  opassign  x = x op e <-> x op= e
  cast      an integer cast added on one subexpression (variable, member, element, call, sum), or an existing
            integer cast dropped or changed
  mulshift  x * 2^n <-> x << n, x * 3 / 5 / 9 <-> (x << k) + x, x * 2 <-> x + x
  shiftstmt v << n inside a statement -> v <<= n; as its own statement before it, and back
  loop      for / while as do / while (with and without the entry test) and as goto loops; do / while as while
  temps     split (a local's later assignment starts a new local) and reuse (a local takes the place of another
            of the same type whose uses all come before it)
Each round takes the transform families in turn (each shuffled), so a family with many candidates (cast) does not
crowd out the others.
Candidates are compiled in batched DOSBox runs (cc.compile_parallel), compared with tools/cdiff.py's compare(),
and scored by the aligned count of differing instructions (relocations compared by target, jumps by mnemonic;
ties broken by the size difference). Every attempt is appended to the log CSV (date, function, file, transform,
sha1 of the function's text, score, size difference, match, first difference, compiler); a candidate already in
the log for that function and compiler (WATCOM_VER; rows without one are 10.0 LA) is not compiled again (its
logged score is used). A match is compiled again alone, in a fresh DOSBox run without the cache, and only counts
when it still matches there (a batched run can leave wcc386 in another state; HANDOFF step 3); a logged match is
confirmed the same way. docs/unsure_tried.csv rows (function, transform, result, compiler) name transforms not to
try for a function under that compiler (step 4 of the HANDOFF plan). The search stops at a match, after --max
compiled candidates, --minutes, or --stall compiled candidates in a row without an improvement. --write writes
the best text back to the C file when it improves on the original, --write-match only when it matches; the best
variant is always saved under build/permute/ (same path as the C file). One search runs at a time
(build/permute.lock).
"""
import os, re, sys, csv, time, random, hashlib, difflib, argparse, tempfile, shutil, fcntl, datetime
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
import cc, cdiff, scope_decls, cexpr

LOG = os.path.join(HERE, 'permute_log.csv')
SKIP = os.path.join(ROOT, 'docs', 'unsure_tried.csv')
LOGF = ['date', 'func', 'file', 'transform', 'sha1', 'score', 'sizediff', 'match', 'first', 'cc']
INT_TYPES = ['int', 'short', 'unsigned', 'unsigned short', 'char', 'unsigned char', 'signed char']
TYPE_RE = r'(?:(?:unsigned|signed)\s+)?(?:char|short|int|long)|unsigned|signed'
DECL1 = re.compile(r'^(\s+)(%s)(\s+)(\w+)\s*;(\s*/\*.*?\*/)?\s*$' % TYPE_RE)
ATOM = r'(?:[A-Za-z_]\w*(?:\[[^\[\]]*\]|\.\w+|->\w+)*|0x[0-9A-Fa-f]+|\d+)'
LV = r'[A-Za-z_]\w*(?:\[[^\[\]]*\]|\.\w+|->\w+)*'
KEYWORDS = ('return', 'break', 'continue', 'goto', 'case', 'default', 'if', 'for', 'while', 'do', 'switch', 'else')
CKEYS = set('if for while do switch return sizeof else case default break continue goto int short char long '
            'unsigned signed void struct union typedef static extern const register'.split())


def strip(l):
    l = re.sub(r'"(\\.|[^"])*"', '""', l)
    return re.sub(r'/\*.*?\*/', '', l)


def body(lines, func):
    """(b0, b1): the indexes of FUNC's opening and closing brace lines"""
    for k, l in enumerate(lines):
        if re.match(r'^[A-Za-z_].*\b%s\s*\(' % re.escape(func), l) and not strip(l).rstrip().endswith(';'):
            j = k
            while j < len(lines) and lines[j].strip() != '{': j += 1
            depth = 0
            for e in range(j, len(lines)):
                depth += strip(lines[e]).count('{') - strip(lines[e]).count('}')
                if depth == 0: return j, e
    raise SystemExit('%s: no definition found' % func)


def fsha(text, func):
    lines = text.split('\n'); b0, b1 = body(lines, func)
    k = b0
    while k > 0 and not re.match(r'^[A-Za-z_].*\b%s\s*\(' % re.escape(func), lines[k]): k -= 1
    return hashlib.sha1('\n'.join(lines[k:b1 + 1]).encode()).hexdigest()[:16]


def ids(s):
    return set(w for w in re.findall(r'\b[A-Za-z_]\w*\b', strip(s)) if w not in CKEYS)


def writes(s):
    s = strip(s); w = set()
    for m in re.finditer(r'([A-Za-z_]\w*)(?:\[[^\]]*\]|\.\w+|->\w+)*\s*(?:[-+*/%&|^]|<<|>>)?=(?!=)', s): w.add(m.group(1))
    for m in re.finditer(r'(?:\+\+|--)\s*([A-Za-z_]\w*)|([A-Za-z_]\w*)\s*(?:\+\+|--)', s): w.add(m.group(1) or m.group(2))
    return w


DECL_ANY = re.compile(r'^\s*(?:(?:unsigned|signed|const|struct|register|volatile)\s+)*[A-Za-z_]\w*(?:\s+|\s*\*+\s*)'
                      r'\**\s*[A-Za-z_]\w*\s*(?:\[[^\]]*\]\s*)*(?:,\s*\**\s*[A-Za-z_]\w*\s*(?:\[[^\]]*\]\s*)*)*;')


def is_decl(l):
    """a declaration line (`T x;`, `T *p;`, `struct S s;`, `T a[N];`), not an expression statement"""
    s = strip(l)
    if not DECL_ANY.match(s): return False
    w = re.match(r'\s*([A-Za-z_]\w*)', s).group(1)
    return w not in KEYWORDS


def simple_stmt(l):
    s = strip(l).strip()
    if not s.endswith(';') or '{' in s or '}' in s or s.endswith(':'): return False
    w = re.match(r'([A-Za-z_]\w*)', s)
    if w and w.group(1) in KEYWORDS: return False
    return not is_decl(l)


def header_without_brace(l):
    s = strip(l).rstrip()
    return bool(re.match(r'^\s*(if|for|while|else|do)\b', s)) and not s.endswith(';') and not s.endswith('{')


# ---- transforms: each yields (desc, new_text) ------------------------------------------------------------------

def t_type(text, func, lines, b0, b1):
    for k in range(b0 + 1, b1):
        m = DECL1.match(lines[k])
        if not m: continue
        cur = re.sub(r'\s+', ' ', m.group(2))
        for t in INT_TYPES:
            if t == cur: continue
            L = list(lines); L[k] = '%s%s%s%s;%s' % (m.group(1), t, m.group(3), m.group(4), m.group(5) or '')
            yield 'type:%s:%s' % (m.group(4), t.replace(' ', '_')), '\n'.join(L)


def decl_units(lines, b0, b1):
    """the declaration units at the top of the body: [(first, last, name)]"""
    units = []; k = b0 + 1
    while k < b1:
        l = lines[k]
        if re.match(r'^    struct\s*(\w+\s*)?\{\s*$', l):
            j = k
            while j < b1 and not re.match(r'^    \}\s*(\w+)\s*;', lines[j]): j += 1
            if j == b1: break
            units.append((k, j, re.match(r'^    \}\s*(\w+)', lines[j]).group(1))); k = j + 1; continue
        m = re.match(r'^    (?:(?:unsigned|signed|const|struct|register)\s+)*[A-Za-z_]\w*[\s*]+\(?\*?\s*(\w+)\)?(?:\[[^\]]*\])*'
                     r'(?:\([^)]*\))?\s*;\s*(?:/\*.*\*/)?$', l)
        if not m or strip(l).strip().startswith('return'): break
        units.append((k, k, m.group(1))); k += 1
    return units


def t_swapdecl(text, func, lines, b0, b1):
    u = decl_units(lines, b0, b1)
    for i in range(len(u) - 1):
        a, b = u[i], u[i + 1]
        L = lines[:a[0]] + lines[b[0]:b[1] + 1] + lines[a[0]:a[1] + 1] + lines[b[1] + 1:]
        yield 'swapdecl:%s:%s' % (a[2], b[2]), '\n'.join(L)


def t_movedecl(text, func, lines, b0, b1):
    """one scalar declaration moved to another place among the declarations (adjacent swaps are swapdecl)"""
    u = decl_units(lines, b0, b1)
    for i, a in enumerate(u):
        if a[0] != a[1] or '[' in strip(lines[a[0]]): continue
        rest = u[:i] + u[i + 1:]
        for j in range(len(rest) + 1):
            if abs(j - i) <= 1: continue   # j == i is the same order, i +- 1 an adjacent swap (swapdecl)
            order = rest[:j] + [a] + rest[j:]
            first, last = u[0][0], u[-1][1]
            L = lines[:first] + sum((lines[x[0]:x[1] + 1] for x in order), []) + lines[last + 1:]
            yield 'movedecl:%s:%d' % (a[2], j), '\n'.join(L)


def t_scope(text, func, lines, b0, b1):
    try: mv = scope_decls.moves(text, func, None)
    except SystemExit: return
    for name, levels in mv.items():
        for lv in range(len(levels)):
            t = scope_decls.apply(text, func, [(name, lv)])
            if t is not None: yield 'scope:%s@%d' % (name, lv), t


def t_swapstmt(text, func, lines, b0, b1):
    for k in range(b0 + 1, b1 - 1):
        a, b = lines[k], lines[k + 1]
        ia, ib = len(a) - len(a.lstrip()), len(b) - len(b.lstrip())
        if ia != ib or not simple_stmt(a) or not simple_stmt(b): continue
        if header_without_brace(lines[k - 1]): continue
        if '(' in strip(a) and '(' in strip(b) and re.search(r'\w\s*\(', strip(a)) and re.search(r'\w\s*\(', strip(b)): continue
        wa, wb = writes(a), writes(b)
        if wa & ids(b) or wb & ids(a): continue
        L = list(lines); L[k], L[k + 1] = b, a
        yield 'swapstmt:%d' % (k - b0), '\n'.join(L)


def _context_ok(s, i, j):
    """the operand pair s[i:j] stands alone: a lower-precedence neighbour on both sides"""
    p = s[:i].rstrip(); q = s[j:].lstrip()
    left = not p or p[-1] in '(,=?:' or p.endswith('&&') or p.endswith('||') or p.endswith('return')
    right = not q or q[0] in '),;?:' or q.startswith('&&') or q.startswith('||')
    return left and right


def t_commute(text, func, lines, b0, b1):
    pat = re.compile(r'(?=(%s)(\s*)(\+|\*|&|\||\^|==|!=)(\s*)(%s))' % (ATOM, ATOM))
    for k in range(b0 + 1, b1):
        l = lines[k]
        if is_decl(l) or l.strip().startswith('/*') or l.strip().startswith('*'): continue
        for m in pat.finditer(l):
            a, op, b = m.group(1), m.group(3), m.group(5)
            i = m.start(); j = i + len(a) + len(m.group(2)) + len(op) + len(m.group(4)) + len(b)
            if l[j:j + 1] in ('[', '(', '.', '-') or (i > 0 and (l[i - 1].isalnum() or l[i - 1] in '_.>')): continue
            if op in '+*&|' and (l[i + len(a) + len(m.group(2)) + 1:i + len(a) + len(m.group(2)) + 2] in ('+', '&', '|', '=')
                                 or l[i + len(a) + len(m.group(2)) - 1:i + len(a) + len(m.group(2))] in ('+', '&', '|')):
                continue
            if not _context_ok(l, i, j) or a == b: continue
            L = list(lines); L[k] = l[:i] + b + m.group(2) + op + m.group(4) + a + l[j:]
            yield 'commute:%d:%s' % (k - b0, op), '\n'.join(L)


FLIP = {'<': '>', '>': '<', '<=': '>=', '>=': '<='}


def t_cmpflip(text, func, lines, b0, b1):
    pat = re.compile(r'(?=(%s)(\s*)(<=|>=|<|>)(\s*)(%s))' % (ATOM, ATOM))
    for k in range(b0 + 1, b1):
        l = lines[k]
        if is_decl(l) or l.strip().startswith('/*') or l.strip().startswith('*'): continue
        for m in pat.finditer(l):
            a, op, b = m.group(1), m.group(3), m.group(5)
            i = m.start(); j = i + len(a) + len(m.group(2)) + len(op) + len(m.group(4)) + len(b)
            o0 = i + len(a) + len(m.group(2))
            if l[o0 - 1:o0] in '<>-' and o0 > 0 and l[o0 - 1] in '<>-': continue
            if l[o0 + len(op):o0 + len(op) + 1] in ('<', '>', '='): continue
            if l[j:j + 1] in ('[', '(', '.', '-') or (i > 0 and (l[i - 1].isalnum() or l[i - 1] in '_.>')): continue
            if not _context_ok(l, i, j): continue
            L = list(lines); L[k] = l[:i] + b + m.group(2) + FLIP[op] + m.group(4) + a + l[j:]
            yield 'cmpflip:%d' % (k - b0), '\n'.join(L)


def t_incdec(text, func, lines, b0, b1):
    for k in range(b0 + 1, b1):
        l = lines[k]
        m = re.match(r'^(\s+)(%s)(\+\+|--);(.*)$' % LV, l)
        if m:
            o = m.group(3)[0]
            for new, d in (('%s%s%s;%s' % (m.group(1), m.group(3), m.group(2), m.group(4)), 'pre'),
                           ('%s%s %s= 1;%s' % (m.group(1), m.group(2), o, m.group(4)), 'op1')):
                L = list(lines); L[k] = new; yield 'incdec:%d:%s' % (k - b0, d), '\n'.join(L)
        m = re.match(r'^(\s+)(\+\+|--)(%s);(.*)$' % LV, l)
        if m:
            L = list(lines); L[k] = '%s%s%s;%s' % (m.group(1), m.group(3), m.group(2), m.group(4))
            yield 'incdec:%d:post' % (k - b0), '\n'.join(L)
        m = re.match(r'^(\s+)(%s) ([-+])= 1;(.*)$' % LV, l)
        if m:
            L = list(lines); L[k] = '%s%s%s%s;%s' % (m.group(1), m.group(2), m.group(3), m.group(3), m.group(4))
            yield 'incdec:%d:post' % (k - b0), '\n'.join(L)
        for m in re.finditer(r'; (%s)(\+\+|--)\)' % LV, l):
            L = list(lines); L[k] = l[:m.start()] + '; %s%s)' % (m.group(2), m.group(1)) + l[m.end():]
            yield 'incdec:%d:forpre' % (k - b0), '\n'.join(L)
        for m in re.finditer(r'; (\+\+|--)(%s)\)' % LV, l):
            L = list(lines); L[k] = l[:m.start()] + '; %s%s)' % (m.group(2), m.group(1)) + l[m.end():]
            yield 'incdec:%d:forpost' % (k - b0), '\n'.join(L)


def t_zero(text, func, lines, b0, b1):
    for k in range(b0 + 1, b1):
        l = lines[k]
        for m in re.finditer(r'(\(|&& |\|\| )!(%s)(?=\)| &&| \|\|)' % ATOM, l):
            L = list(lines); L[k] = l[:m.start()] + '%s%s == 0' % (m.group(1), m.group(2)) + l[m.end():]
            yield 'zero:%d:not' % (k - b0), '\n'.join(L)
        for m in re.finditer(r'(\(|&& |\|\| )(%s) == 0(?=\)| &&| \|\|)' % ATOM, l):
            L = list(lines); L[k] = l[:m.start()] + '%s!%s' % (m.group(1), m.group(2)) + l[m.end():]
            yield 'zero:%d:eq0' % (k - b0), '\n'.join(L)
        m = re.match(r'^(\s*(?:if|while) \()(%s)(\).*)$' % ATOM, l)
        if m:
            L = list(lines); L[k] = '%s%s != 0%s' % m.groups(); yield 'zero:%d:ne0' % (k - b0), '\n'.join(L)
        m = re.match(r'^(\s*(?:if|while) \()(%s) != 0(\).*)$' % ATOM, l)
        if m:
            L = list(lines); L[k] = '%s%s%s' % m.groups(); yield 'zero:%d:bool' % (k - b0), '\n'.join(L)


def t_chain(text, func, lines, b0, b1):
    for k in range(b0 + 1, b1):
        l = lines[k]
        m = re.match(r'^(\s+)(%s) = (%s) = ([^=;]+);(\s*/\*.*\*/)?$' % (LV, LV), l)
        if m:
            ind, a, b, e = m.group(1), m.group(2), m.group(3), m.group(4)
            L = lines[:k] + ['%s%s = %s;' % (ind, b, e), '%s%s = %s;' % (ind, a, b)] + lines[k + 1:]
            yield 'chain:%d:split' % (k - b0), '\n'.join(L)
            if re.match(r'^(%s|-?%s)$' % (ATOM, ATOM), e.strip()):
                L = lines[:k] + ['%s%s = %s;' % (ind, b, e), '%s%s = %s;' % (ind, a, e)] + lines[k + 1:]
                yield 'chain:%d:split2' % (k - b0), '\n'.join(L)
                L = lines[:k] + ['%s%s = %s;' % (ind, a, e), '%s%s = %s;' % (ind, b, e)] + lines[k + 1:]
                yield 'chain:%d:split3' % (k - b0), '\n'.join(L)
        if k + 1 < b1:
            m1 = re.match(r'^(\s+)(%s) = (-?%s);$' % (LV, ATOM), l); m2 = re.match(r'^(\s+)(%s) = (-?%s);$' % (LV, ATOM), lines[k + 1])
            if m1 and m2 and m1.group(1) == m2.group(1) and m1.group(3) == m2.group(3) and m1.group(2) != m2.group(2):
                ind, a, b, e = m1.group(1), m1.group(2), m2.group(2), m1.group(3)
                for x, y, d in ((a, b, 'ab'), (b, a, 'ba')):
                    L = lines[:k] + ['%s%s = %s = %s;' % (ind, x, y, e)] + lines[k + 2:]
                    yield 'chain:%d:merge%s' % (k - b0, d), '\n'.join(L)


def t_ternary(text, func, lines, b0, b1):
    for k in range(b0 + 1, b1):
        l = lines[k]
        m = re.match(r'^(\s+)(%s) = ([^?;]+) \? ([^:;?]+) : ([^;?]+);$' % LV, l)
        if m:
            ind, x, c, a, b = m.groups()
            L = lines[:k] + ['%sif (%s) %s = %s;' % (ind, c.strip(), x, a.strip()), '%selse %s = %s;' % (ind, x, b.strip())] + lines[k + 1:]
            yield 'ternary:%d:if' % (k - b0), '\n'.join(L)
        if k + 1 < b1:
            m1 = re.match(r'^(\s+)if \((.+)\) (%s) = ([^;]+);$' % LV, l)
            m2 = re.match(r'^(\s+)else (%s) = ([^;]+);$' % LV, lines[k + 1])
            if m1 and m2 and m1.group(1) == m2.group(1) and m1.group(3) == m2.group(2) and '?' not in l:
                L = lines[:k] + ['%s%s = %s ? %s : %s;' % (m1.group(1), m1.group(3), m1.group(2), m1.group(4), m2.group(3))] + lines[k + 2:]
                yield 'ternary:%d:q' % (k - b0), '\n'.join(L)


def t_temp(text, func, lines, b0, b1):
    """a scalar local assigned once (`t = E;`, E without calls) and read once later in the next statement: inline it"""
    for d in range(b0 + 1, b1):
        m = DECL1.match(lines[d])
        if not m: continue
        name = m.group(4)
        uses = [k for k in range(b0 + 1, b1) if k != d and re.search(r'\b%s\b' % name, strip(lines[k]))]
        if len(uses) != 2: continue
        a, b = uses
        ma = re.match(r'^(\s+)%s = ([^;]+);$' % name, lines[a])
        if not ma or b != a + 1 or re.search(r'\w\s*\(', ma.group(2)): continue
        if len(re.findall(r'\b%s\b' % name, strip(lines[b]))) != 1 or writes(lines[b]) & ids(ma.group(2)): continue
        L = list(lines)
        L[b] = re.sub(r'\b%s\b' % name, '(%s)' % ma.group(2).strip(), L[b])
        del L[a]; del L[d]
        yield 'temp:%s:inline' % name, '\n'.join(L)


SIMPLE_LV = re.compile(r'^(?:\*\s*[A-Za-z_]\w*|[A-Za-z_]\w*(?:\[\w+\]|\.\w+|->\w+)*)$')


def t_lvinline(text, func, lines, b0, b1):
    """a scalar local assigned once from a simple lvalue (no calls) and not written again: read the lvalue in place"""
    for d in range(b0 + 1, b1):
        m = DECL1.match(lines[d])
        if not m: continue
        name = m.group(4)
        refs = [k for k in range(b0 + 1, b1) if k != d and re.search(r'\b%s\b' % name, strip(lines[k]))]
        sets = [k for k in refs if name in writes(lines[k])]
        if len(sets) != 1 or re.search(r'&\s*%s\b' % name, text): continue
        a = sets[0]
        ma = re.match(r'^(\s+)%s = ([^;]+);\s*$' % name, lines[a])
        if not ma: continue
        e = ma.group(2).strip()
        if not SIMPLE_LV.match(e) or e == name or any(k < a for k in refs): continue
        base = ids(e)
        if any(base & writes(lines[k]) for k in range(a + 1, b1)): continue
        rep = '(%s)' % e if e.startswith('*') else e
        L = list(lines)
        for k in refs:
            if k > a: L[k] = re.sub(r'\b%s\b' % name, lambda mm: rep, L[k])
        del L[a]; del L[d]
        yield 'lvinline:%s' % name, '\n'.join(L)


def t_inplace(text, func, lines, b0, b1):
    """v = E; L = v; -> L = E; (later v -> L), and v = L op e; L = v; -> L op= e; (v a local set only there)"""
    for a in range(b0 + 1, b1 - 1):
        m1 = re.match(r'^(\s+)([A-Za-z_]\w*) = ([^;]+);\s*$', lines[a])
        m2 = re.match(r'^(\s+)(\*?\s*%s) = ([A-Za-z_]\w*);\s*$' % LV, lines[a + 1])
        if not m1 or not m2 or m1.group(1) != m2.group(1) or m2.group(3) != m1.group(2): continue
        v, e, lhs = m1.group(2), m1.group(3).strip(), m2.group(2).strip()
        if v == lhs: continue
        decl = [k for k in range(b0 + 1, b1) if DECL1.match(lines[k]) and DECL1.match(lines[k]).group(4) == v]
        if len(decl) != 1: continue
        if [k for k in range(b0 + 1, b1) if v in writes(lines[k])] != [a] or re.search(r'&\s*%s\b' % v, text): continue
        outs = [('%s = %s;' % (lhs, e), 'inplace:%s' % v)]
        m3 = re.match(r'^%s\s*([-+*/|&^]|<<|>>)\s*(.+)$' % re.escape(lhs), e)
        if m3:
            op, r = m3.group(1), m3.group(2).strip()
            outs.append(('%s%s;' % (lhs, op * 2) if op in '+-' and r == '1' else '%s %s= %s;' % (lhs, op, r), 'inplace:%s:%s=' % (v, op)))
        for st, desc in outs:
            L = list(lines)
            L[a] = m1.group(1) + st
            for k in range(a + 2, b1):
                L[k] = re.sub(r'\b%s\b' % v, lambda mm: lhs, L[k])
            del L[a + 1]; del L[decl[0]]
            yield desc, '\n'.join(L)


def t_tempadd(text, func, lines, b0, b1):
    """a call-free binary subexpression `a op b` (or a whole right-hand side) of a simple statement computed into a
    new int temporary just before the statement"""
    u = decl_units(lines, b0, b1)
    if not u: return
    last = u[-1][1]
    used = set(re.findall(r'\b_t\d+\b', text)); n = 0
    while '_t%d' % n in used: n += 1
    tmp = '_t%d' % n
    ptrs = set()   # locals declared as pointers or arrays: no int temporary for their arithmetic
    for a0, a1, name in u:
        if '*' in strip(lines[a0]) or '[' in strip(lines[a0]) or a0 != a1: ptrs.add(name)
    pat = re.compile(r'(?=(%s)(\s*)(\+|-|\*|&|\||\^|<<|>>)(\s*)(%s))' % (ATOM, ATOM))
    for k in range(last + 1, b1):
        l = lines[k]
        if not simple_stmt(l) or k > 0 and header_without_brace(lines[k - 1]): continue
        ind = l[:len(l) - len(l.lstrip())]
        seen = set()
        for m in pat.finditer(l):
            a, op, b = m.group(1), m.group(3), m.group(5)
            i = m.start(); j = i + len(a) + len(m.group(2)) + len(op) + len(m.group(4)) + len(b)
            if l[j:j + 1] in ('[', '(', '.', '-', '=') or (i > 0 and (l[i - 1].isalnum() or l[i - 1] in '_.>')): continue
            o0 = i + len(a) + len(m.group(2))
            if op in '+-&|' and (l[o0 + 1:o0 + 2] in ('+', '-', '&', '|', '=') or l[o0 - 1:o0] in ('+', '-', '&', '|')): continue
            if not _context_ok(l, i, j): continue
            if re.match(r'[A-Za-z_]\w*', a).group(0) in ptrs if re.match(r'[A-Za-z_]', a) else False: continue
            if re.match(r'[A-Za-z_]\w*', b).group(0) in ptrs if re.match(r'[A-Za-z_]', b) else False: continue
            e = l[i:j]
            if e in seen: continue
            seen.add(e)
            L = list(lines)
            L[k] = l[:i] + tmp + l[j:]
            L.insert(k, '%s%s = %s;' % (ind, tmp, e))
            L.insert(last + 1, '    int %s;' % tmp)
            yield 'tempadd:%d:%s' % (k - b0, op), '\n'.join(L)
        m = re.match(r'^(\s+)(%s) = ([^;]+);(\s*/\*.*\*/)?$' % LV, l)
        if m and not re.search(r'\w\s*\(', m.group(3)) and re.search(r'[-+*&|^<>]', m.group(3)) \
                and not re.match(r'^[A-Za-z_]\w*$', m.group(2)):
            L = list(lines)
            L[k] = '%s%s = %s;' % (m.group(1), m.group(2), tmp)
            L.insert(k, '%s%s = %s;' % (m.group(1), tmp, m.group(3).strip()))
            L.insert(last + 1, '    int %s;' % tmp)
            yield 'tempadd:%d:rhs' % (k - b0), '\n'.join(L)


def t_forchain(text, func, lines, b0, b1):
    """`b = e;` before `for (a = e; ...` merged into `for (a = b = e; ...` (or `b = a = e`), and split back; the
    chained init decides whether Watcom emits the jump to the loop test (ShowRosterStats)"""
    for k in range(b0 + 1, b1):
        l = lines[k]
        m = re.match(r'^(\s+)for \((%s) = (%s) = (-?%s); (.*)$' % (LV, LV, ATOM), l)
        if m:
            ind, a, b, e, rest = m.groups()
            L = lines[:k] + ['%s%s = %s;' % (ind, b, e), '%sfor (%s = %s; %s' % (ind, a, e, rest)] + lines[k + 1:]
            yield 'forchain:%d:split' % (k - b0), '\n'.join(L)
        m = re.match(r'^(\s+)for \((%s) = (-?%s); (.*)$' % (LV, ATOM), l)
        if m and k > b0 + 1:
            ind, a, e, rest = m.groups()
            mp = re.match(r'^(\s+)(%s) = (-?%s);$' % (LV, ATOM), lines[k - 1])
            if mp and mp.group(1) == ind and mp.group(3) == e and mp.group(2) != a:
                b = mp.group(2)
                for x, y, d in ((a, b, 'ab'), (b, a, 'ba')):
                    if d == 'ba': continue   # the loop variable must stay first
                    L = lines[:k - 1] + ['%sfor (%s = %s = %s; %s' % (ind, x, y, e, rest)] + lines[k + 1:]
                    yield 'forchain:%d:merge' % (k - b0), '\n'.join(L)


def t_ifswap(text, func, lines, b0, b1):
    """`if (c) A; else B;` (one line each) -> `if (!(c)) B; else A;`"""
    for k in range(b0 + 1, b1 - 1):
        m1 = re.match(r'^(\s+)if \((.+)\) ([^{};]+;)$', lines[k])
        m2 = re.match(r'^(\s+)else ([^{};]+;)$', lines[k + 1])
        if not (m1 and m2 and m1.group(1) == m2.group(1)) or m2.group(2).startswith('if '): continue
        c = m1.group(2)
        nc = c[1:] if re.match(r'^!%s$' % ATOM, c) else '!(%s)' % c
        L = list(lines)
        L[k] = '%sif (%s) %s' % (m1.group(1), nc, m2.group(2)); L[k + 1] = '%selse %s' % (m1.group(1), m1.group(3))
        yield 'ifswap:%d' % (k - b0), '\n'.join(L)


RET_TYPES = ['int', 'short', 'unsigned short', 'unsigned char', 'char', 'void']


def _sig_lines(lines, func):
    """the lines at column 0 that declare or define FUNC: [(k, return type, params text, rest)]"""
    out = []
    for k, l in enumerate(lines):
        m = re.match(r'^((?:(?:unsigned|signed|static)\s+)*[A-Za-z_]\w*(?:\s*\*+)?)\s+(?:__cdecl\s+)?%s\s*\(([^)]*)\)(.*)$'
                     % re.escape(func), l)
        if m and not l.startswith('#'): out.append((k, m.group(1), m.group(2), m))
    return out


def t_rettype(text, func, lines, b0, b1):
    sig = _sig_lines(lines, func)
    if not sig: return
    cur = re.sub(r'\s+', ' ', sig[-1][1])
    if cur not in RET_TYPES or cur == 'void': return   # a void function stays void; pointers stay
    for t in RET_TYPES:
        if t in (cur, 'void'): continue
        L = list(lines)
        for k, rt, params, m in sig: L[k] = t + l_after(lines[k], m)
        yield 'rettype:%s' % t.replace(' ', '_'), '\n'.join(L)


def l_after(l, m):
    return l[m.end(1):]


def t_paramtype(text, func, lines, b0, b1):
    sig = _sig_lines(lines, func)
    if not sig: return
    plists = [[p.strip() for p in s[2].split(',')] for s in sig]
    n = len(plists[-1])
    if any(len(p) != n for p in plists) or plists[-1] == ['void']: return
    for i in range(n):
        m = re.match(r'^(%s)(\s+\w+)?$' % TYPE_RE, plists[-1][i])
        if not m: continue
        cur = re.sub(r'\s+', ' ', m.group(1))
        for t in INT_TYPES:
            if t == cur: continue
            L = list(lines); ok = True
            for (k, rt, params, mm), pl in zip(sig, plists):
                mi = re.match(r'^(%s)(\s+\w+)?$' % TYPE_RE, pl[i])
                if not mi: ok = False; break
                npl = list(pl); npl[i] = t + (mi.group(2) or '')
                L[k] = lines[k][:mm.start(2)] + ', '.join(npl) + lines[k][mm.end(2):]
            if ok: yield 'paramtype:%d:%s' % (i, t.replace(' ', '_')), '\n'.join(L)


# ---- expression transforms (tools/cexpr.py parses the lines) ----------------------------------------------------

COMMUTATIVE = ('+', '*', '&', '|', '^', '==', '!=')
CAST_TYPES = ['short', 'int', 'unsigned short', 'unsigned char', 'char']
ARITH = ('+', '-', '*', '/', '%', '&', '|', '^', '<<', '>>')


def _expr_lines(text, lines, b0, b1):
    """(k, line, root, toks) for each parsed expression of the body's statement lines"""
    types = cexpr.file_types(text)
    for k in range(b0 + 1, b1):
        l = lines[k]
        if is_decl(l) or l.strip().startswith(('/*', '*', '#')): continue
        for root, toks in cexpr.regions(l, types):
            yield k, l, root, toks


def _put(lines, k, l, n, toks, new):
    a, b = cexpr.span(n, toks)
    L = list(lines); L[k] = l[:a] + new + l[b:]
    return '\n'.join(L)


def _operand(t, n, prec):
    """t (the text of node n) as an operand of an operator of precedence prec"""
    if n.k in ('assign', 'tern', 'comma') or (n.k == 'bin' and cexpr.BIN[n.op] < prec): return '(%s)' % t
    return t


def _const(n):
    if n.k != 'atom': return None
    m = re.match(r'^(0[xX][0-9A-Fa-f]+|\d+)[uUlL]*$', n.op)
    return int(m.group(1), 0) if m else None


def _pure(n):
    """no call, assignment or ++ / -- inside (the text can be repeated)"""
    return not any(x.k in ('call', 'assign') or x.op in ('++', '--') for x in n.walk())


def _pointer_names(lines, b0, b1):
    """locals and parameters declared as pointers or arrays (no integer cast for them)"""
    out = set()
    for k in range(max(0, b0 - 3), b1):
        for m in re.finditer(r'\*\s*([A-Za-z_]\w*)|([A-Za-z_]\w*)\s*\[', strip(lines[k]) if is_decl(lines[k]) or k < b0 else ''):
            out.add(m.group(1) or m.group(2))
    return out


def t_swap(text, func, lines, b0, b1):
    """the operands of + * & | ^ == != swapped, and of < > <= >= flipped, for any operands (commute and cmpflip
    only take two simple ones); an operand that binds looser than the operator gets parentheses"""
    for k, l, root, toks in _expr_lines(text, lines, b0, b1):
        for j, n in enumerate(root.walk()):
            if n.k != 'bin' or not (n.op in COMMUTATIVE or n.op in FLIP): continue
            a, b = n.kids
            if a.k == 'atom' and b.k == 'atom': continue
            ta, tb = cexpr.text(l, a, toks), cexpr.text(l, b, toks)
            if ta == tb: continue
            p = cexpr.BIN[n.op]
            sa, ea = cexpr.span(a, toks); sb, eb = cexpr.span(b, toks)
            mid = l[ea:sb].replace(n.op, FLIP.get(n.op, n.op), 1)
            ta = '(%s)' % ta if (a.k == 'bin' and cexpr.BIN[a.op] <= p) or a.k in ('assign', 'tern', 'comma') else ta
            L = list(lines); L[k] = l[:sa] + _operand(tb, b, p) + mid + ta + l[eb:]
            yield 'swap:%d:%d' % (k - b0, j), '\n'.join(L)


def t_opassign(text, func, lines, b0, b1):
    """x = x op e <-> x op= e (and x = e op x for a commutative op)"""
    for k, l, root, toks in _expr_lines(text, lines, b0, b1):
        for j, n in enumerate(root.walk()):
            if n.k != 'assign': continue
            lhs, rhs = n.kids; tl = cexpr.text(l, lhs, toks)
            if n.op == '=' and rhs.k == 'bin' and rhs.op in ARITH and _pure(lhs):
                x, y = rhs.kids
                if cexpr.text(l, x, toks) == tl: e = cexpr.text(l, y, toks)
                elif rhs.op in COMMUTATIVE and cexpr.text(l, y, toks) == tl: e = cexpr.text(l, x, toks)
                else: continue
                yield 'opassign:%d:%d:fold' % (k - b0, j), _put(lines, k, l, n, toks, '%s %s= %s' % (tl, rhs.op, e))
            elif n.op in cexpr.ASSIGN and n.op != '=' and _pure(lhs):
                op = n.op[:-1]
                e = _operand(cexpr.text(l, rhs, toks), rhs, cexpr.BIN[op] + 1)
                yield 'opassign:%d:%d:split' % (k - b0, j), _put(lines, k, l, n, toks, '%s = %s %s %s' % (tl, tl, op, e))


def t_cast(text, func, lines, b0, b1):
    """an integer cast on one subexpression (a variable, member, element, call result or sum), or an existing
    integer cast dropped or changed"""
    ptrs = _pointer_names(lines, b0, b1) | cexpr.pointer_globals()
    ints = set(INT_TYPES) | {'long', 'unsigned long', 'signed short', 'signed int', 'unsigned int'}
    for k, l, root, toks in _expr_lines(text, lines, b0, b1):
        par = cexpr.parents(root)
        for j, n in enumerate(root.walk()):
            p = par.get(id(n))
            if n.k == 'cast':
                if n.op not in ints: continue
                ti = cexpr.text(l, n.kids[0], toks)
                yield 'cast:%d:%d:none' % (k - b0, j), _put(lines, k, l, n, toks, ti)
                for t in CAST_TYPES:
                    if t != n.op: yield 'cast:%d:%d:%s' % (k - b0, j, t.replace(' ', '_')), _put(lines, k, l, n, toks, '(%s)%s' % (t, ti))
                continue
            if p is None or p.k == 'cast': continue
            if n.k == 'atom':
                if not re.match(r'^[A-Za-z_]', n.op) or n.op in ptrs: continue
            elif n.k not in ('member', 'index', 'call', 'paren') and not (n.k == 'bin' and n.op in ARITH): continue
            if p.k == 'assign' and p.kids[0] is n: continue                      # an lvalue
            if p.k == 'assign' and p.kids[0].k == 'atom' and p.kids[0].op in ptrs: continue   # a pointer's value
            if p.k in ('un', 'post') and p.op in ('++', '--', '&'): continue
            if p.k in ('member', 'index', 'call') and p.kids[0] is n: continue   # the base of a postfix
            t = cexpr.text(l, n, toks)
            if n.k == 'bin': t = '(%s)' % t
            for ty in CAST_TYPES:
                yield 'cast:%d:%d:%s' % (k - b0, j, ty.replace(' ', '_')), _put(lines, k, l, n, toks, '(%s)%s' % (ty, t))


def t_mulshift(text, func, lines, b0, b1):
    """x * 2^n <-> x << n, x * 3 / 5 / 9 <-> (x << k) + x, x * 2 <-> x + x"""
    for k, l, root, toks in _expr_lines(text, lines, b0, b1):
        for j, n in enumerate(root.walk()):
            if n.k != 'bin': continue
            a, b = n.kids
            d = '%d:%d' % (k - b0, j)
            if n.op == '*':
                c, x = (_const(b), a) if _const(b) is not None else (_const(a), b)
                if c is None or c < 2: continue
                tx = cexpr.text(l, x, toks)
                if c & (c - 1) == 0:
                    yield 'mulshift:%s:shl' % d, _put(lines, k, l, n, toks, '(%s << %d)' % (_operand(tx, x, 12), c.bit_length() - 1))
                if c in (2, 3, 5, 9) and _pure(x):
                    s = c.bit_length() - 1
                    new = '(%s + %s)' % (_operand(tx, x, 13), _operand(tx, x, 13)) if c == 2 else \
                        '((%s << %d) + %s)' % (_operand(tx, x, 12), s, _operand(tx, x, 13))
                    yield 'mulshift:%s:add' % d, _put(lines, k, l, n, toks, new)
            elif n.op == '<<' and _const(b) is not None and 0 < _const(b) < 31:
                tx = cexpr.text(l, a, toks)
                yield 'mulshift:%s:mul' % d, _put(lines, k, l, n, toks, '%s * %d' % (_operand(tx, a, 13), 1 << _const(b)))
            elif n.op == '+' and _pure(a):
                ta, tb = cexpr.text(l, a, toks), cexpr.text(l, b, toks)
                inner = a.kids[0] if a.k == 'paren' else a
                if ta == tb:
                    yield 'mulshift:%s:mul2' % d, _put(lines, k, l, n, toks, '%s * 2' % _operand(ta, a, 13))
                elif inner.k == 'bin' and inner.op == '<<' and _const(inner.kids[1]) in (1, 2, 3) and \
                        cexpr.text(l, inner.kids[0], toks) == tb:
                    yield 'mulshift:%s:mul' % d, _put(lines, k, l, n, toks, '%s * %d' % (_operand(tb, b, 13), (1 << _const(inner.kids[1])) + 1))


def t_shiftstmt(text, func, lines, b0, b1):
    """`v << n` inside a statement -> `v <<= n;` on its own line before it (v a scalar local), and back"""
    locs = set(u[2] for u in decl_units(lines, b0, b1)) - _pointer_names(lines, b0, b1)
    for k, l, root, toks in _expr_lines(text, lines, b0, b1):
        if not simple_stmt(l) or header_without_brace(lines[k - 1]): continue
        for j, n in enumerate(root.walk()):
            if n.k == 'bin' and n.op in ('<<', '>>') and n.kids[0].k == 'atom' and n.kids[0].op in locs \
                    and _const(n.kids[1]) is not None:
                v, c = n.kids[0].op, _const(n.kids[1])
                L = _put(lines, k, l, n, toks, v).split('\n')
                L.insert(k, '%s%s %s= %d;' % (l[:len(l) - len(l.lstrip())], v, n.op, c))
                yield 'shiftstmt:%d:%d:out' % (k - b0, j), '\n'.join(L)
    for k in range(b0 + 1, b1 - 1):
        m = re.match(r'^(\s+)([A-Za-z_]\w*) (<<|>>)= (\w+);$', lines[k])
        if not m or m.group(2) not in locs or not simple_stmt(lines[k + 1]): continue
        v, nxt = m.group(2), lines[k + 1]
        if v in writes(nxt) or not re.search(r'\b%s\b' % v, strip(nxt)): continue
        L = list(lines); L[k + 1] = re.sub(r'\b%s\b' % v, '(%s %s %s)' % (v, m.group(3), m.group(4)), nxt); del L[k]
        yield 'shiftstmt:%d:in' % (k - b0), '\n'.join(L)


def _block_end(lines, k, b1):
    """the index of the line closing the block opened at the end of line k"""
    d = 0
    for e in range(k, b1):
        s = strip(lines[e]); d += s.count('{') - s.count('}')
        if d == 0: return e
    return None


def _label(text, base):
    n = 0
    while re.search(r'\b%s%d\b' % (base, n), text): n += 1
    return '%s%d' % (base, n)


def t_loop(text, func, lines, b0, b1):
    """for / while loops as do / while (with and without the entry test) and as goto loops (test at the bottom,
    or at the top with a jump back); do / while as a while loop"""
    for k in range(b0 + 1, b1):
        l = lines[k]
        m = re.match(r'^(\s+)for \(([^;]*); ([^;]*); ([^;]*)\) \{\s*$', l)
        w = re.match(r'^(\s+)while \((.*)\) \{\s*$', l)
        dw = re.match(r'^(\s+)do \{\s*$', l)
        if not (m or w or dw): continue
        e = _block_end(lines, k, b1)
        if e is None: continue
        ind = (m or w or dw).group(1)
        body = lines[k + 1:e]
        inner = strip('\n'.join(body))
        if dw:
            mw = re.match(r'^\s*\} while \((.*)\);\s*$', lines[e])
            if not mw or re.search(r'\bcontinue\b', inner): continue
            c = mw.group(1)
            L = lines[:k] + ['%swhile (1) {' % ind] + body + ['%s    if (!(%s)) break;' % (ind, c), '%s}' % ind] + lines[e + 1:]
            yield 'loop:%d:while1' % (k - b0), '\n'.join(L)
            if not re.search(r'\bbreak\b', inner):
                top = _label(text, '_top')
                L = lines[:k] + ['%s:' % top] + body + ['%sif (%s) goto %s;' % (ind, c, top)] + lines[e + 1:]
                yield 'loop:%d:goto' % (k - b0), '\n'.join(L)
            continue
        if strip(lines[e]).strip() != '}' or re.search(r'\bcontinue\b', inner): continue
        if m: init, c, step = m.group(2).strip(), m.group(3).strip() or '1', m.group(4).strip()
        else: init, c, step = '', w.group(2), ''
        pre = ['%s%s;' % (ind, init)] if init else []
        post = ['%s    %s;' % (ind, step)] if step else []
        d = k - b0
        if m:
            yield 'loop:%d:while' % d, '\n'.join(lines[:k] + pre + ['%swhile (%s) {' % (ind, c)] + body + post + lines[e:])
        yield 'loop:%d:do' % d, '\n'.join(lines[:k] + pre + ['%sdo {' % ind] + body + post + ['%s} while (%s);' % (ind, c)] + lines[e + 1:])
        yield 'loop:%d:ifdo' % d, '\n'.join(lines[:k] + pre + ['%sif (%s) do {' % (ind, c)] + body + post + ['%s} while (%s);' % (ind, c)] + lines[e + 1:])
        if not re.search(r'\bbreak\b', inner):
            top, test = _label(text, '_top'), _label(text, '_test')
            yield 'loop:%d:gotobot' % d, '\n'.join(lines[:k] + pre + ['%sgoto %s;' % (ind, test), '%s:' % top] + body + post +
                                                    ['%s:' % test, '%sif (%s) goto %s;' % (ind, c, top)] + lines[e + 1:])
            yield 'loop:%d:gototop' % d, '\n'.join(lines[:k] + pre + ['%s:' % top, '%sif (!(%s)) goto %s;' % (ind, c, test)] + body +
                                                    post + ['%sgoto %s;' % (ind, top), '%s: ;' % test] + lines[e + 1:])


def _uses(lines, b0, b1, name):
    return [k for k in range(b0 + 1, b1) if re.search(r'\b%s\b' % name, strip(lines[k]))]


def t_temps(text, func, lines, b0, b1):
    """split: a scalar local's later assignment (`v = e;`, e not reading v) starts a new local for the rest of the
    function (declared after v, or last); reuse: a scalar local whose first use is an assignment after another
    local of the same type is last used takes that local's place (its declaration dropped)"""
    u = [x for x in decl_units(lines, b0, b1) if x[0] == x[1] and DECL1.match(lines[x[0]])]
    if not u: return
    last = decl_units(lines, b0, b1)[-1][1]
    decl = {x[2]: x[0] for x in u}
    for v, dk in decl.items():
        defs = [k for k in range(last + 1, b1) if re.match(r'^\s+%s = (.+);' % v, lines[k])
                and not re.search(r'\b%s\b' % v, lines[k].split('=', 1)[1])]
        for n, dline in enumerate(defs[1:], 1):
            nv = '%s_%d' % (v, n)
            if re.search(r'\b%s\b' % nv, text): continue
            nxt = [x for x in defs if x > dline]
            end = nxt[0] if nxt else b1
            L = list(lines)
            for k in range(dline, end): L[k] = re.sub(r'\b%s\b' % v, nv, L[k])
            dl = re.sub(r'\b%s\b' % v, nv, lines[dk])
            for where, at in (('after', dk + 1), ('last', last + 1)):
                M = list(L); M.insert(at, dl)
                yield 'split:%s:%d:%s' % (v, n, where), '\n'.join(M)
    for b, bk in decl.items():
        ub = [k for k in _uses(lines, b0, b1, b) if k != bk]
        if not ub or not re.match(r'^\s+%s = (.+);' % b, lines[ub[0]]) or re.search(r'\b%s\b' % b, lines[ub[0]].split('=', 1)[1]): continue
        tb = DECL1.match(lines[bk]).group(2)
        for a, ak in decl.items():
            if a == b or DECL1.match(lines[ak]).group(2) != tb: continue
            ua = [k for k in _uses(lines, b0, b1, a) if k != ak]
            if not ua or ua[-1] >= ub[0]: continue
            L = list(lines)
            for k in ub: L[k] = re.sub(r'\b%s\b' % b, a, L[k])
            del L[bk]
            yield 'reuse:%s:%s' % (b, a), '\n'.join(L)


TRANSFORMS = [('type', t_type), ('swapdecl', t_swapdecl), ('movedecl', t_movedecl), ('scope', t_scope), ('swapstmt', t_swapstmt),
              ('commute', t_commute), ('cmpflip', t_cmpflip), ('incdec', t_incdec), ('zero', t_zero),
              ('chain', t_chain), ('ternary', t_ternary), ('temp', t_temp), ('rettype', t_rettype),
              ('paramtype', t_paramtype), ('tempadd', t_tempadd), ('ifswap', t_ifswap),
              ('forchain', t_forchain), ('swap', t_swap), ('opassign', t_opassign), ('cast', t_cast),
              ('mulshift', t_mulshift), ('shiftstmt', t_shiftstmt), ('loop', t_loop), ('temps', t_temps),
              ('lvinline', t_lvinline), ('inplace', t_inplace)]


def interleave(nb, rnd):
    """the candidates in an order that takes the transform families in turn (each family shuffled), so one
    family with many candidates (cast) does not crowd the others out of a round"""
    fam = {}
    for x in nb: fam.setdefault(x[0].split(':')[0].split(' ')[0], []).append(x)
    groups = list(fam.values())
    for g in groups: rnd.shuffle(g)
    rnd.shuffle(groups)
    out = []
    while groups:
        for g in groups: out.append(g.pop())
        groups = [g for g in groups if g]
    return out


def pick(nb, rnd):
    """one candidate: a family at random, then one of its candidates"""
    fam = {}
    for x in nb: fam.setdefault(x[0].split(':')[0], []).append(x)
    return rnd.choice(fam[rnd.choice(sorted(fam))])


def neighbours(text, func, only=None):
    lines = text.split('\n'); b0, b1 = body(lines, func)
    out = []
    for name, fn in TRANSFORMS:
        if only and name not in only: continue
        try:
            out += list(fn(text, func, lines, b0, b1))
        except Exception as e:   # a transform must never stop the search
            sys.stderr.write('transform %s failed: %s\n' % (name, e))
    return out


# ---- scoring -----------------------------------------------------------------------------------------------------

def norm(t):
    ins, _, sym = t.partition('  ; ')
    ins = ins.strip()
    if ins.startswith('j') or ins.startswith('call'):
        return ins.split()[0] + (' @' + sym.strip() if sym else '')
    if sym:
        ins = re.sub(r'0x[0-9a-f]+|\b\d+\b', '#', ins)
        return ins + ' @' + sym.strip()
    return ins


def key(r):
    """the search order of two scores: fewer differing instructions, then the size, then a later first difference"""
    return (r[0], r[1], -r[3])


_PIECES = {}


def pieces(src, func):
    """the other pieces of a split function (its code outside its own asm block, e.g. SprSort_loop of SprSort, the
    body Watcom leaves where the function was defined when it moves the entry after a tail caller): the asm labels
    FUNC_x outside FUNC's range (one per piece; not data such as a FUNC_jt jump table, a label whose first line is
    dd / dw / db, nor a function of its own such as pucknorm_body, one that starts with push / call __CHK), plus the
    labels a `pieces of FUNC: L1 L2` comment in the C file names (pieces labelled after another function:
    ThreeStarsLoop's PreGameIntro_scroll)"""
    k = (src, func)
    if k in _PIECES: return _PIECES[k]
    out = []
    try:
        asm = cc.c_paths(src, func)[2]
        s, e = cc.asm_range(src, func)
        names = []
        L = open(asm).read().split('\n') + ['', '']
        for j, l in enumerate(L):
            m = cc.LABEL.match(l)
            if not m or not m.group(1).startswith(func + '_'): continue
            if re.match(r'\s*d[bwd]\s', L[j + 1]): continue
            if L[j + 1].startswith('push dword') and 'call __CHK' in L[j + 2]: continue
            names.append(m.group(1))
        claimed = {}
        for m in re.finditer(r'pieces of (\w+):\s*([\w ]+)', open(src).read()):
            for n in m.group(2).split(): claimed[n] = m.group(1)
        names = [n for n in names if claimed.get(n, func) == func] + [n for n, f in claimed.items() if f == func]
        L = open(asm).read().split('\n')
        def is_code(n):   # the label starts code (not a jump table or other data: GameSummaryScreen_jt)
            k = next((i for i, l in enumerate(L) if l.startswith(n + ':')), None)
            for l in L[k + 1:k + 4] if k is not None else []:
                if cc.LABEL.match(l) or not l.strip() or l.startswith(';'): continue
                return bool(cc.ADDR.search(l)) and not cc.data_size(l)
            return False
        got = []
        for n in sorted(set(names), key=lambda n: cc.label_addr(asm, n) or 0):
            a = cc.label_addr(asm, n)
            if a is None or s <= a < e or any(p0 <= a < p1 for p0, p1 in got) or not is_code(n): continue
            p0, p1 = cc.asm_range(src, n)
            got.append((p0, p1)); out.append(n)
    except (SystemExit, Exception):
        out = []
    _PIECES[k] = out
    return out


def score1(cand_src, obj, func, src):
    c = cdiff.compare(cand_src, obj, func, asm_src=src)
    C = [norm(t) for t in c['ctexts']]; O = [norm(t) for t in c['otexts']]
    sm = difflib.SequenceMatcher(None, C, O, autojunk=False)
    nd = sum(max(i2 - i1, j2 - j1) for tag, i1, i2, j1, j2 in sm.get_opcodes() if tag != 'equal')
    if not c['ok']: nd = max(nd, 1)
    else: nd = 0
    first = c['rows'][c['first']][1] if c['first'] is not None else c['n']
    return nd, abs(c['n'] - (c['olen'] or 0)), c['ok'], first


def score(cand_src, obj, func, src):
    """(differing instructions, size difference, match, first difference) of func, its split pieces added in"""
    nd, sz, ok, first = score1(cand_src, obj, func, src)
    for p in pieces(src, func):
        r = score1(cand_src, obj, p, src)
        nd += r[0]; sz += r[1]; ok = ok and r[2]; first = min(first, r[3])
    return nd, sz, ok, first


def confirm(cand_src, obj, func, src):
    """score a candidate that matched in a batched DOSBox run again, compiled alone in a fresh run without the cache
    (as make compiles it): wcc386's code can depend on what the same run compiled before (HANDOFF step 3, the
    compiler state). None when the fresh compile fails."""
    fresh = obj[:-4] + '_fresh.obj'
    try:
        if not cc.compile_c_raw(cand_src, fresh, cc.src_flags(cand_src)): return None
        return score(cand_src, fresh, func, src)
    finally:
        if os.path.exists(fresh): os.remove(fresh)


# ---- log ---------------------------------------------------------------------------------------------------------

def row_cc(r):
    """the compiler of a log or skip row: rows from before the cc column were all measured under 10.0 LA"""
    return r.get('cc') or 'la'


def load_log(path, func):
    seen = {}
    if os.path.exists(path):
        for r in csv.DictReader(open(path, newline='')):
            if r['func'] == func and row_cc(r) == cc.VER:
                seen[r['sha1']] = None if r['score'] == '' else \
                    (int(r['score']), int(r['sizediff']), r['match'] == '1', int(r.get('first') or 0))
    return seen


def load_skips(func):
    out = []
    if os.path.exists(SKIP):
        for r in csv.DictReader(open(SKIP, newline='')):
            if r.get('func') == func and r.get('transform') and row_cc(r) == cc.VER: out.append(r['transform'])
    return out


def append_log(path, rows):
    new = not os.path.exists(path)
    if not new:
        with open(path, newline='') as f: head = f.readline().rstrip('\n')
        if head != ','.join(LOGF):   # a log from before the cc column: new header, rows kept
            with open(path, newline='') as f: text = f.read()
            with open(path, 'w', newline='') as f: f.write(','.join(LOGF) + '\n' + text.split('\n', 1)[1])
    with open(path, 'a', newline='') as f:
        w = csv.writer(f, lineterminator='\n')
        if new: w.writerow(LOGF)
        for r in rows: w.writerow(r)


# ---- search ------------------------------------------------------------------------------------------------------

def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('src'); ap.add_argument('func')
    ap.add_argument('--max', type=int, default=2000); ap.add_argument('--minutes', type=float, default=30)
    ap.add_argument('--stall', type=int, default=300); ap.add_argument('--jobs', type=int, default=8)
    ap.add_argument('--round', type=int, default=64); ap.add_argument('--seed', type=int, default=1)
    ap.add_argument('--write', action='store_true'); ap.add_argument('--write-match', action='store_true')
    ap.add_argument('--log', default=LOG)
    ap.add_argument('--only', help='comma-separated transform names')
    a = ap.parse_args()
    src = os.path.relpath(os.path.abspath(a.src), ROOT); func = a.func
    os.makedirs(os.path.join(ROOT, 'build'), exist_ok=True)
    lock = open(os.path.join(ROOT, 'build', 'permute.lock'), 'w')
    try: fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
    except OSError: raise SystemExit('another permute.py search is running (build/permute.lock)')
    os.chdir(ROOT)
    rnd = random.Random(a.seed)
    only = set(a.only.split(',')) if a.only else None
    skips = load_skips(func)
    logged = load_log(a.log, func)
    work = tempfile.mkdtemp(prefix='perm_')
    t0 = time.time(); compiled = 0; stall = 0; nlog = 0
    base_text = open(src).read()

    def evaluate(cands):
        """[(desc, text)] -> [(desc, text, score tuple or None)]; logged ones are not compiled again, except a logged
        match (it is confirmed fresh again)"""
        nonlocal compiled, nlog
        out, todo = [], []
        for desc, text in cands:
            h = fsha(text, func)
            if h in logged and not (logged[h] and logged[h][2]): out.append((desc, text, logged[h], False))
            else: todo.append((desc, text, h))
        items = []
        for k, (desc, text, h) in enumerate(todo):
            f = os.path.join(work, 'c%d_%s' % (compiled + k, os.path.basename(src)))
            open(f, 'w').write(text); items.append((f, f[:-2] + '.obj', ''))
        oks = cc.compile_parallel(items, a.jobs) if items else []
        rows = []
        for (desc, text, h), (f, o, _), ok in zip(todo, items, oks):
            r = None
            if ok:
                try:
                    r = score(f, o, func, src)
                    if r[2]: r = confirm(f, o, func, src)
                except (SystemExit, Exception) as e: r = None
            logged[h] = r
            rows.append([datetime.date.today().isoformat(), func, src, desc, h, '' if r is None else r[0],
                         '' if r is None else r[1], '' if r is None else int(r[2]), '' if r is None else r[3], cc.VER])
            out.append((desc, text, r, True))
            for x in (f, o):
                if os.path.exists(x): os.remove(x)
        compiled += len(todo); nlog += len(rows)
        if rows: append_log(a.log, rows)
        return out

    try:
        base = evaluate([('base', base_text)])[0]
        if base[2] is None: raise SystemExit('%s: the file as written does not compile' % src)
        best_desc, best_text, best = 'base', base_text, base[2]
        print('%s %s: base %d differing (size %+d)%s' % (src, func, best[0], best[1], ', MATCH' if best[2] else ''))
        cur_desc, cur_text = best_desc, best_text
        tried = set([fsha(base_text, func)])
        while not best[2]:
            if compiled >= a.max or time.time() - t0 > a.minutes * 60 or stall >= a.stall: break
            nb = [(d, t) for d, t in neighbours(cur_text, func, only) if not any(d.startswith(s) for s in skips)]
            nb = [(d, t) for d, t in nb if fsha(t, func) not in tried]
            nb = interleave(nb, rnd)
            if len(nb) < a.round:   # two transforms at random from the current text
                pool = neighbours(cur_text, func, only)
                for _ in range(a.round * 4):
                    if len(nb) >= a.round or not pool: break
                    d1, t1 = pick(pool, rnd)
                    p2 = neighbours(t1, func, only)
                    if not p2: continue
                    d2, t2 = pick(p2, rnd)
                    if any(d1.startswith(s) or d2.startswith(s) for s in skips): continue
                    if fsha(t2, func) not in tried: nb.append((d1 + ' + ' + d2, t2))
            nb = nb[:a.round]
            if not nb: break
            for d, t in nb: tried.add(fsha(t, func))
            improved = False; plateau = []
            for desc, text, r, new in evaluate([((cur_desc + ' > ' + d) if cur_desc != 'base' else d, t) for d, t in nb]):
                stall += 1   # logged candidates count too: a rerun over a logged neighbourhood ends
                if r is None: continue
                if key(r) < key(best) or r[2]:
                    best, best_desc, best_text = r, desc, text; improved = True; stall = 0
                    if r[2]: break
                elif key(r) == key(best): plateau.append((desc, text))
            if improved: cur_desc, cur_text = best_desc, best_text
            elif plateau and rnd.random() < 0.5: cur_desc, cur_text = rnd.choice(plateau)
            else: cur_desc, cur_text = best_desc, best_text
            print('  %4d compiled, %5.0f s: best %d (size %+d) %s' % (compiled, time.time() - t0, best[0], best[1],
                                                                      best_desc[:120]))
            sys.stdout.flush()
    finally:
        shutil.rmtree(work, ignore_errors=True)
    print('%s %s: %s after %d compiled candidates in %.0f s; best %d differing (size %+d): %s'
          % (src, func, 'MATCH' if best[2] else 'no match', compiled, time.time() - t0, best[0], best[1], best_desc))
    if best_desc != 'base':   # the best variant for a look with cdiff (build/ is not committed)
        os.makedirs(os.path.join(ROOT, 'build', 'permute', os.path.dirname(src)), exist_ok=True)
        open(os.path.join(ROOT, 'build', 'permute', src), 'w').write(best_text)
    if best_desc != 'base' and ((a.write and (best[0], best[1]) < (base[2][0], base[2][1])) or (a.write_match and best[2])):
        open(src, 'w').write(best_text); print('written to %s' % src)
    sys.exit(0 if best[2] else 1)


if __name__ == '__main__':
    main()
