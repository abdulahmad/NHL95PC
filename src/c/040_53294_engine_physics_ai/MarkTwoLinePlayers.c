/* Engine physics / AI: two-line pass. */
#include "nhl95.h"

/* MarkTwoLinePlayers (55C6F) - two-line pass option: when the puck pk crosses the red line (y sign change against its
   previous y, word +7Ah), flag (pflags2 bit 7) the attacking team's skaters already past it and clear the flag
   on the other team. Team order by gmode bit 1. */
void MarkTwoLinePlayers(Player *pk)
{
    Player *a;
    Player *b;
    short k;

    if (!gameopts.twolinepass) return;
    if (gmode & 2) {
        a = &SortCords[6];
        b = &SortCords[0];
    } else {
        a = &SortCords[0];
        b = &SortCords[6];
    }
    if (HIWORD(pk->Ypos) >= 0) {
        if (((short *)pk)[0x7A / 2] >= 0) return;
        k = 6;
        do {
            if (a->position >= 0 && HIWORD(a->Ypos) > 0) a->pflags2 |= 0x80;
            else a->pflags2 &= 0x7F;
            b->pflags2 &= 0x7F;
            a++;
            b++;
        } while (--k);
        return;
    }
    if (((short *)pk)[0x7A / 2] < 0) return;
    k = 6;
    do {
        if (b->position >= 0 && HIWORD(b->Ypos) < 0) b->pflags2 |= 0x80;
        else b->pflags2 &= 0x7F;
        a->pflags2 &= 0x7F;
        a++;
        b++;
    } while (--k);
}
