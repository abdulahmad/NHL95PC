/* Scoring / penalty text: shot check. */
#include "nhl95.h"

/* QuickShotChk (6427F) - quick shot check for puck carrier p (option bit 0, play on, shot on goal): p must skate toward
   the goal and face it (facedir 3-5 / not 2-6 by end); then ShotLaneOpen sets shotongoal, and it counts from
   within |y| <= E4h with the goalie in net. Returns 1 when it does. */
int QuickShotChk(Player *p)
{
    short f;
    short g;
    int y;

    if (gmode & 0x10) return 0;
    if (!gameopts.optbit0) return 0;
    if (*puckc != p->SCnum) return 0;
    if (!shotongoal) return 0;
    if (p->pflags & pfgoal) {
        if (p->Yvel < 0) return 0;
        f = p->facedir;
        if (f >= 2 && f <= 6) return 0;
    } else {
        if (p->Yvel > 0) return 0;
        g = p->facedir;
        if (g <= 2 || g >= 6) return 0;
    }
    ShotLaneOpen();
    shotongoal = shotontarget;
    if (!shotongoal) return shotongoal;
    if (HIWORD(p->Ypos) < 0) y = -HIWORD(p->Ypos);
    else y = HIWORD(p->Ypos);
    if (y > 0xE4) return 0;
    if (p->optmptr->tmgoalie < 0) return 0;
    return 1;
}
