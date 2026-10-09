/* Player stats: leader sorting. */
#include "nhl95.h"

/* CmpPlusMinus (2554B) - qsort comparator of two skater stats records (indexes into statsskaterbuf, 2Fh bytes each, the
   playoff stats at +12h): best plus/minus (signed word +10h) first, then fewer games (+0), more points (+6), more goals (+2). */
int CmpPlusMinus(int *a, int *b)
{
    unsigned short *p;
    unsigned short *q;

    p = !statsplayoffs ? (unsigned short *)(statsskaterbuf + *a * 0x2F)
                       : (unsigned short *)(statsskaterbuf + *a * 0x2F + 0x12);
    q = !statsplayoffs ? (unsigned short *)(statsskaterbuf + *b * 0x2F)
                       : (unsigned short *)(statsskaterbuf + *b * 0x2F + 0x12);
    if (((short *)q)[8] != ((short *)p)[8]) return ((short *)q)[8] - ((short *)p)[8];
    if (q[0] != p[0]) return p[0] - q[0];
    if (q[3] != p[3]) return q[3] - p[3];
    return q[1] - p[1];
}
