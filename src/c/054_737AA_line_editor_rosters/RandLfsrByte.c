/* Line editor: pseudo-random bytes. */
#include "nhl95.h"

/* RandLfsrByte (7665E) - step the 8-bit Galois LFSR *s (taps B8h; a zero state is reseeded with 2Bh) and return it. */
unsigned char RandLfsrByte(unsigned char *s)
{
    unsigned char bit;
    unsigned char v;

    if (!*s) *s = 0x2B;
    bit = *s & 1;
    v = *s;
    v >>= 1;
    *s = v;
    if (bit) *s = v ^ 0xB8;
    return *s;
}
