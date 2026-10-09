/* Season playoffs: pre-simulation. */
#include "nhl95.h"

/* POPreSimRound1 (87F85) - pre-simulate the 8 first-round series (2Ah bytes each at +1998h): a series with team a or b
   (the human teams) is decided for that team, the others are simulated over 7 games. */
void POPreSimRound1(unsigned char *po, int a, int b)
{
    unsigned char *s;
    int i;

    s = po + 0x1998;
    for (i = 0; i < 8; i++, s += 0x2A) {
        if (s[2] == a || s[3] == a) POSimSeriesTeamWins(s, a);
        else if (s[2] == b || s[3] == b) POSimSeriesTeamWins(s, b);
        else POSimSeries(s, 7);
    }
}
