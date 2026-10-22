/* Engine input: joystick event queue. */
#include "nhl95.h"

/* joyq_pop: drop the oldest joystick queue event (50 entries, joyqhead wraps), with joystick sampling switched
 off while the queue is changed. */
void joyq_pop(void)
{
    if (joyqcount > 0) {
        joysampling_save = joysampling;
        joysampling = 0;
        joyqcount--;
        joyqhead++;
        if (joyqhead >= 50) joyqhead = 0;
        joysampling = joysampling_save;
    }
}
