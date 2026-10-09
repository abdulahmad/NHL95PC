/* pucknorm (4D8C7) - 93G/94G pucknorm (puck carrier assignment, slot 18h), head part: on a new assignment
   (pflags pfna set) clear pfna, temp1 = 0, temp2 = 78h and the pass/shot path count psendcount; then the rest of
   the 93G routine runs in pucknorm_body (puckcross timers ...). The 94G BA_PS_flags penalty-shot check is not
   here. */
#include "nhl95.h"

void pucknorm(Player *p)
{
    if (p->pflags & pfna) {
        p->pflags &= ~pfna;
        p->temp1 = 0;
        p->temp2 = 0x78;
        psendcount = 0;
    }
    pucknorm_body(p);
}
