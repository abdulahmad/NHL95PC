/* Misc dialogs: dialog size from its buttons. */
#include "nhl95.h"

/* GrowToButtons (30FB4) - PC only: grow the dialog width *w / height *h to hold n buttons of b (x1, y1, x2, y2,
   flags byte +14h: bit 0 / bit 2 make x2 / y2 relative). The widths add up (+8 each); each height + 8 is a
   maximum. The original never steps b, so it measures the first button n times. */
void GrowToButtons(int *b, int n, int *w, int *h)
{
    int sum;
    int i;
    int v;

    sum = 0;
    for (i = 0; i < n; i++) {
        if (b[5] & 1) v = b[0] + b[2];
        else v = b[2] - b[0];
        sum += v + 8;
        if (sum > *w) *w = sum;
        if (b[5] & 4) {
            v = b[1] + b[3] + 8;
            if (v > *h) *h = v;
        } else {
            v = b[3] - b[1] + 8;
            if (v > *h) *h = v;
        }
    }
}
