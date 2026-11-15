/* Engine physics/AI: forehand or backhand swing. */
#include "nhl95.h"

/* Findhittype: type of swing for player p shooting in direction dir. d = (facedir - dir) & 7; returns 1 (backhand) when bit d
 of F0h (sprite X-flipped, attribute bit 3) or of 1Eh (not flipped) is set, else 0 (forehand). */
short Findhittype(Player *p, short dir)
{
    dir = (p->facedir - dir) & 7;
    if (p->attribute & 8)                       /* x flip */
        return ((1 << dir) & 0xF0) != 0;          /* %11110000 */
    return ((1 << dir) & 0x1E) != 0;              /* %00011110 */
}
