/* Settings dialogs: goalie pulled flag. */
#include "nhl95.h"

/* CtlSwapTeamFlag (7CC8A) - for team (0 home, 1 visitors) with no goalie in (tmgoalie < 0, low flag nibble clear): mark it
   (tmgoalie |= FFF0h) unless the other team has the puck in play (gmode bit 0 clear, puckc set, not team's
   player) and gmode bit 3 is set. */
void CtlSwapTeamFlag(int team)
{
    Team *t;

    t = &(&hmtmstruct)[team];
    if (t->tmgoalie < 0 && !(*(unsigned char *)&t->tmgoalie & 0xF0)) {
        if (!(gmode & 1) && *puckc >= 0 && (team ^ (*puckc < 6)) && (gmode & 8)) return;
        t->tmgoalie |= 0xFFF0;
    }
}
