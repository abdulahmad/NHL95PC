/* Schedule: date arithmetic. */
#include "nhl95.h"

/* NormalizeDate (41C9B) - carry a day count that runs past the end of its month into the following months
   (monthdays_m1: days per month). */
void NormalizeDate(unsigned char *month, unsigned char *day)
{
    while (*day > monthdays_m1[*month]) {
        *day = *day - monthdays_m1[*month];
        (*month)++;
    }
}
