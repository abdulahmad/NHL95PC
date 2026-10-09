/* Engine input: joystick buttons (93G Readjoy1 / Readjoy2). */
#include "nhl95.h"

/* Readjoy1 (50A05) - 93G middle93_1 Readjoy1, reading byte 0 of joyrec instead of the pad (8 without joyrec):
   regd0 = the byte, regd1 = its buttons (70h), regd2 = buttons that changed since the last read (lj1),
   regd3 = buttons held, regd1 = newly pressed. Returns regd0. */
short Readjoy1(void)
{
    unsigned short held;
    unsigned short chg;

    if (joyrec != 0) regd0.w = *(unsigned char *)joyrec;
    else regd0.w = 8;
    regd1.w = regd0.w & 0x70;
    regd2.w = lj1;
    lj1 = held = regd1.w;
    regd3.w = held;
    regd2.w = chg = regd2.w ^ held;
    regd1.w = held & chg;
    return regd0.w;
}
