/* Engine player logic: penalty box. */
#include "nhl95.h"

/* assepen (4B02D) - penalised player p goes to the box: a new assignment (pflags bit 1; flags 4 set, 2 and 10h cleared,
   pflags2 bit 2) seats him at x 9Eh, y -21h - 11 * slot (home, PBnum[0] - 1 capped at 2) or 21h + 11 * slot
   (pflags bit 6, PBnum[1]), facing 2, SPA 7BFh, flag 20h. Without a new assignment he leaves: facing 4, no
   pending change, flags cleared, Xvel -1000h, assexit. Nothing while flag 20h. */
void assepen(Player *p)
{
    signed char f;
    int k;

    f = p->pflags;
    if (f & 0x20) return;
    if (f & 2) {
        p->pflags |= 4;
        p->pflags &= 0xED;
        p->pflags2 |= 4;
        if (!(p->pflags & 0x40)) {
            if (--PBnum[0] > 2) k = 2;
            else k = *(int *)((char *)&PBnum[0] - 3) >> 24;
            HIWORD(p->Ypos) = -0x21 - (k * 12 - k);
        } else {
            if (--PBnum[1] > 2) k = 2;
            else k = *(int *)((char *)&PBnum[1] - 3) >> 24;
            HIWORD(p->Ypos) = k * 12 - k + 0x21;
        }
        p->Xvel = 0;
        p->Yvel = 0;
        HIWORD(p->Xpos) = 0x9E;
        p->facedir = 2;
        p->pflags |= 0x20;
        SetSPA(p, 0x7BF);
        SprSort();
        return;
    }
    p->facedir = 4;
    p->newpnum = -1;
    p->newpos = -1;
    p->pflags &= 0xF3;
    p->pflags2 &= 0xDB;
    p->Xvel = -0x1000;
    assexit(p);
}
