/* Player stats: leader sorting. */
#include "nhl95.h"

/* CmpSavePct (259C0) - qsort comparator of two goalie stats records (indexes into statsgoaliebuf, 36h bytes each, the
   playoff stats at +16h): by word +14h, then +0Ch, +0, +2 (all larger first), then smaller +4, then word +10h. */
int CmpSavePct(int *a, int *b)
{
    unsigned short *p;
    unsigned short *q;

    p = !statsplayoffs ? (unsigned short *)(statsgoaliebuf + *a * 0x36)
                       : (unsigned short *)(statsgoaliebuf + *a * 0x36 + 0x16);
    q = !statsplayoffs ? (unsigned short *)(statsgoaliebuf + *b * 0x36)
                       : (unsigned short *)(statsgoaliebuf + *b * 0x36 + 0x16);
    if (q[10] != p[10]) return q[10] - p[10];
    if (q[6] != p[6]) return q[6] - p[6];
    if (q[0] != p[0]) return q[0] - p[0];
    if (q[1] != p[1]) return q[1] - p[1];
    if (q[2] != p[2]) return p[2] - q[2];
    return p[8] - q[8];
}
