/* Season playoffs: pre-simulation. */
#include "nhl95.h"

/* POPreSimConfFinals (8803B) - as POPreSimRound1 for the 2 conference-final series (+1B90h). */
void POPreSimConfFinals(unsigned char *po, int a, int b)
{
    unsigned char *s;
    int i;

    s = po + 0x1B90;
    for (i = 0; i < 2; i++, s += 0x2A) {
        if (s[2] == a || s[3] == a) POSimSeriesTeamWins(s, a);
        else if (s[2] == b || s[3] == b) POSimSeriesTeamWins(s, b);
        else POSimSeries(s, 7);
    }
}
