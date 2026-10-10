/* Speech: open a speech bank file (VIV) and read its sample directory. */
#include "nhl95.h"

#define BANKD(off) (*(int *)((char *)speechbank + (off)))
#define BANKW(off) (*(short *)((char *)speechbank + (off)))
/* a field of the speech slot at byte offset off (slot number * 26h) */
#define SLOTD(off, f) (*(int *)((char *)speechbank + (off) + (f)))
/* the same, offset first (Watcom orders the address operands by it) */
#define OFFD(off, f) (*(int *)((off) + (char *)speechbank + (f)))
#define SLOTB(off, f) (*((char *)speechbank + (off) + (f)))
#define DBL(x) (*(double *)&(x))

unsigned _dos_open(const char *path, unsigned mode, int *fh);  /* Watcom CRT _dos_open_ */

/* DRAFT (OpenSpeechBank): same size; left: two header words' stack slots (declaration orders tried, 400 of 5040),
   the first ReadBE24 store goes [edx+edi] where the EXE moves the value to edx, and the type byte is in dx, EXE ax. */
/* OpenSpeechBank (83897) - PC only: open the speech bank file path (unless it is the one already open, name at
   +3B80h, open flag +3B78h, handle +3B7Ch) and read its big-endian header: three words (+3B8Dh, the sample count
   +3B8Fh, +3B91h), then per sample its file offset (+12h), length (+1Ah) and name. For each sample it reads the
   2-byte type at the offset: 'G' samples have their size at offset+6 (less 5 header bytes) and play time
   size * C37B0 / C37C0; others use the length and size * C37B0 / C37B8 - 1Ah. Slots after the last sample are
   cleared (ClearSpeechSlot, 400 slots). n goes to +3B70h; the byte (+3B6Ch) and loaded (+3B74h) counts are reset. */
void OpenSpeechBank(char *path, int n)
{
    int i;
    int size;
    short w3;
    short nsamples;
    unsigned got;
    int fh;
    short w1;
    int type;
    int off;
    int pos;
    unsigned short c;
    int cnt;

    if (speechinit == 0) return;
    if (BANKD(0x3B78) != 0) {
        if (StrEqNoCase(path, (char *)speechbank + 0x3B80)) return;
        _dos_close(BANKD(0x3B7C));
    }
    _dos_open(path, 0, &fh);
    strncpy((char *)speechbank + 0x3B80, path, 13);
    BANKD(0x3B7C) = fh;
    BANKD(0x3B70) = n;
    BANKD(0x3B78) = 1;
    BANKD(0x3B6C) = 0;
    BANKD(0x3B74) = 0;
    _dos_read(fh, &w1, 2, &got);
    BANKW(0x3B8D) = Swap16(w1);
    _dos_read(fh, &nsamples, 2, &got);
    cnt = Swap16(nsamples);
    BANKW(0x3B8F) = cnt;
    _dos_read(fh, &w3, 2, &got);
    BANKW(0x3B91) = Swap16(w3);
    for (i = 0; i < BANKD(0x3B8F) >> 16; i++) {
        off = i * 0x26;
        OFFD(off, 0xE) = 0;
        SLOTD(off, 0x12) = ReadBE24(fh);
        OFFD(off, 0x1A) = ReadBE24(fh);
        ReadCString((char *)speechbank + off, fh);
        OFFD(off, 0x22) = 0;
    }
    for (i = 0; i < BANKD(0x3B8F) >> 16; i++) {
        off = i * 0x26;
        pos = SLOTD(off, 0x12);
        lseek(fh, pos, 0);
        _dos_read(fh, &type, 2, &got);
        c = type & 0xFF;
        type = (unsigned short)type >> 8;
        if (c == 'G') {
            lseek(fh, pos + 6, 0);
            _dos_read(fh, &size, 2, &got);
            size = Swap16(size) - 5;
            SLOTD(off, 0x16) = size;
            SLOTD(off, 0x1E) = (unsigned)((unsigned)size * DBL(qword_C37B0) / DBL(qword_C37C0));
            SLOTB(off, 0xD) = 'G';
        } else {
            size = SLOTD(off, 0x1A);
            SLOTD(off, 0x16) = size;
            SLOTD(off, 0x1E) = (unsigned)((unsigned)size * DBL(qword_C37B0) / DBL(qword_C37B8)) - 0x1A;
            SLOTB(off, 0xD) = 0xFF;
        }
    }
    for (i = BANKD(0x3B8F) >> 16; i < 400; i++)
        ClearSpeechSlot((unsigned char *)speechbank + i * 0x26);
}

/* ReadSpeechSample (83BF3) - PC only: read sample n of the open bank (file offset +12h, packed length +1Ah) to
   the end of its room at addr (addr + size - length + 1388h), unpack it to addr (sub_98028), then undo the delta
   coding: each byte is the running sum of the bytes 5 further on (a 5-byte header is dropped). Returns the
   unpacked size less 5. */
int ReadSpeechSample(int n, int addr)
{
    int pos;
    int size;
    char *src;
    unsigned got;
    int fh;
    char *dst;
    int len;
    int cnt;
    char acc;
    int i;

    len = SLOTD(n * 0x26, 0x1A);
    fh = BANKD(0x3B7C);
    pos = SLOTD(n * 0x26, 0x12);
    size = SLOTD(n * 0x26, 0x16);
    dst = _os_handle_3(addr);
    src = &dst[size - len + 5000];
    lseek(fh, pos, 0);
    _dos_read(fh, src, len, &got);
    cnt = sub_98028(src, dst, len);
    acc = 0;
    for (i = 0; i < cnt - 5; i++) {
        dst[i] = dst[i + 5] + acc;
        acc += dst[i + 5];
    }
    return cnt - 5;
}

/* MoveSampleMem (840A9) - PC only: copy n bytes of speech memory from handle address src to dst, in pieces of at
   most speechcopylen bytes through the low-memory buffer speechcopybuf (_os_handle_3 gives each linear address). */
void MoveSampleMem(int dst, int src, unsigned n)
{
    unsigned part;
    void *p;

    while (n != 0) {
        if (n > speechcopylen) part = speechcopylen;
        else part = n;
        p = _os_handle_3(src);
        _fmemmove((void *)speechcopybuf, p, part);
        p = _os_handle_3(dst);
        _fmemmove(p, (void *)speechcopybuf, part);
        src += part;
        dst += part;
        n -= part;
    }
}

/* CompactSpeechSlot (84125) - PC only: move the sample of slot n down to the end of slot dst - 1 (the memory start
   for slot 0, +3B64h), swap the two slot records, give slot dst the new address and mark slot n not loaded. */
void CompactSpeechSlot(int dst, int n)
{
    SpeechSlot tmp;
    int addr;
    int src;
    int off;

    src = SLOTD(n * 0x26, 0xE);
    if (dst == 0) addr = BANKD(0x3B64);
    else addr = SLOTD((dst - 1) * 0x26, 0xE) + SLOTD((dst - 1) * 0x26, 0x16);
    off = n * 0x26;
    MoveSampleMem(addr, src, *(int *)((char *)speechbank + off + 0x16));
    tmp = speechbank[dst];
    speechbank[dst] = *(SpeechSlot *)((char *)speechbank + off);
    *(SpeechSlot *)((char *)speechbank + off) = tmp;
    SLOTD(dst * 0x26, 0xE) = addr;
    SLOTD(off, 0x22) = 0;
}
