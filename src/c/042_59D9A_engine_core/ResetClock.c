/* Engine core: reset the game clock for a new period (93G hockey93_01 ResetClock). */
#include "nhl95.h"

/* ResetClock (5BA07) - reset the game clock for a new period (93G hockey93_01 ResetClock): gameclock =
   PerTimeTotal = GetPeriodTime(), clockticks = 0, periodendtime = gameclock - random(length / 2), and the
   clock is stopped (gmode bit 0) until the faceoff drop. */
void ResetClock(void)
{
    short t;

    gameclock = t = GetPeriodTime();
    clockticks[0] = 0;
    PerTimeTotal = t;
    periodendtime = gameclock - randomd0(t >> 1);
    gmode |= gmclock;                           /* game clock stopped */
}
