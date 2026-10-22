#!/usr/bin/env python3
"""c_progress.py - matched-functions tracker for the C decompilation.

  python3 tools/c_progress.py            rewrites tools/c_functions.csv and C_PROGRESS.md

Status of each src/c/<seg>/<Func>.c:
  matched      the asm block is wrapped in %ifdef CBUILD / %include (cc.py mark): `make` builds it from C and the
               sha1 check proves it byte-identical
  nonmatching  a C file without the marker (work in progress or does not match yet); say why in the notes column
Library segments (is_lib) are not counted. Rows with status asm come from tools/handasm.csv (run tools/find_handasm.py first): hand-written asm, skipped by
the C queue, not counted. The notes column of tools/c_functions.csv is kept across runs (edit it by hand), and so is the cause column of
the drafts (tools/draft_causes.py). The denominator is the number of
compiled-C functions in each segment: labels whose code starts with the wcc386 stack-check prologue
(push N / call __CHK). Hand-written asm (no __CHK) is not counted. The matched count is the number of those
labels whose address lies inside a marked block (a function defined in two C files counts once; a matched helper
without __CHK, like AttDbPtr2, does not count)."""
import os, re, sys, csv, glob
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
import cc
CSV = os.path.join(ROOT, 'tools/c_functions.csv'); MD = os.path.join(ROOT, 'C_PROGRESS.md')

# Library segments (SEGMENT_AGENT.md "Libraries"): Watcom CRT, DOS/4GW glue, EACSNDF, sound/video drivers, EA libraries,
# CMV player / CD stream / zone manager. They stay asm: not in the C queue, not in the denominator.
LIB = re.compile(r'^\d+_[0-9A-F]+_(watcom_|clib_|dos4gw_|ea_|eacsndf|snd_|vesa_|vga_blitters|video_bios_vga|input_keyboard|'
                 r'input_mouse|input_joystick_misc|cmv_player|cdstream|zonemgr)')

def is_lib(stem):
    return bool(LIB.match(stem))

def c_functions(asm):
    """{label: address} of the labels in a segment whose first instructions are push N / call __CHK"""
    out = {}; L = open(asm).read().split('\n')
    for k, l in enumerate(L):
        m = cc.LABEL.match(l)
        if m and not m.group(1).startswith('.'):
            ins = [(x.split(';')[0].strip(), cc.ADDR.search(x).group(1)) for x in L[k + 1:k + 4] if cc.ADDR.search(x)]
            if len(ins) >= 2 and ins[0][0].startswith('push dword') and ins[1][0] == 'call __CHK':
                out[m.group(1)] = int(ins[0][1], 16)
    return out

def main():
    notes = {}; causes = {}
    if os.path.exists(CSV):
        for r in csv.DictReader(open(CSV)):
            if r['status'] == 'asm': continue
            f0 = r['function'].split()[0] if r['function'] else ''
            key = r['c_file'] if os.path.splitext(os.path.basename(r['c_file']))[0] == f0 else '%s:%s' % (r['c_file'], f0)
            notes[key] = r['notes']; causes[key] = r.get('cause') or ''
    rows = []
    for src in sorted(glob.glob(os.path.join(ROOT, 'src/c/*/*.c'))):
        stem, fil, asm, inc = cc.c_paths(src)
        rel = os.path.relpath(src, ROOT)
        body = re.sub(r'/\*.*?\*/', '', open(src).read(), flags=re.S)
        defs = re.findall(r'^[A-Za-z_][\w \t\*]*?\b([A-Za-z_]\w*)\s*\([^;{]*\)\s*\{', body, flags=re.M) or [fil]
        addr = {}
        for d in defs:
            addr[d] = cc.label_addr(cc.c_paths(src, d)[2], d)
        left = list(defs)
        for g in cc.file_blocks(src):          # marked blocks: matched (with the functions that fall through inside)
            s, e, labs, _ = cc.block(src, g)
            grp = [d for d in defs if addr[d] is not None and s <= addr[d] < e]
            left = [d for d in left if d not in grp]
            key = rel if g == fil else '%s:%s' % (rel, g)
            rows.append(dict(function=' '.join(grp) or g, address='%05X' % s, size=e - s, segment=stem, c_file=rel,
                             status='matched', notes=notes.get(key, notes.get(rel, '') if g == fil else ''), cause=''))
        for d in left:                          # not marked: drafts
            try: s, e = cc.asm_range(src, d)
            except Exception: s, e = 0, 0
            key = rel if d == fil else '%s:%s' % (rel, d)
            rows.append(dict(function=d, address='%05X' % s, size=e - s, segment=stem, c_file=rel,
                             status='nonmatching', notes=notes.get(key, notes.get(rel, '') if d == fil else ''),
                             cause=causes.get(key, '')))
    work = [r for r in rows]
    asmrows = []                                # hand-written asm (tools/find_handasm.py): the C queue skips these
    HA = os.path.join(ROOT, 'tools/handasm.csv')
    if os.path.exists(HA):
        for r in csv.DictReader(open(HA)):
            if r['status'] == 'asm':
                asmrows.append(dict(function=r['function'], address=r['address'], size=int(r['size']), segment=r['segment'],
                                    c_file='', status='asm', notes='find_handasm %s: %s' % (r['confidence'], r['signals']), cause=''))
    rows = work + asmrows
    with open(CSV, 'w', newline='') as f:
        w = csv.DictWriter(f, fieldnames=['function', 'address', 'size', 'segment', 'c_file', 'status', 'notes', 'cause'])
        w.writeheader(); w.writerows(rows)
    segs = {}; libs = {}; chk = {}              # segment -> __CHK function count; game segment -> {label: address}
    for asm in sorted(glob.glob(os.path.join(ROOT, 'src/cseg01/*.asm'))):
        st = os.path.basename(asm)[:-4]; fs = c_functions(asm)
        if not fs: continue
        if is_lib(st): libs[st] = len(fs)
        else: segs[st] = len(fs); chk[st] = fs
    nlib = sum(libs.values())
    m = [r for r in rows if r['status'] == 'matched']
    nd = sum(r['status'] == 'nonmatching' for r in rows)
    tot = sum(segs.values())
    blocks = [(int(r['address'], 16), int(r['address'], 16) + r['size']) for r in m]
    done = {st: [l for l, a in fs.items() if any(s <= a < e for s, e in blocks)] for st, fs in chk.items()}
    nmatch = sum(len(v) for v in done.values())
    out = ['# C decompilation progress', '',
           'Generated by `tools/c_progress.py` (do not edit; notes go in `tools/c_functions.csv`). Workflow: [docs/C_MATCHING.md](docs/C_MATCHING.md).', '',
           'Reference compiler: **Watcom C/C++32 10.0 GA** `wcc386` (`tools/watcom/dosga`, the `make` default). 10.0 LA, the reference until 2026-10-22, is kept as a fallback: `make WATCOM_VER=la` (the matched C is tuned for GA; see [BUILD_NOTES.md](BUILD_NOTES.md) section 2 and docs/C_MATCHING.md "The compiler").', '',
           '**%d / %d** compiled-C game functions matched (%.1f%%), %d bytes of code. %d non-matching drafts.' %
           (nmatch, tot, 100.0 * nmatch / tot if tot else 0, sum(r['size'] for r in m), nd), '',
           'Library segments stay asm and are not counted: %d more `__CHK` functions in %s (%d compiled-C functions in the EXE in all).'
           % (nlib, ', '.join('`%s` %d' % (st, n) for st, n in libs.items()), tot + nlib), '',
           '%d functions (%d bytes) are hand-written asm (status `asm`, from `tools/find_handasm.py`): they stay asm and the C queue skips them. '
           'They have no __CHK prologue, so they are not in the denominator.' % (len(asmrows), sum(r['size'] for r in asmrows)), '',
           '| segment | matched | C functions | bytes matched |', '|---|---:|---:|---:|']
    for st, n in segs.items():
        mm = [r for r in m if r['segment'] == st]
        if mm or done[st]: out.append('| %s | %d | %d | %d |' % (st, len(done[st]), n, sum(r['size'] for r in mm)))
    out.append('| other segments | 0 | %d | 0 |' % sum(n for st, n in segs.items()
                                                         if not done[st] and not any(r['segment'] == st for r in m)))
    out += ['', '## Functions', '', '| function(s) | address | bytes | status | C file | notes |', '|---|---|---:|---|---|---|']
    for r in sorted(rows, key=lambda r: r['address']):
        cf = '[%s](%s)' % (os.path.basename(r['c_file']), r['c_file']) if r['c_file'] else ''
        out.append('| %s | %s | %d | %s | %s | %s |' % (r['function'], r['address'], r['size'], r['status'], cf, r['notes']))
    open(MD, 'w').write('\n'.join(out) + '\n')
    print('%d game functions matched, %d nonmatching drafts, %d game C functions (+%d library, not counted), %d hand-asm (skipped)'
          % (nmatch, nd, tot, nlib, len(asmrows)))

if __name__ == '__main__':
    main()
