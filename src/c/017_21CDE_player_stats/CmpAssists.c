/* Player stats: leader sorting. */
#include "nhl95.h"

/* CmpAssists (25237) - qsort comparator of two skater stats records (indexes into statsskaterbuf, 2Fh bytes each, the
   playoff stats at +12h): most assists (word +4) first, then more games (+0), more points (+6), more of word +10h. */
int CmpAssists(int *a, int *b)
{
    unsigned short *p;
    unsigned short *q;

    p = !statsplayoffs ? (unsigned short *)(statsskaterbuf + *a * 0x2F)
                       : (unsigned short *)(statsskaterbuf + *a * 0x2F + 0x12);
    q = !statsplayoffs ? (unsigned short *)(statsskaterbuf + *b * 0x2F)
                       : (unsigned short *)(statsskaterbuf + *b * 0x2F + 0x12);
    if (q[2] != p[2]) return q[2] - p[2];
    if (q[0] != p[0]) return q[0] - p[0];
    if (q[3] != p[3]) return q[3] - p[3];
    return ((short *)q)[8] - ((short *)p)[8];
}
