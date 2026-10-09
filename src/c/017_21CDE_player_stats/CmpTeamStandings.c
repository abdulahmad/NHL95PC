/* CmpTeamStandings - qsort comparator of two team records (statsteamrecs, 4Ch bytes each; season part at +28h,
   playoffs at +3Ah): more points (2 * wins byte +1 + ties byte +3) first, then fewer losses (+0), more wins, more
   word +4, fewer word +6; else by team index. */
#include "nhl95.h"

int CmpTeamStandings(int *a, int *b)
{
    unsigned char *p;
    unsigned char *q;
    int pp;
    int qp;

    p = !statsplayoffs ? statsteamrecs + *a * 0x4C + 0x28 : statsteamrecs + *a * 0x4C + 0x3A;
    q = !statsplayoffs ? statsteamrecs + *b * 0x4C + 0x28 : statsteamrecs + *b * 0x4C + 0x3A;
    qp = q[1] * 2 + q[3];
    pp = p[1] * 2 + p[3];
    if (pp != qp) return qp - pp;
    if (q[0] != p[0]) return p[0] - q[0];
    if (q[1] != p[1]) return q[1] - p[1];
    if (((unsigned short *)q)[2] != ((unsigned short *)p)[2]) return ((unsigned short *)q)[2] - ((unsigned short *)p)[2];
    if (((unsigned short *)q)[3] != ((unsigned short *)p)[3]) return ((unsigned short *)p)[3] - ((unsigned short *)q)[3];
    return *a - *b;
}
