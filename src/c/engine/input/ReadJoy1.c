/* Engine input: joystick buttons. */
#include "nhl95.h"

/* ReadJoy1: reading byte 0 of joyrec instead of the pad (8 without joyrec):
 regd0 = the byte, regd1 = its buttons (70h), regd2 = buttons that changed since the last read (lj1),
 regd3 = buttons held, regd1 = newly pressed. Returns regd0. */
short ReadJoy1(void)
{
    if (joyrec != 0) regd0.w = *(unsigned char *)joyrec;
    else regd0.w = 8;
    regd1.w = regd0.w & 0x70;
    regd2.w = lj1;
    lj1 = regd1.w;
    regd3.w = regd1.w;
    regd2.w ^= regd1.w;
    regd1.w &= regd2.w;
    return regd0.w;
}

/* ReadJoy2 (50A84; 93G ReadJoy2): ReadJoy1 for the second pad: byte 1 of joyrec (8 without joyrec), the
   changes against lj2. Returns regd0. Its end is ReadJoy1's (Readjoy_tail). */
short ReadJoy2(void)
{
    if (joyrec != 0) regd0.w = ((unsigned char *)joyrec)[1];
    else regd0.w = 8;
    regd1.w = regd0.w & 0x70;
    regd2.w = lj2;
    lj2 = regd1.w;
    regd3.w = regd1.w;
    regd2.w ^= regd1.w;
    regd1.w &= regd2.w;
    return regd0.w;
}
