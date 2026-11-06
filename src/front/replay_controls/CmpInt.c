/* Highlights: qsort compare for ints. */
#include "nhl95.h"

/* CmpInt: qsort callback: 1, 0 or -1 as *a is above, equal to or below *b. */
int CmpInt(const void *a, const void *b)
{
    int r;

    r = 0;
    if (*(int *)a > *(int *)b) r = 1;
    else if (*(int *)a < *(int *)b) r = -1;
    return r;
}
