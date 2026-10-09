/* Engine assign/faceoff: force the starting lineup at the opening faceoff (PC only). */
#include "nhl95.h"

/* ForceStartLineup (5125F) - PC only: at the opening faceoff of the game (flag dword_CC0EC clear, gsp 0, the
   clock still at the full period length, no ticks yet) put team `team`'s lineup on the ice at once
   (forcepldata on hmtmstruct + team * 100h: 0 home, 1 away). */
void ForceStartLineup(short team)
{
    if (dword_CC0EC == 0 && gsp == 0 && gameclock == PerTimeTotal && clockticks[0] == 0)
        forcepldata(&hmtmstruct + team);
}
