/* Engine core: between periods. */
#include "nhl95.h"

/* IntermissionStart: gsp 4 -> GameOver; else Intermission, StartPer, SetPenaltyStrength. */
void IntermissionStart(void)
{
    if (gsp == 4) {
        GameOver();
        return;
    }
    Intermission();
    if (gsp > 0) IntermissionPC();
    StartPer();
    SetPenaltyStrength();
}
