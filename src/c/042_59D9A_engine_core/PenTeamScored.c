/* Engine core: delayed-penalty goal check. */
#include "nhl95.h"

/* PenTeamScored (5AAAE) - PC-new. During a delayed penalty (gmpendel, 93G gmode bit 3): side = (puck y < 0)
   xor gmdir (0 home, 1 away); when it differs from (lasttouch < 6), returns 1 if that side's SortCords block
   (0-5 or 6-11) has a skater (position >= 0) with pflags2 bit 4 (caused a penalty), else 0. Goal then
   disallows the goal. */
int PenTeamScored(void)
{
    int side, i;
    Player *p;

    if (gmode & gmpendel) {
        side = (*pucky < 0) ^ ((gmode & gmdir) != 0);
        if ((lasttouch < 6) ^ side) {
            if (side) side = 6;
            p = &SortCords[side];
            for (i = 0; i < 6; i++, p++) {
                if (p->position >= 0 && (p->pflags2 & 0x10)) return 1;
            }
        }
    }
    return 0;
}
