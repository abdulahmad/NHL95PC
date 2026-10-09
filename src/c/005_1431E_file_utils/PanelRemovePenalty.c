/* File utilities: scoreboard penalty panel. */
#include "nhl95.h"

/* PanelRemovePenalty (14CA0) - clear player pl's entry (4 shorts: player, then 3 cleared fields) from the home or away
   penalty panel list (8 entries). */
void PanelRemovePenalty(short away, short pl)
{
    short *e;
    short *f;
    short i;

    e = away ? hudpenaway : hudpenhome;
    f = 0;
    for (i = 0; i < 8; i++) {
        if (pl == e[0]) {
            f = e;
            break;
        }
        e += 4;
    }
    if (f) {
        f[3] = 0;
        f[1] = f[2] = f[3];
    }
}
