/* Engine player logic: line change before a faceoff (94G checks94 StartFaceoffLineChange). */
#include "nhl95.h"

/* StartFaceoffLineChange (4DA37) - start a line change for player p's team before a faceoff (94G checks94
   StartFaceoffLineChange). r is the object that waits for the change (94G a2; its temp words hold the wait).
   Clears pf2lcm, calls SetLCmode(p); when the team went into line change mode (pf2lcm set again): away player
   (pfteam) -> r->temp2 = 168h and r->temp4 = p's SCnum, home player -> r->temp1 = 258h and r->temp3 = SCnum. */
void StartFaceoffLineChange(Player *r, Player *p)
{
    p->pflags2 &= ~pf2lcm;                      /* bclr #3,pflags2(a3) */
    SetLCmode(p);
    if (p->pflags2 & pf2lcm) {
        if (p->pflags & pfteam) {
            r->temp2 = 0x168;
            r->temp4 = p->SCnum;
        } else {                                /* home player */
            r->temp1 = 0x258;
            r->temp3 = p->SCnum;
        }
    }
}
