/* Schedule: calendar date keys. */
#include "nhl95.h"

/* DateKey (41C79) - sortable day number of a season date: months before September (0-based month < 9) belong to
   the next calendar year (+12), then month * 31 + day. */
int DateKey(int month, int day)
{
    int m;

    if (month < 9) m = month + 12;
    else m = month;
    return m * 31 + day;
}
