/* Team select: jersey numbers. */
#include "nhl95.h"

/* BlitJerseyDigit: draw digit d of the jersey number font (jerseydigits: 3 dwords of pixel bits,
 84 pixels) into buffer dst in colour c1 (c2 unused), one byte per set bit; for the right digit the pixels after the first 36 go
 48 bytes further on (the digit's lower rows). */
void BlitJerseyDigit(unsigned char *dst, unsigned d, unsigned char c1, unsigned char c2, int right)
{
    int bits;
    int i;
    int o;

    for (i = 0; i < 84; i++) {
        if (i % 32 == 0) bits = ((int (*)[3])jerseydigits)[d][i / 32];
        if (bits & 1) {
            if (right != 0 && i > 35) o = i + 48;
            else o = i;
            dst[o] = c1;
        }
        bits >>= 1;
    }
}
