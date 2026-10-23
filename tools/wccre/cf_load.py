#!/usr/bin/env python3
"""cf_load.py - load the 32-bit program packed in a Watcom 10.x DOS/OS/2 tool (wcc386, wlink ...).

  python3 tools/wccre/cf_load.py WCC386.EXE [--base HEX] [--out IMAGE.bin]

A 10.x tool is an MZ stub, a small OS/2 LX loader (tools/wccre/lx_load.py) and the real program in Watcom's
"CF" format. Under DOS, W32RUN.EXE (a DOS/4GW program) loads it instead. The CF header sits at the MZ header
size (e_cparhdr * 16):

  +0  'CF' (dword 0x4643)     +4  file offset of the image     +8  image size in the file
  +C  relocation table offset in the image (applied after loading)
  +10 memory size to allocate  +14 entry point offset

The image is linked at 0. The relocation table is a list of runs: a word count (0 ends), a dword offset
(high word first), then count-1 word deltas; every offset in the run gets the load base added to its dword.
The loader starts the program at base + entry with ebx = base (low word = cs), ah = 1 (OS/2), edx = the
offset of a far-callable int 21h emulator (call fword cs:edx with DOS register conventions; carry = error),
ecx = a loader data pointer and edi = [program name, argument string, environment, flag pointer, 0]."""
import argparse, struct


def header(d):
    at = struct.unpack_from('<H', d, 8)[0] * 16
    sig, foff, size, reloc, mem, entry = struct.unpack_from('<6I', d, at)
    if sig != 0x4643:
        raise SystemExit('no CF header at %#x' % at)
    return dict(at=at, file_off=foff, size=size, reloc=reloc, mem=mem, entry=entry)


def relocations(img, reloc):
    """offsets (in the image) of the dwords that get the load base added"""
    out, i = [], reloc
    while True:
        cnt = struct.unpack_from('<H', img, i)[0]; i += 2
        if cnt == 0:
            return out
        hi, lo = struct.unpack_from('<HH', img, i); i += 4
        off = (hi << 16) | lo
        out.append(off)
        for _ in range(cnt - 1):
            off += struct.unpack_from('<H', img, i)[0]; i += 2
            out.append(off)


def load(path, base=0):
    """(header, memory image of hdr['mem'] bytes with the relocations applied for base, relocation offsets)"""
    d = open(path, 'rb').read()
    h = header(d)
    mem = bytearray(max(h['mem'], h['size']))
    mem[:h['size']] = d[h['file_off']:h['file_off'] + h['size']]
    rel = relocations(mem, h['reloc'])
    if base:
        for off in rel:
            v = (struct.unpack_from('<I', mem, off)[0] + base) & 0xFFFFFFFF
            struct.pack_into('<I', mem, off, v)
    return h, mem, rel


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('exe'); ap.add_argument('--base', default='0'); ap.add_argument('--out')
    a = ap.parse_args()
    h, mem, rel = load(a.exe, int(a.base, 16))
    print({k: hex(v) for k, v in h.items()}, 'relocations', len(rel))
    if a.out:
        open(a.out, 'wb').write(mem)


if __name__ == '__main__':
    main()
