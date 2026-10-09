/* Team select: jersey graphic. */
#include "nhl95.h"

/* MakeJerseyShape (7A099) - fill the jersey shape buf with colour c2 (bytes 0-8Fh and C0h-EFh) and draw number num
   (0-99) on it with BlitJerseyDigit: one centred digit (+30h), or tens (+0) and units (+6Ch). */
void MakeJerseyShape(unsigned char *buf, unsigned num, unsigned char c1, unsigned char c2)
{
    short i;

    for (i = 0; i <= 0x8F; i++) buf[i] = c2;
    for (i = 0xC0; i <= 0xEF; i++) buf[i] = c2;
    if (num > 99) return;
    if (num < 10) {
        BlitJerseyDigit(buf + 0x30, num, c1, c2, 0);
    } else {
        BlitJerseyDigit(buf, num / 10, c1, c2, 0);
        BlitJerseyDigit(buf + 0x6C, num % 10, c1, c2, 1);
    }
}
