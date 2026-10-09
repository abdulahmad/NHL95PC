/* Season / playoffs: series setup. */
#include "nhl95.h"

/* POSetSeriesTeams (87520) - fill playoff series record s for teams a and b: the 7 game slots (6 bytes each from
   +2) get the home / visiting team bytes. When both teams' division flags together are 3 (one of each kind),
   games 3, 4 and 5 swap home ice the other way. Both scores of every game (+4 / +5) start at FFh (not played). */
void POSetSeriesTeams(unsigned char *s, int a, int b)
{
    int f;
    int i;

    f = teamdivflags[a] | teamdivflags[b];
    if (f == 3) {
        s[0x26] = a;
        s[0x20] = a;
        s[0x1B] = a;
        s[0x15] = a;
        s[0x0F] = a;
        s[0x08] = a;
        s[0x02] = a;
        s[0x27] = b;
        s[0x21] = b;
        s[0x1A] = b;
    } else {
        s[0x26] = a;
        s[0x21] = a;
        s[0x1A] = a;
        s[0x15] = a;
        s[0x0F] = a;
        s[0x08] = a;
        s[0x02] = a;
        s[0x27] = b;
        s[0x20] = b;
        s[0x1B] = b;
    }
    s[0x14] = b;
    s[0x0E] = b;
    s[0x09] = b;
    s[0x03] = b;
    for (i = 0; i < 7; i++) {
        s[i * 6 + 4] = 0xFF;
        s[i * 6 + 5] = 0xFF;
    }
}
