#!/usr/bin/env python3
"""ghidra_wcc.py - decompile the whole wcc386 CF image with Ghidra (headless), at the emulator's load address.

  python3 tools/wccre/ghidra_wcc.py [--exe WCC386.EXE] [--out build/wccre/ghidra] [--ghidra DIR] [--java-home DIR]

The image is loaded at wccemu.BASE with its relocations applied, so Ghidra addresses are emulator addresses
(image offset = address - BASE). Function seeds: the entry point, every rel32 call target found by a linear sweep
that lands on a plausible function start, and every relocated dword that points into the code. Output:
OUT/all.c (every function, address order) and OUT/funcs.txt. Ghidra / JDK as in tools/ghidra_decomp.py."""
import argparse, glob, os, shutil, struct, subprocess, sys, tempfile
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(os.path.dirname(HERE))
sys.path.insert(0, HERE)
import cf_load, wccemu


def code_end(mem):
    """image offset where the code ends: the first 256-byte run that is almost all text or zeros (the strings
    of CONST follow _TEXT)"""
    for i in range(0, len(mem) - 256, 16):
        b = mem[i:i + 256]
        if sum(1 for c in b if 32 <= c < 127 or c == 0) > 0.9 * len(b) and b.count(0) < 0.5 * len(b):
            return i
    return len(mem)


def seeds(mem, rel, base, entry):
    """function starts: the entry, and relocated code pointers that either sit in data (function pointer tables)
    or land right after a ret (immediates such as a sort callback); jump table entries in code fail both"""
    end = code_end(mem)
    out = {base + entry}
    for off in rel:
        v = struct.unpack_from('<I', mem, off)[0] - base
        if not 0 <= v < end:
            continue
        if off >= end or mem[v - 1] == 0xC3 or (v >= 3 and mem[v - 3] == 0xC2):
            out.add(base + v)
    return sorted(out), end


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--exe', default=os.path.join(ROOT, 'tools/watcom/dosga/WCC386.EXE'))
    ap.add_argument('--out', default=os.path.join(ROOT, 'build/wccre/ghidra'))
    ap.add_argument('--ghidra', default=os.environ.get('GHIDRA_HOME') or (sorted(glob.glob(os.path.expanduser('~/tools/ghidra/ghidra_*'))) or [''])[-1])
    ap.add_argument('--java-home', default=os.environ.get('JAVA_HOME') or os.path.expanduser('~/tools/jdk21'))
    a = ap.parse_args()
    h, mem, rel = cf_load.load(a.exe, wccemu.BASE)
    img = bytes(mem[:h['size']])
    work = tempfile.mkdtemp(prefix='ghwcc_')
    try:
        open(os.path.join(work, 'wcc.bin'), 'wb').write(img)
        os.mkdir(os.path.join(work, 'proj'))
        s, end = seeds(img, rel, wccemu.BASE, h['entry'])
        open(os.path.join(work, 'seeds.txt'), 'w').write(''.join('%X\n' % x for x in s))
        print('code ends at image +%X; seeds %d' % (end, len(s)))
        env = dict(os.environ, JAVA_HOME=a.java_home)
        cmd = [os.path.join(a.ghidra, 'support', 'analyzeHeadless'), os.path.join(work, 'proj'), 'wcc',
               '-import', os.path.join(work, 'wcc.bin'), '-loader', 'BinaryLoader', '-loader-baseAddr', '0x%X' % wccemu.BASE,
               '-processor', 'x86:LE:32:default', '-cspec', 'gcc',
               '-scriptPath', os.path.join(ROOT, 'tools/ghidra'),
               '-postScript', 'WccDecomp.java', os.path.join(work, 'seeds.txt'), os.path.abspath(a.out),
               '-deleteProject']
        r = subprocess.run(cmd, env=env, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
        tail = [l for l in r.stdout.split('\n') if 'WccDecomp' in l or 'ERROR' in l]
        print('\n'.join(tail[-20:]))
        if r.returncode:
            raise SystemExit('analyzeHeadless exit %d' % r.returncode)
    finally:
        shutil.rmtree(work, ignore_errors=True)


if __name__ == '__main__':
    main()
