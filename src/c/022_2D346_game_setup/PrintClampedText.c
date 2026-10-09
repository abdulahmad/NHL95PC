/* Game setup: labels. */
#include "nhl95.h"

/* PrintClampedText (2F580) - print s with a shadow at x / y, kept inside its half of the screen: right half (x >= 140h)
   ends by 280h, left half ends by F0h but starts no further left than 8. */
void PrintClampedText(int x, int y, char *s)
{
    int w;

    w = fputchar(s);
    if (x >= 0x140 && x + w > 0x280) {
        x = 0x280 - w;
    } else if (x < 0x140 && x + w > 0xF0) {
        x = 0xF0 - w;
        if (x < 8) x = 8;
    }
    PrintShadowText(x, y, s);
}
