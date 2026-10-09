/* Engine player logic: enter from the bench (93G asseben). */
#include "nhl95.h"

/* asseben (4AAC2) - 93G asseben: assignment 'enter from the bench' for player p. Nothing while locked in an
   animation (pflags bit 5). On a new assignment (pflags bit 1, pfna) the player stops, is placed at the bench
   door (x -A0h, y = (SCnum - 6, +2 when >= 0) * 0Eh, regd0 holds the slot), faces 2, pflags bits 4-5 cleared
   and bit 5 set, SPA D15h for the goalie (position 0) else 7A1h. Otherwise: facedir 4, pflags bit 2 and pflags2
   bits 2/5 cleared, SPA 0, Xvel 1000h, assexit. */
void asseben(Player *p)
{
    if (p->pflags & 0x20) return;
    if (p->pflags & 2) {
        p->pflags &= 0xFD;                  /* clear pfna */
        p->Xvel = 0;
        p->Yvel = 0;
        *(short *)((char *)p + 0x48) = 0;
        regd0.w = p->SCnum - 6;
        if (regd0.w >= 0) regd0.w += 2;
        HIWORD(p->Ypos) = regd0.w * 0xE;
        HIWORD(p->Xpos) = -0xA0;
        p->facedir = 2;
        p->pflags &= 0xCF;
        p->pflags |= 0x20;
        SetSPA(p, p->position == 0 ? 0xD15 : 0x7A1);
        return;
    }
    p->facedir = 4;
    p->pflags &= 0xFB;
    p->pflags2 &= 0xDB;
    p->SPA = 0;
    p->Xvel = 0x1000;
    assexit(p);
}
