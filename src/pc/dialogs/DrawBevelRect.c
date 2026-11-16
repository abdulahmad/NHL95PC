/* Misc dialogs: bevelled rectangle. */
#include "nhl95.h"

/* DrawBevelRect: fill the w x h rectangle at x, y with colour fill (FillRect), then draw its
 left and top edges in colour light and its bottom and right edges in colour dark (FillRectColor lines). */
void DrawBevelRect(int x, int y, int w, int h, int fill, int light, int dark)
{
    int x2;
    int y2;

    x2 = x + w - 1;
    y2 = y + h - 1;
    FillRect(x, y, w, h, fill);
    FillRectColor(x, y, x, y2, light);
    FillRectColor(x, y, x2, y, light);
    FillRectColor(x, y2, x2, y2, dark);
    FillRectColor(x2, y, x2, y2, dark);
}
