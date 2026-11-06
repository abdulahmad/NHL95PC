/* Engine player logic: three stars eligibility. */
#include "nhl95.h"

/* StarEligible: roster player pl of team side may be a star unless he is on
 the bench (tmpdst < -1: -2 bench) or on the ice in that team's SortCords entries with position 6. Returns 1
 when eligible, else 0. */
int StarEligible(int side, int pl)
{
    Player *p;
    int i;

    if ((&hmtmstruct)[side].tmpdst[pl] < -1) return 0;
    p = &SortCords[side ? 6 : 0];
    for (i = 0; i < 6; i++, p++) {
        if (p->pnum == pl) {
            if (p->position == 6) return 0;
            break;
        }
    }
    return 1;
}
