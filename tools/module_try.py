#!/usr/bin/env python3
"""module_try.py - compile C functions as one translation unit, as the original module was.

  python3 tools/module_try.py STEM[,STEM...] [--files A.c,B.c] [--only F1,F2,...] [--keep OUT.c] [-v]

Watcom merges identical function tails across a whole source file, moves a callee's entry next to a function that
tail-calls it, and which copy of a shared exit survives depends on every function in the file (docs/C_MATCHING.md,
shared exits). The original source files were about one per segment, but a function's C file here holds only part
of its segment, so a shared exit can land in another owner than in the EXE (POSeedRound2_x, RunDemoGame,
PickAwardWinners). This takes every C function defined in the segment's files (src/c/<stem>/*.c; several stems
comma-separated; --files adds C files from anywhere, e.g. for a module that spans a segment split; --only keeps just
the named functions and the files that define them), in address order (a split function where its non-entry piece
is, where it was defined: SayClip at SayClip_body, ControlsDlgInGame at ControlsDlgInGame_side), compiles them as one file and compares each function with the EXE. It
prints, per function, the result in its own file and in the module file, then the functions that match only in the
module file (they need the functions between them and their exit's owner together in one C file, in address order)
and the ones the module file breaks.

Merging keeps each file's own view of every name (each file is compiled on its own):
* one `#include "nhl95.h"`. A file's `#define X X_decl` before the include (any `#define X Y` undone after it)
  hides the header's X from that file; the module hides X only for a function it defines whose definition differs
  from the header's declaration.
* types, struct tags, enum constants and macros are kept once when the files agree; a file whose definition
  differs, or that uses the name for something else, gets its own copy renamed (Name__t<k>).
* functions and globals: a name every file sees the same way is declared once (a function the module defines: as
  its definition; else as the header declares it; else as most files do). A file that sees it differently (another
  prototype or type, another `#pragma aux`) gets an alias Name__m<k> with its own declaration and
  `#pragma aux Name__m<k> "Name"` (its own pragma with the object name added; a `__cdecl` declaration keeps its
  class), so its code uses the same symbol with its own convention. Views that compile to the same calls count as
  one: any pointer parameter alike, any int-sized one alike, an old-style `f()` against parameters that are all
  pointers or int-sized, a void result on the file's side (it does not use the result). Watcom applies a symbol's
  last `#pragma aux` to the whole file (tested), so a file's view is its declaration plus its last pragma.
  A call through an alias to a function the module defines is an external call (no fall-through or near tail jump
  into it): -v lists the aliases and renames.
* a function defined in two files (a copy kept for a fall-through) is taken once: from the file that marks it, else
  the one named after it, else the first."""
import argparse, glob, os, re, sys, tempfile, shutil
from collections import OrderedDict
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
import cc, permute

KEYWORDS = set('''auto break case char const continue default do double else enum extern float for goto if int long
register return short signed sizeof static struct switch typedef union unsigned void volatile while __cdecl __pascal
__fortran __syscall __stdcall __near __far __huge __interrupt __loadds __saveregs _Packed __based __segment __self
__export __inline'''.split())
CONV = ('__cdecl', '__pascal', '__fortran', '__syscall', '__stdcall')
INC = os.path.join(ROOT, 'src', 'c', 'include')

# ---- lexing ---------------------------------------------------------------------------------------------------------

TOK = re.compile(r'/\*.*?\*/|//[^\n]*|"(?:\\.|[^"\\\n])*"|\'(?:\\.|[^\'\\\n])*\'|\d[\w.]*|[A-Za-z_]\w*|->|\S', re.S)
IDENT = re.compile(r'[A-Za-z_]\w*$')


def tokens(text):
    """(token, start, end, previous token) of the code tokens of text (comments skipped)"""
    prev = ''
    for t in TOK.finditer(text):
        s = t.group(0)
        if s.startswith('/*') or s.startswith('//'): continue
        yield s, t.start(), t.end(), prev
        prev = s


def idents(text):
    """the identifiers text uses as names (not members after . / ->, not in strings or comments)"""
    return {s for s, a, b, p in tokens(text) if IDENT.match(s) and p not in ('.', '->')}


def rename(text, m):
    """text with every identifier in m replaced (not members after . / ->, not in strings or comments)"""
    if not m: return text
    out, pos = [], 0
    for s, a, b, p in tokens(text):
        if s in m and p not in ('.', '->'):
            out.append(text[pos:a]); out.append(m[s]); pos = b
    out.append(text[pos:])
    return ''.join(out)


def strip_comments(s):
    return re.sub(r'/\*.*?\*/|//[^\n]*', ' ', s, flags=re.S)


def squash(s):
    """s as one canonical token string (no comments, a space only between two words)"""
    out = ''
    for t in re.findall(r'"(?:\\.|[^"\\])*"|\w+|\S', strip_comments(s)):
        if out and (out[-1].isalnum() or out[-1] == '_') and (t[0].isalnum() or t[0] == '_'): out += ' '
        out += t
    return out


def split_top(s, sep=','):
    """s split at sep outside parentheses / brackets / braces"""
    parts, d, cur = [], 0, ''
    for c in s:
        if c in '([{': d += 1
        elif c in ')]}': d -= 1
        if c == sep and d == 0: parts.append(cur); cur = ''
        else: cur += c
    parts.append(cur)
    return parts


def pp_end(t, i):
    """the end of the preprocessor directive at i (backslash continuations, a comment running past the line)"""
    n = len(t)
    while True:
        j = t.find('\n', i)
        if j < 0: return n
        line = t[i:j]
        k = line.rfind('/*')
        if k >= 0 and line.find('*/', k) < 0:
            e = t.find('*/', i + k)
            if e < 0: return n
            i = e + 2; continue
        if line.rstrip('\r').endswith('\\'): i = j + 1; continue
        return j


def skip(t, j):
    """the end of the comment / literal / preprocessor line at j, or None"""
    if t.startswith('/*', j):
        e = t.find('*/', j + 2); return len(t) if e < 0 else e + 2
    if t.startswith('//', j):
        e = t.find('\n', j); return len(t) if e < 0 else e
    c = t[j]
    if c in '"\'':
        k = j + 1
        while k < len(t) and t[k] != c and t[k] != '\n': k += 2 if t[k] == '\\' else 1
        return k + 1
    if c == '#' and t[t.rfind('\n', 0, j) + 1:j].strip() == '': return pp_end(t, j)
    return None


def close_brace(t, j):
    d = 0
    while j < len(t):
        e = skip(t, j)
        if e is not None: j = e; continue
        if t[j] == '{': d += 1
        elif t[j] == '}':
            d -= 1
            if d == 0: return j + 1
        j += 1
    return len(t)


class Item:
    def __init__(self, kind, text, lead):
        self.kind, self.text, self.lead, self.cls = kind, text, lead, kind   # lead: the comments right before it


def scan(t):
    """the top-level items of a C text: 'pp' (a directive), 'decl' (up to ; outside braces), 'func' (a definition)"""
    items, lead, i, n = [], [], 0, len(t)
    while i < n:
        if t[i].isspace(): i += 1; continue
        if t.startswith('/*', i) or t.startswith('//', i):
            e = skip(t, i); lead.append(t[i:e]); i = e; continue
        if t[i] == '#':
            e = pp_end(t, i); items.append(Item('pp', t[i:e], lead)); lead = []; i = e; continue
        j, depth, brace, kind = i, 0, 0, 'decl'
        while j < n:
            e = skip(t, j)
            if e is not None: j = e; continue
            c = t[j]
            if c in '([': depth += 1
            elif c in ')]': depth -= 1
            elif c == '{':
                if brace == 0 and depth == 0 and strip_comments(t[i:j]).rstrip().endswith(')'):
                    j = close_brace(t, j); kind = 'func'; break
                brace += 1
            elif c == '}': brace -= 1
            elif c == ';' and brace == 0 and depth == 0: j += 1; break
            j += 1
        items.append(Item(kind, t[i:j], lead)); lead = []; i = j
    if lead: items.append(Item('comment', '', lead))
    return items


# ---- declarations ---------------------------------------------------------------------------------------------------

def nobody(s):
    """s with every {...} emptied"""
    while True:
        s2 = re.sub(r'\{[^{}]*\}', '{}', s)
        if s2 == s: return s
        s = s2


def declarator_name(p):
    p = re.sub(r'=.*$', '', p, flags=re.S)
    m = re.match(r'^[^(]*?\b([A-Za-z_]\w*)\s*\(', p)   # a function: the name before the first parenthesis
    if m and m.group(1) not in KEYWORDS: return m.group(1)
    m = re.search(r'\(\s*\*\s*(\w+)\s*\)', p)   # a function pointer
    if m: return m.group(1)
    ids = [x for x in re.findall(r'[A-Za-z_]\w*', re.sub(r'\[[^\]]*\]', '', p)) if x not in KEYWORDS]
    return ids[-1] if ids else None


def is_type_item(s):
    """a typedef, a struct / union / enum definition or a forward declaration of a tag"""
    s = strip_comments(s).strip()
    if re.match(r'typedef\b', s): return True
    b = nobody(s)
    return bool(re.match(r'^(struct|union|enum)\s*\w*\s*\{\}\s*;$|^(struct|union|enum)\s+\w+\s*;$', b))


def type_names(s):
    """the names a type item defines: typedef names, tags with a body, enum constants"""
    s = strip_comments(s).strip()
    names = re.findall(r'\b(?:struct|union|enum)\s+(\w+)\s*\{', s)
    for body in re.findall(r'\benum\b[^{;]*\{([^{}]*)\}', s):
        names += [m.group(1) for m in (re.match(r'\s*(\w+)', x) for x in body.split(',')) if m]
    if re.match(r'typedef\b', s):
        b = nobody(s[len('typedef'):]).strip().rstrip(';')
        for p in split_top(b.split('{}')[-1] if '{}' in b else b):
            n = declarator_name(p)
            if n: names.append(n)
    return names


def typedef_map(text):
    """{name: type} of a simple typedef item (typedef unsigned char u8; typedef struct T {...} Name)"""
    s = strip_comments(text).strip()
    if not re.match(r'typedef\b', s): return {}
    b = nobody(s[len('typedef'):]).rstrip(';').strip()
    if '{}' in b:
        m = re.match(r'^(struct|union|enum)\s+(\w+)\s*\{\}\s*(\w+)$', b)
        return {m.group(3): m.group(2)} if m else {}
    n = declarator_name(b)
    if n and re.match(r'^[\w\s]*\b%s$' % re.escape(n), b): return {n: b[:b.rindex(n)].strip()}
    return {}


def decl_parts(s):
    """[(name, a declaration of just that name)] of an ordinary declaration (int a, *b; gives two)"""
    s0 = strip_comments(s).strip().rstrip(';').strip()
    parts = split_top(s0)
    n0 = declarator_name(nobody(parts[0]))
    if n0 is None: return []
    if len(parts) == 1: return [(n0, s0 + ';')]
    m = re.search(r'[\s*(]*\b%s\b' % re.escape(n0), parts[0])
    prefix = parts[0][:m.start()] + ' ' if m else ''
    out = [(n0, parts[0].strip() + ';')]
    for p in parts[1:]:
        n = declarator_name(nobody(p))
        if n: out.append((n, prefix + p.strip() + ';'))
    return out


def norm_type(s, tmap):
    toks = re.findall(r'\w+|\S', s)
    for _ in range(4):   # typedefs of typedefs
        out = []
        for t in toks:
            if t in ('struct', 'union', 'enum', 'extern', 'register'): continue
            out += re.findall(r'\w+|\S', tmap[t]) if t in tmap and tmap[t] != t else [t]
        if out == toks: break
        toks = out
    s = squash(' '.join(toks))
    for a, b in (('unsigned int', 'unsigned'), ('signed int', 'int'), ('short int', 'short'), ('long int', 'long'),
                 ('signed short', 'short'), ('signed long', 'long')):
        s = re.sub(r'\b%s\b' % a, b, s)
    return s


def norm_param(p, tmap):
    p = squash(p)
    if p in ('void', '...', ''): return p
    p = re.sub(r'\(\*\w+\)', '(*)', p)
    arr = re.search(r'(\[[^\]]*\])+$', p)
    if arr: p = p[:arr.start()]
    toks = re.findall(r'\w+|\S', p)
    if len(toks) > 1 and IDENT.match(toks[-1]) and toks[-1] not in KEYWORDS and toks[-1] not in tmap \
            and toks[-2] not in ('struct', 'union', 'enum'):
        toks = toks[:-1]
    return norm_type(' '.join(toks) + ('*' if arr else ''), tmap)


def norm_decl(s, name, tmap):
    """a declaration of name as a canonical string: name as @, no parameter names, typedefs resolved"""
    s = strip_comments(s).strip().rstrip(';').strip()
    s = re.sub(r'^\s*(extern|static)\b', '', s)
    m = re.search(r'\b%s\s*\(' % re.escape(name), s)
    if m:
        o = m.end() - 1; d = 0; c = o
        for c in range(o, len(s)):
            d += {'(': 1, ')': -1}.get(s[c], 0)
            if d == 0: break
        ps = [norm_param(p, tmap) for p in split_top(s[o + 1:c])]
        ps = [] if ps == [''] else ps
        return norm_type(s[:m.start()], tmap) + ' @(' + ','.join(ps) + ')' + squash(s[c + 1:])
    return norm_type(rename(s, {name: '@'}), tmap)


WIDE = re.compile(r'^(?:const )?(?:int|unsigned|long|unsigned long|signed)$')


def call_params(ps):
    """a parameter list as the call code sees it: every pointer is 'ptr', every int-sized integer 'i32' (an int
    passed for a pointer is an error in Watcom, so the two stay apart)"""
    if ps in ('', 'void'): return ps
    return ','.join('ptr' if '*' in p else 'i32' if WIDE.match(p) else p for p in split_top(ps))


def compatible(a, b):
    """the calls / uses a file's view a of a name compiles to are the same under the module's view b: the same
    pragma, the same result (or a void one on the file's side: it does not use the result), and the same parameters
    as the call sees them (any pointer alike, any int-sized integer alike; an old-style `f()` against parameters
    that are all pointers or int-sized)"""
    if a == b: return True
    if a[1] != b[1]: return False
    ma = re.match(r'^(.*) @\((.*)\)$', a[0]); mb = re.match(r'^(.*) @\((.*)\)$', b[0])
    if not ma or not mb: return False
    (ra, pa), (rb, pb) = ma.groups(), mb.groups()
    conv = lambda r: [w for w in re.findall(r'__\w+', r) if w in CONV]
    if conv(ra) != conv(rb): return False
    ra, rb = (squash(re.sub(r'\b(%s)\b' % '|'.join(CONV), ' ', r)) for r in (ra, rb))
    if ra != rb and ra != 'void': return False
    pa, pb = call_params(pa), call_params(pb)
    if pa == pb: return True
    if '' in (pa, pb):
        ps = pb if pa == '' else pa
        return all(p in ('ptr', 'i32') for p in ps.split(',')) or ps == 'void'
    return False


# ---- one C file -----------------------------------------------------------------------------------------------------

AUX = re.compile(r'^#\s*pragma\s+aux\s+(\(\s*\w+\s*\)\s*)?(\w+)(\s*=)?(\s*"[^"]*")?')


class CFile:
    def __init__(self, path, k):
        self.path, self.k = path, k
        self.items = scan(open(path).read())
        # #define X Y before the include, #undef X after it: the header's X is hidden from this file
        self.hides = OrderedDict()
        inc = [i for i, it in enumerate(self.items) if it.kind == 'pp' and re.match(r'#\s*include\b', it.text)]
        first_inc = inc[0] if inc else 0
        undefs = {}
        for i, it in enumerate(self.items):
            m = re.match(r'#\s*undef\s+(\w+)', it.text) if it.kind == 'pp' else None
            if m and i > first_inc: undefs.setdefault(m.group(1), i)
        drop = set()
        for i, it in enumerate(self.items[:first_inc]):
            m = re.match(r'#\s*define\s+(\w+)\s+(\w+)\s*$', strip_comments(it.text).strip()) if it.kind == 'pp' else None
            if m and m.group(1) in undefs:
                self.hides[m.group(1)] = m.group(2); drop |= {i, undefs[m.group(1)]}
        self.items = [it for i, it in enumerate(self.items) if i not in drop]
        for it in self.items:
            if it.kind == 'func':
                h = strip_comments(it.text[:it.text.index('{')])
                m = re.match(r'^(.*?)\b([A-Za-z_]\w*)\s*\(', h, re.S)
                it.name, it.head = (m.group(2), squash(h)) if m else (None, None)
        self.classify()

    def funcs(self):
        return [(it.name, it) for it in self.items if it.kind == 'func' and it.name]

    def classify(self):
        """the file's types, macros, ordinary declarations and pragmas"""
        self.types, self.macros, self.decls, self.pragmas, self.tmap = {}, {}, OrderedDict(), {}, {}
        self.uses = set()
        for it in self.items:
            s = strip_comments(it.text).strip()
            if it.kind == 'pp':
                m = re.match(r'#\s*define\s+(\w+)', s); a = AUX.match(s)
                if m: it.cls = 'macro'; self.macros[m.group(1)] = squash(s)
                elif re.match(r'#\s*(undef|include)\b', s): it.cls = 'skip'
                elif a: it.cls = 'pragma'; self.pragmas[a.group(2)] = s   # the last one counts
                else: it.cls = 'other'
            elif it.kind == 'decl':
                if is_type_item(it.text):
                    ns = type_names(it.text)
                    it.cls = 'type' if ns else 'other'
                    for n in ns: self.types[n] = squash(it.text)
                    self.tmap.update(typedef_map(it.text))
                else:
                    it.cls = 'decl'
                    for n, t in decl_parts(it.text): self.decls[n] = t
            if it.kind == 'func' or it.cls in ('macro', 'decl'): self.uses |= idents(it.text)

    def apply(self, m):
        if not m: return
        for it in self.items:
            it.text = rename(it.text, m)
            if it.kind == 'func' and it.name:
                it.name = m.get(it.name, it.name); it.head = squash(rename(it.head, m))
        self.classify()


def header_info():
    """the header's declarations {name: text}, simple typedefs {name: type} and type / macro names"""
    decls, tmap, names = {}, {}, set()
    for h in sorted(glob.glob(os.path.join(INC, '*.h'))):
        for it in scan(open(h, errors='replace').read()):
            if it.kind == 'pp':
                m = re.match(r'#\s*define\s+(\w+)', it.text)
                if m: names.add(m.group(1))
            elif it.kind == 'decl':
                if is_type_item(it.text):
                    names.update(type_names(it.text)); tmap.update(typedef_map(it.text))
                else:
                    for n, t in decl_parts(it.text): decls.setdefault(n, t)
    return decls, tmap, names


# ---- the module -----------------------------------------------------------------------------------------------------

def build(files, only=None):
    """(module text, [(addr, name, file)] in address order, notes on the aliases and renames)"""
    hdecls, htmap, hnames = header_info()
    cfs = [CFile(f, k) for k, f in enumerate(files)]
    # the functions in address order; a function defined in two files is taken once
    cands = OrderedDict()
    for cf in cfs:
        for name, it in cf.funcs():
            if only and name not in only: continue
            cands.setdefault(name, []).append((cf, it))
    funcs = []
    for name, cs in cands.items():
        if len(cs) > 1:
            cs.sort(key=lambda c: (name not in cc.file_blocks(c[0].path), os.path.basename(c[0].path) != name + '.c',
                                   c[0].k))
        cf, it = cs[0]
        asm = cc.c_paths(cf.path, name)[2]
        addr = cc.label_addr(asm, name)
        if addr is None: sys.stderr.write('%s (%s): no asm label, left out\n' % (name, cf.path)); continue
        # a split function (permute.pieces) was defined where its other piece is, not its entry: Watcom moves the entry
        # next to the function that falls into it and leaves the rest in place (SayClip_body before SayClip, and
        # ControlsDlgInGame_side after ClearCtlBlink, with the entry back after MenuP1ControlsInGame)
        ps = [a for a in (cc.label_addr(asm, p) for p in permute.pieces(cf.path, name)) if a is not None]
        at = min(ps) if ps else addr
        funcs.append((at, addr, name, cf, it))
    funcs.sort(key=lambda x: x[:2])
    funcs = [(addr, name, cf, it) for at, addr, name, cf, it in funcs]
    first = OrderedDict()
    for addr, name, cf, it in funcs: first.setdefault(cf, addr)
    cfs = list(first)   # the files that give a function, by their first function's address
    md = {name: cf for _, name, cf, _ in funcs}   # the functions the module defines -> their file
    notes = []

    def type_pass():
        """a type / macro that files define differently, or that a file uses for something else (or the header
        defines): every file but the largest group of one definition gets its own copy renamed"""
        defs = OrderedDict()
        for cf in cfs:
            for n, t in list(cf.types.items()) + list(cf.macros.items()): defs.setdefault(n, OrderedDict())[cf] = t
        maps = {cf: {} for cf in cfs}
        for n, by in defs.items():
            groups = OrderedDict()
            for cf, t in by.items(): groups.setdefault(t, []).append(cf)
            if len(groups) == 1 and n not in hnames and not any(n in cf.uses for cf in cfs if cf not in by): continue
            keep = None if (n in hnames or any(n in cf.uses for cf in cfs if cf not in by)) else \
                max(groups, key=lambda t: len(groups[t]))
            for t, g in groups.items():
                if t != keep:
                    for cf in g: maps[cf][n] = '%s__t%d' % (n, g[0].k)
        for cf in cfs:
            if maps[cf]:
                cf.apply(maps[cf])
                notes.append('%s: renamed %s' % (os.path.basename(cf.path), ', '.join('%s -> %s' % kv for kv in sorted(maps[cf].items()))))
        return any(maps.values())

    for _ in range(3):
        if not type_pass(): break

    # functions and globals: each file's view of each name
    names = OrderedDict()
    for cf in cfs:
        for n in list(cf.decls) + list(cf.pragmas): names[n] = 1
    for n in md: names[n] = 1
    for cf in cfs:
        for n in cf.hides:
            if any(n in c.uses for c in cfs): names[n] = 1
    aliases = {cf: {} for cf in cfs}
    canon_decl, canon_pragma, hide, alias_lines = OrderedDict(), OrderedDict(), [], []
    for n in names:
        views = OrderedDict()   # cf -> (normalized declaration, normalized pragma, declaration, pragma)
        for cf in cfs:
            defn = [it for nm, it in cf.funcs() if nm == n]
            if not (defn or n in cf.decls or n in cf.pragmas or n in cf.uses): continue
            tm = dict(htmap, **cf.tmap)
            if defn: text = defn[0].head + ';'
            elif n in cf.decls: text = cf.decls[n]
            elif n in hdecls and n not in cf.hides: text = hdecls[n]
            else: text = 'int %s();' % n   # used without a declaration
            p = cf.pragmas.get(n)
            views[cf] = (norm_decl(text, n, tm), squash(rename(p, {n: '@'})) if p else None, text, p)
        if not views: continue
        if n in md:
            canon = views[md[n]]
        elif n in hdecls:
            canon = (norm_decl(hdecls[n], n, htmap), None, hdecls[n], None)
        else:
            groups = OrderedDict()
            for cf, v in views.items(): groups.setdefault(v[:2], []).append(cf)
            canon = views[max(groups.values(), key=len)[0]]
        for cf, v in views.items():
            if compatible(v[:2], canon[:2]): continue
            a = '%s__m%d' % (n, cf.k); aliases[cf][n] = a
            alias_lines.append(rename(v[2], {n: a}))
            if v[3]:
                pr = rename(v[3], {n: a}); m = AUX.match(pr)
                if not m.group(3) and not m.group(4): pr = pr[:m.end(2)] + ' "%s"' % n + pr[m.end(2):]
                alias_lines.append(pr)
            else:
                cls = next((c for c in CONV if re.search(r'\b%s\b' % c, v[2])), None)
                alias_lines.append('#pragma aux %s%s "%s";' % ('(%s) ' % cls if cls else '', a, n))
            notes.append('%s: %s -> %s (its view: %s%s; the module: %s%s)' % (
                os.path.basename(cf.path), n, a, v[0], ' ' + v[1] if v[1] else '', canon[0],
                ' ' + canon[1] if canon[1] else ''))
        if n in md:
            if n in hdecls and norm_decl(hdecls[n], n, htmap) != canon[0]: hide.append(n)
            canon_decl[n] = None   # the definition's head, after the renames below
        elif n not in hdecls:
            canon_decl[n] = canon[2]
        if canon[3]: canon_pragma[n] = canon[3]
    for cf in cfs:
        cf.apply(aliases[cf])
    type_pass()   # a macro body can differ now (an alias in one file)

    out = ['/* module_try: %s */' % ', '.join(os.path.relpath(cf.path, ROOT) for cf in cfs)]
    out += ['#define %s %s_decl' % (n, n) for n in hide]
    out.append('#include "nhl95.h"')
    out += ['#undef %s' % n for n in hide]
    seen = set()

    def emit(text):
        text = text.strip()
        if not text.endswith(';') and not text.startswith('#'): text += ';'
        if squash(text) not in seen: seen.add(squash(text)); out.append(text)
    for cf in cfs:   # types, macros and other directives in each file's order
        for it in cf.items:
            if it.cls in ('type', 'macro', 'other'): emit(it.text)
    for n, t in canon_decl.items(): emit(t if t is not None else dict(md[n].funcs())[n].head + ';')
    for t in alias_lines: emit(t)
    for n, t in canon_pragma.items(): emit(t)
    for addr, name, cf, it in funcs:
        out += [''] + it.lead + [it.text]
    return '\n'.join(out) + '\n', [(addr, name, cf.path) for addr, name, cf, it in funcs], notes


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('stem', nargs='?', default='', help='segment stem(s), comma-separated')
    ap.add_argument('--files', help='more C files, comma-separated (e.g. from the segment before)')
    ap.add_argument('--only'); ap.add_argument('--keep')
    ap.add_argument('-v', '--verbose', action='store_true', help='list the aliases and renames')
    a = ap.parse_args()
    os.chdir(ROOT)
    files = []
    for st in [s for s in a.stem.split(',') if s]:
        files += sorted(glob.glob(os.path.join('src', 'c', st, '*.c')))
    for f in (a.files.split(',') if a.files else []):
        f = os.path.relpath(os.path.abspath(f), ROOT)
        if f not in files: files.append(f)
    if not files: raise SystemExit('no C files')
    text, funcs, notes = build(files, set(a.only.split(',')) if a.only else None)
    used = list(OrderedDict((f, 1) for _, _, f in funcs))
    stem = a.stem.split(',')[0] if a.stem else os.path.basename(os.path.dirname(files[0]))
    work = tempfile.mkdtemp(prefix='module_')
    try:
        mod = os.path.join(work, stem.split('_', 2)[-1][:8].upper() + '.c'); open(mod, 'w').write(text)
        if a.keep:
            os.makedirs(os.path.dirname(os.path.abspath(a.keep)), exist_ok=True); open(a.keep, 'w').write(text)
        items = [(mod, mod[:-2] + '.obj', '')] + [(f, os.path.join(work, 'own%d.obj' % i), '') for i, f in enumerate(used)]
        oks = cc.compile_parallel(items, 8)
        if not oks[0]: raise SystemExit('the module file does not compile (--keep it to look)')
        own = {f: (o if ok else None) for (f, o, _), ok in zip(items[1:], oks[1:])}
        print('%-24s %6s  %-28s %s' % ('function', 'addr', 'own file', 'module file'))
        only_mod, broken = [], []
        for addr, name, f in funcs:
            def res(obj, src):
                if obj is None: return 'no compile', False
                try:
                    s = permute.score(src, obj, name, f)
                    return ('MATCH' if s[2] else '%d differing (%+d)' % (s[0], s[1])), s[2]
                except (SystemExit, Exception) as e:
                    return 'error: %s' % str(e)[:40], False
            r1, ok1 = res(own[f], f); r2, ok2 = res(mod[:-2] + '.obj', mod)
            print('%-24s %06X  %-28s %s' % (name, addr, r1, r2))
            if ok2 and not ok1: only_mod.append('%s (%s)' % (name, os.path.basename(f)))
            if ok1 and not ok2: broken.append('%s (%s)' % (name, os.path.basename(f)))
        print('module-only matches: %s' % (', '.join(only_mod) or 'none'))
        print('broken in the module: %s' % (', '.join(broken) or 'none'))
        if a.verbose:
            for l in notes: print('  ' + l)
        elif notes: print('%d aliases / renames (-v lists them)' % len(notes))
    finally:
        shutil.rmtree(work, ignore_errors=True)


if __name__ == '__main__':
    main()
