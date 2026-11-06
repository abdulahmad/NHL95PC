/* Engine assign/faceoff: wait for the bench (asstab 29h). */
#include "nhl95.h"

/* assbenchwait: asstab 29h (ASSbenchwait): while the animation is not locked (pfalock), frame = -1 and check4bench; once the player is at
 the bench, temp1 = 64h and temp5 = 0. */
void assbenchwait(Player *p)
{
    if (!(p->pflags & pfalock)) {
        p->frame = -1;
        if (check4bench(p)) {
            p->temp1 = 0x64;
            p->temp5 = 0;
        }
    }
}
