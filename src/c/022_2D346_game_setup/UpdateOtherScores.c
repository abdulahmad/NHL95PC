/* UpdateOtherScores - advance the six other games to the home team's period (period plus the difference of the
   start lags, teamstartlag, of the home team and the game's first team): for each period reached a game below the
   3rd scores 0-2 goals per team; at period 4 (overtime) a tied game goes on (4) and a team wins with a 30% chance
   each (5, one goal more), otherwise it is over (6); period 5 ends an overtime game. */
#include "nhl95.h"

void UpdateOtherScores(int period)
{
    int last;
    int i;
    int p;

    for (i = 0; i < 6; i++) {
        last = teamstartlag[*(int *)((char *)&HomeTeam - 2) >> 16] - teamstartlag[othergames[i * 2]];
        last += period;
        if (last < otherperiod[i]) continue;
        for (p = otherperiod[i]; p <= last; p++) {
            if (p == 4) {
                if (otherscores[i * 2] == otherscoresb[i * 2]) {
                    otherperiod[i] = p;
                    if ((rand() & 0x7FFF) % 100 > 70) {
                        otherperiod[i] = 5;
                        otherscores[i * 2]++;
                    } else if ((rand() & 0x7FFF) % 100 > 70) {
                        otherperiod[i] = 5;
                        otherscoresb[i * 2]++;
                    }
                } else {
                    otherperiod[i] = 6;
                }
            } else if (p == 5 && otherperiod[i] == 4) {
                otherperiod[i] = 5;
            } else if (otherperiod[i] < 3 && p != otherperiod[i]) {
                otherperiod[i] = p;
                otherscores[i * 2] += (rand() & 0x7FFF) % 3;
                otherscoresb[i * 2] += (rand() & 0x7FFF) % 3;
            }
        }
    }
}
