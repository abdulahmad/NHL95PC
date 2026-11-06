/* Scoring penalty text: game time stamps. */
#include "nhl95.h"

/* GetPeriodTimeRemaining: time stamp of the current moment for the scoring penalty summaries: period (gsp) in
 the top bits (<< 14), elapsed time of the period (PerTimeTotal - gameclock) in the low bits. */
short GetPeriodTimeRemaining(void)
{
    return (gsp << 14) + PerTimeTotal - gameclock;
}
