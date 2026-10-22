/* Engine display: goalie choice. */
#include "nhl95.h"

/* SetTeamGoalie: for a human-controlled side set the goalie choice g (negative: pull the goalie, tmgoalie |=
 FFF0h); with the play live (gmode bit 3, not bit 0) and the puck on the other side the high byte goes FFh
 setpersonel when the choice changed (not from none to none). */
/* DRAFT: 204 vs 204. Reading the old choice through g2 gives the EXE's side / address / old registers; left:
   the puck carrier byte c is loaded into dl (EXE bl). */
void SetTeamGoalie(short side, short g)
{
    short old;
    short g2;
    signed char c;

    g2 = (&hmtmstruct)[side].tmgoalie;
    old = g2;
    if (cont1team != side + 1 && cont2team != side + 1) return;
    if (g < 0) {
        (&hmtmstruct)[side].tmgoalie |= 0xFFF0;
    } else {
        (&hmtmstruct)[side].tmgoalie = g;
        if (!(gmode & 1) && (gmode & 8)) {
            c = *puckc;
            if (c >= 0 && ((c < 6) ^ side)) byte_DF64D[side << 8] |= 0xFF;
        }
    }
    if ((&hmtmstruct)[side].tmgoalie < 0 && old < 0) return;
    if (old != (&hmtmstruct)[side].tmgoalie) setpersonel(&(&hmtmstruct)[side]);
}
