/* Engine input: joystick event queue. */
#include "nhl95.h"

/* joyq_pop (4FCE8) - drop the oldest joystick queue event (50 entries, joyqhead wraps), with joystick sampling switched
   off while the queue is changed. */
void joyq_pop(void)
{
    int n;
    int h;

    n = joyqcount;
    if (n > 0) {
        joysampling_save = joysampling;
        joysampling = 0;
        joyqcount = n - 1;
        h = joyqhead + 1;
        joyqhead = h;
        if (h >= 50) joyqhead = 0;
        joysampling = joysampling_save;
    }
}
