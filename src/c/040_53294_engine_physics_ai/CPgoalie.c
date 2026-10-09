/* Engine physics / AI: a computer team pulls its goalie late (PC only). */
#include "nhl95.h"

/* CPgoalie (591C7) - PC only (called from ChkGoalies): computer team t pulls its goalie when no penalty shot
   runs, gsp is 2 (third period), t trails o by 1-2 goals (up to gsp), at most 60 s are left and the puck y is
   on the attacking side (sign flipped by the first SortCords entry's pflags bit 7). The goalie byte gets -1, the
   goalie's menu item is unchecked (2) and "pulled" checked (1) in off_CD498, then setpersonel. */
void CPgoalie(Team *t, Team *o, int y)
{
    short per;
    short diff;
    short side;

    if (penshotmode != 0) return;
    per = gsp;
    if (per != 2) return;
    diff = o->tmscore - t->tmscore;
    if (diff <= 0 || diff > per) return;
    if (gameclock > 60) return;
    if ((t->tmsort->pflags & 0x80) == 0) y = -y;
    if ((short)y < 0) return;
    HIBYTE(t->tmgoalie) = -1;
    side = (t == &awtmstruct);
    *(unsigned char *)((int (*)[3])off_CD498)[side][(short)(t->tmgoalie & 0xF)] = 2;
    *(unsigned char *)((int (*)[3])off_CD4A0)[side][0] = 1;
    setpersonel(t);
}
