/* Engine core: between periods. */
#include "nhl95.h"

/* PeriodOver_sp: gsp 4 -> GameOver; else Intermission, StartPer, SetPenaltyStrength. */
void PeriodOver_sp(void)
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
