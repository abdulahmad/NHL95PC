/* Joystick calibration: menu entries. */
#include "nhl95.h"

/* CalLeftJoystick (6B35C) - calibration screen for the left (first) joystick: JoystickCalScreen(1, 0, 0,
   "LEFT JOYSTICK"). */
int CalLeftJoystick(void)
{
    return JoystickCalScreen(1, 0, 0, (char *)str_LEFTJOYSTICK);
}

/* CalRightJoystick (6B37A) - calibration screen for the right (second) joystick: JoystickCalScreen(2, 8, 1,
   "RIGHT JOYSTICK"); shares CalLeftJoystick's call. */
int CalRightJoystick(void)
{
    return JoystickCalScreen(2, 8, 1, (char *)str_RIGHTJOYSTICK);
}
