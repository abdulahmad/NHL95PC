/* Engine assign / faceoff: leave the penalty box (93G assleavebox). */
#include "nhl95.h"

/* assleavebox (5147D) - 93G assleavebox: a player whose penalty ran out comes out of the box. Not while flag 20h or
   heading to the bench (check4bench). A new assignment (bit 1): temp2 = 8, the box door spot x -A8h, y -32h / 41h by
   side plus (2 - random 0-3) x 15, temp1 = temp5 = 0. temp1 5Ah: back in the game (assignment 28h, setplayer with
   temp5, frame -1, temp1 / temp5 0). temp1 100 (out): a skater facing 6 may, at random by his energy (tmpde / 32 +
   80), stretch (SPA D97h, flag 20h); else stand (SPA 289h) when idle. Otherwise every 8 frames (temp1): near the
   door (|y - (-32h / 46h)| <= 26h, x gap <= 1Fh) take SPA 289h (1 for the goalie), pflags bit 2, turn a step
   towards facing 6 and drift (Xvel -800h); within 10h facing 6: out (temp1 100, SPA 289h, TakePlayerFromBox).
   Else, not parked, skate to the door. */
void assleavebox(Player *p)
{
    short d;

    if (p->pflags & 0x20) return;
    if (check4bench(p)) return;
    if (p->pflags & 2) {
        p->pflags &= 0xFD;
        p->temp2 = 8;
        p->temp4 = !(p->pflags & 0x40) ? -0x32 : 0x41;
        p->temp4 += (2 - randomd0(4)) * 0xF;
        p->temp3 = -0xA8;
        p->temp1 = 0;
        p->temp5 = 0;
    }
    if (p->temp1 == 0x5A) {
        assinsert(p, 0x28);
        setplayer(p, p->temp5);
        p->frame = -1;
        p->temp5 = 0;
        p->temp1 = 0;
        return;
    }
    if (p->temp1 != 100) {
        if (--p->temp1 < 0) {
            p->temp1 += 8;
            d = (p->Ypos >> 16) - (!(p->pflags & 0x40) ? -0x32 : 0x46);
            regd0.w = HIWORD(p->Xpos) - p->temp3;
            if (ABS(d) <= 0x26 && regd0.w <= 0x1F) {
                regd1.w = p->position == 0 ? 1 : 0x289;
                SetSPA(p, regd1.w);
                p->pflags |= 4;
                if (p->facedir != 6) p->facedir = ((p->facedir < 7 && p->facedir > 2 ? 1 : -1) + p->facedir) & 7;
                p->Yvel = 0;
                p->Xvel = -0x800;
                if (regd0.w > 0x10) return;
                p->Xvel = 0;
                if (p->facedir != 6) return;
                p->temp1 = 100;
                SetSPA(p, 0x289);
                TakePlayerFromBox(p);
                return;
            }
        }
        if (p->pflags & 4) return;
        regd0.w = p->temp3;
        regd1.w = p->temp4;
        skateto(p, 0);
        return;
    }
    if (p->position > 0 && p->facedir == 6 && !randomd0((short)(p->tmptr->tmpde[p->pnum] / 32 + 0x50))) {
        SetSPA(p, 0xD97);
        p->pflags |= 0x20;
        return;
    }
    if (p->SPA == 0) SetSPA(p, 0x289);
}
