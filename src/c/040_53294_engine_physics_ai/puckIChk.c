/* Engine physics / AI: icing (93G puckIChk). */
#include "nhl95.h"

/* puckIChk (56E52) - icing check while the icing watch (iflags bit 2) is on and no icing yet (bit 0): once the loose
   puck crosses the goal line of the end in iflags bit 1 (y beyond -/+E8h), icing (bit 0) if it is wide of the
   net (|x| > 2Ch), else the watch ends. */
void puckIChk(void)
{
    short x;
    int a;

    if (!(iflags & 4)) return;
    if (iflags & 1) return;
    if (*puckc >= 0) return;
    if (!(iflags & 2)) {
        if (*pucky >= -0xE8) return;
    } else {
        if (*pucky < 0xE8) return;
    }
    x = *puckx;
    if (x < 0) a = -(int)x;
    else a = x;
    if (a <= 0x2C) {
        iflags &= ~4;
        return;
    }
    iflags |= 1;
}
