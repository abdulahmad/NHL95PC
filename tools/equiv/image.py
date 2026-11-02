#!/usr/bin/env python3
"""Retail image loader for the functional-equivalence harness (FUNCTIONAL_PLAN.md, "How the check works" item 1).

  img = load('HOCKEY.EXE')      # objects flat at their linear bases, internal fixups applied
  img.read(lin, n); img.fixups; img.labels(); img.map_into(uc)

Fixups: tools/le_parse.py already decodes every record to a linear source and target. Handled kinds:
  7 (32-bit offset): dword = target object base + target offset. This is the only kind in HOCKEY.EXE
     (26809 records, all internal, none import).
  5 (16-bit offset): low word of the target address.  2 (16-bit selector): FAKE_SEL.
  6 (16:32 pointer): dword offset + word FAKE_SEL.  Not present in the retail EXE; kept for completeness.
Selectors are never real here: the flat model has no segment registers in play, so any selector is FAKE_SEL.
Fixups straddling a page end appear twice in le_parse (same linear source); the write is idempotent.

labels(): name -> linear address from src/inc/symbols.inc (cross-segment symbols, includes data), plus
every non-local label in src/cseg01/*.asm whose next line carries a `; <hexaddr>` comment (docs/C_MATCHING.md).
cdiff.load_labels needs `make` output (build/obj), which may be absent, so it is not used.
"""
import os, re, sys, glob
ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
sys.path.insert(0, os.path.join(ROOT, 'tools'))
import le_parse   # already decodes fixups to linear form, so rebuild_exe's parse_fixup_records is not needed

FAKE_SEL = 0x0008
PAGE = 0x1000

class Obj:
    def __init__(self, num, base, size, flags, data):
        self.num, self.base, self.size, self.flags, self.bytes = num, base, size, flags, data

class Image:
    def __init__(self, objects, fixups):
        self.objects, self.fixups = objects, fixups   # fixups: {src_lin: (kind, target_lin)}
        self._labels = None

    def _obj(self, lin, n=1):
        for o in self.objects:
            if o.base <= lin and lin + n <= o.base + o.size: return o
        raise ValueError('%#x+%d not inside one object' % (lin, n))

    def read(self, lin, n):
        o = self._obj(lin, n)
        return bytes(o.bytes[lin - o.base:lin - o.base + n])

    def map_into(self, uc):
        from unicorn import UC_PROT_ALL
        for o in self.objects:
            sz = (o.size + PAGE - 1) & ~(PAGE - 1)
            uc.mem_map(o.base, sz, UC_PROT_ALL)
            uc.mem_write(o.base, bytes(o.bytes))

    def labels(self):
        if self._labels is None:
            lab = {}
            for ln in open(os.path.join(ROOT, 'src/inc/symbols.inc')):
                m = re.match(r';\s+([0-9A-F]+)\s+(\S+)\s+\S+\.asm\s+\d+', ln)
                if m: lab[m.group(2)] = int(m.group(1), 16)
            for f in sorted(glob.glob(os.path.join(ROOT, 'src/cseg01/**/*.asm'), recursive=True)):
                prev = None
                for ln in open(f, errors='replace'):
                    m = re.match(r'[^;\s]+[^;]*\t; ([0-9A-F]+)\s*$', ln)
                    if prev and m: lab.setdefault(prev, int(m.group(1), 16))
                    prev = None
                    m = re.match(r'([A-Za-z_]\w*):\s*$', ln)
                    if m: prev = m.group(1)
            self._labels = lab
        return self._labels

def load(exe='HOCKEY.EXE'):
    if not os.path.isabs(exe) and not os.path.exists(exe): exe = os.path.join(ROOT, exe)
    info, fx, d = le_parse.parse(exe)
    objs = []
    for o in info['objects']:
        buf = bytearray(o['virtual_size'])
        for p in o['pages']:
            n = min(p['size'], o['virtual_size'] - (p['linear'] - o['base']))
            buf[p['linear'] - o['base']:p['linear'] - o['base'] + n] = d[p['file_off']:p['file_off'] + n]
        objs.append(Obj(o['num'], o['base'], o['virtual_size'], o['flags'], buf))
    img = Image(objs, {})
    for f in fx:
        k, s, t = f['type'], f['src_lin'], f['tgt_lin']
        o = img._obj(s, 2 if k in (2, 5) else 4)
        i = s - o.base
        if k == 7:   o.bytes[i:i + 4] = (t & 0xFFFFFFFF).to_bytes(4, 'little')
        elif k == 5: o.bytes[i:i + 2] = (t & 0xFFFF).to_bytes(2, 'little')
        elif k == 2: o.bytes[i:i + 2] = FAKE_SEL.to_bytes(2, 'little')
        elif k == 6: o.bytes[i:i + 6] = (t & 0xFFFFFFFF).to_bytes(4, 'little') + FAKE_SEL.to_bytes(2, 'little')
        else: raise SystemExit('unsupported fixup kind %d at %#x' % (k, s))
        img.fixups[s] = (k, t)
    return img

def selftest():
    from unicorn import Uc, UC_ARCH_X86, UC_MODE_32, UC_HOOK_CODE, UC_PROT_ALL
    from unicorn.x86_const import UC_X86_REG_EIP, UC_X86_REG_ESP, UC_X86_REG_EAX, UC_X86_REG_EDX
    import struct
    img = load(); lab = img.labels(); ok = True
    def chk(name, cond, extra=''):
        nonlocal ok; ok &= bool(cond); print('%s %s %s' % ('PASS' if cond else 'FAIL', name, extra))
    code = img.objects[0]; lo, hi = code.base, code.base + code.size
    for fn, addr in (('SetSPA', 0x59D9A), ('SeriesLength', 0x42221), ('FadePalette', 0x11598)):
        b = img.read(addr, 10)
        tgt = (addr + 10 + struct.unpack_from('<i', b, 6)[0]) & 0xFFFFFFFF
        chk('a prologue ' + fn, lab.get(fn) == addr and b[0] == 0x68 and b[5] == 0xE8 and lo <= tgt < hi
            and tgt == lab['__CHK'], '%s label=%#x call->%#x' % (b[:6].hex(), lab.get(fn, 0), tgt))
    # (b) a 32-bit fixup inside SeriesLength: the loaded dword must equal the fixup target
    f = [s for s, (k, t) in img.fixups.items() if lab['SeriesLength'] <= s < lab['SeriesLength'] + 116 and k == 7]
    chk('b fixup in SeriesLength', f and all(struct.unpack('<I', img.read(s, 4))[0] == img.fixups[s][1] for s in f),
        ', '.join('%#x->%#x' % (s, img.fixups[s][1]) for s in f[:3]))
    # (c) run SetSPA in Unicorn: eax = struct ptr (data object), dx = new value, stack with a sentinel return
    uc = Uc(UC_ARCH_X86, UC_MODE_32); img.map_into(uc)
    STK, RET, CHK = 0x7F00000, 0x7E00000, lab['__CHK']
    uc.mem_map(STK, 0x10000, UC_PROT_ALL); uc.mem_map(RET, 0x1000, UC_PROT_ALL); uc.mem_write(RET, b'\xf4')
    esp = STK + 0x8000 - 4; uc.mem_write(esp, struct.pack('<I', RET))
    obj = img.objects[1].base + 0x1000
    uc.reg_write(UC_X86_REG_ESP, esp); uc.reg_write(UC_X86_REG_EAX, obj - 0x10); uc.reg_write(UC_X86_REG_EDX, 0x1234)
    def hook(u, a, sz, ud):   # __CHK no-op: return to caller, dropping the pushed argument (ret addr + 4)
        sp = u.reg_read(UC_X86_REG_ESP); u.reg_write(UC_X86_REG_EIP, struct.unpack('<I', u.mem_read(sp, 4))[0])
        u.reg_write(UC_X86_REG_ESP, sp + 8)
    uc.hook_add(UC_HOOK_CODE, hook, begin=CHK, end=CHK)
    try:
        uc.emu_start(lab['SetSPA'], RET, count=100); fault = ''
    except Exception as e: fault = str(e)
    chk('c run SetSPA to ret', not fault and uc.reg_read(UC_X86_REG_EIP) == RET, fault)
    print('ALL PASS' if ok else 'FAILED'); return ok

if __name__ == '__main__':
    if '--selftest' in sys.argv: sys.exit(0 if selftest() else 1)
    im = load()
    for o in im.objects: print('obj%d base=%#x size=%#x flags=%#x' % (o.num, o.base, o.size, o.flags))
    print('fixups applied:', len(im.fixups), ' labels:', len(im.labels()))
