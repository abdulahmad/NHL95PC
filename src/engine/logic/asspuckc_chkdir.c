/* Engine player logic: the puck carrier's evade check. */
#include "nhl95.h"

/* asspuckc_chkdir (4C9FD, Genesis asspuckc chkdir): skateto's evade routine for the puck carrier p; regd0.w is
 the direction skateto picked (sign-extended from its low byte here). regd2 / regd3 = the puck position plus p's
 velocity >> 8. For each of the six opposing skaters (SortCords 6-11 for the home side, 0-5 for the visitors):
 with his predicted spot (position + velocity >> 8) within 19h of that point on both axes, count a threat and
 steer away from him (vtoa of the gap), turning randomly by 0-1 when that is straight back (facedir ^ 4). Then,
 deep in his own end (|regd3| AAh..E8h on his side, |regd2| <= 50h): steer towards the team's player at +FAh of
 the team structure when that one's predicted spot is within 14h (the second test re-checks regd1, as the EXE
 does); and within 1Eh of the centre line in x and 14h of the goal line (y DCh) head round the net (vtoa of the
 gap to the goal line). No result; the direction is left in regd0. The team-mate's predicted spot adds the
 velocity first (the EXE's register order). */
void asspuckc_chkdir(Player *p)
{
    Player *o;
    short t;

    regd0.w = (signed char)regd0.w;
    regd2.w = *puckx + (p->Xvel >> 8);
    regd3.w = *pucky + (p->Yvel >> 8);
    threat = 0;
    regd4.w = 6;
    o = &SortCords[regd4.w > p->SCnum ? 6 : 0];
    do {
        regd1.w = (o->Xpos >> 16) + (o->Xvel >> 8) - regd2.w;
        if (ABS(regd1.w) <= 0x19) {
            regd1.w = (o->Yvel >> 8) + (o->Ypos >> 16) - regd3.w;
            if (ABS(regd1.w) <= 0x19) {
                threat++;
                regd0.w = vtoa((short)(HIWORD(p->Xpos) - HIWORD(o->Xpos)), (short)(HIWORD(p->Ypos) - HIWORD(o->Ypos)));
                regd1.w = p->facedir ^ 4;
                if (regd0.w == regd1.w) regd0.w = (randomd0(2) + regd0.w) & 7;
            }
        }
        o++;
    } while (--regd4.w);
    if (((p->pflags & 0x80) != 0) ^ (HIWORD(p->Ypos) < 0)) return;
    if (ABS(regd3.w) < 0xAA || ABS(regd3.w) > 0xE8 || ABS(regd2.w) > 0x50) return;
    regd4.w = *(short *)((char *)p->tmptr + 0xFA);
    if (regd4.w >= 0) {
        o = &SortCords[regd4.w];
        regd1.w = (o->Xvel >> 8) + (o->Xpos >> 16) - regd2.w;
        if (ABS(regd1.w) <= 0x14) {
            regd4.w = (o->Yvel >> 8) + (o->Ypos >> 16) - regd3.w;
            if (ABS(regd1.w) <= 0x14) regd0.w = vtoa((short)-regd1.w, (short)-regd4.w);
        }
    }
    if (ABS(regd2.w) <= 0x1E) {
        t = (p->pflags & 0x80) ? -0xDC : 0xDC;
        regd1.w = t - regd3.w;
        if (ABS(regd1.w) <= 0x14) regd0.w = vtoa(p->Xpos >> 16, (short)(HIWORD(p->Ypos) - t));
    }
}
