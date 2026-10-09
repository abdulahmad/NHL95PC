/* Player stats: leader sorting. */
#include "nhl95.h"

/* CmpGoals (25144) - qsort comparator of two skater stats records (indexes into statsskaterbuf, 2Fh bytes each, the
   playoff stats at +12h): most goals (word +2) first, then fewer games (+0), more points (+6), more of word +0Eh. */
typedef struct SkaterStat { unsigned char b[0x2F]; } SkaterStat;

int CmpGoals(int *a, int *b)
{
    unsigned short *p;
    unsigned short *q;

    p = !statsplayoffs ? (unsigned short *)((SkaterStat *)statsskaterbuf + *a)
                       : (unsigned short *)((char *)((SkaterStat *)statsskaterbuf + *a) + 0x12);
    q = !statsplayoffs ? (unsigned short *)((SkaterStat *)statsskaterbuf + *b)
                       : (unsigned short *)((char *)((SkaterStat *)statsskaterbuf + *b) + 0x12);
    if (q[1] != p[1]) return q[1] - p[1];
    if (q[0] != p[0]) return p[0] - q[0];
    if (q[3] != p[3]) return q[3] - p[3];
    return ((short *)q)[7] - ((short *)p)[7];
}
