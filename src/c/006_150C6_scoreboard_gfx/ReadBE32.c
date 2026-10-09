/* Scoreboard graphics: big-endian reader. */
#include "nhl95.h"

/* ReadBE32 (16072) - 32-bit big-endian value at p (bytes read as signed chars, as the original). */
int ReadBE32(signed char *p)
{
    int v;

    v = *p++;
    v = (v << 8) + *p++;
    v = (v << 8) + *p++;
    v = (v << 8) + *p++;
    return v;
}
