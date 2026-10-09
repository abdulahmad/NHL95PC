/* setpassmode (551AF) - 93G/94G setpassmode: enter pass mode for player p. The default pass direction (passdir)
   is the player's facing direction (facedir, 0-7); sflags bit 2 marks pass mode. The Genesis version also
   handles the BA_PS_flags pass-aim timer, which the PC version does not have. */
#include "nhl95.h"

void setpassmode(Player *p)
{
    passdir = p->facedir & 7;   /* facedir is the default pass direction: first 3 bits */
    sflags |= 4;                /* pass mode */
}
