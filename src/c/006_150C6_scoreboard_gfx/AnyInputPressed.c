/* Scoreboard graphics: wait for input. */
#include "nhl95.h"

/* AnyInputPressed (1600C) - 1 when a key is pressed, a joystick button (30h on either pad, when pads are available:
   ctlavailmask bits 1 / 2) or a mouse button (ctlavailmask bit 0); else 0. */
int AnyInputPressed(void)
{
    int r;
    int k;

    r = PollKey();
    if (!r && ((ctlavailmask & 2) || (ctlavailmask & 4))) {
        k = sub_B3464();
        if ((k & 0x30) || ((k >> 8) & 0x30)) r = 1;
    }
    if (!r && (ctlavailmask & 1)) {
        ((void (*)(void))mousepollfn)();
        if (mousebtns & 3) r = 1;
    }
    return r;
}
