/* Engine input: faceoff (93G faceoffinput). */
#include "nhl95.h"

/* faceoffinput (4FF0D) - faceoff input for p while its assignment is 17h (faceoff): store the stick direction (fodir1 /
   fodir2 by end); without a draw yet (pflags2 bit 1): the shoot button (regd1 bit 4) draws (SPA 7DDh, or D05h
   from word_DFF42 11h on), otherwise temp5 counts down to the idle animation 7F1h. */
void faceoffinput(Player *p)
{
    signed char f;

    if (p->asslist[p->assnum] != 0x17) return;
    if (p->pflags & pfgoal) fodir2 = regd0.w;
    else fodir1 = regd0.w;
    f = p->pflags2;
    if (f & 2) return;
    if (!(regd1.w & 0x10)) {
        if (--p->temp5 < 0) SetSPA(p, 0x7F1);
        return;
    }
    p->pflags2 = f | 2;
    if (word_DFF42 < 0x11) {
        p->pflags |= 0x20;
        SetSPA(p, 0x7DD);
    } else {
        SetSPA(p, 0xD05);
    }
    p->temp5 = -1;
}
