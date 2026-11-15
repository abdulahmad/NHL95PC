/* Scoring penalty text: rink objects. */
#include "nhl95.h"

/* SetRinkObject: set rink object slot i (12-byte records at rinkobjs) to object v: marks v in the bit set
 rinkobjused, copies its 3 words from rinkobjdefs (+5, +7, +9), the two bytes indexed by the +9 word from
 rinkobjanim rinkobjanim_b1 (+0Bh, +4), type 0Ch, active 1. */
void SetRinkObject(int i, int v)
{
    unsigned char *o;
    int k;

    o = (unsigned char *)rinkobjs + i * 12;
    *(short *)o = v;
    rinkobjused[v / 16] |= 1 << (v % 16);
    k = v * 3;
    *(short *)(o + 5) = rinkobjdefs[k];
    k++;
    *(short *)(o + 7) = rinkobjdefs[k];
    k++;
    *(short *)(o + 9) = rinkobjdefs[k];
    o[0xB] = rinkobjanim[*(short *)(o + 9)];
    o[4] = rinkobjanim_b1[*(short *)(o + 9)];
    o[2] = 0xC;
    o[3] = 1;
}
