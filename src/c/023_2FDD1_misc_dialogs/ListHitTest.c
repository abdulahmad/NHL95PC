/* Misc dialogs: list box hit test. */
#include "nhl95.h"

/* ListHitTest (3023E) - PC only: the row of a list box at x, y (inside 2 pixels of the box left, top, width w)
   that point mx, my falls in: n rows of the font height (byte_D42C3) + 2. Returns the row or -1. */
int ListHitTest(int mx, int my, int left, int top, int w, int n)
{
    int x1;
    int x2;
    int hit;
    int i;
    int ry;

    top += 2;
    x1 = left + 2;
    x2 = x1 + (w - 4);
    hit = -1;
    for (i = 0; i < n && hit < 0; i++) {
        ry = top + i * (byte_D42C3 + 2);
        if (mx >= x1 && mx <= x2 && my >= ry && my <= ry + byte_D42C3 + 2) hit = i;
    }
    return hit;
}
