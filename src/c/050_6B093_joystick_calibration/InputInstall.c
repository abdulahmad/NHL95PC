/* Joystick input: install the input handler. */
#include "nhl95.h"

/* the keyboard library init (hand asm) does not preserve ebx and edx */
#pragma aux sub_B29F0 modify [ebx edx];

/* InputInstall: set ctlavailmask bit 0 when a mouse is present (sub_B2F22). The first time:
 init the mouse library (sub_B29F0), clear the pointer state, add the InputPollTick timer handler, empty the
 input queue and make EventToPointer the pointer update function. */
void InputInstall(void)
{
    if (sub_B2F22()) ctlavailmask |= 1;
    else ctlavailmask &= 0xFE;
    if (inputinstalled == 0) {
        sub_B29F0();
        ptrstep = dword_CDA24 = 0;
        inputinstalled = 1;
        addtimer(InputPollTick);
        ClearInputQueue();
        ptrupdatefn = (int)EventToPointer;
    }
}
