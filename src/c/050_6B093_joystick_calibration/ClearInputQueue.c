/* Joystick calibration: input queue. */
#include "nhl95.h"

/* ClearInputQueue (6B3D7) - empty the input event queue (count / head 0, tail 1Fh) and clear the held button and Enter
   flags; returns 0. */
int ClearInputQueue(void)
{
    inputqcount = 0;
    inputqtail = 0x1F;
    inputqhead = 0;
    dword_CDA38 = 0;
    joybtnheld = 0;
    enterheld = 0;
    return 0;
}
