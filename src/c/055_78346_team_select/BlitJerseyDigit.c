/* Team select: jersey numbers. */
#include "nhl95.h"

/* BlitJerseyDigit (7A017) - PC only: draw digit d of the jersey number font (jerseydigits: 3 dwords of pixel bits,
   84 pixels) into buffer dst in colour c1 (c2 unused), one byte per set bit; for the right digit the pixels after the first 36 go
   48 bytes further on (the digit's lower rows). */
void BlitJerseyDigit(unsigned char *dst, unsigned d, int c1, int c2, int right)
{
    int bits;
    unsigned char col;
    int i;
    int o;

    col = c1;
    for (i = 0; i < 84; i++) {
        if (i % 32 == 0) bits = ((int (*)[3])jerseydigits)[d][i / 32];
        if (bits & 1) {
            if (right != 0 && i > 35) o = i + 48;
            else o = i;
            dst[o] = col;
        }
        bits >>= 1;
    }
}
