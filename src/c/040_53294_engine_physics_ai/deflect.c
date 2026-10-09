/* Engine physics / AI: the puck deflects (93G deflect). */
#include "nhl95.h"

/* deflect (57A3E) - 93G deflect: the puck p is deflected: no carrier (puckc byte -1), random x / y velocity
   -1000h..FFFh, random z velocity 0..FFFh (also left in regd0), then puckflip. */
void deflect(Player *p)
{
    *(unsigned char *)puckc = 0xFF;
    p->Yvel = randomd0(0x2000) - 0x1000;
    p->Xvel = randomd0(0x2000) - 0x1000;
    regd0.w = p->Zvel = randomd0(0x1000);
    puckflip(p);
}
