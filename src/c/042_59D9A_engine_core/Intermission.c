/* Intermission (5DE42) - 93G/94G Intermission start: SetupTeamForIntermission (bench reset, energy refill,
   starting lines), then clear the integer part of Xpos of all 17 sort objects (94G clr.w (a0) ;Xpos). */
#include "nhl95.h"

void Intermission(void)
{
    short i;

    SetupTeamForIntermission();
    for (i = 0; i < 17; i++) HIWORD(SortCords[i].Xpos) = 0;
}
