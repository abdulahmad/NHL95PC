/* Engine physics / AI: player collision scan (93G checkplcoll). */
#include "nhl95.h"

#define OOB(i) (*(int *)(OOlist + (i) - 2) >> 24)  /* OOlist byte i + 1, read as the top byte of a dword */

/* checkplcoll (58CE2) - 93G checkplcoll: unless p is out of play (pflags2 bit 5), for a skater (SCnum up to 11)
   or SCnum 16: walk the y-sorted object list (OOlist) up from p's place (OOlistpos) and then down, while the next
   object is within 16 in y of y, checking each against p at x (checkcx). */
void checkplcoll(Player *p, short x, int y)
{
    short i;
    short d;
    short pl;

    if (p->pflags2 & 0x20) return;
    if (p->SCnum > 11 && p->SCnum != 16) return;
    i = OOlistpos[HIWORD(*(int *)&p->radiusy)];
    for (;;) {
        if (i == 16) break;
        pl = (signed char)OOlist[i + 1];
        if ((d = Ylist[OOB(i)] - y) > 16) break;
        checkcx(p, x, d, pl);
        i++;
    }
    i = OOlistpos[HIWORD(*(int *)&p->radiusy)];
    if (i == 0) return;
    do {
        pl = (signed char)OOlist[i - 1];
        if ((d = y - Ylist[OOB(i - 2)]) > 16) return;
        checkcx(p, x, d, pl);
    } while (--i);
}
