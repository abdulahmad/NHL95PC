/* Options / settings: random helper. */
#include "nhl95.h"

/* RandMod (45282) - random number 0..n-1 from the C library rand (15 bits). */
int RandMod(int n)
{
    return (rand() & 0x7FFF) % n;
}
