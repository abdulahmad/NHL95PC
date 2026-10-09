/* Joystick calibration: input handler. */
#include "nhl95.h"

/* InputRemove (6B47C) - if the input tick handler is installed: clear the pointer step state and remove InputPollTick
   from the timer (sub_8E4F8). */
void InputRemove(void)
{
    if (inputinstalled) {
        dword_CDA24 = 0;
        ptrstep = 0;
        sub_8E4F8(InputPollTick);
        inputinstalled = 0;
    }
}
