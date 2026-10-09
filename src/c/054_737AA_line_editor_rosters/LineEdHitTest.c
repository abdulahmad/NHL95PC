/* Line editor / rosters: mouse hit test. */
#include "nhl95.h"

/* LineEdHitTest (77F6F) - PC only: which line editor item is at mouse x, y. Left of x 1F0h: one of the 40 line
   slots (lineslotx / linesloty pairs, 3Ah x 28h boxes) -> *item = slot; otherwise a roster row (y 16h-181h,
   13 pixels each) -> *item = 100 + row. Returns 1 on a hit, else 0. */
int LineEdHitTest(int x, int y, int *item)
{
    int i;
    int top;

    x += 4;
    if (x < 500) {
        for (i = 0; i < 40; i++) {
            if (x >= lineslotx[i * 2] && x < lineslotx[i * 2] + 0x3A) {
                top = linesloty[i * 2];
                if (y >= top && y < top + 0x28) {
                    *item = i;
                    return 1;
                }
            }
        }
    } else if (y >= 0x16 && y < 0x182) {
        *item = (y - 0x16) / 13 + 100;
        return 1;
    }
    return 0;
}
