/* Misc dialogs: dialog sizing. */
#include "nhl95.h"

/* GrowToButton: grow the dialog size *w *h so button b (ints: left, top, right, bottom; flags at +14h) fits
 with an 8-pixel margin. Flag 1: right is a width (left + right), flag 4: bottom is a height. */
void GrowToButton(int *b, int *w, int *h)
{
    int v;
    int u;

    if (b[5] & 1) {
        v = b[0] + b[2] + 8;
        if (v > *w) *w = v;
    } else {
        v = b[2] - b[0] + 8;
        if (v > *w) *w = v;
    }
    if (b[5] & 4) {
        u = b[1] + b[3] + 8;
        if (u > *h) *h = u;
    } else {
        u = b[3] - b[1] + 8;
        if (u > *h) *h = u;
    }
}
