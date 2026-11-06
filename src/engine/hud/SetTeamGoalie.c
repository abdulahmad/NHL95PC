/* Engine display: goalie choice. */
#include "nhl95.h"

/* SetTeamGoalie: for a human-controlled side set the goalie choice g (negative: pull the goalie, tmgoalie |=
 FFF0h); with the play live (gmode bit 3, not bit 0) and the puck on the other side the high byte goes FFh
 setpersonel when the choice changed (not from none to none). The puck carrier byte is read in place in both
 tests (Watcom keeps the one load in bl); a local for it, or a second copy of the old choice, moves the
 registers of the whole function. */
void SetTeamGoalie(short side, short g)
{
    short old;

    old = (&hmtmstruct)[side].tmgoalie;
    if (cont1team != side + 1 && cont2team != side + 1) return;
    if (g < 0) {
        (&hmtmstruct)[side].tmgoalie |= 0xFFF0;
    } else {
        (&hmtmstruct)[side].tmgoalie = g;
        if (!(gmode & 1) && (gmode & 8)) {
            if (*puckc >= 0 && ((*puckc < 6) ^ side)) byte_DF64D[side << 8] |= 0xFF;
        }
    }
    if ((&hmtmstruct)[side].tmgoalie < 0 && old < 0) return;
    if (old != (&hmtmstruct)[side].tmgoalie) setpersonel(&(&hmtmstruct)[side]);
}
