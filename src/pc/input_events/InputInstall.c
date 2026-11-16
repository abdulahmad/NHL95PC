/* Joystick input: install the input handler. */
#include "nhl95.h"

/* the keyboard library init (hand asm) does not preserve ebx and edx */
#pragma aux InstallKeyboardHandler modify [ebx edx];

/* InputInstall: set ctlavailmask bit 0 when a mouse is present (InitMouse). The first time:
 init the mouse library (InstallKeyboardHandler), clear the pointer state, add the InputPollTick timer handler, empty the
 input queue and make EventToPointer the pointer update function. */
void InputInstall(void)
{
    if (InitMouse()) ctlavailmask |= 1;
    else ctlavailmask &= 0xFE;
    if (inputinstalled == 0) {
        InstallKeyboardHandler();
        ptrstep = InputResetWord = 0;
        inputinstalled = 1;
        addtimer(InputPollTick);
        ClearInputQueue();
        ptrupdatefn = (int)EventToPointer;
    }
}
