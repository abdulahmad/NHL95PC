/* Engine player logic: flip the puck (93G logic93_5 / 94G checks94 puckflip). */
#include "nhl95.h"

/* puckflip (4DFA4) - flip the puck (93G logic93_5 / 94G checks94 puckflip). PC addition: when Xvel + Yvel of
   p is below 14h the puck is too slow and puckunflip runs instead. Else facedir ^= regd0 & 1, kept in 0-3,
   SPAcnt = -1 (st SPAcnt) and the puck-flip animation (SPApflip). */
void puckflip(Player *p)
{
    if (p->Xvel + p->Yvel < 0x14) {
        puckunflip(p);
        return;
    }
    p->facedir = (p->facedir ^ (regd0.w & 1)) & 3;  /* eor.w d0,facedir(a3) / andi.w #3 */
    p->SPAcnt = -1;
    SetSPA(p, SPApflip);
}
