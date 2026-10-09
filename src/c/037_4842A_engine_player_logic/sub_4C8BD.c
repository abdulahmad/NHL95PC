/* Engine player logic: lane to a team-mate behind the net. */
#include "nhl95.h"

/* sub_4C8BD (4C8BD) - PC only: with p's predicted spot (position + velocity / 512) deep in its own end (|y|
   AAh..E8h on p's own side, |x| <= 50h) and its current assignment slot (byte +1Eh + assnum) not 11h: when the
   team's player slot +FAh is set, and regd1.w is within 20 (checked twice - the EXE tests regd1 rather than the
   gaps), regd0.w = vtoa of the gap to that player's predicted spot. */
void sub_4C8BD(Player *p)
{
    int y;
    int x;
    int n;
    Player *o;

    x = (p->Xvel >> 9) + (p->Xpos >> 16);
    y = (p->Yvel >> 9) + (p->Ypos >> 16);
    if (((unsigned char *)p)[0x1E + p->assnum] == 0x11) return;
    if (((p->pflags & 0x80) != 0) ^ (HIWORD(p->Ypos) < 0)) return;
    if (ABS(y) < 0xAA || ABS(y) > 0xE8 || ABS(x) > 0x50) return;
    n = *(short *)((char *)p->tmptr + 0xFA);
    if (n < 0) return;
    o = &SortCords[n];
    x -= (o->Xpos >> 16) + (o->Xvel >> 9);
    if (ABS(regd1.w) > 20) return;
    y -= (o->Ypos >> 16) + (o->Yvel >> 9);
    if (ABS(regd1.w) > 20) return;
    regd0.w = vtoa((short)x, (short)y);
}
