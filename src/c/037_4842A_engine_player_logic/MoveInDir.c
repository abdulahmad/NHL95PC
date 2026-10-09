/* Engine player logic: joystick move. */
#include "nhl95.h"

/* MoveInDir (49260) - move p by joystick direction dir: goalies use goalieacc; no direction (8+): stop (dir 9 while
   moving) or the stand animation 289h unless one is running; otherwise turn one step toward dir (facedir
   +/- 1) and skate (SPA 2E9h, playeracc). */
void MoveInDir(Player *p, short dir)
{
    if (p->position == 0) {
        goalieacc(p, dir);
        return;
    }
    dir &= 0xF;
    if (dir > 7) {
        if (dir == 9 && (p->Xvel | p->Yvel)) {
            StopNA(p);
            return;
        }
        if (!(p->pflags2 & 2)) SetSPA(p, 0x289);
        return;
    }
    if (dir -= p->facedir) p->facedir = ((((-dir) & 4) >> 1) - 1 + p->facedir) & 7;
    SetSPA(p, 0x2E9);
    playeracc(p, p->facedir);
}
