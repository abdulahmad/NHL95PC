/* Engine assign faceoff: penalty shot assignments. */
#include "nhl95.h"

/* the current assignment byte (slot +1Eh + assnum), read signed as the top byte of a dword */
#define CURASS(p) (*(int *)((char *)(p) + (p)->assnum + 0x1B) >> 24)

/* PenShotAssign: hand out the penalty shot assignments to the 12 players. In penshotmode: skaters
 (position > 0) get temp5 0 and the shooter (penshotplayer) 27h, the others clear the ice (2Dh) unless already in
 29h 1Dh; goalies get temp5 0 and the defending one (side penshotteam) stays (2Dh), the other leaves (27h, no
 line change). Afterwards: at penshotstart the players clearing (2Dh) come back (27h then 9; not with gameopts bit
 2), skaters get 28h (no line change) and goalies not in 29h 27h; else skaters not in 29h 1Dh get 27h (28h with
 gameopts bit 2) and goalies not in 29h get 27h, both with temp5 0. */
void PenShotAssign(void)
{
    Player *p;
    int i;

    p = SortCords;
    if (penshotmode) {
        for (i = 0; i < 12; i++, p++) {
            if (p->position > 0) {
                p->temp5 = 0;
                if (i == penshotplayer) assinsert(p, 0x27);
                else if (CURASS(p) != 0x29 && CURASS(p) != 0x1D) assinsert(p, 0x2D);
            }
            if (p->position == 0) {
                p->temp5 = p->position;
                if (((p->pflags & 0x40) != 0) ^ penshotteam) {
                    p->newpnum = -1;
                    p->newpos = -1;
                    assinsert(p, 0x27);
                } else assinsert(p, 0x2D);
            }
        }
        return;
    }
    for (i = 0; i < 12; i++, p++) {
        if (penshotstart) {
            if (((unsigned char *)p + p->assnum)[0x1E] == 0x2D) {
                if (*(unsigned char *)&gameopts & 4) continue;
                assinsert(p, 0x27);
                assinsert(p, 9);
            } else if (p->position > 0) {
                p->newpos = -1;
                p->newpnum = p->newpos;
                assinsert(p, 0x28);
            } else if (p->position == 0 && ((unsigned char *)p + p->assnum)[0x1E] != 0x29) assinsert(p, 0x27);
        } else if (p->position > 0) {
            p->temp5 = 0;
            if (CURASS(p) == 0x29 || CURASS(p) == 0x1D) continue;
            assinsert(p, (*(unsigned char *)&gameopts & 4) ? 0x28 : 0x27);
        } else if (p->position == 0) {
            p->temp5 = p->position;
            if (CURASS(p) == 0x29) continue;
            assinsert(p, 0x27);
        }
    }
}
