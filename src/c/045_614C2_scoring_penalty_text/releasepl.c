/* Scoring / penalty text: penalty release (93G releasepl). */
#include "nhl95.h"

/* releasepl (6392A) - a penalty is over for team tm: the first free SortCords slot of the team (position < 0) comes
   back with the position priolist[tmap (+1 with the goalie pulled)], tmap + 1; both teams' line flags are
   set. The slot is filled with roster player pl (setplayer) and flagged pflags2 bit 2. */
void releasepl(Team *tm, short pl)
{
    Player *p;

    p = tm->tmsort;
    while (p->position >= 0) p++;
    tm->tmap++;
    hmtmflags[0] |= 1;
    awtmflags |= 1;
    byte_DF6E8 |= 0x40;
    byte_DF7E8 |= 0x40;
    p->position = priolist[tm->tmap + (tm->tmgoalie < 0)];
    Setplass(p);
    setplayer(p, pl);
    p->pflags2 |= 4;
}
