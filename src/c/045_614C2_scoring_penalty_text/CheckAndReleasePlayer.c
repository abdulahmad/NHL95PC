/* Scoring / penalty text: penalty box release. */
#include "nhl95.h"

/* CheckAndReleasePlayer (639F9) - penalty box player i of team t: in the last 5 ticks of his time (low 14 bits) play
   the box door sound (97h); at exactly 0, release a player back to the ice (releasepl). */
void CheckAndReleasePlayer(Team *t, short i)
{
    if ((t->tmpdst[i] & 0x3FFF) <= 5) {
        if (t->tmpdst[i] == 0) releasepl(t, i);
        sfx(0x97);
    }
}
