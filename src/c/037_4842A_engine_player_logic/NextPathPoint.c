/* Engine player logic: next point of the shootout skating path (94G title94 NextPathPoint, PC version). */
#include "nhl95.h"

/* NextPathPoint (4F99B) - load the next point of the shootout path (94G title94 NextPathPoint): the path table
   at dword_CCB18 has 3 dwords per point (x, y, end; dword_CCB1C / dword_CCB20 are its y / end columns).
   sopathx = x (negated when pspathside < 0, the other side of the rink), sopathy = y, sopathend = end, then
   sopathpoint goes to the next point. The PC has no end-of-path check here (94G stops at x = 80h). */
void NextPathPoint(void)
{
    int k;
    int x;

    k = sopathpoint * 3;                        /* 3 dwords per point */
    x = dword_CCB18[k];
    if (pspathside < 0) x = -x;                 /* path side */
    sopathx = x;
    sopathy = dword_CCB1C[k];
    sopathend = dword_CCB20[k];
    sopathpoint++;
}
