/* Engine physics / AI: puck collision scan. */
#include "nhl95.h"

#define OOB(i) (*(int *)(OOlist + (i) - 2) >> 24)      /* OOlist byte i + 1, as the top byte of a dword */
#define YL(n) (*(int *)((char *)Ylist + (n) * 2 - 2) >> 16)  /* Ylist[n], as the top word of a dword */

/* PuckCheckColl (548AC) - PC only: puck p stops (x / y velocity 0) more than 400 from the centre line in y; while
   it is low (z up to 16) walk the y-sorted object list (OOlist) up and down from its place (OOlistpos) and check
   each object within 40 in y against it (checkpuckcoll). */
void PuckCheckColl(Player *p)
{
    short i;
    short pl;

    if ((HIWORD(p->Ypos) < 0 ? -(p->Ypos >> 16) : p->Ypos >> 16) > 400) {
        p->Yvel = 0;
        p->Xvel = p->Yvel;
    }
    if (HIWORD(p->Zpos) > 16) return;
    for (i = OOlistpos[HIWORD(*(int *)&p->radiusy)]; i != 16; i++) {
        pl = (signed char)OOlist[i + 1];
        if (YL(OOB(i)) - (p->Ypos >> 16) > 40) break;
        checkpuckcoll(p, pl);
    }
    i = OOlistpos[HIWORD(*(int *)&p->radiusy)];
    if (i == 0) return;
    do {
        pl = (signed char)OOlist[i - 1];
        if ((p->Ypos >> 16) - YL(OOB(i - 2)) > 40) return;
        checkpuckcoll(p, pl);
    } while (--i);
}
