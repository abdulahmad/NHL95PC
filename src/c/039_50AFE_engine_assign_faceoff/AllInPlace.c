/* Engine assign/faceoff: are all players in place? (PC only). */
#include "nhl95.h"

/* AllInPlace (51440) - PC only: 1 when every one of the 12 player sort objects is either off the ice (position
   < 0) or has reached its spot (temp5 == -100, set by the assignment when the player arrives), else 0. */
int AllInPlace(void)
{
    Player *p;
    int i;

    p = SortCords;
    for (i = 0; i < 12; i++, p++) {
        if (p->position >= 0 && p->temp5 != -100)
            return 0;                           /* still on the way */
    }
    return 1;
}
