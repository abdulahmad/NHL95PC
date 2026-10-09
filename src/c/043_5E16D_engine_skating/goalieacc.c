/* Skating: goalie acceleration (93G logic93_5 goalieacc). */
#include "nhl95.h"

/* goalieacc (5F8B2) - goalie gets acc. in direction dir (93G logic93_5 goalieacc). p = goalie.
   dir 8+ means no direction: 9 stops him if he is still moving (StopNA), otherwise he takes the ready stance
   (SPAgready) unless an animation is in progress. Else facedir turns one step toward dir, SPAgskate, playeracc.
   PC: when the clock is stopped, or he has no puck and his assignment is assgoalietopuck, he turns toward the
   puck direction (puckdir) instead. */
void goalieacc(Player *p, short dir)
{
    dir &= 0x0F;
    if (dir > 7) {
        if (dir == 9 && (p->Xvel | p->Yvel)) {
            StopNA(p);
            return;
        }
        if (!(p->pflags2 & pf2aip)) SetSPA(p, SPAgready);
        return;
    }
    if (!(gmode & gmclock) && *puckc != p->SCnum && p->asslist[p->assnum] == ASSgoalietopuck) {
        if (p->puckdir != p->facedir)
            p->facedir = (p->facedir + ((((p->facedir - p->puckdir) & 4) >> 1) - 1)) & 7;
    } else {
        dir -= p->facedir;
        if (dir != 0)
            p->facedir = (((-dir & 4) >> 1) - 1 + p->facedir) & 7;   /* one step the short way round */
    }
    SetSPA(p, SPAgskate);
    playeracc(p, p->facedir);
}
