/* Engine player logic: faceoff centre (93G assfaceoffp1). */
#include "nhl95.h"

/* assfaceoffp1 (4D528) - 93G assfaceoffp1: a faceoff centre. Not while flag 20h; out of the faceoff (gmode2 bit 0
   clear) nopuck 20 and leave (assexit). A new assignment (bit 1) resets temp1, takes the faceoff frame 167h (16Ch
   facing 0) with SPA 0 and the wait temp5 (side 0: 40, side 1: 20 + random 10). Store the stick stance for the
   pad (word_E0390, +4 for side 1): 2 in frames 169h / 16Eh, 3 in 16Ah / 16Fh (sound 9Eh + side on SPA count 7),
   else 1; +3 when handed is 0. Then, unless pflags bit 3 or pflags2 bit 1 (set now): with temp5 >= 0 or the drop
   timer word_DFF42 > 10h and a 7-in-8 chance count temp5 down to SPA 7F1h (the swipe); else temp5 = -1 and SPA
   7DDh (frozen, flag 20h) before 11h, D05h after. */
void assfaceoffp1(Player *p)
{
    short *pad;
    short t;
    short spa;

    if (p->pflags & 0x20) return;
    if (!(gmode2 & 1)) {
        p->nopuck = 0x14;
        assexit(p);
        return;
    }
    if (p->pflags & 2) {
        p->pflags &= 0xFD;
        p->temp1 = 0;
        p->frame = p->facedir ? 0x167 : 0x16C;
        SetSPA(p, 0);
        if (p->pflags & 0x40) p->temp5 = randomd0(10) + 0x14;
        else p->temp5 = 0x28;
    }
    pad = word_E0390;
    if (p->pflags & 0x40) pad += 2;
    if (p->frame == 0x169 || p->frame == 0x16E) regd0.w = 2;
    else if (p->frame == 0x16A || p->frame == 0x16F) {
        if (p->SPAcnt == 7) sfx((short)((p->pflags & 0x40 ? 1 : 0) + 0x9E));
        regd0.w = 3;
    } else regd0.w = 1;
    if (!p->handed) regd0.w += 3;
    *pad = regd0.w;
    if (p->pflags & 8) return;
    if (p->pflags2 & 2) return;
    p->pflags2 |= 2;
    if (p->temp5 >= 0 || ((unsigned short)word_DFF42 > 0x10 && randomd0(8))) {
        t = --p->temp5;
        if (t >= 0) return;
        spa = 0x7F1;
    } else {
        p->temp5 = -1;
        if (word_DFF42 < 0x11) {
            p->pflags |= 0x20;
            spa = 0x7DD;
        } else spa = 0xD05;
    }
    SetSPA(p, spa);
}
