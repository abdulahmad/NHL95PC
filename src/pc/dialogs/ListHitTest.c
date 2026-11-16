/* Misc dialogs: list box hit test. */
#include "nhl95.h"

/* ListHitTest: the row of a list box at x, y (inside 2 pixels of the box left, top, width w)
 that point mx, my falls in: n rows of the font height (TextCharH) + 2. Returns the row or -1. */
int ListHitTest(int mx, int my, int left, int top, int w, int n)
{
    int x2;
    int x1;
    int ry;
    int ry2;
    int hit;
    int i;

    top += 2;
    x1 = left += 2;
    w -= 4;
    x2 = x1 + w;
    hit = -1;
    for (i = 0; i < n && hit < 0; i++) {
        ry = top + i * (TextCharH + 2);
        ry2 = ry + TextCharH + 2;
        if (mx >= x1 && mx <= x2 && my >= ry && my <= ry2) hit = i;
    }
    return hit;
}
