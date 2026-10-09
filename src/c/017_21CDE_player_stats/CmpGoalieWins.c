/* Player stats: leader sorting. */
#include "nhl95.h"

/* CmpGoalieWins (2586A) - qsort comparator of two goalie stats records (as CmpSavePct): most wins (word +2) first, then
   (season only) word +6, then fewer +4, fewer +0, more +0Ch, fewer +10h, more +14h. */
int CmpGoalieWins(int *a, int *b)
{
    unsigned short *p;
    unsigned short *q;

    p = !statsplayoffs ? (unsigned short *)(statsgoaliebuf + *a * 0x36)
                       : (unsigned short *)(statsgoaliebuf + *a * 0x36 + 0x16);
    q = !statsplayoffs ? (unsigned short *)(statsgoaliebuf + *b * 0x36)
                       : (unsigned short *)(statsgoaliebuf + *b * 0x36 + 0x16);
    if (q[1] != p[1]) return q[1] - p[1];
    if (!statsplayoffs && q[3] != p[3]) return q[3] - p[3];
    if (q[2] != p[2]) return p[2] - q[2];
    if (q[0] != p[0]) return p[0] - q[0];
    if (q[6] != p[6]) return q[6] - p[6];
    if (q[8] != p[8]) return p[8] - q[8];
    return q[10] - p[10];
}
