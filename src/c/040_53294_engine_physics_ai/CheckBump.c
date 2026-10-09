/* Engine physics / AI: a fast player bumps the puck carrier (PC only). */
#include "nhl95.h"

/* CheckBump (54990) - PC only: player p runs into the puck carrier c. One time in 20h (randomd0), with the
   puck within 28h in y of c and p faster than 1B58h in x or y: c takes a quarter of p's velocity, p stops,
   sflags bit 6 (sfslock) is set and, while the clock runs, p gets penalty 1Eh (AddPenalty2). Returns 1 then,
   else 0. */
int CheckBump(Player *p, Player *c)
{
    short dy;
    short yv;
    short xv;

    if (randomd0(0x20) == 0) {
        dy = *pucky - HIWORD(c->Ypos);
        if ((dy < 0 ? -(int)dy : (int)dy) <= 0x28) {
            xv = p->Xvel;
            yv = p->Yvel;
            if ((xv < 0 ? -(int)xv : (int)xv) > 0x1B58 || (yv < 0 ? -(int)yv : (int)yv) > 0x1B58) {
                c->Xvel = xv >> 2;
                c->Yvel = yv >> 2;
                p->Xvel = 0;
                p->Yvel = 0;
                sflags |= 0x40;
                if (gmode & 1) return 1;
                AddPenalty2(p, 0x1E);
                return 1;
            }
        }
    }
    return 0;
}
