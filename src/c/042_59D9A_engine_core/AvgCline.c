/* Engine core: average energy of a team's line on the ice (93G penalty93_2 AvgCline). */
#include "nhl95.h"

/* AvgCline (5A03B) - return regd0 = average energy of current line on team t (93G penalty93_2 AvgCline).
   Sums the tmpde energy word of each of the team's 6 SortCords entries with position > 0 (skaters on the ice,
   not the goalie) into regd0.l; regd0.w = sum / count when there is any (else the sum, 0). */
void AvgCline(Team *t)
{
    Player *p;
    short i, n;

    p = t->tmsort;
    regd0.l = 0;
    n = 0;
    i = 6;
    do {                                            /* dbf d2 */
        if (p->position > 0) {
            regd0.l += t->tmpde[p->pnum];
            n++;
        }
        p++;
    } while (--i != 0);
    if (n != 0) regd0.w = regd0.l / n;
}
