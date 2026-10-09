/* assexit (4D509) - 93G/94G assexit: finish the current assignment of player p. Steps to the next entry of the
   player's 8-deep assignment stack (assnum + 1, wrapped to 0-7) and sets pflags bit 1 (93G pfna, 'new
   assignment') so the assignment dispatcher starts it on the next pass. */
#include "nhl95.h"

void assexit(Player *p)
{
    p->assnum = (p->assnum + 1) & 7;    /* add 1 to the assignment index, keep the first 3 bits */
    p->pflags |= 2;                     /* pfna: signal next assignment */
}
