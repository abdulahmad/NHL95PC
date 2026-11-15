/* Engine player logic: puck flip end. */
#include "nhl95.h"

/* puckunflip: end of a puck flip: mid-flip (SPAnum 4..11) toggles facedir bit 1; facedir bit 2 set; SPAnum 0,
 SPAcnt -1. */
void puckunflip(Player *p)
{
    if (p->SPAnum >= 4 && p->SPAnum < 12) p->facedir ^= 2;
    p->facedir |= 4;
    p->SPAnum = 0;
    p->SPAcnt = -1;
}
