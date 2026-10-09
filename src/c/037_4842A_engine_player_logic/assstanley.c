/* Engine player logic: Stanley Cup celebration. */
#include "nhl95.h"

/* assstanley (4A832) - Stanley Cup celebration skate for p (not while flag 20h): a new assignment (pflags bit 1) heads
   for (-50h, 0) with SPA ECBh and Pencntdwn 100h; when the SPA ends, full energy (tmpde 300h) and SPA 833h. Near
   the target direction (vtoa <= 7) turn one step every 12 frames toward it and skate. */
void assstanley(Player *p)
{
    if (p->pflags & 0x20) return;
    if (p->pflags & 2) {
        p->pflags &= 0xFD;
        p->temp3 = -0x50;
        p->temp4 = 0;
        p->temp1 = 0;
        ((unsigned char *)p)[0x46] = 0;
        SetSPA(p, 0xECB);
        Pencntdwn = 0x100;
    }
    if (!p->SPA) {
        p->tmptr->tmpde[p->pnum] = 0x300;
        SetSPA(p, 0x833);
    }
    regd0.w = vtoa((short)(p->temp3 - HIWORD(p->Xpos)), (short)(p->temp4 - HIWORD(p->Ypos)));
    if (regd0.w > 7) return;
    if (--p->temp1 < 0) {
        p->temp1 += 12;
        if (p->facedir != regd0.w) p->facedir = (p->facedir + 1) & 7;
    }
    playeracc(p, regd0.w);
}
