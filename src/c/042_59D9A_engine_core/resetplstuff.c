/* Engine core: reset the players' state (93G resetplstuff). */
#include "nhl95.h"

/* resetplstuff (5E01A) - 93G resetplstuff: for both teams clear tmflags bit 4, and for the 6 SortCords entries
   of the team: pflags2 0; a player on the ice (position >= 0) gets SPA 289h, nopuck and impact 0 and pflags
   bits 0, 2-5 cleared. */
void resetplstuff(void)
{
    short side;
    Team *t;
    Player *p;
    short i;

    side = 0;
    t = &hmtmstruct;
    for (; side < 2; side++) {
        t->tmflags &= 0xEF;
        p = t->tmsort;
        for (i = 0; i < 6; i++) {
            p->pflags2 = 0;
            if (p->position >= 0) {
                SetSPA(p, 0x289);
                p->impact = p->nopuck = 0;
                p->pflags &= 0xC2;
            }
            p++;
        }
        t = &awtmstruct;
    }
}
