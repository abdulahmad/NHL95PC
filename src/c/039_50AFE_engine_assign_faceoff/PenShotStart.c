/* Engine assign / faceoff: penalty shot. */
#include "nhl95.h"

/* PenShotStart (511B4) - penalty shot setup for team side's 6 objects: at the start (penshotstart) an object on
   assignment 2Dh gets 29h (temp5 0); otherwise an on-ice object without a pending change (newpos / newpnum -1,
   temp5 != -100) not already on assignment 27h gets it inserted. */
void PenShotStart(short side)
{
    Player *p;
    int i;

    if (penshotmode) return;
    p = &SortCords[side * 6];
    for (i = 0; i < 6; i++, p++) {
        if (penshotstart && p->asslist[p->assnum] == 0x2D) {
            p->temp5 = 0;
            assreplace(p, 0x29);
        } else if (p->position >= 0 && p->newpos == -1 && p->newpnum == -1 && p->temp5 != -100
                   && p->asslist[p->assnum] != 0x27) {
            assinsert(p, 0x27);
        }
    }
}
