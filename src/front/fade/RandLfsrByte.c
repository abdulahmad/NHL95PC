/* Line editor: pseudo-random bytes. */
#include "nhl95.h"

/* RandLfsrByte: step the 8-bit Galois LFSR *s (taps B8h; a zero state is reseeded with 2Bh) and return it. */
unsigned char RandLfsrByte(unsigned char *s)
{
    unsigned char bit;

    if (!*s) *s = 0x2B;
    bit = *s & 1;
    *s >>= 1;
    if (bit) *s ^= 0xB8;
    return *s;
}
