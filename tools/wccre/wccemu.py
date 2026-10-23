#!/usr/bin/env python3
"""wccemu.py - run a Watcom 10.x wcc386 (the CF program inside WCC386.EXE) in the unicorn CPU emulator.

  python3 tools/wccre/wccemu.py [--exe WCC386.EXE] [--root DIR] [--] ARGS...      e.g.  -- S000.C

No DOSBox, no DOS/4GW: tools/wccre/cf_load.py loads the program, and the int 21h services it calls through its
loader stub (base+0x2FE03 in 10.0 GA: `push ebp / call fword [handler] / pop ebp / ret`) are done here in Python,
with the semantics of the OS/2 loader in the same EXE (tools/wccre/lx_load.py; its dispatcher table lists the
only functions the program can use). Files resolve case-insensitively under --root, which is the DOS drive C:.
Memory from the allocator (AH=48h) is zero-filled, like OS/2's DosAllocMem and a freshly booted DOSBox.

Other tools import WccEmu and add hooks (tools/wccre/regdump.py) to watch the compiler work."""
import argparse, os, struct, sys, time
import unicorn as U
from unicorn import x86_const as X
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(os.path.dirname(HERE))
sys.path.insert(0, HERE)
import cf_load

GDT = 0x1000
INFO = 0x10000          # program name, arguments, environment, start struct
STACK_LO, STACK_HI = 0x100000, 0x300000
BASE = 0x400000         # the CF image
HEAP_LO, HEAP_HI = 0x1000000, 0x9000000

# per compiler: (int 21h stub, exit retf) as image offsets; found from the startup code (tools/wccre/NOTES.md)
STUBS = {
    0x80E30: (0x2FE03, 0x2FE01),   # 10.0 GA
}


def gdt_entry(base, limit, access, flags):
    e = (limit & 0xFFFF) | ((base & 0xFFFFFF) << 16) | ((access & 0xFF) << 40) | (((limit >> 16) & 0xF) << 48)
    e |= ((flags & 0xF) << 52) | (((base >> 24) & 0xFF) << 56)
    return struct.pack('<Q', e)


class Exit(Exception):
    pass


class WccEmu:
    def __init__(self, exe, root, args, env=None, cwd='', fill=None, heap_skew=0, heap_align=0x10000):
        """fill: a byte for memory the program gets without loading it (the allocator's blocks, the stack, the
        image tail past the file data) instead of zeros, to find reads of memory the compiler never set"""
        self.fill = fill
        self.heap_skew = heap_skew          # heap_skew / heap_align move the allocator's blocks (address tests)
        self.heap_align = heap_align
        self.trace_dos = False
        h, mem, rel = cf_load.load(exe, BASE)
        self.hdr, self.image = h, bytes(mem)
        if h['size'] not in STUBS:
            raise SystemExit('wccemu: unknown compiler image (size %#x); add its stub offsets to STUBS' % h['size'])
        self.int21_at, self.exit_at = (BASE + x for x in STUBS[h['size']])
        uc = self.uc = U.Uc(U.UC_ARCH_X86, U.UC_MODE_32)
        uc.mem_map(0, 0x100000)             # GDT, info area (page 0 stays unmapped below)
        uc.mem_map(STACK_LO, STACK_HI - STACK_LO)
        uc.mem_map(BASE, (len(mem) + 0xFFFF) & ~0xFFFF)
        uc.mem_map(HEAP_LO, HEAP_HI - HEAP_LO)
        uc.mem_write(BASE, bytes(mem))
        if fill is not None:
            uc.mem_write(BASE + h['size'], bytes([fill]) * (len(mem) - h['size']))
            uc.mem_write(STACK_LO, bytes([fill]) * (STACK_HI - STACK_LO))
        uc.mem_write(GDT, b'\0' * 8 + gdt_entry(0, 0xFFFFF, 0x9A, 0xC) + gdt_entry(0, 0xFFFFF, 0x92, 0xC))
        uc.reg_write(X.UC_X86_REG_GDTR, (0, GDT, 3 * 8 - 1, 0))
        uc.hook_add(U.UC_HOOK_CODE, self._int21, begin=self.int21_at, end=self.int21_at)
        uc.hook_add(U.UC_HOOK_CODE, self._exit, begin=self.exit_at, end=self.exit_at)
        uc.hook_add(U.UC_HOOK_MEM_UNMAPPED | U.UC_HOOK_MEM_PROT, self._fault)
        self.start(root, args, env, cwd)

    def start(self, root, args, env=None, cwd=''):
        """set up a run of the program. A second start() on the same WccEmu is the next program of one DOSBox
        session: the image's file data is loaded again (its startup clears BSS), and everything else (the
        allocator's blocks, the stack, the image tail) keeps what the previous run left there"""
        uc, h = self.uc, self.hdr
        self.root = os.path.abspath(root)
        self.cwd = cwd                      # DOS path below C:\ ('' = root)
        self.stdout = bytearray()
        self.files = {}                     # handle -> python file
        self.next_handle = 5
        self.heap = HEAP_LO + self.heap_skew
        self.exit_code = None
        self.fault = None
        uc.mem_write(BASE, self.image[:h['size']])
        for r in (X.UC_X86_REG_SS, X.UC_X86_REG_DS, X.UC_X86_REG_ES, X.UC_X86_REG_FS, X.UC_X86_REG_GS):
            uc.reg_write(r, 0x10)
        # start block, as the OS/2 loader builds it
        env = env if env is not None else {'PATH': 'C:\\', 'INCLUDE': 'C:\\INC', 'DOS4G': 'QUIET'}
        envb = b''.join(('%s=%s' % kv).encode() + b'\0' for kv in env.items()) + b'\0'
        prog = b'C:\\WCC386.EXE\0'
        argb = ' '.join(args).encode() + b'\0\0'
        p_env = INFO; p_prog = p_env + len(envb); p_args = p_prog + len(prog)
        p_flag = (p_args + len(argb) + 15) & ~15; p_start = p_flag + 16; p_loader = p_start + 32
        uc.mem_write(p_env, envb + prog + argb)
        uc.mem_write(p_start, struct.pack('<5I', p_prog, p_args, p_env, p_flag, 0))
        esp = STACK_HI - 0x100
        uc.reg_write(X.UC_X86_REG_ESP, esp)
        uc.reg_write(X.UC_X86_REG_EAX, 0x100)          # ah = 1: OS/2
        uc.reg_write(X.UC_X86_REG_EBX, BASE | 0x08)    # load base, low word = cs
        uc.reg_write(X.UC_X86_REG_ECX, p_loader)
        uc.reg_write(X.UC_X86_REG_EDX, 0)              # the handler offset: never called (hooked)
        uc.reg_write(X.UC_X86_REG_EDI, p_start)
        uc.reg_write(X.UC_X86_REG_ESI, BASE + h['entry'])
        uc.reg_write(X.UC_X86_REG_EBP, 0)
        uc.reg_write(X.UC_X86_REG_EFLAGS, 0x202)

    # ---------------------------------------------------------------- helpers
    def r(self, reg): return self.uc.reg_read(reg)
    def w(self, reg, v): self.uc.reg_write(reg, v & 0xFFFFFFFF)

    def cstr(self, addr, n=260):
        b = bytes(self.uc.mem_read(addr, n))
        return b[:b.index(0)].decode('latin-1') if 0 in b else b.decode('latin-1')

    def host(self, dos, create=False):
        """DOS path -> host path under root (case-insensitive), or None"""
        p = dos.replace('/', '\\')
        if len(p) >= 2 and p[1] == ':':
            p = p[2:]
        parts = [x for x in (p.split('\\') if p.startswith('\\') else self.cwd.split('\\') + p.split('\\')) if x and x != '.']
        cur = self.root
        for k, part in enumerate(parts):
            if part == '..':
                cur = os.path.dirname(cur) if cur != self.root else cur; continue
            try:
                names = os.listdir(cur)
            except OSError:
                return None
            hit = [n for n in names if n.upper() == part.upper()]
            if hit:
                cur = os.path.join(cur, hit[0])
            elif create and k == len(parts) - 1:
                cur = os.path.join(cur, part)
            else:
                return None
        return cur

    def ok(self):
        self.flags(cf=False)

    def err(self, code):
        self.w(X.UC_X86_REG_EAX, code); self.flags(cf=True)

    def flags(self, cf):
        f = self.r(X.UC_X86_REG_EFLAGS)
        self.w(X.UC_X86_REG_EFLAGS, (f | 1) if cf else (f & ~1))

    # ---------------------------------------------------------------- hooks
    def _exit(self, uc, addr, size, _):
        self.exit_code = self.r(X.UC_X86_REG_EAX)
        uc.emu_stop()

    def _fault(self, uc, access, addr, size, value, _):
        self.fault = 'memory fault: access %d at %#x (eip %#x, image +%#x)' % (
            access, addr, self.r(X.UC_X86_REG_EIP), self.r(X.UC_X86_REG_EIP) - BASE)
        return False

    def _int21(self, uc, addr, size, _):
        eax = self.r(X.UC_X86_REG_EAX)
        ah, al = (eax >> 8) & 0xFF, eax & 0xFF
        fn = getattr(self, 'dos_%02X' % ah, None)
        if self.trace_dos:
            sys.stderr.write('int21 ah=%02X al=%02X ebx=%x ecx=%x edx=%x\n' % (
                ah, al, self.r(X.UC_X86_REG_EBX), self.r(X.UC_X86_REG_ECX), self.r(X.UC_X86_REG_EDX)))
        if fn is None:
            self.fault = 'int 21h AH=%02Xh not emulated (caller %#x)' % (ah, struct.unpack('<I', uc.mem_read(self.r(X.UC_X86_REG_ESP), 4))[0] - BASE)
            uc.emu_stop(); return
        fn(al)
        esp = self.r(X.UC_X86_REG_ESP)
        ret = struct.unpack('<I', uc.mem_read(esp, 4))[0]
        self.w(X.UC_X86_REG_ESP, esp + 4)
        self.w(X.UC_X86_REG_EIP, ret)

    # ---------------------------------------------------------------- int 21h
    def _file(self):
        return self.files.get(self.r(X.UC_X86_REG_EBX) & 0xFFFF)

    def _open(self, path, mode):
        try:
            f = open(path, mode)
        except OSError:
            return None
        h = self.next_handle; self.next_handle += 1
        self.files[h] = f
        return h

    def dos_3C(self, al):       # create: edx name, cx attributes -> eax handle
        p = self.host(self.cstr(self.r(X.UC_X86_REG_EDX)), create=True)
        h = self._open(p, 'w+b') if p else None
        if h is None: return self.err(3)
        self.w(X.UC_X86_REG_EAX, h); self.ok()

    def dos_3D(self, al):       # open: al mode, edx name -> eax handle
        p = self.host(self.cstr(self.r(X.UC_X86_REG_EDX)))
        if p is None or not os.path.isfile(p): return self.err(2)
        h = self._open(p, {0: 'rb', 1: 'r+b', 2: 'r+b'}.get(al & 3, 'rb'))
        if h is None: return self.err(5)
        self.w(X.UC_X86_REG_EAX, h); self.ok()

    def dos_3E(self, al):       # close: bx
        h = self.r(X.UC_X86_REG_EBX) & 0xFFFF
        f = self.files.pop(h, None)
        if f: f.close()
        self.ok()

    def dos_3F(self, al):       # read: bx, ecx count, edx buffer -> eax
        h = self.r(X.UC_X86_REG_EBX) & 0xFFFF
        n = self.r(X.UC_X86_REG_ECX)
        if h == 0:
            data = b''
        else:
            f = self.files.get(h)
            if f is None: return self.err(6)
            data = f.read(n)
        self.uc.mem_write(self.r(X.UC_X86_REG_EDX), data)
        self.w(X.UC_X86_REG_EAX, len(data)); self.ok()

    def dos_40(self, al):       # write: bx, ecx count (0 = truncate), edx buffer -> eax
        h = self.r(X.UC_X86_REG_EBX) & 0xFFFF
        n = self.r(X.UC_X86_REG_ECX)
        data = bytes(self.uc.mem_read(self.r(X.UC_X86_REG_EDX), n)) if n else b''
        if h in (1, 2):
            self.stdout += data
        else:
            f = self.files.get(h)
            if f is None: return self.err(6)
            if n == 0: f.truncate()
            else: f.write(data)
        self.w(X.UC_X86_REG_EAX, n); self.ok()

    def dos_41(self, al):       # delete: edx name
        p = self.host(self.cstr(self.r(X.UC_X86_REG_EDX)))
        if p is None or not os.path.isfile(p): return self.err(2)
        os.remove(p); self.ok()

    def dos_42(self, al):       # seek: al whence, bx, ecx:dx offset -> eax position, dx high word
        f = self._file()
        if f is None: return self.err(6)
        off = ((self.r(X.UC_X86_REG_ECX) << 16) + (self.r(X.UC_X86_REG_EDX) & 0xFFFF)) & 0xFFFFFFFF
        if off & 0x80000000: off -= 1 << 32
        pos = f.seek(off, al)
        self.w(X.UC_X86_REG_EAX, pos)
        self.w(X.UC_X86_REG_EDX, (self.r(X.UC_X86_REG_EDX) & ~0xFFFF) | (pos >> 16))
        self.ok()

    def dos_44(self, al):       # ioctl al=0: device info of bx -> edx (80h = character device)
        if al != 0: return self.err(1)
        h = self.r(X.UC_X86_REG_EBX) & 0xFFFF
        if h not in (0, 1, 2) and h not in self.files: return self.err(6)
        self.w(X.UC_X86_REG_EDX, 0x80 if h in (0, 1, 2) else 0); self.ok()

    def dos_48(self, al):       # allocate ebx bytes -> eax (zero-filled, 64K aligned like DosAllocMem)
        n = self.r(X.UC_X86_REG_EBX)
        at = (self.heap + self.heap_align - 1) & ~(self.heap_align - 1)
        if at + n > HEAP_HI: return self.err(8)
        self.heap = at + n
        if self.fill is not None:
            self.uc.mem_write(at, bytes([self.fill]) * n)
        self.w(X.UC_X86_REG_EAX, at); self.ok()

    def _dta(self, dta, path):
        """fill a DOS DTA (attribute +15h, time +16h, date +18h, size +1Ah, name +1Eh) for a host file"""
        st = os.stat(path)
        t = time.localtime(st.st_mtime)
        ftime = (t.tm_hour << 11) | (t.tm_min << 5) | (t.tm_sec // 2)
        fdate = ((t.tm_year - 1980) << 9) | (t.tm_mon << 5) | t.tm_mday
        attr = 0x10 if os.path.isdir(path) else 0x20
        name = os.path.basename(path).upper().encode()[:12] + b'\0'
        self.uc.mem_write(dta + 0x15, struct.pack('<BHHI', attr, ftime, fdate, st.st_size if attr == 0x20 else 0) + name)

    def dos_4E(self, al):       # find first: edx pattern, ecx attributes, ebx DTA (dword +0 = search handle)
        import fnmatch
        dta = self.r(X.UC_X86_REG_EBX)
        pat = self.cstr(self.r(X.UC_X86_REG_EDX)).replace('/', '\\')
        d, _, name = pat.rpartition('\\')
        hd = self.host(d + '\\' if d or pat.startswith('\\') else '') if d or pat.startswith('\\') else self.host('')
        hits = []
        if hd and os.path.isdir(hd):
            hits = sorted(os.path.join(hd, n) for n in os.listdir(hd) if fnmatch.fnmatch(n.upper(), name.upper()))
            if not self.r(X.UC_X86_REG_ECX) & 0x10:
                hits = [h for h in hits if os.path.isfile(h)]
        if not hits:
            self.uc.mem_write(dta, struct.pack('<i', -1)); return self.err(2)
        self.searches = getattr(self, 'searches', {})
        sh = len(self.searches) + 1
        self.searches[sh] = hits[1:]
        self.uc.mem_write(dta, struct.pack('<I', sh))
        self._dta(dta, hits[0]); self.ok()

    def dos_4F(self, al):       # find next (al = 0) or close the search (al != 0): edx DTA
        dta = self.r(X.UC_X86_REG_EDX)
        sh = struct.unpack('<i', self.uc.mem_read(dta, 4))[0]
        rest = getattr(self, 'searches', {}).get(sh)
        if al != 0:
            getattr(self, 'searches', {}).pop(sh, None); return self.ok()
        if not rest:
            return self.err(18)
        self._dta(dta, rest.pop(0)); self.ok()

    def dos_60(self, al):       # full name of edx into ebx (ecx bytes), as DosQueryPathInfo level 5
        p = self.cstr(self.r(X.UC_X86_REG_EDX)).replace('/', '\\')
        if len(p) >= 2 and p[1] == ':': p = p[2:]
        parts = p.split('\\') if p.startswith('\\') else self.cwd.split('\\') + p.split('\\')
        out = []
        for x in parts:
            if x in ('', '.'): continue
            if x == '..':
                if out: out.pop()
            else: out.append(x)         # DOSBox keeps the spelling (C:\INC\nhl95.h)
        full = ('C:\\' + '\\'.join(out)).encode() + b'\0'
        if len(full) > self.r(X.UC_X86_REG_ECX): return self.err(111)
        self.uc.mem_write(self.r(X.UC_X86_REG_EBX), full); self.ok()

    def dos_19(self, al):       # current drive (the OS/2 loader returns DosQueryCurrentDisk's 1-based number)
        self.w(X.UC_X86_REG_EAX, 3); self.ok()

    def dos_47(self, al):       # current directory of drive dl into esi
        self.uc.mem_write(self.r(X.UC_X86_REG_ESI), self.cwd.encode() + b'\0'); self.ok()

    def dos_2A(self, al):       # date: fixed (1 June 1994, a Wednesday)
        self.w(X.UC_X86_REG_EAX, (self.r(X.UC_X86_REG_EAX) & ~0xFF) | 3)
        self.w(X.UC_X86_REG_ECX, (self.r(X.UC_X86_REG_ECX) & ~0xFFFF) | 1994)
        self.w(X.UC_X86_REG_EDX, (self.r(X.UC_X86_REG_EDX) & ~0xFFFF) | (6 << 8) | 1)
        self.ok()

    def dos_2C(self, al):       # time: fixed 12:00:00.00
        self.w(X.UC_X86_REG_ECX, (self.r(X.UC_X86_REG_ECX) & ~0xFFFF) | (12 << 8))
        self.w(X.UC_X86_REG_EDX, self.r(X.UC_X86_REG_EDX) & ~0xFFFF)
        self.ok()

    # ---------------------------------------------------------------- run
    def run(self, max_seconds=60):
        t = time.time()
        try:
            self.uc.emu_start(BASE + self.hdr['entry'], 0, timeout=int(max_seconds * 1e6))
        except U.UcError as e:
            if not self.fault:
                self.fault = 'unicorn: %s at eip %#x (image +%#x)' % (e, self.r(X.UC_X86_REG_EIP), self.r(X.UC_X86_REG_EIP) - BASE)
        self.seconds = time.time() - t
        for f in self.files.values():
            f.close()
        self.files.clear()
        if self.fault:
            raise SystemExit('wccemu: ' + self.fault)
        if self.exit_code is None:
            raise SystemExit('wccemu: did not exit (timeout?) at eip %#x' % self.r(X.UC_X86_REG_EIP))
        return self.exit_code


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--exe', default=os.path.join(ROOT, 'tools/watcom/dosga/WCC386.EXE'))
    ap.add_argument('--root', default='.')
    ap.add_argument('--trace-dos', action='store_true')
    ap.add_argument('args', nargs='*')
    a = ap.parse_args()
    emu = WccEmu(a.exe, a.root, a.args)
    emu.trace_dos = a.trace_dos
    code = emu.run()
    sys.stdout.write(emu.stdout.decode('latin-1').replace('\r', ''))
    sys.stderr.write('exit %d, %.2fs\n' % (code, emu.seconds))
    sys.exit(code)


if __name__ == '__main__':
    main()
