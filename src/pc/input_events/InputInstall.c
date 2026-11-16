/* Joystick input: install the input handler. */
#include "nhl95.h"

/* the keyboard library init (hand asm) does not preserve ebx and edx */
#pragma aux RemoveKeyboardHandler modify [ebx edx];

/* InputInstall: set ctlavailmask bit 0 when a mouse is present (InitMouse). The first time:
 init the mouse library (RemoveKeyboardHandler), clear the pointer state, add the InputPollTick timer handler, empty the
 input queue and make EventToPointer the pointer update function. */
void InputInstall(void)
{
    if (InitMouse()) ctlavailmask |= 1;
    else ctlavailmask &= 0xFE;
    if (inputinstalled == 0) {
        RemoveKeyboardHandler();
        ptrstep = dword_CDA24 = 0;
        inputinstalled = 1;
        addtimer(InputPollTick);
        ClearInputQueue();
        ptrupdatefn = (int)EventToPointer;
    }
}
