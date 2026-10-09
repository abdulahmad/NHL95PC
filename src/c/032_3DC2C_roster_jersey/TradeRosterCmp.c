/* Roster / jersey: trade list sort. */
#include "nhl95.h"

/* TradeRosterCmp (3FEF0) - qsort compare for trade roster rows: same position letter (byte 0) sorts by name (+6), empty
   rows last, then positions in the order L, C, R, D, others. */
int TradeRosterCmp(unsigned char *a, unsigned char *b)
{
    if (*a == *b) {
        if (!*a) return 0;
        return strcmp((char *)a + 6, (char *)b + 6);
    }
    if (!*a) return 1;
    if (!*b) return -1;
    if (*a == 'L') return -1;
    if (*b == 'L') return 1;
    if (*a == 'C') return -1;
    if (*b == 'C') return 1;
    if (*a == 'R') return -1;
    if (*b == 'R') return 1;
    if (*a == 'D') return -1;
    return 1;
}
