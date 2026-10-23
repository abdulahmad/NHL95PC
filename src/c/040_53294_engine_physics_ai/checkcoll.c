/* Engine physics AI: one object's collision pass. */
#define checkcoll checkcoll_decl
#include "nhl95.h"
#undef checkcoll
void checkcoll(Player *p, short x, short y);  /* x and y are compared and stored as words */

/* checkcoll: clear the collision flag. Unless pflags bit 2 is set, test the walls at the player's
 position (and, for a skater with no wall normal, again at the hot-spot step), then the other players.
 On a collision, keep the old position unless the animation is in the block range. Otherwise reinsert
 p in the y-sorted object list and store its y. When sflags bit 7 is set, the two coordinates are swapped. */
void checkcoll(Player *p, short x, short y)
{
    short sc;
    short i;
    short pl;

    dword_CCC2C = 0;
    collflag = 0;
    if (sflags & 0x80) {
        pl = y;
        y = x;
        x = pl;
    }
    if (!(p->pflags & 4)) {
        wcradiusx = p->radiusx;
        wcradiusy = p->radiusy;
        checkwallcoll(p, p->Xpos >> 16, p->Ypos >> 16);
        if ((p->Wallcos | p->Wallsin) == 0 && p->SCnum <= 11) {
            GetHot(p);
            wcradiusy = wcradiusx = 1;
            checkwallcoll(p, (short)(HIWORD(p->Xpos) + regd0.w), (short)(HIWORD(p->Ypos) + regd1.w));
        }
        checkplcoll(p, x, y);
    }
    if (collflag) {
        if (p->SPA < 0xF0F || p->SPA > 0x1055) {
            *(short *)((char *)&p->Xpos + 2) = *(short *)((char *)&p->OldXpos + 2);
            *(short *)((char *)&p->Ypos + 2) = *(short *)((char *)&p->OldXpos + 6);
        }
        return;
    }
    sc = p->SCnum;
    i = OOlistpos[sc];
    while (i != 16) {
        pl = (signed char)OOlist[i + 1];
        if (y <= Ylist[(signed char)OOlist[i + 1]]) break;
        OOlistpos[sc]++;
        OOlistpos[pl]--;
        OOlist[i] = pl;
        OOlist[i + 1] = sc;
        i++;
    }
    i = OOlistpos[sc];
    if (i) {
        do {
            pl = (signed char)OOlist[i - 1];
            if (y >= Ylist[(signed char)OOlist[i - 1]]) break;
            OOlistpos[sc]--;
            OOlistpos[pl]++;
            OOlist[i] = pl;
            OOlist[i - 1] = sc;
        } while (--i);
    }
    Ylist[sc] = y;
}
