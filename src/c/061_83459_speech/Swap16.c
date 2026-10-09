/* Speech: byte order helpers. */
#include "nhl95.h"

/* Swap16 (837D9) - swap the two bytes of a 16-bit value (big-endian sample headers). */
unsigned Swap16(unsigned x)
{
    return ((x & 0xFF) << 8) | ((x >> 8) & 0xFF);
}
