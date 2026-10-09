/* GetPeriodTime (5B9D1) - 93G GetPeriodTime: the period length for the current options: PerTimeTab (CBC4A)
   indexed by the period-length option (gameopts bits 10-11). With gameopts bit 9 set, overtime periods (curperiod
   above 3) always get the full length PerTimeTab[0]. */
#include "nhl95.h"

short GetPeriodTime(void)
{
    short t = PerTimeTab[gameopts.pertime];

    if (gameopts.fullot && curperiod > 3) t = PerTimeTab[0];
    return t;
}
