/* Line editor / rosters: status line. */
#include "nhl95.h"

/* PrintLineEdStatus (76771) - clear the status line box at x / y (11 lines high, width of s clipped to x 26Bh) and print
   s there. */
void PrintLineEdStatus(int x, int y, char *s)
{
    int w;

    if (fputchar(s) + x > 0x26B) w = 0x26B - x;
    else w = fputchar(s);
    sub_90D20(x, y + 2, w, 0xB, dlgfillcol);
    sub_91964(s, x, y);
}
