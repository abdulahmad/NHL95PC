/* SetSPA (59D9A) - 93G/94G SetSPA: start sprite animation 'spa' (an SPAtab index) on player p, unless it is
   already playing. Restarting clears the frame number and sets the frame counter to -1 so the next updateanim
   loads the first frame. Callers: assignments, skating, faceoffs, input. */
#include "nhl95.h"

void SetSPA(Player *p, short spa)
{
    if (spa != p->SPA) {        /* already running: leave it alone */
        p->SPAnum = 0;
        p->SPA = spa;
        p->SPAcnt = -1;         /* restart animation */
    }
}
