/* Engine player logic: three stars eligibility (PC only). */
#include "nhl95.h"

/* StarEligible (487D9) - PC only (PickThreeStars): roster player pl of team side may be a star unless he is on
   the bench (tmpdst < -1: -2 bench) or on the ice in that team's SortCords entries with position 6. Returns 1
   when eligible, else 0. */
int StarEligible(int side, int pl)
{
    Player *p;
    int i;

    if ((&hmtmstruct)[side].tmpdst[pl] < -1) return 0;
    if (side != 0) side = 6;
    p = &SortCords[side];
    for (i = 0; i < 6; i++, p++) {
        if (p->pnum == pl) {
            if (p->position == 6) return 0;
            break;
        }
    }
    return 1;
}
