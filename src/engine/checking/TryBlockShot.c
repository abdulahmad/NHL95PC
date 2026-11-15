/* Engine physics AI: shot blocking. */
#include "nhl95.h"

/* TryBlockShot: chance for player p to block a shot: range 8 (4 when gmode2 bit 5 is set and p is not
 on the team of gmode2 bit 6), plus 15 - the rating byte at 5Ah; randomd0(range 2) <= 1 succeeds, then if
 CanBlockShot says how, BlockShotDive. */
void TryBlockShot(Player *p)
{
    int r;
    int n;

    n = 8;
    if ((gmode2 & 0x20) && ((*(short *)&gmode2 & 0x40) ^ (unsigned char)(p->pflags & 0x40))) n = 4;
    n += 15 - ((unsigned char *)p)[0x5A];
    n /= 2;
    if (randomd0(n) <= 1) {
        r = CanBlockShot(p);
        if (r) BlockShotDive(p, r);
    }
}
