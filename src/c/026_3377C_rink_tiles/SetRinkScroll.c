/* Rink tiles: scrolling. */
#include "nhl95.h"

/* SetRinkScroll (33DD3) - scroll the rink view to x / y: a changed axis sets its tile scroll (bgscroll = pos / 8) and
   pixel scroll (pos % 8); when either changed, store -x / -y in rinkscrollx / y and redraw (sub_6A033 3). */
void SetRinkScroll(int x, int y)
{
    int ch;

    ch = 0;
    if (-x != rinkscrollx) {
        bgscrollx = x >> 3;
        scrollx = x % 8;
        ch = 1;
    }
    if (-y != rinkscrolly) {
        bgscrolly = y >> 3;
        scrolly = y % 8;
        ch = 1;
    }
    if (ch) {
        rinkscrollx = -x;
        rinkscrolly = -y;
        sub_6A033(3);
    }
}
