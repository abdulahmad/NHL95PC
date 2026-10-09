/* Scoring / penalty text: rink objects. */
#include "nhl95.h"

/* SetRinkObject (614C2) - set rink object slot i (12-byte records at word_DEE94) to object v: marks v in the bit set
   word_E9B2C, copies its 3 words from word_CCEF8 (+5, +7, +9), the two bytes indexed by the +9 word from
   byte_CCE00 / byte_CCE01 (+0Bh, +4), type 0Ch, active 1. */
void SetRinkObject(int i, int v)
{
    unsigned char *o;
    int k;

    o = (unsigned char *)word_DEE94 + i * 12;
    *(short *)o = v;
    word_E9B2C[v / 16] |= 1 << (v % 16);
    k = v * 3;
    *(short *)(o + 5) = word_CCEF8[k];
    k++;
    *(short *)(o + 7) = word_CCEF8[k];
    k++;
    *(short *)(o + 9) = word_CCEF8[k];
    o[0xB] = byte_CCE00[*(short *)(o + 9)];
    o[4] = byte_CCE01[*(short *)(o + 9)];
    o[2] = 0xC;
    o[3] = 1;
}
