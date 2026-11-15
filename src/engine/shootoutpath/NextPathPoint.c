/* Engine player logic: next point of the shootout skating path (PC version). */
#include "nhl95.h"

/* NextPathPoint: load the next point of the shootout path: the path table
 at ShootoutPathData has 3 dwords per point (x, y, end; ShootoutPathData_y ShootoutPathData_end are its y end columns).
 sopathx = x (negated when pspathside < 0, the other side of the rink), sopathy = y, sopathend = end, then
 sopathpoint goes to the next point. The PC has no end-of-path check here. */
void NextPathPoint(void)
{
    int k;
    int x;

    k = sopathpoint * 3;                        /* 3 dwords per point */
    x = ShootoutPathData[k];
    if (pspathside < 0) x = -x;                 /* path side */
    sopathx = x;
    sopathy = ShootoutPathData_y[k];
    sopathend = ShootoutPathData_end[k];
    sopathpoint++;
}
