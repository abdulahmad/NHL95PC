/* Engine physics / AI: should the computer pull its goalie for a faceoff (PC only). */
#include "nhl95.h"

/* ChkPullGoalieLate (593F5) - PC only: 1 when team side (0 home, 1 away) is not the one on controller 1, the
   game is in the third period (gsp 2) with at most 60 s left, the team trails by 1-2 goals and the faceoff y
   (foy, sign flipped by the first SortCords entry's pflags bit 7) is on its attacking side; else 0. */
int ChkPullGoalieLate(int side)
{
    Team *t;
    Team *o;
    int y;
    int diff;

    t = &hmtmstruct + side;
    o = &hmtmstruct + (unsigned char)(side == 0);
    y = foy;
    if (gsp != 2) return 0;
    if (gameclock > 60) return 0;
    if (cont1team == side + 1 || cont1team == side + 1) return 0; /* the asm tests this twice (je, je) */
    diff = o->tmscore - t->tmscore;
    if (diff > 0) {
        if (diff > 2) return 0;
        if ((t->tmsort->pflags & 0x80) == 0) y = -y;
        if (y < 0) return 0;
        return 1;
    }
    return 0;
}
