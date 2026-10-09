/* Menu system: goalie sorting. */
#include "nhl95.h"

/* CmpGAA (1FC8F) - qsort comparator of two goalie stats records (as CmpSavePct): goalies with no minutes (word +0Ch) last,
   then lower goals-against average (+10h) first, then more minutes, more games (+0), fewer +0Eh, more wins (+2),
   fewer +4, more +14h. */
int CmpGAA(int *a, int *b)
{
    unsigned short *p;
    unsigned short *q;

    p = !statsplayoffs ? (unsigned short *)(statsgoaliebuf + *a * 0x36)
                       : (unsigned short *)(statsgoaliebuf + *a * 0x36 + 0x16);
    q = !statsplayoffs ? (unsigned short *)(statsgoaliebuf + *b * 0x36)
                       : (unsigned short *)(statsgoaliebuf + *b * 0x36 + 0x16);
    if ((q[6] == 0) ^ (p[6] == 0)) return q[6] - p[6];
    if (q[8] != p[8]) return p[8] - q[8];
    if (q[6] != p[6]) return q[6] - p[6];
    if (q[0] != p[0]) return q[0] - p[0];
    if (q[7] != p[7]) return p[7] - q[7];
    if (q[1] != p[1]) return q[1] - p[1];
    if (q[2] != p[2]) return p[2] - q[2];
    return q[10] - p[10];
}
