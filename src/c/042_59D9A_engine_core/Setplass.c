/* Engine core: set a player's initial assignment from his position (94G collide94 Setplass). */
#include "nhl95.h"

/* Setplass (5B298) - set player p's initial assignment from his position (94G collide94 Setplass): for
   positions 0-6, assreplace(p, Setplass_alist[position]) (goalie: assgoalie, defence: assdefd, wings:
   asswingd, centre: asscenterd). Other positions (negative, or above 6 on the PC) are left alone. */
void Setplass(Player *p)
{
    short pos;

    pos = p->position;
    if (pos >= 0 && pos <= 6)
        assreplace(p, Setplass_alist[pos]);
}
