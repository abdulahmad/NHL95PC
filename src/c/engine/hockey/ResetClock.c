/* Engine core: reset the game clock for a new period. */
#include "nhl95.h"

/* ResetClock: reset the game clock for a new period: gameclock =
 PerTimeTotal = GetPeriodTime, clockticks = 0, periodendtime = gameclock - random(length 2), and the
 clock is stopped (gmode bit 0) until the faceoff drop. */
void ResetClock(void)
{
    short t;

    gameclock = t = GetPeriodTime();
    clockticks[0] = 0;
    PerTimeTotal = t;
    t = t >> 1;                                 /* not >>= (that drops a cwde) */
    periodendtime = gameclock - randomd0(t);
    gmode |= gmclock;                           /* game clock stopped */
}
