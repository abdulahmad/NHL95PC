/* Schedule: calendar date keys. */
#include "nhl95.h"

/* DateKey: sortable day number of a season date: months before September (0-based month < 9) belong to
 the next calendar year (+12), then month * 31 + day. */
int DateKey(int month, int day)
{
    if (month >= 9) return month * 31 + day;
    return (month + 12) * 31 + day;
}
