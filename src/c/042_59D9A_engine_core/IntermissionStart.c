/* Engine core: between periods. */
#include "nhl95.h"

/* IntermissionStart (5DE70) - 93G hockey93_06 IntermissionStart. gsp 4 -> GameOver; else Intermission (PC:
   IntermissionPC after the first period), StartPer, SetPenaltyStrength. */
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
