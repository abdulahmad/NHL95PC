/* Speech: shut down, 24-bit reads, slot loading (one source block: the slot loaders end in ShutdownSpeech's and ReadBE24's exits). */
#include "nhl95.h"

#define BANKD(off) (*(int *)((char *)speechbank + (off)))

/* ShutdownSpeech (8363C) - PC only: when the speech system is up, remove the SpeechTimerTick timer handler,
   close the open bank file (flag +3B78h, handle +3B7Ch of speechbank), free the speech queue, the sample memory
   (+3B60h, sub_8D2F0), the bank and the request block, and clear speechinit. */
void ShutdownSpeech(void)
{
    if (speechinit != 0) {
        sub_8E4F8(SpeechTimerTick);
        if (BANKD(0x3B78) != 0) _dos_close(BANKD(0x3B7C));
        jctime(speechq);
        sub_8D2F0(BANKD(0x3B60));
        jctime((int)speechbank);
        jctime((int)samplereq);
        speechinit = 0;
    }
}


/* ReadBE24 (837FB) - PC only: read three bytes from file fh, most significant first (the VIV bank headers are
   big-endian), and return them as a number. */
int ReadBE24(int fh)
{
    unsigned got;
    int value;

    ((unsigned char *)&value)[3] = 0;
    _dos_read(fh, (unsigned char *)&value + 2, 1, &got);
    _dos_read(fh, (unsigned char *)&value + 1, 1, &got);
    _dos_read(fh, (unsigned char *)&value, 1, &got);
    return value;
}

/* an int field of speech slot n (26h bytes each) */
#define SLOTD(n, off) (*(int *)((char *)speechbank + (n) * 0x26 + (off)))
#define SLOTFREQ (*(double *)&qword_C37C8)
#define SLOTRATE (*(double *)&qword_C37D0)

/* DRAFT (LoadSpeechSlot): n lands in edx, EXE ebx; declaration orders tried. */
/* LoadSpeechSlot (83CAE) - PC only: load sample n into the speech memory right after slot n - 1 (slot 0 at the
   memory start +3B64h): its address (+0Eh), size (ReadSpeechSample, +16h), its play time size * C37C8 / C37D0 less
   the bank's +3B70h (+1Eh), loaded (+22h); count the bytes (+3B6Ch) and loaded slots (+3B74h). */
void LoadSpeechSlot(int n)
{
    int addr;
    int size;
    int off;
    int t;
    char *p;

    if (n == 0) addr = BANKD(0x3B64);
    else {
        p = (n - 1) * 0x26 + (char *)speechbank;
        addr = *(int *)(p + 0xE) + *(int *)(p + 0x16);
    }
    off = n * 0x26;
    *(int *)(off + (char *)speechbank + 0xE) = addr;
    size = ReadSpeechSample(n);
    *(int *)(off + (char *)speechbank + 0x16) = size;
    t = BANKD(0x3B70);
    *(int *)(off + (char *)speechbank + 0x1E) = (unsigned)((unsigned)size * SLOTFREQ / SLOTRATE) - t;
    *(int *)(off + (char *)speechbank + 0x22) = 1;
    BANKD(0x3B6C) += size;
    BANKD(0x3B74)++;
}

/* PlaceSpeechSlot (83D78) - PC only: read sample n (file offset +12h, length +1Ah) from the open bank file into the
   speech memory after slot n - 1 and mark it loaded; count the bytes read (+3B6Ch) and loaded slots (+3B74h). */
void PlaceSpeechSlot(int n)
{
    unsigned got;
    unsigned len;
    int addr;
    int fh;

    if (n == 0) addr = BANKD(0x3B64);
    else addr = SLOTD(n - 1, 0xE) + SLOTD(n - 1, 0x16);
    SLOTD(n, 0xE) = addr;
    fh = BANKD(0x3B7C);
    len = SLOTD(n, 0x1A);
    lseek(fh, SLOTD(n, 0x12), 0);
    _dos_read(fh, (void *)addr, len, &got);
    SLOTD(n, 0x22) = 1;
    BANKD(0x3B6C) += got;
    BANKD(0x3B74)++;
}
