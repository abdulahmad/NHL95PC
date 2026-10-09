/* Team select: game line check. */
#include "nhl95.h"

/* PruneGameLines (79090) - PC only: fit the line table lines of team side to its roster status (side's roster, 27h
   bytes per player, 444h per team). During a game (curperiod >= 0): a slot (of 28h) whose player is neither
   dressed (3) nor 4 becomes empty (100). Before it: every status 2 player of the 28 becomes 3, then the players in
   the goalie / extra slots 28h-2Fh with status 3 go back to 2. */
void PruneGameLines(unsigned char side, unsigned char *lines)
{
    int i;
    unsigned char *s;
    unsigned char st;
    int r;

    if (curperiod >= 0) {
        for (i = 0; i < 0x28; i++) {
            s = lines + i;
            if (*s == 100) continue;
            r = side * 0x444 + *s * 39;
            st = hmroster[r];
            if (st != 4 && st != 3) *s = 100;
        }
        return;
    }
    for (i = 0; i < 28; i++) {
        if (hmroster[side * 0x444 + i * 39] == 2) hmroster[side * 0x444 + i * 39] = 3;
    }
    for (i = 0; i < 8; i++) {
        if (lines[i + 0x28] != 100 && hmroster[lines[i + 0x28] * 39 + side * 0x444] == 3)
            hmroster[lines[i + 0x28] * 39 + side * 0x444] = 2;
    }
}
