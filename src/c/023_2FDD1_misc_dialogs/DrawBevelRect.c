/* Misc dialogs: bevelled rectangle. */
#include "nhl95.h"

/* DrawBevelRect (2FE49) - PC only: fill the w x h rectangle at x, y with colour fill (sub_90D20), then draw its
   left and top edges in colour light and its bottom and right edges in colour dark (sub_B4FAC lines). */
void DrawBevelRect(int x, int y, int w, int h, int fill, int light, int dark)
{
    int x2;
    int y2;

    x2 = x + w - 1;
    y2 = y + h - 1;
    sub_90D20(x, y, w, h, fill);
    sub_B4FAC(x, y, x, y2, light);
    sub_B4FAC(x, y, x2, y, light);
    sub_B4FAC(x, y2, x2, y2, dark);
    sub_B4FAC(x2, y, x2, y2, dark);
}
