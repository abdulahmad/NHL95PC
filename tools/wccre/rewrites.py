#!/usr/bin/env python3
"""rewrites.py - expression-level source rewrites that change the code generator's temporaries and use counts.

permute.py's natural transforms move things around (declarations, statements, operands, comparisons). The
register-tie and stack-slot targets that tieorder.py / countsolve.py find often need something else: a value
computed once instead of twice, a temporary fewer, one more or one fewer reference to a variable. These rewrites
change exactly that, on simple assignment statements (`lhs = expr;`, `lhs op= expr;`), and nothing else:

  merge     v = A; v op= B;            ->  v = A op B;          (v not read in B)
  split     v = A op B;                ->  v = A; v op= B;      (v not read in B)
  assoc     a - b - c  <->  a - (b + c),  a + b - c  <->  a + (b - c),  (a op b) op c  <->  a op (b op c)
  reuse     w = E; ... x = ... E ...;   ->  x = ... w ...;      (E's names and w not written between)
  recompute w = E; ... x = ... w ...;   ->  x = ... (E) ...;    (one read at a time)
  alias     a = b = E; ... a ...        ->  ... b ...           (one read at a time, either way round)
  commute   a op b -> b op a for + * & | ^ inside a right side (permute's commute does not reach every operand)
  narrow    if ((E & 0x30) == 0)       ->  b = E; if ((b & 0x30) == 0)   (b a new unsigned char / short local,
            declared last; or an int local narrowed when every read is a small mask test)
  alias16   a 16-bit store (HIWORD(...) = ..., a short lhs) moved past independent statements of its straight run

All of them keep the computed values (no cast, no copy of a value already held, no signature change: AGENTS.md;
narrow's local is a new typed value, not a copy); the compiler
decides whether the code changes. Each yields (description, new text) like permute.py's transforms, so
targetsearch.py scores them with the rest.

  python3 tools/wccre/rewrites.py src/c/<seg>/<File>.c FUNC     lists the rewrites of FUNC (no compile)"""
import os, re, sys
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(os.path.dirname(HERE))
sys.path.insert(0, os.path.join(ROOT, 'tools'))
import permute

# ---- tokens and a small C expression parser ----------------------------------------------------------------------

TOK = re.compile(r'\s*(0[xX][0-9A-Fa-f]+[uUlL]*|\d+[uUlL]*|[A-Za-z_]\w*|\'(?:\\.|[^\'])\'|"(?:\\.|[^"])*"|'
                 r'->|\+\+|--|<<|>>|<=|>=|==|!=|&&|\|\||[-+*/%&|^~!<>?:.,()\[\]])')
TYPE_WORDS = {'int', 'short', 'char', 'long', 'unsigned', 'signed', 'const', 'struct', 'void', 'volatile'}
BIN = [('||',), ('&&',), ('|',), ('^',), ('&',), ('==', '!='), ('<', '>', '<=', '>='), ('<<', '>>'), ('+', '-'),
       ('*', '/', '%')]
PREC = dict((op, i) for i, ops in enumerate(BIN) for op in ops)
ASSOC_SAME = {'+': '+-', '-': '+-', '*': '*', '&': '&', '|': '|', '^': '^'}


def typedefs():
    """type names declared in the project headers (for telling a cast from a parenthesised expression)"""
    names = set()
    inc = os.path.join(ROOT, 'src', 'c', 'include')
    for fn in os.listdir(inc) if os.path.isdir(inc) else []:
        t = open(os.path.join(inc, fn), errors='replace').read()
        names |= set(re.findall(r'typedef\s+[^;{]*?\b([A-Za-z_]\w*)\s*;', t))
        names |= set(re.findall(r'}\s*([A-Za-z_]\w*)\s*;', t))
    return names


TYPES = None


def tokens(s):
    out, i = [], 0
    s = s.rstrip()
    while i < len(s):
        m = TOK.match(s, i)
        if not m: raise ValueError('cannot tokenize at %r' % s[i:i + 10])
        out.append(m.group(1)); i = m.end()
    return out


class Parser:
    def __init__(self, toks, local_types=()):
        self.t, self.i = toks, 0
        self.types = (TYPES or set()) | set(local_types)

    def peek(self, k=0):
        return self.t[self.i + k] if self.i + k < len(self.t) else None

    def take(self, want=None):
        tok = self.peek()
        if want is not None and tok != want: raise ValueError('expected %s, got %s' % (want, tok))
        self.i += 1
        return tok

    def expr(self):          # the comma operator is not parsed (a comma ends the expression)
        return self.ternary()

    def ternary(self):
        c = self.binary(0)
        if self.peek() == '?':
            self.take(); a = self.ternary(); self.take(':'); b = self.ternary()
            return ('?', c, a, b)
        return c

    def binary(self, level):
        if level == len(BIN): return self.unary()
        e = self.binary(level + 1)
        while self.peek() in BIN[level]:
            op = self.take()
            e = ('bin', op, e, self.binary(level + 1))
        return e

    def is_cast(self):
        if self.peek() != '(': return False
        j, words = self.i + 1, []
        while j < len(self.t) and self.t[j] != ')':
            words.append(self.t[j]); j += 1
        if not words or j >= len(self.t): return False
        core = [w for w in words if w != '*']
        if not core or not all(re.match(r'[A-Za-z_]\w*$', w) for w in core): return False
        return all(w in TYPE_WORDS for w in core) or (len(core) == 1 and core[0] in self.types) or \
            (core[0] == 'struct') or (words[-1] == '*' and core[-1] in self.types | TYPE_WORDS)

    def unary(self):
        tok = self.peek()
        if tok in ('-', '+', '!', '~', '*', '&', '++', '--'):
            self.take(); return ('un', tok, self.unary())
        if tok == 'sizeof':
            self.take(); return ('un', 'sizeof ', self.unary())
        if self.is_cast():
            self.take('(')
            words = []
            while self.peek() != ')': words.append(self.take())
            self.take(')')
            return ('cast', ' '.join(words).replace(' *', ' *').replace('* ', '*'), self.unary())
        return self.postfix()

    def postfix(self):
        e = self.primary()
        while True:
            tok = self.peek()
            if tok == '[':
                self.take(); i = self.expr(); self.take(']'); e = ('idx', e, i)
            elif tok == '(':
                self.take(); args = []
                while self.peek() != ')':
                    args.append(self.expr())
                    if self.peek() == ',': self.take()
                self.take(')'); e = ('call', e, args)
            elif tok in ('.', '->'):
                self.take(); e = ('mem', e, tok, self.take())
            elif tok in ('++', '--'):
                self.take(); e = ('post', tok, e)
            else:
                return e

    def primary(self):
        tok = self.take()
        if tok == '(':
            e = self.expr(); self.take(')'); return ('par', e)
        if tok is None: raise ValueError('unexpected end')
        return ('atom', tok)


def parse(s, local_types=()):
    p = Parser(tokens(s), local_types)
    e = p.expr()
    if p.peek() is not None: raise ValueError('trailing tokens at %s' % p.peek())
    return e


def prec(e):
    if e[0] == 'bin': return PREC[e[1]]
    if e[0] == '?': return -1
    return 100


def show(e, parent=None, right=False):
    """print an AST; a constructed node gets parentheses only where precedence needs them"""
    k = e[0]
    if k == 'atom': return e[1]
    if k == 'par': return '(%s)' % show(e[1])
    if k == 'bin':
        s = '%s %s %s' % (show(e[2], e, False), e[1], show(e[3], e, True))
        if parent is not None and parent[0] == 'bin' and (prec(e) < prec(parent) or (right and prec(e) == prec(parent))):
            s = '(%s)' % s
        elif parent is not None and parent[0] in ('un', 'cast', 'idx', 'call', 'mem', 'post'):
            s = '(%s)' % s
        return s
    if k == '?':
        s = '%s ? %s : %s' % (show(e[1]), show(e[2]), show(e[3]))
        return '(%s)' % s if parent is not None else s
    if k == 'un': return '%s%s' % (e[1], show(e[2], e))
    if k == 'cast': return '(%s)%s' % (e[1], show(e[2], e))
    if k == 'post': return '%s%s' % (show(e[2], e), e[1])
    if k == 'idx': return '%s[%s]' % (show(e[1], e), show(e[2]))
    if k == 'call': return '%s(%s)' % (show(e[1], e), ', '.join(show(a) for a in e[2]))
    if k == 'mem': return '%s%s%s' % (show(e[1], e), e[2], e[3])
    raise ValueError(k)


def unpar(e):
    while e[0] == 'par': e = e[1]
    return e


def same(a, b):
    """structurally equal, ignoring parentheses"""
    a, b = unpar(a), unpar(b)
    if a[0] != b[0] or len(a) != len(b): return False
    for x, y in zip(a[1:], b[1:]):
        if isinstance(x, tuple):
            if not isinstance(y, tuple) or not same(x, y): return False
        elif isinstance(x, list):
            if not isinstance(y, list) or len(x) != len(y) or not all(same(p, q) for p, q in zip(x, y)): return False
        elif x != y:
            return False
    return True


def names(e):
    """identifiers read in e (not member names after . / ->)"""
    out = set()
    def walk(n):
        if n[0] == 'atom':
            if re.match(r'[A-Za-z_]\w*$', n[1]): out.add(n[1])
            return
        if n[0] == 'mem':
            walk(n[1]); return
        for x in n[1:]:
            if isinstance(x, tuple): walk(x)
            elif isinstance(x, list):
                for y in x: walk(y)
    walk(e)
    return out


def is_macro_call(e):
    return e[0] == 'call' and unpar(e[1])[0] == 'atom' and re.match(r'[A-Z][A-Z0-9_]*$', unpar(e[1])[1])


def has_effect(e):
    """a call (other than an all-caps macro such as HIWORD), ++ / -- or an assignment-like node: not safe to
    duplicate or drop"""
    if (e[0] == 'call' and not is_macro_call(e)) or e[0] == 'post' or (e[0] == 'un' and e[1] in ('++', '--')): return True
    return any(has_effect(x) for x in e[1:] if isinstance(x, tuple)) or \
        any(has_effect(y) for x in e[1:] if isinstance(x, list) for y in x)


def subtrees(e, path=()):
    """(path, node) of every node; a path is a tuple of child indexes"""
    yield path, e
    for i, x in enumerate(e[1:], 1):
        if isinstance(x, tuple):
            yield from subtrees(x, path + (i,))
        elif isinstance(x, list):
            for j, y in enumerate(x):
                yield from subtrees(y, path + ((i, j),))


def replace(e, path, new):
    if not path: return new
    i, rest = path[0], path[1:]
    L = list(e)
    if isinstance(i, tuple):
        lst = list(L[i[0]]); lst[i[1]] = replace(lst[i[1]], rest, new); L[i[0]] = lst
    else:
        L[i] = replace(L[i], rest, new)
    return tuple(L)


# ---- statements --------------------------------------------------------------------------------------------------

ASSIGN = re.compile(r'^(\s+)(.+?)\s(=|\+=|-=|\*=|&=|\|=|\^=|<<=|>>=)\s(.+);(\s*/\*.*\*/)?\s*$')


def statement(line, local_types=()):
    """(indent, lhs text, op, rhs AST, trailing comment) of a simple assignment line, or None"""
    s = permute.strip(line)
    if '{' in s or '}' in s or re.match(r'^\s*(if|for|while|do|else|return|switch|case)\b', s): return None
    m = ASSIGN.match(line)
    if not m: return None
    ind, lhs, op, rhs, cm = m.groups()
    if '=' in lhs.replace('==', '') or ',' in rhs and '(' not in rhs: return None
    try:
        lhs_ast = parse(lhs, local_types); rhs_ast = parse(rhs, local_types)
    except (ValueError, IndexError):
        return None
    if unpar(lhs_ast)[0] not in ('atom', 'idx', 'mem', 'un'): return None
    return ind, lhs.strip(), op, rhs_ast, cm or ''


def text_of(st):
    ind, lhs, op, rhs, cm = st
    return '%s%s %s %s;%s' % (ind, lhs, op, show(rhs), cm)


def straight(lines, k, b1, step):
    """the indexes of the simple statement lines after (step 1) or before (step -1) line k in the same block,
    stopping at a brace, a control statement or a label"""
    out, j = [], k + step
    while 0 <= j < b1:
        s = permute.strip(lines[j]).strip()
        if not s: j += step; continue
        if '{' in s or '}' in s or s.endswith(':') or re.match(r'^(if|for|while|do|else|switch|case|return|goto)\b', s):
            break
        out.append(j); j += step
    return out


def writes_of(line):
    return permute.writes(line)


# ---- the rewrites ------------------------------------------------------------------------------------------------

def r_merge(lines, b0, b1, lt):
    for k in range(b0 + 1, b1 - 1):
        a = statement(lines[k], lt)
        if not a or a[2] != '=': continue
        nxt = straight(lines, k, b1, 1)
        if not nxt: continue
        b = statement(lines[nxt[0]], lt)
        if not b or b[1] != a[1] or b[2] == '=' or a[1] in names(b[3]) or not re.match(r'[A-Za-z_]\w*$', a[1]):
            continue
        op = b[2][:-1]
        merged = (a[0], a[1], '=', ('bin', op, a[3], b[3]), a[4])
        L = list(lines); L[k] = text_of(merged); del L[nxt[0]]
        yield 'merge:%d' % (k - b0), L


def r_split(lines, b0, b1, lt):
    for k in range(b0 + 1, b1):
        a = statement(lines[k], lt)
        if not a or a[2] != '=' or not re.match(r'[A-Za-z_]\w*$', a[1]): continue
        e = unpar(a[3])
        if e[0] != 'bin' or e[1] not in ('+', '-', '*', '&', '|', '^', '<<', '>>'): continue
        if a[1] in names(e[3]) or has_effect(e[3]) and a[1] in names(e[2]): continue
        first = (a[0], a[1], '=', unpar(e[2]), a[4]); second = (a[0], a[1], e[1] + '=', e[3], '')
        L = list(lines); L[k:k + 1] = [text_of(first), text_of(second)]
        yield 'split:%d' % (k - b0), L


def assoc_variants(e):
    """regroupings of e's top node and its same-class child"""
    e = unpar(e)
    if e[0] != 'bin' or e[1] not in ASSOC_SAME: return
    op, l, r = e[1], unpar(e[2]), unpar(e[3])
    cls = ASSOC_SAME[op]
    if l[0] == 'bin' and l[1] in cls and len(cls) > 0 and (op in '+-' or l[1] == op):   # (a lop b) op c
        a, lop, b, c = l[2], l[1], l[3], e[3]
        if op in '+-':
            inner = '+' if lop == op else '-'               # a+b+c = a+(b+c); a-b-c = a-(b+c); a+b-c = a+(b-c); a-b+c = a-(b-c)
            yield ('bin', lop, a, ('bin', inner, b, c))
        else:
            yield ('bin', op, a, ('bin', op, b, c))
    if r[0] == 'bin' and r[1] in cls and (op in '+-' or r[1] == op):                    # a op (b rop c)
        a, b, rop, c = e[2], r[2], r[1], r[3]
        if op in '+-':
            outer = '+' if rop == '+' else '-'               # a+(b+c) = a+b+c; a-(b+c) = a-b-c; a+(b-c) = a+b-c; a-(b-c) = a-b+c
            if op == '-': outer = '-' if rop == '+' else '+'
            yield ('bin', outer, ('bin', op, a, b), c)
        else:
            yield ('bin', op, ('bin', op, a, b), c)


def r_assoc(lines, b0, b1, lt):
    for k in range(b0 + 1, b1):
        a = statement(lines[k], lt)
        if not a: continue
        seen = 0
        for path, node in subtrees(a[3]):
            for v in assoc_variants(node):
                new = (a[0], a[1], a[2], replace(a[3], path, v), a[4])
                L = list(lines); L[k] = text_of(new)
                yield 'assoc:%d:%d' % (k - b0, seen), L
                seen += 1


def r_reuse(lines, b0, b1, lt):
    """x = ... E ...; after w = E; (no write to w or E's names between) -> x = ... w ..."""
    for k in range(b0 + 1, b1):
        a = statement(lines[k], lt)
        if not a: continue
        for j in straight(lines, k, b1, -1)[:8]:
            w = statement(lines[j], lt)
            if not w or w[2] != '=' or not re.match(r'[A-Za-z_]\w*$', w[1]) or has_effect(w[3]): continue
            if unpar(w[3])[0] == 'atom': continue
            between = range(j + 1, k)
            dirty = set().union(*[writes_of(lines[x]) for x in between]) if between else set()
            if dirty & (names(w[3]) | {w[1]}): continue
            for n, (path, node) in enumerate(subtrees(a[3])):
                if path and same(node, w[3]):
                    new = (a[0], a[1], a[2], replace(a[3], path, ('atom', w[1])), a[4])
                    L = list(lines); L[k] = text_of(new)
                    yield 'reuse:%d:%s' % (k - b0, w[1]), L
            break


def r_recompute(lines, b0, b1, lt):
    """x = ... w ...; after w = E; (E without calls, nothing written between) -> one read of w as (E)"""
    for k in range(b0 + 1, b1):
        a = statement(lines[k], lt)
        if not a: continue
        for j in straight(lines, k, b1, -1)[:8]:
            w = statement(lines[j], lt)
            if not w or w[2] != '=' or not re.match(r'[A-Za-z_]\w*$', w[1]) or has_effect(w[3]): continue
            dirty = set().union(*[writes_of(lines[x]) for x in range(j + 1, k)]) if k > j + 1 else set()
            if dirty & (names(w[3]) | {w[1]}) or w[1] in names(w[3]): continue
            for n, (path, node) in enumerate(subtrees(a[3])):
                if node == ('atom', w[1]):
                    new = (a[0], a[1], a[2], replace(a[3], path, ('par', w[3])), a[4])
                    L = list(lines); L[k] = text_of(new)
                    yield 'recompute:%d:%s:%d' % (k - b0, w[1], n), L
            break


CHAIN = re.compile(r'^(\s+)([A-Za-z_]\w*) = ([A-Za-z_]\w*) = (.+);')
COPY = re.compile(r'^(\s+)([A-Za-z_]\w*) = ([A-Za-z_]\w*);')


def r_alias(lines, b0, b1, lt):
    """after a = b = E; (or a = b;): each later read of a as b, or of b as a, one at a time, while neither is
    written (same block, any depth below it)"""
    for k in range(b0 + 1, b1):
        m = CHAIN.match(lines[k]) or COPY.match(lines[k])
        if not m: continue
        a, b = m.group(2), m.group(3)
        if a == b: continue
        depth = 0
        for j in range(k + 1, b1):
            s = permute.strip(lines[j])
            depth += s.count('{') - s.count('}')
            if depth < 0: break
            if {a, b} & writes_of(lines[j]): break
            for x, y in ((a, b), (b, a)):
                for n, mm in enumerate(re.finditer(r'(?<![\w.>])%s\b' % x, s)):
                    L = list(lines)
                    L[j] = lines[j][:mm.start()] + y + lines[j][mm.end():]
                    yield 'alias:%d:%s>%s:%d' % (j - b0, x, y, n), L


def r_commute(lines, b0, b1, lt):
    """a op b -> b op a for + * & | ^ anywhere in a simple assignment's right side (a + b - c -> b + a - c)"""
    for k in range(b0 + 1, b1):
        a = statement(lines[k], lt)
        if not a: continue
        n = 0
        for path, node in subtrees(a[3]):
            node = unpar(node)
            if node[0] == 'bin' and node[1] in ('+', '*', '&', '|', '^') and not (has_effect(node[2]) and has_effect(node[3])):
                new = (a[0], a[1], a[2], replace(a[3], path, ('bin', node[1], unpar(node[3]), unpar(node[2]))), a[4])
                L = list(lines); L[k] = text_of(new)
                yield 'commute:%d:%d' % (k - b0, n), L
                n += 1


# ---- the edits StaticEck's Fable run found (docs/WCC_INTERNALS.md, "What source edits do to the list") ---------

COND = re.compile(r'^(\s*)if\s*\((.*)\)\s*(\{?)\s*$')
INT_DECL = re.compile(r'^(\s+)int\s+([A-Za-z_]\w*)\s*;(\s*/\*.*\*/)?\s*$')
CONST = re.compile(r'(0[xX][0-9A-Fa-f]+|\d+)[uUlL]*$')
LHS16 = re.compile(r'^(HIWORD|LOWORD)\s*\(|^\*\s*\(\s*(unsigned\s+)?short\s*\*\s*\)|^\(\s*\(\s*(unsigned\s+)?short\s*\*\s*\)|\.w$')


def mask_tests(e):
    """(path of E, E, mask) for every `E & MASK` of e with a constant mask that fits a byte or a word and an E
    that is more than a name (a call, a shift, a sum)"""
    for path, n in subtrees(e):
        if n[0] != 'bin' or n[1] != '&': continue
        for i, j in ((2, 3), (3, 2)):
            c = unpar(n[j]); x = unpar(n[i])
            if c[0] == 'atom' and CONST.match(c[1]):
                v = int(c[1].rstrip('uUlL'), 0)
                if 0 < v <= 0xFFFF and x[0] != 'atom': yield path + (i,), x, v
                break


def fresh_name(lines, b0, b1, base):
    used = set(re.findall(r'\b[A-Za-z_]\w*\b', '\n'.join(lines[b0 - 1:b1 + 1])))
    for cand in [base] + ['%s%d' % (base, i) for i in range(2, 10)]:
        if cand not in used: return cand


def mask_reads_only(lines, b0, b1, v):
    """the largest mask when every read of local v is a `v & MASK` test (or `MASK & v`), else None"""
    big = 0; reads = 0
    for k in range(b0 + 1, b1):
        s = permute.strip(lines[k])
        for m in re.finditer(r'(?<![\w.>])%s\b' % re.escape(v), s):
            after = s[m.end():].lstrip(); before = s[:m.start()].rstrip()
            if re.match(r'=(?!=)', after) or re.match(r'(\+|-|\*|&|\||\^|<<|>>)=', after): return None   # written
            if re.match(r'(\+\+|--)', after) or before.endswith('++') or before.endswith('--'): return None
            if re.match(r'&\s*%s' % CONST.pattern.rstrip('$'), after):
                big = max(big, int(re.match(r'&\s*((?:0[xX][0-9A-Fa-f]+|\d+))', after).group(1), 0)); reads += 1
            elif re.search(r'(0[xX][0-9A-Fa-f]+|\d+)[uUlL]*\s*&\s*$', before):
                big = max(big, int(re.search(r'(0[xX][0-9A-Fa-f]+|\d+)[uUlL]*\s*&\s*$', before).group(1), 0)); reads += 1
            elif INT_DECL.match(lines[k]) and INT_DECL.match(lines[k]).group(2) == v:
                continue
            else:
                return None
    return big if reads and big <= 0xFFFF else None


def r_narrow(lines, b0, b1, lt):
    """a value tested with a small mask, `(E & 0x30) == 0` / `E & 0x30` / `!(E & 0x30)` with E more than a name:
    E stored first in a new unsigned char (mask up to 0xFF, else unsigned short) local declared last, the test on
    the local (JoystickCalScreen #247: the conversion is one more register conflict before the tie). Also an
    existing int local narrowed to unsigned char / unsigned short when every read of it is such a mask test."""
    units = permute.decl_units(lines, b0, b1)
    if not units: return
    d = units[-1][1]
    for k in range(d + 1, b1):
        m = COND.match(permute.strip(lines[k]).rstrip())
        if not m: continue
        ind, cond, brace = m.groups()
        try:
            e = parse(cond, lt)
        except (ValueError, IndexError):
            continue
        for path, x, v in mask_tests(e):
            name = fresh_name(lines, b0, b1, 'b')
            if not name: continue
            typ = 'unsigned char' if v <= 0xFF else 'unsigned short'
            new = replace(e, path, ('atom', name))
            L = lines[:d + 1] + ['    %s %s;' % (typ, name)] + lines[d + 1:k] + \
                ['%s%s = %s;' % (ind, name, show(x)), '%sif (%s)%s' % (ind, show(new), ' {' if brace else '')] + lines[k + 1:]
            yield 'narrow:%d:%s' % (k - b0, typ.split()[-1]), L
    for u in units:
        m = INT_DECL.match(lines[u[0]])
        if not m or u[0] != u[1]: continue
        v = m.group(2)
        big = mask_reads_only(lines, b0, b1, v)
        if big is None: continue
        typ = 'unsigned char' if big <= 0xFF else 'unsigned short'
        L = list(lines); L[u[0]] = '%s%s %s;%s' % (m.group(1), typ, v, m.group(3) or '')
        yield 'narrow:%s:%s' % (v, typ.split()[-1]), L


def r_alias16(lines, b0, b1, lt):
    """a simple statement that stores 16 bits (HIWORD(...) = ..., a short lhs, .w) moved earlier or later past the
    independent simple statements of its straight run (no shared names, no calls crossed): a name's first 16-bit
    use in code order decides where the names walk re-lists it"""
    for k in range(b0 + 1, b1):
        st = statement(lines[k], lt)
        if not st or not LHS16.search(st[1]) or has_effect(st[3]): continue
        try:
            lhs = parse(st[1], lt)
        except (ValueError, IndexError):
            continue
        rk = names(st[3]) | names(lhs); wk = writes_of(lines[k]) | {st[1]}
        for seq, step in ((straight(lines, k, b1, -1), -1), (straight(lines, k, b1, 1), 1)):
            for j in seq:
                o = statement(lines[j], lt)
                if not o or has_effect(o[3]): break
                try:
                    olhs = parse(o[1], lt)
                except (ValueError, IndexError):
                    break
                rj = names(o[3]) | names(olhs); wj = writes_of(lines[j]) | {o[1]}
                if (wk & (rj | wj)) or (wj & rk) or o[1] == st[1]: break
                L = list(lines); s = L.pop(k); L.insert(j, s)
                yield 'alias16:%d:%+d' % (k - b0, j - k), L


REWRITES = [('merge', r_merge), ('commute', r_commute), ('split', r_split), ('assoc', r_assoc), ('reuse', r_reuse),
            ('recompute', r_recompute), ('alias', r_alias), ('narrow', r_narrow), ('alias16', r_alias16)]


DECL_ONE = re.compile(r'^\s+(?:(?:unsigned|signed|const)\s+)*[A-Za-z_]\w*\s+\**\s*([A-Za-z_]\w*)\s*;\s*(/\*.*\*/)?\s*$')


def drop_dead(lines, b0, b1, lt):
    """remove a local that is no longer read (only declared, or only assigned by `v = E;` with E free of side
    effects): its declaration and those assignments go, as a contributor would tidy after inlining it"""
    changed = True
    while changed:
        changed = False
        single = set(u[0] for u in permute.decl_units(lines, b0, b1) if u[0] == u[1])
        for d in range(b0 + 1, b1):
            m = DECL_ONE.match(lines[d])
            if not m or d not in single or permute.strip(lines[d]).strip().split()[0] in permute.KEYWORDS: continue
            v = m.group(1)
            refs = [k for k in range(b0 + 1, b1) if k != d and re.search(r'(?<![\w.>])%s\b' % v, permute.strip(lines[k]))]
            if re.search(r'&\s*%s\b' % v, '\n'.join(lines[b0:b1 + 1])): continue
            stores = []
            for k in refs:
                st = statement(lines[k], lt)
                if st and st[1] == v and st[2] == '=' and v not in names(st[3]) and not has_effect(st[3]) and \
                        len(re.findall(r'(?<![\w.>])%s\b' % v, permute.strip(lines[k]))) == 1:
                    stores.append(k)
                else:
                    break
            else:
                for k in sorted(stores + [d], reverse=True): del lines[k]
                b1 -= len(stores) + 1
                changed = True
                break
    return lines


def local_types(text):
    return set(re.findall(r'typedef\s+[^;{]*?\b([A-Za-z_]\w*)\s*;', text)) | set(re.findall(r'}\s*([A-Za-z_]\w*)\s*;', text))


def neighbours(text, func, only=None):
    """[(description, new text)] of every rewrite of FUNC's body"""
    global TYPES
    if TYPES is None: TYPES = typedefs()
    lines = text.split('\n')
    b0, b1 = permute.body(lines, func)
    lt = local_types(text)
    out, seen = [], set()
    for name, fn in REWRITES:
        if only and name not in only: continue
        try:
            for desc, L in fn(lines, b0, b1, lt):
                L = drop_dead(list(L), b0, b1 + (len(L) - len(lines)), lt)
                t = '\n'.join(L)
                if t != text and t not in seen:
                    seen.add(t); out.append((desc, t))
        except Exception as e:      # a rewrite must never stop the search
            sys.stderr.write('rewrite %s failed: %s\n' % (name, e))
    return out


def main():
    if len(sys.argv) < 3: raise SystemExit(__doc__)
    text = open(sys.argv[1]).read()
    for desc, t in neighbours(text, sys.argv[2]):
        a, b = text.split('\n'), t.split('\n')
        import difflib
        d = [l for l in difflib.unified_diff(a, b, lineterm='', n=0) if l[:1] in '+-' and l[:3] not in ('+++', '---')]
        print('%-28s %s' % (desc, ' | '.join(x.strip() for x in d)[:150]))


if __name__ == '__main__':
    main()
