/* Main startup: input timing. */
#include "nhl95.h"

/* ResetInputSampling (1145F) - restart the input tick count: returns the ticks so far and sets inputticks to 0, with
   joystick sampling switched off around the reset. */
int ResetInputSampling(void)
{
    int t;

    joysampling_save = joysampling;
    joysampling = 0;
    t = inputticks;
    inputticks = 0;
    joysampling = joysampling_save;
    return t;
}
