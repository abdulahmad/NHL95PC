/* Line editor rosters: skater sorting. */
#include "nhl95.h"

/* CmpRosterSkaters: qsort compare for the roster screen's skaters: records in rosterpstat (28h bytes each,
 playoffs at +12h); no games (word +0) last, then more points (+6), fewer games, more goals (+2), more +10h. */
int CmpRosterSkaters(int *a, int *b)
{
    unsigned short *p;
    unsigned short *q;

    p = !statsplayoffs ? (unsigned short *)(rosterpstat + *a * 0x28)
                       : (unsigned short *)(rosterpstat + *a * 0x28 + 0x12);
    q = !statsplayoffs ? (unsigned short *)(rosterpstat + *b * 0x28)
                       : (unsigned short *)(rosterpstat + *b * 0x28 + 0x12);
    if ((q[0] == 0) ^ (p[0] == 0)) return q[0] - p[0];
    if (q[3] != p[3]) return q[3] - p[3];
    if (q[0] != p[0]) return p[0] - q[0];
    if (q[1] != p[1]) return q[1] - p[1];
    return ((short *)q)[8] - ((short *)p)[8];
}
