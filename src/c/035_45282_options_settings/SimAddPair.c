/* Options settings: pair list helper. */
#include "nhl95.h"

/* SimAddPair: append the pair (a, b) to a list of at most 4 pairs (two ints each); *count is the
 number of pairs in use. */
void SimAddPair(int *count, int (*pairs)[2], int a, int b)
{
    if (*count < 4) {
        pairs[*count][0] = a;
        pairs[*count][1] = b;
        (*count)++;
    }
}
