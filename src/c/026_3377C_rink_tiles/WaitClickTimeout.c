/* Rink tiles: wait for a click or a timeout. */
#include "nhl95.h"

/* WaitClickTimeout (33E6A) - PC only: wait up to ticks timer ticks (sub_B395C) for mouse clicks, reading input
   events through ptrupdatefn. A click (result bit 1) counts; a second click, a press of bit 2 (count 3) or 20
   ticks after the first click end the wait. Returns the click count (0 on timeout). */
int WaitClickTimeout(int ticks)
{
    int t1;
    int start;
    int bits;
    int x;
    int y;
    int done;
    int clicks;
    int now;

    start = sub_B395C();
    done = 0;
    clicks = 0;
    do {
        unsigned char *ev = GetInputEvent();
        if (ev != NULL) {
            bits = ((int (*)(unsigned char *, int *, int *))ptrupdatefn)(ev, &y, &x);
            if (bits & 2) {
                if (clicks == 0) t1 = sub_B395C();
                else done = -1;
                clicks++;
            }
            if (bits & 4) {
                clicks = 3;
                done = -1;
            }
        }
        now = sub_B395C();
        if (clicks != 0 && now - t1 > 20) done = -1;
    } while (done == 0 && now - start < ticks);
    return clicks;
}
