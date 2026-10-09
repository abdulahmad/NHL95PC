/* Engine core: add a roster player to the player list (PC only). */
#include "nhl95.h"

/* TryAddPlayerToList (5BB9E) - PC only: put roster player pl of team t into slot `slot` of PlList (6 entries,
   the player list SetPlList builds for the line/stat screens). Not when he is in the penalty box (tmpdst > 0)
   or marked -3 or below in tmpdst, and not when another slot already holds him. Returns 1 when added, else 0. */
int TryAddPlayerToList(Team *t, short pl, short slot)
{
    short i;

    if (t->tmpdst[pl] > 0 || t->tmpdst[pl] <= -3)
        return 0;                               /* in the box, or not available */
    for (i = 5; i >= 0; i--) {
        if (i != slot && pl == PlList[i])
            return 0;                           /* already in the list */
    }
    PlList[slot] = pl;
    return 1;
}
