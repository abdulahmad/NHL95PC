/* Engine assign/faceoff: force the starting lineup at the opening faceoff. */
#include "nhl95.h"

/* ForceStartLineup: at the opening faceoff of the game (flag demoflag clear, gsp 0, the
 clock still at the full period length, no ticks yet) put team `team`'s lineup on the ice at once
 (forcepldata on hmtmstruct + team * 100h: 0 home, 1 away). */
void ForceStartLineup(short team)
{
    if (demoflag == 0 && gsp == 0 && gameclock == PerTimeTotal && clockticks[0] == 0)
        forcepldata(&hmtmstruct + team);
}
