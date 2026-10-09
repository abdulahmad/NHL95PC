/* LockScroll (5CD25) - PC only: lock the rink scroll on the current camera position. Copies camx/camy to the
   scroll target xc1/yc1 and sets sflags bit 6 (93G sfslock), so the camera stops following the puck. */
#include "nhl95.h"

void LockScroll(void)
{
    xc1 = camx;
    yc1 = camy;
    sflags |= 0x40;             /* sfslock */
}
