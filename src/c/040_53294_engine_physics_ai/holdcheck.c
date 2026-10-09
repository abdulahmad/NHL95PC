/* Engine physics / AI: holding check (93G holdcheck). */
#include "nhl95.h"

#define HIW(v) (((short *)&(v))[1])

/* holdcheck (56B79) - 93G holdcheck: player a grabbing player b. Not when a is already held (pflags bit 5), is
   SCnum 16, has no position or pflags2 bit 0 is set; only when b faces a (direction from b to a within one step of
   b's facedir). Dropping the puck carrier clears sflags bit 3; both skate on at their mean velocity, both get
   pflags bit 5, a takes SPA 669h and b 651h (88Bh unless b is in 639h). On a quick shot chance (QuickShotChk)
   with no penalty shot pending, a gets the penalty shot (penshotctl 1 / 2 / -1 by controller) and b a penalty 1Ah,
   the puck is loose (puckc -1) and b's nopuck 20h; else unless a's checking aggression (checkagr) is over 6, b
   gets holding (12h when in SPA 651h, else 0Fh). Then collflag -1. */
void holdcheck(Player *a, Player *b)
{
    int d;
    short v;

    if (a->pflags & 0x20 || a->SCnum == 16 || a->position == 0 || a->pflags2 & 1) return;
    d = b->facedir;
    if (((vtoa((short)(HIW(a->Xpos) - HIW(b->Xpos)), (short)(HIW(a->Ypos) - HIW(b->Ypos))) - d + 1) & 7) > 2) return;
    if (*(signed char *)puckc == a->SCnum) sflags &= 0xF7;
    v = (a->Xvel + b->Xvel) >> 1;
    a->Xvel = v;
    b->Xvel = v;
    v = (a->Yvel + b->Yvel) >> 1;
    a->Yvel = v;
    b->Yvel = v;
    a->pflags |= 0x20;
    SetSPA(a, 0x669);
    b->pflags |= 0x20;
    SetSPA(b, b->SPA == 0x639 ? 0x651 : 0x88B);
    if (QuickShotChk(a)) {
        if (penshotplayer < 0) {
            penshotplayer = a->SCnum;
            if (c1playernum[0] == penshotplayer) penshotctl = 1;
            else if (c1playernum[0] == penshotplayer) penshotctl = 2;
            else penshotctl = -1;
            AddPenalty(b, 0x1A);
            *(signed char *)puckc = -1;
            b->nopuck = 0x20;
        }
    } else if (checkagr(b) <= 6) {
        AddPenalty(b, b->SPA == 0x651 ? 0x12 : 0xF);
    }
    collflag = 0xFF;
}
