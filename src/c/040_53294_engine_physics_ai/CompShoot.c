/* Engine physics / AI: computer shot. */
#include "nhl95.h"

/* CompShoot (55A35) - computer player p shoots: regd0 = puck y toward p's goal end (negated unless pflags bit 7),
   regd1 = (E8h - regd0) / 8, the shot delay temp2 = min(regd1, 20); assignment 12h (shoot). */
void CompShoot(Player *p)
{
    regd0.w = *pucky;
    if (!(p->pflags & pfgoal)) regd0.w = -regd0.w;
    regd1.w = (unsigned short)(0xE8 - regd0.w) >> 3;
    p->temp2 = regd1.w < 20 ? regd1.w : 20;
    assreplace(p, 0x12);
}
