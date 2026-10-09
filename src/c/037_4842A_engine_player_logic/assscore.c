/* Engine player logic: goal celebration (93G assscore). */
#include "nhl95.h"

#define PUCK ((Player *)puckstruct)

/* assscore (4A90F) - 93G assscore: celebrate a goal. The scorer drops the puck (puckc -1; a puck in assignment 18h
   goes to 1Ah). Not while flag 20h or heading to the bench (check4bench). A new assignment (bit 1): a random wait
   temp1 (0-119), temp2 = 8 and the spot temp3 / temp4: -50h / 0 in gmode bit 7, else x +-100 by the camera side and
   the camera y (55 lower on the left); the scorer (lastplayer) restarts the dance count dword_CCA58. When temp1
   runs out: flag 20h, a new wait and SPA 731h - the scorer SPA 769h, up to 3 in a row (or at random) with no wait,
   then count reset and a wait of at least 30. Else, unless pflags bit 3, skate to the spot. */
void assscore(Player *p)
{
    if (*puckc == p->SCnum) {
        *puckc = -1;
        if (((unsigned char *)(PUCK->assnum + (int)puckstruct))[0x1E] == 0x18) assreplace(PUCK, 0x1A);
    }
    if (p->pflags & 0x20) return;
    if (check4bench(p)) return;
    if (p->pflags & 2) {
        p->pflags &= 0xFD;
        p->temp1 = randomd0(0x78);
        p->temp2 = 8;
        if (gmode & 0x80) {
            p->temp3 = -0x50;
            p->temp4 = 0;
        } else {
            p->temp3 = camx < 0 ? -100 : 100;
            p->temp4 = camy;
            if (camx < 0) p->temp4 = camy - 0x37;
        }
        if (p->SCnum == lastplayer) dword_CCA58 = 0;
    }
    if (--p->temp1 < 0) {
        p->pflags |= 0x20;
        regd1.w = 0x731;
        p->temp1 = randomd0(0x78);
        if (p->SCnum == lastplayer) {
            regd1.w = 0x769;
            if (!dword_CCA58 || (dword_CCA58 < 3 && !randomd0(2))) {
                p->temp1 = 0;
                dword_CCA58++;
            } else {
                dword_CCA58 = 0;
                p->temp1 = p->temp1 > 0x1E ? p->temp1 : 0x1E;
            }
        }
        SetSPA(p, regd1.w);
        return;
    }
    if (p->pflags & 8) return;
    regd0.w = p->temp3;
    regd1.w = p->temp4;
    skateto(p, 0);
}
