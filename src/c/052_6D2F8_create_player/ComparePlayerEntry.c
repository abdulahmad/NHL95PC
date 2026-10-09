/* Create player: player list sort. */
#include "nhl95.h"

/* ComparePlayerEntry (6D78B) - qsort compare for player list rows: same position letter (byte 0) sorts by name (+0Bh),
   empty rows last, then positions in the order L, C, R, D, others. */
int ComparePlayerEntry(unsigned char *a, unsigned char *b)
{
    if (*a == *b) {
        if (!*a) return 0;
        return strcmp((char *)a + 0xB, (char *)b + 0xB);
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
