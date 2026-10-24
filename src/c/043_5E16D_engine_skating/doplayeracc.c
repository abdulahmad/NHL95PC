/* Engine: skating. */
#include "nhl95.h"

/* doplayeracc (5E16D, Genesis doplayeracc): player p gets acceleration in direction dir (low nibble: 0-7 skate,
 8 none, 9 stop). The goalie goes to goalieacc. Picks the glide animation (SPAglideback backwards, the referee his
 glide or its signalling variant, else SPAglide); 8 / 9 only glide (unless an animation is in progress, pf2aip) or
 stop (dostop) when moving. For a skating direction: clears pfrev (skating backwards) when he has the puck, else
 sets or keeps it while he is in his own zone facing his goal with the puck ahead (vtoa of the gap to the puck,
 its y led by the puck's y velocity, all mirrored for the bottom goal). No turn needed (doplayeracc_ftab 0):
 noturn0. Otherwise turn facedir by ftab times $300 - speed (at least $180, regd4; reversed backwards), with a
 turn animation (left / right from the ftab sign and attribute bit 3; the referee his own) above speed 20, then
 accelerate (playeracc) facing facedir (flipped by 4 backwards) above speed 2. Speed squared >> 16 is regd3.
 No result. The puck's y lead is one expression, `*pucky + HIBYTE(*puckvy) - y`: Watcom spills the byte to
 [esp] and adds *pucky from a register, as the EXE. */
void doplayeracc(Player *p, short dir)
{
    short spa;
    short d;
    short dx;
    short y, dy;
    short t;
    int xv, yv;

    if (p->position == 0) {
        goalieacc(p, dir);
        return;
    }
    if (p->pflags & pfrev) spa = SPAglideback;
    else if (p->SCnum == SCref) {
        if (refsignal != 0 || ((gmode & gmclock) == 0 && ((gmode2 & 0x80) || (gmode & 8))))
            spa = SPArefglidesig;
        else spa = SPArefglide;
    } else spa = SPAglide;
    dir &= 0xF;
    if (dir > 7) {
        if (dir == 9 && (p->Xvel | p->Yvel)) {
            dostop(p);
            return;
        }
        if (!(p->pflags2 & pf2aip)) SetSPA(p, spa);
        return;
    }
    d = dir;
    if (*puckc == p->SCnum) goto clrrev;
    dx = *puckx - HIWORD(p->Xpos);
    y = HIWORD(p->Ypos);
    dy = *pucky + HIBYTE(*puckvy) - y;
    if (!(p->pflags & pfgoal)) {
        dx = -dx;
        y = -y;
        dy = -dy;
        dir ^= 4;
    }
    if (!(p->pflags & pfrev)) {
        if (y >= 0 || dir != 4 || ((vtoa(dx, dy) + 1) & 7) > 2) goto clrrev;
    }
    if (p->pflags & pfrev) {
        dir = (dir - 3) & 7;
        if (dir > 2 || ((vtoa(dx, dy) + 2) & 7) > 4) goto clrrev;
    }
    if (!(p->pflags & pfrev) && p->SCnum != SCref && !(gmode & gmclock)) {
        if (!(p->Yvel | p->Xvel) || ((vtoa(p->Xvel, p->Yvel) - d + 1) & 7) <= 2) p->pflags |= pfrev;
    }
    goto done;
clrrev:
    p->pflags &= ~pfrev;
done:
    t = (d - p->facedir) & 7;
    if (doplayeracc_ftab[t] == 0) {
        noturn0(p, t, p->facedir);
        return;
    }
    xv = p->Xvel; yv = p->Yvel;
    regd3.l = xv * xv + yv * yv >> 16;
    regd4.w = 0x300 - regd3.w;
    if (regd4.w < 0x180) regd4.w = 0x180;
    regd4.l = regd4.w * doplayeracc_ftab[t];
    if (p->pflags & pfrev) regd4.l = -regd4.l;
    *(int *)p->pad_34 += regd4.l;
    p->facedir &= 7;
    if ((unsigned short)regd3.w > 0x14) {
        if ((doplayeracc_ftab[t] < 0) ^ ((p->attribute & 8) != 0)) {
            if (p->SCnum == SCref) {
                if (refsignal != 0 || ((gmode & gmclock) == 0 && ((gmode2 & 0x80) || (gmode & 8))))
                    spa = 0xBAB;
                else spa = 0xABB;
            } else spa = 0x331;                     /* SPAturnl */
        } else {
            if (p->SCnum == SCref) {
                if (refsignal != 0 || ((gmode & gmclock) == 0 && ((gmode2 & 0x80) || (gmode & 8))))
                    spa = 0xBC3;
                else spa = 0xAD3;
            } else spa = 0x349;                     /* SPAturnr */
        }
        p->pflags2 |= pf2aip;
    }
    SetSPA(p, spa);
    if ((unsigned short)regd3.w > 2) playeracc(p, (p->pflags & pfrev) ? (p->facedir ^ 4) : p->facedir);
}
