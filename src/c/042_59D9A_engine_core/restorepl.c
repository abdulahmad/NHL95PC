/* Engine core: hand the joystick from one player to another (93G logic93_1 restorepl). */
#include "nhl95.h"

/* restorepl (59FE1) - restore old joy controlled player oldpl, give newpl the joystick (93G logic93_1
   restorepl). If oldpl (a skater, 0-11) is in line change mode (pf2lcm) he keeps control: returns oldpl.
   Else oldpl loses pfjoy and gets pfna (new assignment), newpl (0-11) gets pfjoy; returns newpl. */
short restorepl(short newpl, short oldpl)
{
    Player *o;

    if (oldpl >= 0 && oldpl <= 11) {
        o = &SortCords[oldpl];
        if (o->pflags2 & pf2lcm) return oldpl;
        o->pflags &= ~pfjoy;                                    /* release the old player (bclr pfjoycon) */
        o->pflags |= pfna;                                      /* bset pfna */
    }
    if (newpl >= 0 && newpl <= 11) SortCords[newpl].pflags |= pfjoy;
    return newpl;
}
