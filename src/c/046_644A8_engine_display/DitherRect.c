/* Engine display: checkerboard dither of a rectangle. */
#include "nhl95.h"

/* DitherRect (65CA8) - PC only: plot colour c on every other pixel of every other row of the w x h rectangle at
   x, y (rows from y + 1; sub_B5D80 pixels). */
void DitherRect(int x, int y, int w, int h, int c)
{
    int py;
    int px;

    for (py = y + 1; py < y + h; py += 2) {
        for (px = x; px < x + w; px += 2) sub_B5D80(px, py, c);
    }
}
