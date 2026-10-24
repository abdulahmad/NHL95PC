/* Engine player logic: skating to a spot. */
#include "nhl95.h"

/* DRAFT (10.0 GA, 1158 vs 1160, 2 differing): with t declared after ady, the stop written as two zero stores
   and the vtoa result stored in d before the facedir step, every temporary lands in the EXE register. Left:
   the stop itself, which the EXE compiles from the chained p->Xvel = p->Yvel = 0 (store, reload into ax,
   copy); the chained form adds a conflict, reorders the tied temporaries and moves picks (42 differing). */
/* SkateToSpot (4E292, PC only): skate p to the spot regd0.w / regd1.w with skateto (evade: its evade routine,
   passed straight through). Within 8 of the spot both ways, stop there. Near the goal line ends (|x| up to 1Eh,
   |y| from F2h, a target inside F2h) aim behind the net instead (y FCh, x 28h toward the target's side) and drop
   a y speed that points the other way; along the boards (|x| 10h-1Eh, |y| from E8h, the target on p's side with
   |y| E0h-E8h and |x| under 14h) aim at y DCh, x 28h on p's side and drop such an x speed. Within 19h both ways
   cut speeds over 9C4h by a quarter. A far axis under 640h speed gets 640h toward the spot, with the skating
   animation (SetSPA: A5Bh / A73h for SortCords 10h, 99h / 1F1h for a goalie, else 289h / 2E9h) when it has none
   or stands still. Then turn facedir one step toward the spot unless it is within one step or temp2's high byte
   is set. */
void SkateToSpot(Player *p, int evade)
{
    short axp;
    short dx;
    short dy;
    short spa2;
    short adx;
    short ady;
    short t;
    short ayp;
    short ary;
    short d;

    dx = regd0.w - HIWORD(p->Xpos);
    adx = ABS(dx);
    dy = regd1.w - HIWORD(p->Ypos);
    ady = ABS(dy);
    if (adx < 8 && ady < 8) {
        p->Yvel = 0;
        p->Xvel = 0;
        HIWORD(p->Xpos) = regd0.w;
        HIWORD(p->Ypos) = regd1.w;
        return;
    }
    axp = ABS(HIWORD(p->Xpos));
    t = ABS(HIWORD(p->Ypos));
    ayp = t;
    ary = ABS(regd1.w);
    if (axp <= 0x1E && ayp >= 0xF2 && ary < 0xF2) {
        regd1.w = HIWORD(p->Ypos) < 0 ? -0xFC : 0xFC;
        regd0.w = regd0.w < 0 ? -0x28 : 0x28;
        if ((p->Yvel > 0) ^ (HIWORD(p->Ypos) > 0)) p->Yvel = 0;
        dx = regd0.w - HIWORD(p->Xpos);
        adx = ABS(dx);
        dy = regd1.w - HIWORD(p->Ypos);
        ady = ABS(dy);
    } else if (axp >= 0x10 && axp <= 0x1E && ayp >= 0xE8 && (HIWORD(p->Ypos) ^ regd1.w) >= 0 && ary < 0xE8
               && ary > 0xE0 && ABS(regd0.w) < 0x14) {
        regd1.w = HIWORD(p->Ypos) < 0 ? -0xDC : 0xDC;
        regd0.w = HIWORD(p->Xpos) < 0 ? -0x28 : 0x28;
        if ((p->Xvel > 0) ^ (HIWORD(p->Xpos) > 0)) p->Xvel = 0;
        dx = regd0.w - HIWORD(p->Xpos);
        adx = ABS(dx);
        dy = regd1.w - HIWORD(p->Ypos);
        ady = ABS(dy);
    }
    skateto(p, (void (*)(Player *))evade);
    if (adx < 0x19 && ady < 0x19) {
        if (ABS(p->Xvel) > 0x9C4) p->Xvel -= p->Xvel / 4;
        if (ABS(p->Yvel) > 0x9C4) p->Yvel -= p->Yvel / 4;
    }
    if (p->SCnum == 0x10) {
        axp = 0xA5B;
        spa2 = 0xA73;
    } else if (p->position == 0) {
        axp = 0x99;
        spa2 = 0x1F1;
    } else {
        axp = 0x289;
        spa2 = 0x2E9;
    }
    if (adx >= 8 && ABS(p->Xvel) < 0x640) {
        if (p->Xvel == 0 && axp == p->SPA) SetSPA(p, spa2);
        else if (p->SPA == 0) SetSPA(p, axp);
        p->Xvel = dx > 0 ? 0x640 : -0x640;
    }
    if (ady >= 8 && ABS(p->Yvel) < 0x640) {
        if (p->Xvel == 0 && axp == p->SPA) SetSPA(p, spa2);
        else if (p->SPA == 0) SetSPA(p, axp);
        p->Yvel = dy > 0 ? 0x640 : -0x640;
    }
    d = vtoa((short)(regd0.w - HIWORD(p->Xpos)), (short)(regd1.w - HIWORD(p->Ypos)));
    d = (d - p->facedir) & 7;
    if (((d + 1) & 7) > 2 && !HIBYTE(p->temp2)) p->facedir = ((d < 5 ? 1 : -1) + p->facedir) & 7;
}
