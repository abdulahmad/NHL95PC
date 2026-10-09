/* Sweepcheck (532A2) - 93G/94G Sweepcheck: player p starts a sweep check. Locks his animation (pflags pfalock)
   and starts the sweep check animation (93G $B24). */
#include "nhl95.h"

void Sweepcheck(Player *p)
{
    p->pflags |= pfalock;
    SetSPA(p, SPAsweep);
}
