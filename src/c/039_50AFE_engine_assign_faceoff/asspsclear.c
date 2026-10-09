/* Engine assign / faceoff: clear the ice for a penalty shot. */
#include "nhl95.h"

/* asspsclear (52DB0) - PC only: a player clearing the ice for a penalty shot skates to the bench gate. Not while flag
   20h; once there (temp1 100) frame -1 at x -A8h; nothing outside penshotmode. A new assignment (bit 1): temp2 = 8,
   the spot x -A8h, y -32h / 41h by side plus (2 - random 0-3) x 15, temp1 = temp5 = 0, no line change pending
   (newpos / newpnum -1). Every 8 frames (temp1): near the spot (|y| <= 28h, x gap <= 20h) take SPA 289h (1 for
   the goalie), pflags bit 2, turn a step towards facing 4 and drift (Xvel -800h); within 10h facing 4: through the
   gate (facing 2, SPA 7BFh / goalie D2Dh, flag 20h, pflags2 bit 2, temp5 -100, temp1 100). Off the spot and not
   parked skate there (EvadePC unless the goalie or a stoppage). */
void asspsclear(Player *p)
{
    short d;

    if (p->pflags & 0x20) return;
    if (p->temp1 != 100) {
        if (!penshotmode) return;
        if (p->pflags & 2) {
            p->pflags &= 0xFD;
            p->temp2 = 8;
            p->temp4 = !(p->pflags & 0x40) ? -0x32 : 0x41;
            p->temp4 += (2 - randomd0(4)) * 0xF;
            p->temp3 = -0xA8;
            p->temp1 = 0;
            p->temp5 = 0;
            p->newpos = -1;
            p->newpnum = p->newpos;
        }
        if (--p->temp1 < 0) {
            p->temp1 += 8;
            d = HIWORD(p->Ypos) - p->temp4;
            regd0.w = HIWORD(p->Xpos) - p->temp3;
            if (ABS(d) <= 0x28 && regd0.w <= 0x20) {
                regd1.w = p->position == 0 ? 1 : 0x289;
                SetSPA(p, regd1.w);
                p->pflags |= 4;
                if (p->facedir != 4) p->facedir = ((p->facedir < 4 ? 1 : -1) + p->facedir) & 7;
                p->Yvel = 0;
                p->Xvel = -0x800;
                if (regd0.w > 0x10) return;
                p->Xvel = 0;
                if (p->facedir != 4) return;
                p->Xvel = -0x800;
                p->facedir = 2;
                SetSPA(p, p->position == 0 ? 0xD2D : 0x7BF);
                p->pflags |= 0x20;
                p->pflags2 |= 4;
                p->temp5 = -100;
                p->temp1 = 100;
                return;
            }
        }
        if (p->pflags & 4) return;
        regd0.w = p->temp3;
        regd1.w = p->temp4;
        skateto(p, (gmode & 1) || p->position == 0 ? 0 : (void (*)(Player *))EvadePC);
    } else {
        p->frame = -1;
        HIWORD(p->Xpos) = -0xA8;
    }
}
