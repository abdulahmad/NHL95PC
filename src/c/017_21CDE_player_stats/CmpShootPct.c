/* Player stats: leader sorting. */
#include "nhl95.h"

/* CmpShootPct (25755) - qsort comparator for shooting percentage: highest sort key (statssortkeys, the precomputed
   percentage) first, then on the skater stats records (2Fh bytes, playoffs at +12h) more games (+0), more
   points (+6), more goals (+2), more of word +10h. */
int CmpShootPct(int *a, int *b)
{
    unsigned short *p;
    unsigned short *q;

    if (statssortkeys[*b] != statssortkeys[*a]) return statssortkeys[*b] - statssortkeys[*a];
    p = !statsplayoffs ? (unsigned short *)(statsskaterbuf + *a * 0x2F)
                       : (unsigned short *)(statsskaterbuf + *a * 0x2F + 0x12);
    q = !statsplayoffs ? (unsigned short *)(statsskaterbuf + *b * 0x2F)
                       : (unsigned short *)(statsskaterbuf + *b * 0x2F + 0x12);
    if (q[0] != p[0]) return q[0] - p[0];
    if (q[3] != p[3]) return q[3] - p[3];
    if (q[1] != p[1]) return q[1] - p[1];
    return ((short *)q)[8] - ((short *)p)[8];
}
