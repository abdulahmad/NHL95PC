/* Misc dialogs: button hover / click tracking. */
#include "nhl95.h"

/* TrackButtons (30A39) - PC only: for the n buttons of list (7 dwords each: x, y, w, h, pressed, ...) and the
   mouse at x, y with button bits: a button under the mouse is drawn pressed (-1) while bit 0 is down; on a
   release (bit 1) it is the result and is drawn released; buttons the mouse left are released and redrawn.
   Returns the released button or -1. */
int TrackButtons(int *list, int n, int x, int y, int buttons)
{
    int hit;
    int i;
    int *b;

    hit = -1;
    for (i = 0; i < n; i++) {
        b = list + i * 7;
        if (x >= b[0] && x < b[0] + b[2] && y >= b[1] && y < b[1] + b[3]) {
            if (b[4] == 0 && (buttons & 1)) {
                b[4] = -1;
                DrawButton((Button *)b);
            }
            if ((buttons & 2) == 0) continue;
            hit = i;
            b = list + i * 7;
        } else {
            b = list + i * 7;
            if (b[4] == 0) continue;
        }
        b[4] = 0;
        DrawButton((Button *)b);
    }
    return hit;
}
