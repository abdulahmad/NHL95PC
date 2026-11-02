/* Sweepcheck: player p starts a sweep check. Locks his animation (pflags pfalock)
 and starts the sweep check animation. */
#include "nhl95.h"

void Sweepcheck(Player *p)
{
    p->pflags |= pfalock;
    SetSPA(p, SPAsweep);
}
