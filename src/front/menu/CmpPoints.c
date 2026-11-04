/* Player stats: leader sorting. */
#include "nhl95.h"

/* CmpPoints: qsort comparator of two skater stats records (indexes into statsskaterbuf, 2Fh bytes each, the
 playoff stats at +12h): players with games (+0) first, then most points (+6), fewer games, more goals (+2), more of word +10h. */
int CmpPoints(int *a, int *b)
{
    unsigned short *p;
    unsigned short *q;

    p = !statsplayoffs ? (unsigned short *)(statsskaterbuf + *a * 0x2F)
                       : (unsigned short *)(statsskaterbuf + *a * 0x2F + 0x12);
    q = !statsplayoffs ? (unsigned short *)(statsskaterbuf + *b * 0x2F)
                       : (unsigned short *)(statsskaterbuf + *b * 0x2F + 0x12);
    if (!q[0] ^ !p[0]) return q[0] - p[0];
    if (q[3] != p[3]) return q[3] - p[3];
    /* q[0] has to stay a memory operand. A plain q[0] on both sides is cached in cx. */
    if (p[0] != *(volatile unsigned short *)q) return p[0] - q[0];
    if (q[1] != p[1]) return q[1] - p[1];
    return ((short *)q)[8] - ((short *)p)[8];
}
