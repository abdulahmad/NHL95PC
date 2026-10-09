/* StopIfFree (4A80E) - PC only: let player p glide to a stop (doplayeracc with direction 8 = no input) unless his
   animation is locked (pflags bit 5, pfalock) or he is under joystick control (bit 3). Used by the position
   assignments. */
#include "nhl95.h"

void StopIfFree(Player *p)
{
    if ((p->pflags & pfalock) == 0 && (p->pflags & pfjoy) == 0) doplayeracc(p, 8);
}
