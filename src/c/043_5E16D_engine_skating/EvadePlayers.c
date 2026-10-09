/* Skating: the skateto collision-avoidance callback and the stop routines that share its epilogue. */
#include "nhl95.h"

/* EvadePlayers (5E4C4) - PC-new skateto collision routine (the 93G a0 routine slot; 93G has only EvadePC).
   p = player (eax). Nothing when pflags2 bit 5 is set. Behind the net (|Ypos| > F2h, |Xpos| < 32h): regd0.w = a
   direction round the net from the Xpos / Yvel signs. Else for every other SortCords entry (0-14, not the goalies
   12/13, the puck only while nothing is closer than 50h): if the predicted x and y gaps (position + high byte of
   the velocity) are both within 28h and the closest so far, regd0.w = a sidestep direction from vtoa of the gap,
   turned away from the boards near the ends. Results in the 68k-register statics regd0.w (direction), regd1.w / regd2.w
   (|dy|, |dx|); no return value. */
void EvadePlayers(Player *p)
{
    Player *o;
    short i, best, dx, dy, pv, ov;
    int sum;

    if (p->pflags2 & 0x20) return;
    dy = ABS(HIWORD(p->Ypos));
    if (dy > 0xA2 && dy > 0xF2 && ABS(HIWORD(p->Xpos)) < 0x32) {      /* behind the net */
        if (HIWORD(p->Ypos) > 0) {
            if (p->Yvel > 0) regd0.w = HIWORD(p->Xpos) < 0 ? 7 : 1;
            else regd0.w = HIWORD(p->Xpos) < 0 ? 6 : 2;
        } else {
            if (p->Yvel < 0) regd0.w = HIWORD(p->Xpos) < 0 ? 5 : 3;
            else regd0.w = HIWORD(p->Xpos) < 0 ? 6 : 2;
        }
        return;
    }
    best = 0x64;
    for (o = SortCords, i = 0; i < 15; i++, o++) {
        if (i == 12 || i == 13) continue;               /* not the goalies */
        if (i == 14 && best <= 0x50) continue;          /* the puck only if nothing is close */
        regd2.w = dx = HIWORD(p->Xpos) - HIWORD(o->Xpos);
        pv = HIBYTE(p->Xvel);
        ov = HIBYTE(o->Xvel);
        regd2.w = dx + (pv - ov);                         /* predicted x gap */
        regd2.w = ABS(regd2.w);
        if (regd2.w > 0x28) continue;
        regd1.w = dy = HIWORD(p->Ypos) - HIWORD(o->Ypos);
        pv = HIBYTE(p->Yvel);
        ov = HIBYTE(o->Yvel);
        regd1.w = (pv - ov) + dy;                         /* predicted y gap */
        regd1.w = ABS(regd1.w);
        if (regd1.w > 0x28) continue;
        sum = regd2.w + regd1.w;
        if (best <= sum) continue;            /* closest so far? */
        best = regd2.w + regd1.w;
        regd0.w = vtoa(dx, dy);
        if (HIWORD(p->Xpos) < -0x82) {                  /* near the left end */
            if (regd0.w <= 4 || regd0.w >= 8) continue;
            regd0.w = o->Yvel != 0 ? 4 : 0;
        } else if (HIWORD(p->Xpos) > 0x82) {            /* near the right end */
            if (regd0.w <= 0 || regd0.w >= 4) continue;
            regd0.w = o->Yvel != 0 ? 4 : 0;
        } else if (HIWORD(p->Xpos) > -0x64 && HIWORD(p->Xpos) < 0) {
            if (regd0.w <= 0 || regd0.w >= 4) continue;
            regd0.w = 8 - regd0.w;
            if (regd0.w == 6 && o->Yvel != 0) regd0.w = (dy < 0) + 4;
            else regd0.w = dy > 0 ? 7 : 0;
        } else {
            if (HIWORD(p->Xpos) >= 0x64 || HIWORD(p->Xpos) < 0) continue;
            if (regd0.w <= 4 || regd0.w >= 8) continue;
            regd0.w = 8 - regd0.w;
            if (regd0.w == 2 && o->Yvel != 0) regd0.w = (dy >= 0) + 3;
            else regd0.w = dy > 0;
        }
    }
}
