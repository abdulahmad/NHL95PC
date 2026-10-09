/* File utilities: scoreboard penalty panel. */
#include "nhl95.h"

/* PanelAddPenalty (14C22) - PC only: put player pl with penalty time t into the first free entry (player -1) of
   the home or away penalty panel list (8 entries of 4 shorts: player, time, then 2 cleared fields), reset the
   panel redraw flags (dword_C585C / C5860) and mark that side's list for redraw (dword_C5844 / C5848 = 0). */
void PanelAddPenalty(short away, short pl, short t)
{
    short *e;
    short i;

    dword_C5860 = dword_C585C = 0;
    e = away ? hudpenaway : hudpenhome;
    for (i = 0; i < 8; i++) {
        if (e[0] == -1) {
            e[0] = pl;
            e[1] = t;
            e[3] = 0;
            e[2] = e[3];
            if (away) dword_C5848 = 0;
            else dword_C5844 = 0;
            return;
        }
        e += 4;
    }
}
