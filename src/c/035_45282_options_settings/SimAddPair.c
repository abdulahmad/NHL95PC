/* Options / settings: pair list helper. */
#include "nhl95.h"

/* SimAddPair (452A6) - append the pair (a, b) to a list of at most 4 pairs (two ints each); *count is the
   number of pairs in use. */
void SimAddPair(int *count, int *pairs, int a, int b)
{
    int n;

    n = *count;
    if (n < 4) {
        pairs[n * 2] = a;
        pairs[*count * 2 + 1] = b;
        (*count)++;
    }
}
