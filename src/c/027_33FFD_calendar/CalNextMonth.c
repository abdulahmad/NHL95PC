/* Calendar: month arrows. */
#include "nhl95.h"

/* CalNextMonth (34691) - next-month arrow: both arrows on, calmonth + 1 (wrapping 12 -> 0, skipping 6); the last season
   month (5) turns the next arrow off. Clears the selected day. */
void CalNextMonth(void)
{
    calnextslot = (int)CalNextMonth;
    calprevslot = (int)CalPrevMonth;
    if (++calmonth == 0xC) calmonth = 0;
    if (calmonth == 6) calmonth = 5;
    if (calmonth == 5) calnextslot = 0;
    calsel = -1;
}
