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

  narrow    lo8 = E; use lo8 & mask, or a local narrowed when every read discards the high bits
  declorder a local declaration moved; with a target, rank by a checked conflict-list/savings-sort replay
  alias16   independent word stores or their operands reordered to change the first 16-bit aliases

New narrow locals hold computed expressions, never a copy of an existing variable. Hoists run only before
an assignment or if, never out of a conditionally evaluated arm or a loop condition. New declarations are
tried first and last. Existing locals narrow only when every reference is understood and needs the low part.
All of them keep the computed values (no new cast, copy or signature change: AGENTS.md); the compiler
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
        with open(os.path.join(inc, fn), errors='replace') as f: t = f.read()
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
    lhs_node = unpar(lhs_ast)
    if lhs_node[0] not in ('atom', 'idx', 'mem', 'un') and not (
            lhs_node[0] == 'call' and unpar(lhs_node[1]) in (('atom', 'HIWORD'), ('atom', 'LOWORD')) and
            len(lhs_node[2]) == 1): return None
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


# ---- low-part values, declaration order, and first word aliases ---------------------------------------------------

INTEGER_DECL = re.compile(r'\b(?:(?:extern|static|register)\s+)*(?:(?:unsigned|signed)\s+)?'
                          r'(char|short|int|long)(?:\s+int)?\s+(\**)\s*([A-Za-z_]\w*)\s*(\[[^\]]*\])?\s*(?=[;,)])')
HEADER_TEXT = None


def header_text():
    global HEADER_TEXT
    if HEADER_TEXT is None:
        inc = os.path.join(ROOT, 'src', 'c', 'include')
        chunks = []
        for name in sorted(os.listdir(inc)):
            if name.endswith('.h'):
                with open(os.path.join(inc, name), errors='replace') as f: chunks.append(f.read())
        HEADER_TEXT = '\n'.join(chunks)
        HEADER_TEXT = re.sub(r'/\*.*?\*/', '', HEADER_TEXT, flags=re.S)
    return HEADER_TEXT


def integer_env(text):
    """Simple integer declarations, including arrays/pointers (whose elements have the given width).
    Later declarations override header globals; unknown types and ambiguous member widths stay unknown."""
    env, fields = {}, {}
    for m in INTEGER_DECL.finditer(header_text() + '\n' + text):
        typ, ptr, name, array = m.groups()
        bits = {'char': 8, 'short': 16, 'int': 32, 'long': 32}[typ]
        env[name] = (bits, bool(ptr or array))
    for m in INTEGER_DECL.finditer(header_text()):
        typ, ptr, name, array = m.groups()
        bits = {'char': 8, 'short': 16, 'int': 32, 'long': 32}[typ]
        value = None if ptr or array else bits
        if name not in fields: fields[name] = value
        elif fields[name] != value: fields[name] = None
    return env, fields


def const_int(e):
    e = unpar(e)
    if e[0] != 'atom': return None
    s = re.sub(r'[uUlL]+$', '', e[1])
    try:
        return int(s, 16 if s.lower().startswith('0x') else 8 if len(s) > 1 and s[0] == '0' else 10)
    except ValueError:
        return None


def stored_bits(e, env, fields):
    """Known integer lvalues only; a pointer's value is never a narrow integer."""
    e = unpar(e)
    if e[0] == 'atom':
        bits, container = env.get(e[1], (None, False))
        return None if container else bits
    if e[0] == 'mem': return fields.get(e[3])
    if e[0] == 'idx' or e[0] == 'un' and e[1] == '*':
        base = unpar(e[1] if e[0] == 'idx' else e[2])
        if base[0] == 'atom':
            bits, container = env.get(base[1], (None, False))
            return bits if container else None
        if base[0] == 'cast' and '*' in base[1]:
            words = base[1].split()
            return 8 if 'char' in words else 16 if 'short' in words else None
    if e[0] == 'call' and unpar(e[1]) in (('atom', 'HIWORD'), ('atom', 'LOWORD')):
        return 16
    return None


def integer_value(e, env, fields, returns):
    """For narrow stores, require an integer expression (a masked operand is already integral in C)."""
    e = unpar(e)
    if e[0] == 'atom':
        return const_int(e) is not None or env.get(e[1], (None, True))[1] is False
    if e[0] in ('mem', 'idx'): return stored_bits(e, env, fields) is not None
    if e[0] == 'call':
        return unpar(e[1])[0] == 'atom' and unpar(e[1])[1] in returns
    if e[0] == 'bin': return integer_value(e[2], env, fields, returns) and integer_value(e[3], env, fields, returns)
    if e[0] == 'un' and e[1] in ('+', '-', '~', '!'): return integer_value(e[2], env, fields, returns)
    return False


def low_reads(e, demand=None, masks=True):
    """(identifier, bits needed or None) in operand order. Only modular integer operations propagate a
    low-part demand; shift counts, comparisons, addresses, and arbitrary call arguments need full values."""
    k = e[0]
    if k == 'atom':
        if re.fullmatch(r'[A-Za-z_]\w*', e[1]): yield e[1], demand
        return
    if k == 'par':
        yield from low_reads(e[1], demand, masks); return
    if k == 'mem':
        yield from low_reads(e[1], masks=masks); return
    if k == 'bin':
        op, left, right = e[1:]
        a = b = demand if op in ('+', '-', '*', '&', '|', '^') else None
        if op == '<<': a = demand
        if op == '&' and masks:
            x, y = const_int(left), const_int(right)
            if y is not None and 0 <= y <= 0xFFFF: a = min(a or 32, max(1, y.bit_length()))
            if x is not None and 0 <= x <= 0xFFFF: b = min(b or 32, max(1, x.bit_length()))
        yield from low_reads(left, a, masks); yield from low_reads(right, b, masks); return
    if k == 'un' and e[1] in ('+', '-', '~'):
        yield from low_reads(e[2], demand, masks); return
    if k == 'cast':
        words = e[1].split()
        bits = 8 if 'char' in words else 16 if 'short' in words else None
        yield from low_reads(e[2], min(demand or 32, bits) if bits and '*' not in e[1] else None, masks); return
    if k == '?':
        yield from low_reads(e[1], masks=masks)
        yield from low_reads(e[2], demand, masks); yield from low_reads(e[3], demand, masks); return
    for x in e[1:]:
        if isinstance(x, tuple): yield from low_reads(x, masks=masks)
        elif isinstance(x, list):
            for y in x: yield from low_reads(y, masks=masks)


def strict_effect(e):
    """Unlike the older rewrites, do not assume that an arbitrary capitalized macro is pure."""
    if e[0] == 'call' and unpar(e[1]) not in (('atom', 'HIWORD'), ('atom', 'LOWORD')): return True
    if e[0] == 'post' or e[0] == 'un' and e[1] in ('++', '--'): return True
    return any(strict_effect(n) for _, n in subtrees(e) if n is not e and
               (n[0] in ('call', 'post') or n[0] == 'un' and n[1] in ('++', '--')))


def line_expr(line, lt):
    """An entire assignment statement or an if condition; keep its controlled statement intact."""
    st = statement(line, lt)
    if st: return ('stmt', st, st[3])
    m = re.match(r'^(\s*)if\s*\(', line)
    if not m: return None
    start, depth = m.end(), 1
    for j in range(start, len(line)):
        if line[j] == '(': depth += 1
        elif line[j] == ')': depth -= 1
        if not depth:
            try: return ('if', (m.group(1), line[j + 1:]), parse(line[start:j], lt))
            except (ValueError, IndexError): return None
    return None


def expr_line(ctx, e):
    if ctx[0] == 'stmt': return text_of(ctx[1][:3] + (e, ctx[1][4]))
    return '%sif (%s)%s' % (ctx[1][0], show(e), ctx[1][1])


def insertion_safe(lines, k, b0):
    """Inserting before an unbraced controlled statement would change its scope."""
    j = k - 1
    while j > b0 and not permute.strip(lines[j]).strip(): j -= 1
    s = permute.strip(lines[j]).strip()
    return not (permute.header_without_brace(lines[j]) or s.endswith(':') or s.startswith('#') or
                re.match(r'^(else|do)\s*$', s) or
                j > b0 and not s.endswith((';', '{', '}')))


def eager_subtrees(e, path=()):
    """Do not hoist from a short-circuit arm, ternary arm, sizeof, or macro/call argument."""
    yield path, e
    if e[0] in ('call', 'cast') or e[0] == 'un' and e[1].strip() == 'sizeof': return
    for i, x in enumerate(e[1:], 1):
        if not isinstance(x, tuple): continue
        if e[0] == '?' and i != 1 or e[0] == 'bin' and e[1] in ('&&', '||') and i == 3: continue
        yield from eager_subtrees(x, path + (i,))


def r_narrow(lines, b0, b1, lt):
    """Materialize a computed low part, or narrow a local whose every read discards its high bits."""
    text = '\n'.join(lines)
    if re.search(r'\bvolatile\b', text): return
    env, fields = integer_env('\n'.join(lines[b0 - 1:b1]))
    returns = set(re.findall(r'\b(?:int|short|char|long)\s+(?:__cdecl\s+)?([A-Za-z_]\w*)\s*\(',
                             header_text() + '\n' + text)) | {'HIWORD', 'LOWORD'}
    units = permute.decl_units(lines, b0, b1)
    first, last = b0 + 1, units[-1][1] + 1 if units else b0 + 1
    used = set(re.findall(r'[A-Za-z_]\w*', text + '\n' + header_text()))
    for k in range(last, b1):
        ctx = line_expr(lines[k], lt)
        if not ctx or not insertion_safe(lines, k, b0): continue
        e = ctx[2]
        lhs = parse(ctx[1][1], lt) if ctx[0] == 'stmt' else None
        if lhs is not None and strict_effect(lhs): continue
        candidates = []
        for path, node in eager_subtrees(e):
            node = unpar(node)
            if node[0] != 'bin' or node[1] != '&': continue
            mask = const_int(node[3])
            if mask is not None and 0 <= mask <= 0xFFFF:
                # Keep the original path, including any parentheses around the left operand.
                p = path
                original = e
                for index in p: original = original[index]
                while original[0] == 'par': p += (1,); original = original[1]
                candidates.append((p + (2,), node[2], 8 if mask <= 0xFF else 16))
        if lhs is not None and ctx[1][2] == '=':
            bits = stored_bits(lhs, env, fields)
            if bits in (8, 16) and integer_value(e, env, fields, returns): candidates.append(((), e, bits))
        for n, (path, value, bits) in enumerate(candidates):
            v = unpar(value)
            # A load or plain identifier is a copy, not a computed low-part value.
            if v[0] not in ('bin', 'call', 'un') or v[0] == 'un' and v[1] not in ('-', '+', '~'): continue
            if v[0] == 'call' and unpar(v[1]) in (('atom', 'HIWORD'), ('atom', 'LOWORD')): continue
            if any(x[0] == 'cast' for _, x in subtrees(value)): continue
            rest = replace(e, path, ('atom', '0'))
            if strict_effect(rest): continue
            # Writes inside E may not change the other reads or the destination's address.
            if writes_of(show(value)) & (names(rest) | (names(lhs) if lhs else set())): continue
            for width in ([8, 16] if bits == 8 else [16]):
                name = 'lo%d' % width
                while name in used: name += '_'
                new = replace(e, path, ('atom', name))
                ind = ctx[1][0]
                for place, pos in [('last', last), ('first', first)]:
                    if place == 'first' and first == last: continue
                    L = list(lines)
                    L[k:k + 1] = ['%s%s = %s;' % (ind, name, show(value)), expr_line(ctx, new)]
                    L.insert(pos, '    unsigned %s %s;' % ('char' if width == 8 else 'short', name))
                    yield 'narrow:%d:%d:u%d:%s' % (k - b0, n, width, place), L
    # Only simple, uninitialized top-level integer locals. Every textual reference must be understood.
    for d0, d1, name in units:
        if d0 != d1: continue
        m = re.fullmatch(r'(\s*)(?:(?:signed|unsigned)\s+)?(int|short|long)(?:\s+int)?\s+' +
                         re.escape(name) + r'\s*;(\s*/\*.*\*/)?\s*', lines[d0])
        if not m: continue
        old = 16 if m[2] == 'short' else 32
        for width in (8, 16):
            if width >= old: continue
            stores = reads = 0
            for k in range(d1 + 1, b1):
                s = permute.strip(lines[k])
                if not re.search(r'(?<![\w.>])%s\b' % name, s): continue
                ctx = line_expr(lines[k], lt)
                if not ctx:
                    # A return or standalone expression can also read a local through a mask.
                    mread = re.fullmatch(r'\s*(?:return\s+)?(.+);\s*', s)
                    if not mread or re.match(r'\s*(for|while|do|switch|goto)\b', s): break
                    try: read = parse(mread[1], lt)
                    except (ValueError, IndexError): break
                    refs = [b for v, b in low_reads(read) if v == name]
                    if not refs or any(b is None or b > width for b in refs): break
                    reads += len(refs)
                    continue
                if ctx[0] == 'if' and re.search(r'(?<![\w.>])%s\b' % name, ctx[1][1]): break
                demand = None
                if ctx[0] == 'stmt':
                    lhs = parse(ctx[1][1], lt)
                    if ctx[1][1] == name:
                        if ctx[1][2] != '=' or not integer_value(ctx[2], env, fields, returns) or \
                                unpar(ctx[2])[0] == 'atom' and const_int(ctx[2]) is None: break
                        stores += 1
                    else:
                        if name in names(lhs): break
                        if ctx[1][2] == '=': demand = stored_bits(lhs, env, fields)
                refs = [b for v, b in low_reads(ctx[2], demand) if v == name]
                if any(b is None or b > width for b in refs): break
                reads += len(refs)
            else:
                if stores and reads:
                    L = list(lines)
                    L[d0] = '%sunsigned %s %s;%s' % (m[1], 'char' if width == 8 else 'short', name, m[3] or '')
                    yield 'narrow:local:%s:u%d' % (name, width), L


def declaration_models(text, func, target, source):
    """One IR compile per beam text, then tieinverse's checked Shell-sort replay for all moves."""
    import tempfile
    import irdump, emucc, cc, tiesearch
    from slotdump import shell_sort
    models = []
    with tempfile.TemporaryDirectory(prefix='rw_declorder_') as work:
        src = os.path.join(work, os.path.basename(source) if source else func + '.c')
        with open(src, 'w') as f: f.write(text)
        holder = {}
        def setup(emu): holder['d'] = irdump.IRDump(emu, func)
        ok, out, emu = emucc.compile_c(src, src[:-2] + '.obj', cc.src_flags(source or src), setup=setup)
        if not ok: return []
        for k, p, blocks in holder['d'].dumps:
            pairs = [(a, b) for a, b, pas in target if pas == k]
            if not pairs: continue
            sigs = tiesearch.pass_signatures(p, blocks)
            labels = [c['label'] for c in p['confs']]
            lookup = dict(zip(sigs, labels))
            if any(a not in lookup or b not in lookup for a, b in pairs): continue
            built = [c['label'] for c in p.get('before', [])]
            sav = {c['label']: c['savings'] for c in p['confs']}
            if shell_sort(built, lambda a, b: sav[a] > sav[b]) != labels: continue
            globals_ = {c['label'] for c, origin in irdump.built_order(p, blocks) if origin == 'global'}
            models.append((built, sav, globals_, [(lookup[a], lookup[b]) for a, b in pairs]))
    return models


def r_declorder(lines, b0, b1, lt, target=None, source=None, func=None):
    """Move only uninitialized local declarations; locals in the names walk run in reverse source order."""
    units = permute.decl_units(lines, b0, b1)
    if len(units) < 2: return
    models = declaration_models('\n'.join(lines), func, target, source) if target else []
    ranked = []
    for i, unit in enumerate(units):
        if unit[0] != unit[1] or '[' in permute.strip(lines[unit[0]]): continue
        rest = units[:i] + units[i + 1:]
        for j in range(len(units)):
            if i == j: continue
            order = rest[:j] + [unit] + rest[j:]
            miss, usable = 0, False
            for built, sav, global_, pairs in models:
                movable = {u[2] for u in units} & global_
                slots = [p for p, name in enumerate(built) if name in movable]
                original = [u[2] for u in reversed(units) if u[2] in movable]
                # Re-listed aliases and single-block locals do not follow this declaration model.
                if [built[p] for p in slots] != original: continue
                new = list(built)
                for p, name in zip(slots, (u[2] for u in reversed(order) if u[2] in movable)): new[p] = name
                from slotdump import shell_sort
                alloc = shell_sort(new, lambda a, b: sav[a] > sav[b])
                miss += sum(alloc.index(a) > alloc.index(b) for a, b in pairs)
                usable = True
            L = lines[:units[0][0]] + sum((lines[u[0]:u[1] + 1] for u in order), []) + lines[units[-1][1] + 1:]
            desc = 'declorder:%s:%d' % (unit[2], j)
            if usable: desc += ':target=%d' % miss
            ranked.append((miss if usable else len(target or ()) + 1, desc, L))
    for _, desc, L in sorted(ranked, key=lambda x: x[0]): yield desc, L


def r_alias16(lines, b0, b1, lt):
    """Change the order of first 16-bit aliases by commuting operands or independent adjacent stores."""
    text = '\n'.join(lines)
    if re.search(r'\bvolatile\b', text): return
    env, fields = integer_env('\n'.join(lines[b0 - 1:b1]))
    locals_ = {u[2] for u in permute.decl_units(lines, b0, b1)}
    parameters = {m[3] for m in INTEGER_DECL.finditer(lines[b0 - 1])}
    scalar_names = locals_ | parameters
    first, rows = {}, {}
    for k in range(b0 + 1, b1):
        ctx = line_expr(lines[k], lt)
        if not ctx: continue
        pieces = []
        if ctx[0] == 'stmt':
            pieces.append(ctx[1])
        else:
            for name, bits in low_reads(ctx[2], masks=False):
                if name in scalar_names and env.get(name) == (32, False) and bits == 16:
                    first.setdefault(name, k)
            inline = statement('    ' + ctx[1][1].strip(), lt)
            if inline: pieces.append(inline)
        for st in pieces:
            lhs = parse(st[1], lt)
            demand = stored_bits(lhs, env, fields)
            used = []
            for name, bits in low_reads(st[3], demand if demand == 16 else None, masks=False):
                if name in scalar_names and env.get(name) == (32, False) and bits == 16:
                    used.append(name); first.setdefault(name, k)
            if ctx[0] == 'stmt': rows[k] = (st, lhs, used)
    def initial(k, used): return [v for v in used if first[v] == k]
    for k, (st, lhs, used) in rows.items():
        fresh = initial(k, used)
        if not fresh: continue
        for n, (path, node) in enumerate(subtrees(st[3])):
            node = unpar(node)
            if node[0] != 'bin' or node[1] not in ('+', '*', '&', '|', '^') or strict_effect(node): continue
            left, right = names(node[2]) & set(fresh), names(node[3]) & set(fresh)
            if not left or not right or left & right: continue
            rhs = replace(st[3], path, ('bin', node[1], node[3], node[2]))
            # The commutation must actually change the first-alias walk.
            before = [v for v, bits in low_reads(st[3], stored_bits(lhs, env, fields), masks=False) if v in fresh and bits == 16]
            after = [v for v, bits in low_reads(rhs, stored_bits(lhs, env, fields), masks=False) if v in fresh and bits == 16]
            if list(dict.fromkeys(before)) == list(dict.fromkeys(after)): continue
            L = list(lines); L[k] = text_of(st[:3] + (rhs, st[4]))
            yield 'alias16:operand:%d:%d' % (k - b0, n), L
        if k + 1 not in rows or not insertion_safe(lines, k, b0): continue
        other, dest, others = rows[k + 1]
        if not initial(k + 1, others) or st[2] != '=' or other[2] != '=' or st[0] != other[0]: continue
        if any(strict_effect(e) for e in (lhs, st[3], dest, other[3])): continue
        def scalar(e): return unpar(e)[0] == 'atom' and unpar(e)[1] in locals_ and env.get(unpar(e)[1], (0, True))[1] is False
        a, b = unpar(lhs), unpar(dest)
        if scalar(a) and scalar(b):
            if any(re.search(r'&\s*%s\b' % re.escape(e[1]), text) for e in (a, b)): continue
            if any(n[0] in ('mem', 'idx') or n[0] == 'un' and n[1] == '*'
                   for rhs in (st[3], other[3]) for _, n in subtrees(rhs)): continue
            if a == b or a[1] in names(other[3]) or b[1] in names(st[3]): continue
        else:
            # Only disjoint fields of the SAME known struct object; arbitrary pointers might alias.
            def field(e):
                e = unpar(e)
                if e[0] == 'call' and unpar(e[1]) in (('atom', 'HIWORD'), ('atom', 'LOWORD')) and len(e[2]) == 1:
                    e = unpar(e[2][0])
                return e if e[0] == 'mem' and unpar(e[1])[0] == 'atom' else None
            a, b = field(lhs), field(dest)
            if not a or not b or a[1:3] != b[1:3] or a[3] == b[3]: continue
            obj = unpar(a[1])[1]
            ptr = re.search(r'\b([A-Za-z_]\w*)\s*\*\s*' + re.escape(obj) + r'\b', '\n'.join(lines[b0 - 1:b1]))
            structs = re.findall(r'typedef\s+struct(?:\s+\w+)?\s*\{([^{}]*)\}\s*(\w+)\s*;', header_text(), re.S)
            bodies = [body for body, typ in structs if ptr and typ == ptr[1] and not re.search(r'\bunion\b', body)]
            if not any(re.search(r'\b%s\s*;' % a[3], body) and re.search(r'\b%s\s*;' % b[3], body) for body in bodies): continue
            # Only unaliased local scalar reads can be proved independent of the field stores.
            if not (names(st[3]) | names(other[3])) <= scalar_names: continue
            if any(re.search(r'&\s*%s\b' % re.escape(name), text) for name in names(st[3]) | names(other[3])): continue
            # Indirect reads could observe the other store, even through a different pointer.
            if any(n[0] in ('mem', 'idx') or n[0] == 'un' and n[1] == '*'
                   for e in (st[3], other[3]) for _, n in subtrees(e)): continue
        L = list(lines); L[k], L[k + 1] = L[k + 1], L[k]
        yield 'alias16:statement:%d:%d' % (k - b0, k + 1 - b0), L


REWRITES = [('narrow', r_narrow), ('declorder', r_declorder), ('alias16', r_alias16),
            ('merge', r_merge), ('commute', r_commute), ('split', r_split), ('assoc', r_assoc),
            ('reuse', r_reuse), ('recompute', r_recompute), ('alias', r_alias)]


DECL_ONE = re.compile(r'^\s+(?:(?:unsigned|signed|const)\s+)*[A-Za-z_]\w*\s+\**\s*([A-Za-z_]\w*)\s*;\s*(/\*.*\*/)?\s*$')


def drop_dead(lines, b0, b1, lt):
    """remove a local that is no longer read (only declared, or only assigned by `v = E;` with E free of side
    effects): its declaration and those assignments go, as a contributor would tidy after inlining it"""
    changed = True
    while changed:
        changed = False
        # Struct members are not locals: deleting a field changes layout and breaks every candidate.
        decls = permute.decl_units(lines, b0, b1)
        for d, end, name in decls:
            if d != end: continue
            m = DECL_ONE.match(lines[d])
            if not m or permute.strip(lines[d]).strip().split()[0] in permute.KEYWORDS: continue
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


def neighbours(text, func, only=None, target=None, source=None):
    """[(description, new text)] of FUNC rewrites. Optional target: tiesearch (a, b, pass) pairs;
    source supplies the original file's compiler flags when ranking declaration moves."""
    global TYPES
    if TYPES is None: TYPES = typedefs()
    lines = text.split('\n')
    b0, b1 = permute.body(lines, func)
    lt = local_types(text)
    out, seen = [], set()
    for name, fn in REWRITES:
        if only and name not in only: continue
        try:
            args = dict(target=target, source=source, func=func) if name == 'declorder' else {}
            for desc, L in fn(lines, b0, b1, lt, **args):
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
