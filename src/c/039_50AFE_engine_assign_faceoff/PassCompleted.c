/* Engine assign/faceoff: count a completed pass (PC only). */
#include "nhl95.h"

/* PassCompleted (50AFE) - PC only: player p received a pass. When the passer (passplayer, sort object number)
   is on p's team (both < 6 home, or both >= 6 away) and the game is not in highlight mode (gmhl), the team's
   completed-pass count (tmpasscomp) goes up. passplayer = -1 (no pass in flight). */
void PassCompleted(Player *p)
{
    if (passplayer >= 0 && (passplayer < 6) == (p->SCnum < 6) && !(gmode & gmhl))
        p->tmptr->tmpasscomp++;
    passplayer = -1;
}
