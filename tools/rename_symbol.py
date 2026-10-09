#!/usr/bin/env python3
"""rename_symbol.py - rename one label or equate consistently across src/, rebuild, and record the name.

  python3 tools/rename_symbol.py OLD NEW [--evidence TEXT] [--source-game 93G] [--source-file logic93_5.asm]
                                 [--file94 checks94.asm] [--other-names TEXT] [--confidence high] [--method manual-trace]
                                 [--no-record] [--no-build] [--dry-run]
  python3 tools/rename_symbol.py --batch renames.txt [same options]
        one rename per line: OLD NEW [{key=value,...}] [evidence text ...]; a line starting with '#' is a comment.
        {...} overrides the command-line options for that line only: source_game, source_file, file94, other_names,
        confidence, method, no_record (e.g. {source_game=PC-new,confidence=medium} or {no_record} for an IDA sub_
        label that is really a shared epilogue tail). All renames are applied in order,
        then one build; a failure anywhere restores everything. Use it for the many loc_ -> .local renames.

What it does
  1. Builds the tree first (make): the rename starts from a MATCHing build, and the old address comes from build/obj.
  2. Checks NEW: a NASM identifier, not an instruction or register (nasm is asked), not defined anywhere in src/
     (labels, locals, equates in src/inc). A name that differs from an existing one only in case is a warning.
  3. Replaces OLD as a whole token in every src/**/*.asm and src/inc/*.inc file (code, global/extern lists and
     comments; never inside an ';IDA:' note). OLD.local references follow the rename (NEW.local).
     NEW starting with '.' makes OLD a NASM local label of the global label above it: references in that scope
     become .NEW, all others parent.NEW; it leaves the global list unless another file uses it.
  4. When OLD is the IDA name of the address (name_map_94.csv ida_name, not an auto name) the definition line gets
     ';IDA: OLD', as in the Genesis repos.
  5. Records the name so the maps stay in step with src/:
       function entry in cseg01 (sub_ name, or a name_map_94.csv row) -> tools/manual_names.csv + name_map_94.csv
                                                                          (the same row matcher.py would merge)
       label in dseg02 (data / BSS)                                    -> tools/global_map.csv
       equate in src/inc/structs.inc                                   -> tools/struct_fieldmap.csv (genesis_field)
       other code labels (loc_, jpt_ ... and locals)                    -> nothing (they live in src/ only)
     A function rename needs --evidence (what the routine does / which Genesis routine it matches), unless --no-record.
  NEW of the form BASE+k / BASE-k (k decimal, 0x.. or ..h) folds an alias label into an expression: OLD must be
     a bare label line at BASE's address + k in the same file (e.g. the Watcom -5r label dword_E03BA = regd0-2, or a
     table's second column word_C90E2 = dirtab+2). Every use becomes BASE+k, the OLD label line is removed (the bytes
     stay), the global/extern lists follow, and a tools/global_map.csv row for OLD is dropped.
  6. make again: it must print MATCH, else every file is restored and the exit status is 1. Then src/inc/symbols.inc
     is regenerated (tools/update_symbols.py).
Needs the same as make: nasm, python3, your HOCKEY.EXE."""
import os, re, sys, csv, io, argparse, subprocess, tempfile
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
import update_symbols as US
from link_src import read_layout
SRC = os.path.join(ROOT, 'src')
IDC = r'A-Za-z0-9_$#@~?'
IDENT = re.compile(r'^[A-Za-z_?][A-Za-z0-9_$#@~?.]*$')
LOCAL = re.compile(r'^\.[A-Za-z0-9_$#@~?][A-Za-z0-9_$#@~?.]*$')
AUTO = re.compile(r'^(sub|loc|locret|nullsub|j_sub|unk|off|asc|byte|word|dword|qword|tbyte|jpt|stru|algn|flt|dbl)_[0-9A-F]+$')
LABEL_DEF = re.compile(r'^([A-Za-z_?][A-Za-z0-9_$#@~?.]*):')
LOCAL_DEF = re.compile(r'^(\.[A-Za-z0-9_$#@~?.]+):')
LINE_OPTS = ('source_game', 'source_file', 'file94', 'other_names', 'confidence', 'method', 'no_record')
FOLD = re.compile(r'^([A-Za-z_?][A-Za-z0-9_$#@~?]*)([+-](?:[0-9]+|0[xX][0-9A-Fa-f]+|[0-9][0-9A-Fa-f]*[hH]))$')
EQU_DEF = re.compile(r'^\s*([A-Za-z_?.][A-Za-z0-9_$#@~?.]*)\s+equ\b', re.I)

def ident(n):
    """the assembler-safe form gen_src gave a listing name (same rule as fixup_labels.ident)"""
    n = n.strip()
    n = n.split('(')[0].split()[-1].replace('::', '__') if '::' in n else n.split(' ')[0]
    n = re.sub(r'[^A-Za-z0-9_@$?]', '_', n)
    return '_' + n if n and n[0].isdigit() else n

def die(msg): sys.exit('rename_symbol: ' + msg)

def tok(name):
    return re.compile(r'(?<![%s.])%s(?![%s])' % (IDC, re.escape(name), IDC))

def sub_code(text, rx, new):
    """replace in each line, but not inside an ';IDA:' note"""
    out = []
    for ln in text.split('\n'):
        i = ln.find(';IDA:')
        out.append(rx.sub(new, ln) if i < 0 else rx.sub(new, ln[:i]) + ln[i:])
    return '\n'.join(out)

def make():
    # the link step checks the sha1 and fails (removing the EXE) on a mismatch, so success == MATCH
    r = subprocess.run(['make', '-s'], cwd=ROOT, capture_output=True, text=True)
    ok = r.returncode == 0 and os.path.exists(os.path.join(ROOT, 'build/HOCKEY.EXE')) and 'MISMATCH' not in r.stdout
    return ok, r.stdout[-1500:] + r.stderr[-1500:]

def nasm_name_ok(name):
    """a bare NAME line must be read as an (orphan) label, not as an instruction/prefix/register"""
    with tempfile.TemporaryDirectory() as td:
        p = os.path.join(td, 't.asm'); open(p, 'w').write('bits 32\nsection s progbits\n%s\n' % name)
        r = subprocess.run(['nasm', '-f', 'elf32', '-l', os.path.join(td, 't.lst'), p, '-o', os.path.join(td, 't.o')], capture_output=True, text=True)
        lst = open(os.path.join(td, 't.lst')).read() if os.path.exists(os.path.join(td, 't.lst')) else ''
        return r.returncode == 0 and 'label alone on a line' in r.stderr and not re.search(r'^\s+3 [0-9A-F]{8} ', lst, re.M)

def defined_names(texts):
    """every name defined in src/: global labels, full names of locals, equates"""
    names = {}
    for f, t in texts.items():
        parent = None
        for ln in t.split('\n'):
            m = LABEL_DEF.match(ln)
            if m: parent = m.group(1); names.setdefault(m.group(1), f); continue
            m = LOCAL_DEF.match(ln)
            if m and parent: names.setdefault(parent + m.group(1), f); continue
            m = EQU_DEF.match(ln)
            if m: names.setdefault(m.group(1) if not m.group(1).startswith('.') or not parent else parent + m.group(1), f)
    return names

def read_csv(path):
    raw = open(path, newline='').read()
    return list(csv.DictReader(io.StringIO(raw))), next(csv.reader(io.StringIO(raw)))

def write_csv(path, cols, rows):
    with open(path, 'w', newline='') as fh:
        w = csv.writer(fh); w.writerow(cols)
        for r in rows: w.writerow([r.get(c, '') for c in cols])

class Fail(Exception): pass

class Session:
    def __init__(self, a):
        self.a = a
        files = [os.path.join(SRC, s['src']) for s in read_layout()]
        files += sorted(os.path.join(SRC, 'inc', f) for f in os.listdir(os.path.join(SRC, 'inc')) if f.endswith('.inc') and f != 'symbols.inc')
        self.orig = {f: open(f).read() for f in files}
        self.texts = dict(self.orig)
        self.names = defined_names(self.texts)
        self.segs = read_layout()
        self.addr = {}
        if os.path.isdir(os.path.join(ROOT, 'build/obj')):
            try: self.addr = US.addresses(os.path.join(ROOT, 'build/obj'), self.segs)
            except Exception as e: print('warning: no addresses from build/obj (%s)' % e)
        self.nm_path = os.path.join(ROOT, 'name_map_94.csv')
        self.csvs = {}
        self.log = []

    def table(self, rel):
        p = os.path.join(ROOT, rel)
        if p not in self.csvs: rows, cols = read_csv(p); self.csvs[p] = [cols, rows, False]
        return self.csvs[p]

    def rename(self, old, new, evidence=None):
        a = self.a; texts = self.texts; names = self.names
        if old not in names: raise Fail('%s is not defined in src/ (labels, locals as parent.name, equates)' % old)
        deff = names[old]
        dlines = texts[deff].split('\n')
        di = next((i for i, l in enumerate(dlines) if l.startswith(old + ':') or (EQU_DEF.match(l) and EQU_DEF.match(l).group(1) == old)), None)
        if di is None: raise Fail('%s is a local label (parent.name); rename locals by hand in %s' % (old, os.path.relpath(deff, ROOT)))
        is_equ = not dlines[di].startswith(old + ':')
        fm = FOLD.match(new)
        if fm: return self.fold(old, fm.group(1), fm.group(2), deff, di, is_equ, evidence)
        local = new.startswith('.')
        parent = None
        if local:
            if is_equ: raise Fail('an equate cannot become a local label')
            if not LOCAL.match(new): raise Fail('%s is not a valid NASM local label' % new)
            parent = next((LABEL_DEF.match(dlines[i]).group(1) for i in range(di - 1, -1, -1) if LABEL_DEF.match(dlines[i])), None)
            if parent is None: raise Fail('no global label above %s to attach %s to' % (old, new))
            j = di + 1
            while j < len(dlines) and not LABEL_DEF.match(dlines[j]):
                if LOCAL_DEF.match(dlines[j]): raise Fail('%s has its own local labels (%s); it must stay a global label' % (old, dlines[j].split(':')[0]))
                j += 1
            full = parent + new
        else:
            if not IDENT.match(new): raise Fail('%s is not a valid NASM identifier' % new)
            if not nasm_name_ok(new): raise Fail('%s is an instruction, prefix or register name for nasm' % new)
            full = new
        if full in names: raise Fail('%s is already defined in %s' % (full, os.path.relpath(names[full], ROOT)))
        ci = [n for n in names if n.lower() == full.lower() and n != old]
        if ci: print('warning: %s differs only in case from %s' % (full, ', '.join(ci)))
        addr = self.addr.get(old)
        # ---- rewrite
        rx = tok(old); changed = []
        ext_users = [g for g in texts if g != deff and old in texts[g] and re.search(r'^extern .*' + rx.pattern, texts[g], re.M)]
        for f, t in texts.items():
            if old not in t or not rx.search(t): continue
            if not local:
                nt = sub_code(t, rx, new)
            else:
                ls = t.split('\n'); out = []; in_scope = False
                for i, ln in enumerate(ls):
                    if f != deff: out.append(sub_code(ln, rx, full)); continue
                    m = LABEL_DEF.match(ln)
                    if m: in_scope = (m.group(1) == parent)
                    if i == di: out.append(new + ':' + ln[len(old) + 1:]); continue
                    if ln.startswith('global '):
                        lst = [n.strip() for n in ln[7:].split(',')]
                        if old in lst:
                            lst = [full if n == old else n for n in lst] if ext_users else [n for n in lst if n != old]
                            if lst: out.append('global ' + ', '.join(lst))
                            continue
                    out.append(sub_code(ln, rx, new if in_scope and not ln.startswith(('global ', 'extern ')) else full))
                nt = '\n'.join(out)
            if nt != t: texts[f] = nt; changed.append(f)
        # names of locals under a renamed global follow it
        for n in [n for n in names if n.startswith(old + '.')]: names[full + n[len(old):]] = names.pop(n)
        names[full] = names.pop(old)
        if addr is not None: self.addr[full] = self.addr.pop(old)
        for n in [n for n in self.addr if n.startswith(old + '.')]: self.addr[full + n[len(old):]] = self.addr.pop(n)
        # ;IDA: note on the definition when OLD is the listing's name for this address
        nm_cols, nm_rows, _ = self.table('name_map_94.csv')
        nm_row = next((r for r in nm_rows if addr is not None and int(r['pc_address'], 16) == addr), None)
        if nm_row and ident(nm_row['ida_name']) == old and not AUTO.match(old) and not is_equ:
            t = texts[deff].split('\n')
            k = next(i for i, l in enumerate(t) if l.startswith(new + ':'))
            if ';IDA:' not in t[k]: t[k] = t[k] + '\t;IDA: ' + nm_row['ida_name']
            texts[deff] = '\n'.join(t)
        # ---- record
        seg = next((s for s in self.segs if addr is not None and s['start'] <= addr < s['end']), None)
        rec = ''
        if not a.no_record and not local:
            evidence = evidence or a.evidence
            if is_equ and deff.endswith('structs.inc'):
                cols, rows, _ = self.table('tools/struct_fieldmap.csv')
                for r in rows:
                    if r['genesis_field'] == old: r['genesis_field'] = new
                self.csvs[os.path.join(ROOT, 'tools/struct_fieldmap.csv')][2] = True; rec = 'tools/struct_fieldmap.csv'
            elif seg and seg['obj'] == 1 and (old.startswith('sub_') or (nm_row and nm_row['method'] != 'data')):
                if not evidence: raise Fail('%s: a function rename needs evidence (what it does / which Genesis routine it matches), or --no-record' % old)
                cols, rows, _ = self.table('tools/manual_names.csv')
                mr = next((r for r in rows if int(r['pc_address'], 16) == addr), None)
                if mr is None:
                    mr = {c: '' for c in cols}
                    if nm_row: mr.update({c: nm_row.get(c, '') for c in cols})
                    mr['pc_address'] = '%08X' % addr; rows.append(mr)
                if not mr.get('ida_name'): mr['ida_name'] = old if AUTO.match(old) else (nm_row or {}).get('ida_name', '')
                mr['proposed_name'] = new; mr['segment'] = mr.get('segment') or seg['module']
                for c, v in (('source_game', a.source_game), ('source_file', a.source_file), ('94_source_file', a.file94),
                             ('other_game_names', a.other_names), ('confidence', a.confidence), ('evidence', evidence)):
                    if v is not None: mr[c] = v
                if not mr.get('confidence') or mr['confidence'] == 'none': mr['confidence'] = 'high'
                if not mr.get('source_game'): mr['source_game'] = 'PC-new'
                mr['method'] = a.method
                rows.sort(key=lambda r: int(r['pc_address'], 16))
                self.csvs[os.path.join(ROOT, 'tools/manual_names.csv')][2] = True
                nrow = {c: mr.get(c, '') for c in nm_cols}      # the row matcher.py would merge
                nm_rows[:] = sorted([r for r in nm_rows if int(r['pc_address'], 16) != addr] + [nrow], key=lambda r: r['pc_address'])
                self.csvs[self.nm_path][2] = True; rec = 'tools/manual_names.csv, name_map_94.csv'
            elif seg and seg['obj'] == 2:
                cols, rows, _ = self.table('tools/global_map.csv')
                gr = next((r for r in rows if r['genesis_symbol'] == old and int(r['pc_address'], 16) == addr), None)
                if gr is None: gr = {'pc_address': '%X' % addr}; rows.append(gr)
                gr['genesis_symbol'] = new
                gr['evidence'] = evidence or gr.get('evidence') or 'named in src/ (%s)' % seg['module']
                self.csvs[os.path.join(ROOT, 'tools/global_map.csv')][2] = True; rec = 'tools/global_map.csv'
        self.log.append('%s -> %s%s: %d file(s)%s%s' % (old, full, ' (local %s)' % new if local else '', len(changed),
                        '' if addr is None else ', %05X %s' % (addr, seg['module'] if seg else '?'), ', recorded in ' + rec if rec else ''))

    def fold(self, old, base, off, deff, di, is_equ, evidence):
        """OLD is an alias of BASE+k (a Watcom -5r load label such as dword_E03BA = regd0-2, or dirtab+2):
        every use becomes the expression, the OLD label line goes, the bytes stay where they were."""
        texts = self.texts; names = self.names
        if is_equ: raise Fail('%s is an equate; fold only label aliases' % old)
        if base not in names: raise Fail('%s (the base of %s%s) is not defined; name the base first' % (base, base, off))
        if names[base] != deff: raise Fail('%s and %s are defined in different files' % (old, base))
        k = int(off[1:-1], 16) if off.lower().endswith('h') else int(off[1:], 0)
        k = -k if off[0] == '-' else k
        ao, ab = self.addr.get(old), self.addr.get(base)
        if ao is None or ab is None: raise Fail('no build/obj address for %s or %s; run make first' % (old, base))
        if ab + k != ao: raise Fail('%s is at %05X but %s%s is %05X' % (old, ao, base, off, ab + k))
        if texts[deff].split('\n')[di].split(';')[0].strip() != old + ':':
            raise Fail('%s: the definition line has more than the label; fold it by hand' % old)
        rx = tok(old); changed = []
        bad = [l.strip() for t in texts.values() for l in t.split('\n') if 'nosplit' in l and rx.search(l)]
        if bad: raise Fail('%s is used in a nosplit operand (%s); nasm ignores nosplit on [idx*s+sym+k], so give it its own name instead of folding' % (old, bad[0]))
        for f, t in texts.items():
            if not rx.search(t) and f != deff: continue
            out = []
            for i, ln in enumerate(t.split('\n')):
                if f == deff and i == di: continue                       # drop the alias label line
                if ln.startswith(('global ', 'extern ')):
                    kw = ln.split(' ', 1)[0]; lst = [n.strip() for n in ln[len(kw) + 1:].split(',')]
                    if old in lst:
                        lst = [n for n in lst if n != old]
                        if kw == 'extern' and not any(base in [m.strip() for m in l2[7:].split(',')] for l2 in t.split('\n') if l2.startswith('extern ')):
                            lst.append(base)
                        if kw == 'global' and base not in ' '.join(l2 for l2 in t.split('\n') if l2.startswith('global ')).replace(',', ' ').split():
                            lst.append(base)
                        if lst: out.append(kw + ' ' + ', '.join(lst))
                        continue
                out.append(sub_code(ln, rx, base + off))
            nt = '\n'.join(out)
            if nt != t: texts[f] = nt; changed.append(f)
        names.pop(old); self.addr.pop(old, None)
        rec = ''
        if not self.a.no_record:
            cols, rows, _ = self.table('tools/global_map.csv')
            n0 = len(rows); rows[:] = [r for r in rows if r['genesis_symbol'] != old]
            if len(rows) != n0: self.csvs[os.path.join(ROOT, 'tools/global_map.csv')][2] = True; rec = ' (its tools/global_map.csv row removed)'
        self.log.append('%s -> %s%s (alias folded, label line removed): %d file(s)%s' % (old, base, off, len(changed), rec))

    def commit(self):
        a = self.a
        newtexts = {f: t for f, t in self.texts.items() if t != self.orig[f]}
        dirty = {p: v for p, v in self.csvs.items() if v[2]}
        for l in self.log: print(l)
        print('files changed: %d source, %d tables' % (len(newtexts), len(dirty)))
        if a.dry_run: print('dry run: nothing written'); return
        backup = {f: self.orig[f] for f in newtexts}
        backup.update({p: open(p, newline='').read() for p in dirty})
        for f, t in newtexts.items(): open(f, 'w').write(t)
        for p, (cols, rows, _) in dirty.items(): write_csv(p, cols, rows)
        if a.no_build:
            print('not built (--no-build): run make, then tools/update_symbols.py'); return
        ok, log = make()
        if not ok:
            for f, t in backup.items(): open(f, 'w', newline='').write(t)
            make()
            die('the build after the rename does not MATCH; all files restored:\n' + log)
        open(US.INC, 'w').write(US.render(os.path.join(ROOT, 'build/obj')))
        print('MATCH after the rename; src/inc/symbols.inc updated')

def main():
    ap = argparse.ArgumentParser(description=__doc__.split('\n')[0])
    ap.add_argument('old', nargs='?'); ap.add_argument('new', nargs='?'); ap.add_argument('--batch')
    ap.add_argument('--evidence'); ap.add_argument('--source-game'); ap.add_argument('--source-file'); ap.add_argument('--file94')
    ap.add_argument('--other-names'); ap.add_argument('--confidence'); ap.add_argument('--method', default='manual-trace')
    ap.add_argument('--no-record', action='store_true'); ap.add_argument('--no-build', action='store_true'); ap.add_argument('--dry-run', action='store_true')
    a = ap.parse_args()
    pairs = []
    if a.batch:
        for k, ln in enumerate(open(a.batch), 1):
            ln = '' if ln.lstrip().startswith('#') else ln.strip()
            if not ln: continue
            p = ln.split(None, 2)
            if len(p) < 2: die('%s:%d: need OLD NEW [evidence]' % (a.batch, k))
            ev, opts = (p[2] if len(p) > 2 else None), {}
            if ev and ev.startswith('{'):
                if '}' not in ev: die('%s:%d: unclosed {options}' % (a.batch, k))
                body, ev = ev[1:].split('}', 1); ev = ev.strip() or None
                for kv in filter(None, (x.strip() for x in body.split(','))):
                    key, _, val = kv.partition('=')
                    key = key.strip().replace('-', '_')
                    if key not in LINE_OPTS: die('%s:%d: unknown option %s (use %s)' % (a.batch, k, key, ', '.join(LINE_OPTS)))
                    opts[key] = True if key == 'no_record' else val.strip()
            pairs.append((p[0], p[1], ev, opts))
    elif a.old and a.new: pairs = [(a.old, a.new, None, {})]
    else: ap.error('give OLD NEW or --batch FILE')
    if not a.no_build:
        ok, log = make()
        if not ok: die('the tree does not build to a MATCH before the rename; fix that first:\n' + log)
    S = Session(a)
    for old, new, ev, opts in pairs:
        saved = {key: getattr(a, key) for key in opts}
        for key, val in opts.items(): setattr(a, key, val)
        try: S.rename(old, new, ev)
        except Fail as e: die(str(e) + ('' if len(pairs) == 1 else ' (nothing written)'))
        for key, val in saved.items(): setattr(a, key, val)
    S.commit()

if __name__ == '__main__':
    main()
