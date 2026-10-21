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
Candidates are compiled in batched DOSBox runs (cc.compile_parallel), compared with tools/cdiff.py's compare(),
and scored by the aligned count of differing instructions (relocations compared by target, jumps by mnemonic;
ties broken by the size difference). Every attempt is appended to the log CSV (date, function, file, transform,
sha1 of the function's text, score, size difference, match); a candidate already in the log for that function is
not compiled again (its logged score is used). docs/unsure_tried.csv rows (function, transform, result) name
transforms not to try for a function (step 4 of the HANDOFF plan). The search stops at a match, after --max
compiled candidates, --minutes, or --stall compiled candidates in a row without an improvement. --write writes
the best text back to the C file when it improves on the original, --write-match only when it matches; the best
variant is always saved under build/permute/ (same path as the C file). One search runs at a time
(build/permute.lock).
"""
import os, re, sys, csv, time, random, hashlib, difflib, argparse, tempfile, shutil, fcntl, datetime
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
import cc, cdiff, scope_decls

LOG = os.path.join(HERE, 'permute_log.csv')
SKIP = os.path.join(ROOT, 'docs', 'unsure_tried.csv')
LOGF = ['date', 'func', 'file', 'transform', 'sha1', 'score', 'sizediff', 'match', 'first']
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


TRANSFORMS = [('type', t_type), ('swapdecl', t_swapdecl), ('movedecl', t_movedecl), ('scope', t_scope), ('swapstmt', t_swapstmt),
              ('commute', t_commute), ('cmpflip', t_cmpflip), ('incdec', t_incdec), ('zero', t_zero),
              ('chain', t_chain), ('ternary', t_ternary), ('temp', t_temp), ('rettype', t_rettype),
              ('paramtype', t_paramtype), ('tempadd', t_tempadd), ('ifswap', t_ifswap),
              ('forchain', t_forchain)]


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


def score(cand_src, obj, func, src):
    c = cdiff.compare(cand_src, obj, func, asm_src=src)
    C = [norm(t) for t in c['ctexts']]; O = [norm(t) for t in c['otexts']]
    sm = difflib.SequenceMatcher(None, C, O, autojunk=False)
    nd = sum(max(i2 - i1, j2 - j1) for tag, i1, i2, j1, j2 in sm.get_opcodes() if tag != 'equal')
    if not c['ok']: nd = max(nd, 1)
    else: nd = 0
    first = c['rows'][c['first']][1] if c['first'] is not None else c['n']
    return nd, abs(c['n'] - (c['olen'] or 0)), c['ok'], first


# ---- log ---------------------------------------------------------------------------------------------------------

def load_log(path, func):
    seen = {}
    if os.path.exists(path):
        for r in csv.DictReader(open(path, newline='')):
            if r['func'] == func:
                seen[r['sha1']] = None if r['score'] == '' else \
                    (int(r['score']), int(r['sizediff']), r['match'] == '1', int(r.get('first') or 0))
    return seen


def load_skips(func):
    out = []
    if os.path.exists(SKIP):
        for r in csv.DictReader(open(SKIP, newline='')):
            if r.get('func') == func and r.get('transform'): out.append(r['transform'])
    return out


def append_log(path, rows):
    new = not os.path.exists(path)
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
        """[(desc, text)] -> [(desc, text, score tuple or None)]; logged ones are not compiled again"""
        nonlocal compiled, nlog
        out, todo = [], []
        for desc, text in cands:
            h = fsha(text, func)
            if h in logged: out.append((desc, text, logged[h], False))
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
                try: r = score(f, o, func, src)
                except (SystemExit, Exception) as e: r = None
            logged[h] = r
            rows.append([datetime.date.today().isoformat(), func, src, desc, h, '' if r is None else r[0],
                         '' if r is None else r[1], '' if r is None else int(r[2]), '' if r is None else r[3]])
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
            rnd.shuffle(nb)
            if len(nb) < a.round:   # two transforms at random from the current text
                pool = neighbours(cur_text, func, only)
                for _ in range(a.round * 4):
                    if len(nb) >= a.round or not pool: break
                    d1, t1 = rnd.choice(pool)
                    p2 = neighbours(t1, func, only)
                    if not p2: continue
                    d2, t2 = rnd.choice(p2)
                    if any((d1 + '+' + d2).startswith(s) or d2.startswith(s) for s in skips): continue
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
