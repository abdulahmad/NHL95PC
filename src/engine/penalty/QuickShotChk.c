/* Scoring penalty text: shot check. */
#include "nhl95.h"

/* QuickShotChk: quick shot check for puck carrier p (option bit 0, play on, shot on goal): p must skate toward
 the goal and face it (facedir 3-5 not 2-6 by end); then ShotLaneOpen sets shotongoal, and it counts from
 within |y| <= E4h with the goalie in net. Returns 1 when it does. */
int QuickShotChk(Player *p)
{
    int y;

    if ((gmode & 0x10) || !gameopts.optbit0 || *puckc != p->SCnum || !shotongoal) return 0;
    if (p->pflags & pfgoal) {
        if (p->Yvel < 0) return 0;
        if (p->facedir >= 2 && p->facedir <= 6) return 0;
    } else {
        if (p->Yvel > 0) return 0;
        if (p->facedir <= 2 || p->facedir >= 6) return 0;
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
