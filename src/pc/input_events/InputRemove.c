/* Joystick calibration: input handler. */
#include "nhl95.h"

/* InputRemove: if the input tick handler is installed: clear the pointer step state and remove InputPollTick
 from the timer (RemoveTimerCallback). */
void InputRemove(void)
{
    if (inputinstalled) {
        dword_CDA24 = 0;
        ptrstep = 0;
        RemoveTimerCallback(InputPollTick);
        inputinstalled = 0;
    }
}
