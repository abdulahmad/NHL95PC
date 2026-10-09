/* Season playoffs: pre-simulation. */
#include "nhl95.h"

/* POPreSimRound2 (87FE0) - as POPreSimRound1 for the 4 second-round series (+1AE8h). */
void POPreSimRound2(unsigned char *po, int a, int b)
{
    unsigned char *s;
    int i;

    s = po + 0x1AE8;
    for (i = 0; i < 4; i++, s += 0x2A) {
        if (s[2] == a || s[3] == a) POSimSeriesTeamWins(s, a);
        else if (s[2] == b || s[3] == b) POSimSeriesTeamWins(s, b);
        else POSimSeries(s, 7);
    }
}
