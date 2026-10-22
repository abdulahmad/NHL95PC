"""cexpr.py - a small C expression parser for single source lines (tools/permute.py's expression transforms).

regions(line) yields the expressions on one line (an `if` / `while` / `switch` condition, the three parts of a `for`
header, a `return` value, an expression statement), each parsed into a tree of Nodes whose spans are character
offsets into the line, so a transform rewrites one subexpression and keeps the rest of the line as written.
Anything the parser does not understand (a declaration, a line split across lines, an unknown cast) is skipped."""
import glob, os, re

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(HERE)

TOKEN = re.compile(r'\s*(0[xX][0-9A-Fa-f]+[uUlL]*|\d+[uUlL]*|[A-Za-z_]\w*|"(?:\\.|[^"\\])*"|\'(?:\\.|[^\'\\])*\'|->|\+\+|--|'
                   r'<<=|>>=|<<|>>|<=|>=|==|!=|&&|\|\||[-+*/%&|^]=|[-+*/%&|^!~<>=?:;,.()\[\]{}])')
BIN = {'*': 13, '/': 13, '%': 13, '+': 12, '-': 12, '<<': 11, '>>': 11, '<': 10, '>': 10, '<=': 10, '>=': 10,
       '==': 9, '!=': 9, '&': 8, '^': 7, '|': 6, '&&': 5, '||': 4}
ASSIGN = {'=', '+=', '-=', '*=', '/=', '%=', '&=', '|=', '^=', '<<=', '>>='}
TYPEWORDS = {'unsigned', 'signed', 'char', 'short', 'int', 'long', 'void', 'const', 'volatile', 'float', 'double'}
STMT_KEYS = {'if', 'while', 'switch', 'for', 'return', 'else', 'do', 'case', 'default', 'break', 'continue', 'goto'}
_TYPEDEFS = None


def typedefs():
    """typedef names from src/c/include (a parenthesized one is a cast)"""
    global _TYPEDEFS
    if _TYPEDEFS is None:
        _TYPEDEFS = set()
        for h in glob.glob(os.path.join(ROOT, 'src', 'c', 'include', '*.h')):
            t = re.sub(r'/\*.*?\*/', ' ', open(h, errors='replace').read(), flags=re.S)
            for m in re.finditer(r'\btypedef\b[^;{]*(?:\{[^}]*\}[^;]*)??\b([A-Za-z_]\w*)\s*(?:\[[^\]]*\]\s*)*;', t):
                _TYPEDEFS.add(m.group(1))
            for m in re.finditer(r'\}\s*([A-Za-z_]\w*)\s*;', t):
                _TYPEDEFS.add(m.group(1))
    return _TYPEDEFS


_PTRS = None


def pointer_globals():
    """globals declared in src/c/include as pointers or arrays"""
    global _PTRS
    if _PTRS is None:
        _PTRS = set()
        for h in glob.glob(os.path.join(ROOT, 'src', 'c', 'include', '*.h')):
            t = re.sub(r'/\*.*?\*/', ' ', open(h, errors='replace').read(), flags=re.S)
            for l in t.split(';'):
                if '(' in l or 'typedef' in l: continue
                for m in re.finditer(r'\*\s*([A-Za-z_]\w*)|([A-Za-z_]\w*)\s*\[', l):
                    _PTRS.add(m.group(1) or m.group(2))
    return _PTRS


class ParseError(Exception):
    pass


class Node:
    """k: atom, paren, un, post, call, index, member, cast, bin, assign, tern, comma; s / e: token span [s, e)"""
    __slots__ = ('k', 'op', 'kids', 's', 'e')

    def __init__(self, k, op, kids, s, e):
        self.k, self.op, self.kids, self.s, self.e = k, op, kids, s, e

    def walk(self):
        yield self
        for c in self.kids:
            yield from c.walk()


def tokens(line):
    """[(text, start, end)] of a line with comments blanked out (offsets kept)"""
    code = re.sub(r'/\*.*?\*/', lambda m: ' ' * len(m.group(0)), line)
    code = re.sub(r'//.*$', lambda m: ' ' * len(m.group(0)), code)
    out, i = [], 0
    while i < len(code):
        if code[i:].strip() == '': break
        m = TOKEN.match(code, i)
        if not m: raise ParseError('token at %d' % i)
        out.append((m.group(1), m.start(1), m.end(1))); i = m.end()
    return out


class Parser:
    def __init__(self, toks, types=()):
        self.t = [x[0] for x in toks]; self.types = typedefs() | set(types)

    def peek(self, i):
        return self.t[i] if i < len(self.t) else None

    def match_paren(self, i):
        """index of the bracket closing the one at i"""
        o = self.t[i]; c = {'(': ')', '[': ']'}[o]; d = 0
        for j in range(i, len(self.t)):
            if self.t[j] == o: d += 1
            elif self.t[j] == c:
                d -= 1
                if d == 0: return j
        raise ParseError('unclosed %s' % o)

    def is_cast(self, i):
        j = self.match_paren(i)
        inner = self.t[i + 1:j]
        if not inner: return False
        k = 0
        if inner[0] in ('struct', 'union') and len(inner) >= 2: k = 2
        else:
            while k < len(inner) and inner[k] in TYPEWORDS: k += 1
            if k == 0 and inner[0] in self.types: k = 1
            if k == 0: return False
        while k < len(inner) and inner[k] == '*': k += 1
        return k == len(inner)

    def expr(self, i, minp=0):
        """parse from token i: (node, next index)"""
        left, i = self.unary(i)
        while True:
            op = self.peek(i)
            if op is None: break
            if op in BIN and BIN[op] > minp:
                right, j = self.expr(i + 1, BIN[op])
                left = Node('bin', op, [left, right], left.s, right.e); i = j
            elif op in ASSIGN and minp <= 2:
                right, j = self.expr(i + 1, 1)            # right-associative
                left = Node('assign', op, [left, right], left.s, right.e); i = j
            elif op == '?' and minp <= 3:
                a, j = self.expr(i + 1, 0)
                if self.peek(j) != ':': raise ParseError('?:')
                b, j = self.expr(j + 1, 2)
                left = Node('tern', '?', [left, a, b], left.s, b.e); i = j
            elif op == ',' and minp < 1:
                right, j = self.expr(i + 1, 1)
                left = Node('comma', ',', [left, right], left.s, right.e); i = j
            else: break
        return left, i

    def unary(self, i):
        t = self.peek(i)
        if t is None: raise ParseError('end')
        if t in ('!', '~', '-', '+', '*', '&', '++', '--'):
            a, j = self.unary(i + 1)
            return Node('un', t, [a], i, a.e), j
        if t == 'sizeof':
            if self.peek(i + 1) == '(' and self.is_cast(i + 1):
                j = self.match_paren(i + 1)
                return Node('atom', 'sizeof', [], i, j + 1), j + 1
            a, j = self.unary(i + 1)
            return Node('un', t, [a], i, a.e), j
        if t == '(':
            if self.is_cast(i):
                j = self.match_paren(i)
                a, k = self.unary(j + 1)
                return Node('cast', ' '.join(self.t[i + 1:j]), [a], i, a.e), k
            j = self.match_paren(i)
            inner, k = self.expr(i + 1)
            if k != j: raise ParseError('paren')
            return self.postfix(Node('paren', '()', [inner], i, j + 1), j + 1)
        if re.match(r'^([A-Za-z_]\w*|\d\w*|0[xX]\w+|"|\')', t) and t not in STMT_KEYS and t not in TYPEWORDS:
            return self.postfix(Node('atom', t, [], i, i + 1), i + 1)
        raise ParseError('unexpected %r' % t)

    def postfix(self, n, i):
        while True:
            t = self.peek(i)
            if t == '[':
                j = self.match_paren(i); idx, k = self.expr(i + 1)
                if k != j: raise ParseError('index')
                n = Node('index', '[]', [n, idx], n.s, j + 1); i = j + 1
            elif t == '(':
                j = self.match_paren(i); args = []
                if j > i + 1:
                    k = i + 1
                    while True:
                        a, k = self.expr(k, 1)
                        args.append(a)
                        if k == j: break
                        if self.peek(k) != ',': raise ParseError('args')
                        k += 1
                n = Node('call', '()', [n] + args, n.s, j + 1); i = j + 1
            elif t in ('.', '->'):
                if not re.match(r'^[A-Za-z_]\w*$', self.peek(i + 1) or ''): raise ParseError('member')
                n = Node('member', t + self.t[i + 1], [n], n.s, i + 2); i += 2
            elif t in ('++', '--'):
                n = Node('post', t, [n], n.s, i + 1); i += 1
            else: return n, i


def file_types(text):
    """typedef names a C file declares itself"""
    t = re.sub(r'/\*.*?\*/', ' ', text, flags=re.S)
    return set(re.findall(r'\btypedef\b[^;]*?\b([A-Za-z_]\w*)\s*;', t)) | set(re.findall(r'\}\s*([A-Za-z_]\w*)\s*;', t))


def regions(line, types=()):
    """[(Node, toks)] for each expression on the line; [] when the line cannot be parsed. types: extra typedef
    names (file_types of the C file)"""
    try: toks = tokens(line)
    except ParseError: return []
    p = Parser(toks, types); out = []

    def full(i, stop):
        """an expression from i that must end at token index stop (exclusive)"""
        if i >= stop: return
        try:
            n, j = p.expr(i)
            if j == stop: out.append((n, toks))
        except (ParseError, IndexError, KeyError):
            pass

    i, n = 0, len(p.t)
    try:
        while i < n:
            t = p.t[i]
            if t in ('if', 'while', 'switch') and p.peek(i + 1) == '(':
                j = p.match_paren(i + 1); full(i + 2, j); i = j + 1
            elif t == 'for' and p.peek(i + 1) == '(':
                j = p.match_paren(i + 1)
                parts, k, d = [], i + 2, 0
                for q in range(i + 2, j):
                    if p.t[q] in '([': d += 1
                    elif p.t[q] in ')]': d -= 1
                    elif p.t[q] == ';' and d == 0: parts.append((k, q)); k = q + 1
                parts.append((k, j))
                for a, b in parts: full(a, b)
                i = j + 1
            elif t in ('else', 'do', '{', '}', ';', 'break', 'continue'):
                i += 1
            elif t == 'return':
                j = i + 1
                while j < n and p.t[j] != ';': j += 1
                full(i + 1, j); i = j + 1
            elif t in ('case', 'default', 'goto') or (re.match(r'^[A-Za-z_]\w*$', t) and p.peek(i + 1) == ':'):
                while i < n and p.t[i] not in (':', ';'): i += 1
                i += 1
            elif t in TYPEWORDS or t in ('struct', 'union', 'static', 'extern', 'register', 'typedef') or \
                    (t in p.types and re.match(r'^[A-Za-z_*]', p.peek(i + 1) or '')):
                return out                                # a declaration
            else:
                j, d = i, 0
                while j < n:
                    if p.t[j] in '([': d += 1
                    elif p.t[j] in ')]': d -= 1
                    elif p.t[j] == ';' and d == 0: break
                    j += 1
                if j == n: return out                     # no `;`: a statement split across lines
                full(i, j); i = j + 1
    except (ParseError, IndexError, KeyError):
        pass
    return out


def span(n, toks):
    """character span [a, b) of a node"""
    return toks[n.s][1], toks[n.e - 1][2]


def text(line, n, toks):
    a, b = span(n, toks)
    return line[a:b]


def parents(root):
    """{id(child): parent}"""
    out = {}
    for n in root.walk():
        for c in n.kids: out[id(c)] = n
    return out
