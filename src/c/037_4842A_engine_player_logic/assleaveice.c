/* Engine player logic: leave the ice (93G assleaveice). */
#include "nhl95.h"

/* assleaveice (4AB87) - 93G assleaveice: skate off to the bench gate. Not while flag 20h; once off (temp1 100)
   clear pflags2 bit 4, frame -1 and go to assignment 29h. A new assignment (bit 1): pflags2 bit 2; a controlled
   player (pflags bit 3) gives up control (changeplayer, controller 0 for pad 1 else 2); temp2 = 8, the gate spot
   x -A8h, y -1Ch / 24h by side, temp1 0, pflags2 bit 5 and no wall angle. Every 8 frames (temp1): near the gate
   (|y| <= 14h, x gap <= 20h) take SPA 289h (1 for the goalie), pflags bit 2, turn a step towards facing 4 and drift
   (Xvel -800h); within 10h facing 4: through the gate (facing 2, SPA 7BFh / goalie D2Dh, flag 20h, temp1 100) and,
   with fewer than 4 skaters (gsp) outside gmode bit 6, off the lines (RemoveFromLines). Else, not parked, skate to
   the gate. */
void assleaveice(Player *p)
{
    short d;

    if (p->pflags & 0x20) return;
    if (p->temp1 != 100) {
        if (p->pflags & 2) {
            p->pflags &= 0xFD;
            p->pflags2 |= 4;
            if (p->pflags & 8) {
                if (p->SCnum == c1playernum[0]) regd4.w = 0;
                else regd4.w = 2;
                changeplayer(p, regd4.w);
            }
            p->temp2 = 8;
            p->temp4 = !(p->pflags & 0x40) ? -0x1C : 0x24;
            p->temp3 = -0xA8;
            p->temp1 = 0;
            p->pflags2 |= 0x20;
            p->Wallcos = 0;
            p->Wallsin = 0;
        }
        if (--p->temp1 < 0) {
            p->temp1 += 8;
            d = HIWORD(p->Ypos) - p->temp4;
            regd0.w = HIWORD(p->Xpos) - p->temp3;
            if (ABS(d) <= 0x14 && regd0.w <= 0x20) {
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
                p->temp1 = 100;
                if (gsp < 4 && !(gmode & 0x40)) RemoveFromLines((short)((p->pflags & 0x40) != 0), p->pnum);
                return;
            }
        }
        if (p->pflags & 4) return;
        regd0.w = p->temp3;
        regd1.w = p->temp4;
        skateto(p, 0);
    } else {
        p->pflags2 &= 0xEF;
        p->frame = -1;
        assreplace(p, 0x29);
    }
}
