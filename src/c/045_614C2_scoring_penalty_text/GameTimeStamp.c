/* Scoring / penalty text: game time stamps. */
#include "nhl95.h"

/* GameTimeStamp (62CD7) - time stamp of the current moment for the scoring / penalty summaries: period (gsp) in
   the top bits (<< 14), elapsed time of the period (PerTimeTotal - gameclock) in the low bits. */
short GameTimeStamp(void)
{
    return (gsp << 14) + PerTimeTotal - gameclock;
}
