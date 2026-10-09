/* Engine assign/faceoff: wait for the bench (PC only, asstab 29h). */
#include "nhl95.h"

/* assbenchwait (526ED) - asstab 29h (ASSbenchwait, PC only; set by setpersonel for a sort object that has no
   position): while the animation is not locked (pfalock), frame = -1 and check4bench; once the player is at
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
