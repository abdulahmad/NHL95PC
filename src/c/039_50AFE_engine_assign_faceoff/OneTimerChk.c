/* Engine assignments / faceoff: one-timer. */
#include "nhl95.h"

/* OneTimerChk (50E5C) - may receiver p one-time the pass: in the attacking zone (|y| 4Fh-DDh, on the side p attacks),
   the other team's goalie in net; across from the goalie (different x) beyond 12 always, else a 1 in 3 chance
   (1 in 2 beyond 6). Returns 1 for a one-timer. */
int OneTimerChk(Player *p)
{
    Player *g;
    int i;
    int y;
    int x;
    short n;

    if (HIWORD(p->Ypos) < 0) y = -HIWORD(p->Ypos);
    else y = HIWORD(p->Ypos);
    if (y <= 0x4E || y >= 0xDE) return 0;
    if (!((HIWORD(p->Ypos) < 0) ^ ((p->pflags & pfgoal) != 0))) return 0;
    if (p->optmptr->tmgoalie < 0) return 0;
    g = &SortCords[p->SCnum < 6 ? 6 : 0];
    for (i = 0; i < 6; i++, g++) if (!g->position) break;
    n = 3;
    if (HIWORD(p->Xpos) ^ HIWORD(g->Xpos)) {
        if (HIWORD(g->Xpos) < 0) x = -HIWORD(g->Xpos);
        else x = HIWORD(g->Xpos);
        if (x > 12) return 1;
        if (x > 6) n = 2;
    }
    if (!randomd0(n)) return 1;
    return 0;
}
