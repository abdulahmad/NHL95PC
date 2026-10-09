/* Calendar: month arrows. */
#include "nhl95.h"

/* CalPrevMonth (346FE) - previous-month arrow: both arrows on, calmonth - 1 (wrapping -1 -> 11, skipping 8); the first
   season month (9) turns the previous arrow off. Clears the selected day. */
void CalPrevMonth(void)
{
    calnextslot = (int)CalNextMonth;
    calprevslot = (int)CalPrevMonth;
    if (--calmonth == -1) calmonth = 0xB;
    if (calmonth == 8) calmonth = 9;
    if (calmonth == 9) calprevslot = 0;
    calsel = -1;
}
