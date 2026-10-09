/* Schedule: playoff series setup. */
#include "nhl95.h"

/* SetSeriesTeams (42F42) - PC only: fill the team bytes of playoff series s (+2 home, +3 away, then 6-byte game
   records with the home team at +2 and the away team at +3 of each record, from +6) for a best-of-games series
   between a (home ice) and b. Seven games: 2-2-1-1-1 home pattern (games 1, 2, 5, 7 at a); when the two
   teams' teamdivflags together give 3 (one from each conference) games 3-4 are at a too (2-3-2). Five games:
   2-2-1; three games: 1-1-1; otherwise just s[2] / s[3]. */
void SetSeriesTeams(unsigned char *s, int a, int b, int games)
{
    if ((teamdivflags[a] | teamdivflags[b]) == 3 && games == 7) {
        s[0x26] = a; s[0x20] = a; s[0x1B] = a; s[0x15] = a; s[0x0F] = a; s[0x08] = a; s[0x02] = a;
        s[0x27] = b; s[0x21] = b; s[0x1A] = b;
        goto tail4;
    }
    if (games == 7) {
        s[0x26] = a; s[0x21] = a; s[0x1A] = a; s[0x15] = a; s[0x0F] = a; s[0x08] = a; s[0x02] = a;
        s[0x27] = b; s[0x20] = b;
tail5:
        s[0x1B] = b;
tail4:
        s[0x14] = b; s[0x0E] = b; s[0x09] = b; s[0x03] = b;
        return;
    }
    if (games == 5) {
        s[0x1A] = a; s[0x15] = a; s[0x0F] = a; s[0x08] = a; s[0x02] = a;
        goto tail5;
    }
    if (games == 3) {
        s[0x0E] = a; s[0x09] = a; s[0x02] = a;
        s[0x0F] = b; s[0x08] = b; s[0x03] = b;
        return;
    }
    s[0x02] = a;
    s[0x03] = b;
}
