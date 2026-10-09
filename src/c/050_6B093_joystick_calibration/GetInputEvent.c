/* Joystick calibration: input queue. */
#include "nhl95.h"

/* GetInputEvent (6B391) - next event of the 32-entry input queue (13 bytes each), or 0 when it is empty. */
unsigned char *GetInputEvent(void)
{
    if (!inputqcount) return 0;
    inputqcount--;
    inputqtail = (inputqtail + 1) & 0x1F;
    return (unsigned char *)inputqueue + inputqtail * 13;
}
