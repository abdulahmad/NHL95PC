/* Engine core: force the new players onto the ice (93G forcepldata). */
#include "nhl95.h"

#define PNUM(p) (*(int *)&(p)->pad_40 >> 24)  /* newpnum, read as the top byte of the dword at +40h */

/* forcepldata (5E0DD) - 93G hockey93_05 forcepldata (no skating on/off, faceoffs only): for the 6 SortCords entries
   of team t: newpos -> position; a player put on the ice gets Setplass, the center anearest (assinsert 11h), his
   tmpdst -1, roster status 4 (on ice) and setplayer with newpnum. newpnum / newpos are cleared to -1. */
void forcepldata(Team *t)
{
    Player *p;
    short i;

    p = t->tmsort;
    i = 6;
    do {
        if ((p->position = p->newpos) >= 0) {
            Setplass(p);
            if (p->position == 4) assinsert(p, 0x11);
            t->tmpdst[PNUM(p)] = -1;
            t->tmroster[PNUM(p) * 39] = 4;
            setplayer(p, PNUM(p));
        }
        p->newpnum = -1;
        p->newpos = -1;
        p++;
    } while (--i);
}
