/* Engine physics / AI: aggression. */
#include "nhl95.h"

/* checkagr (5369F) - random roll for an aggressive act (fight / penalty) by p: range (20 - aggress) * 16, doubled with
   pflags bit 3, halved within 40 of the puck in both x and y, x8 after the second period, doubled without
   gameopts bit 9, x4 per power-play man down (other tmap - own tmap >= 1, >= 2) and x4 against the puck carrier's
   team during a stoppage; randomd0 of 1.5 times that. Returns 0 for a hit. */
short checkagr(Player *p)
{
    short n;
    int d;
    short m;

    n = (0x14 - p->aggress) << 4;
    if (p->pflags & 8) n += n;
    d = HIWORD(p->Xpos) - *puckx;
    if (d < 0) d = -d;
    if (d <= 0x28) {
        d = HIWORD(p->Ypos) - *pucky;
        if (d < 0) d = -d;
        if (d <= 0x28) n >>= 1;
    }
    if (gsp > 2) n <<= 3;
    if (!gameopts.fullot) n += n;
    m = p->optmptr->tmap - p->tmptr->tmap;
    if (m >= 1) n <<= 2;
    if (m >= 2) n <<= 2;
    if ((gmode & 8) && *puckc >= 0 && ((p->SCnum < 6) ^ (*puckc < 6))) n <<= 2;
    return randomd0(((int)n >> 1) + n);
}
