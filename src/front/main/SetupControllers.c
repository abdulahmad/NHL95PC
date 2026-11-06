/* Main startup: map the two controllers onto the pad devices. */
#include "nhl95.h"

/* SetupControllers: from ctl1team/ctl2team and ctl1side/ctl2side set cont1team/cont2team
 (0 none, 1 home, 2 away) and samesideflag. Map ctl1dev/ctl2dev onto pad1dev/pad2dev
 (1 mouse, 2 joystick 1, 4 joystick 2, 8 keyboard, 10h none). Recentre the mouse and
 stop joystick sampling. */
void SetupControllers(void)
{
    if (ctl1team[0] < 0)
        cont1team = 0;
    else if (ctl1side[0] == 0)
        cont1team = 1;
    else
        cont1team = 2;
    if (ctl2team < 0)
        cont2team = 0;
    else if (ctl2side == 0)
        cont2team = 1;
    else
        cont2team = 2;
    samesideflag = ctl1side[0] == ctl2side;
    switch (ctl1dev[0]) {
    case 1: pad1dev[0] = 1; break;
    case 2: pad1dev[0] = 2; break;
    case 4: pad1dev[0] = 4; break;
    case 8: pad1dev[0] = 8; break;
    case 0x10: pad1dev[0] = 0; break;
    }
    switch (ctl2dev) {
    case 1: pad2dev = 1; break;
    case 2: pad2dev = 2; break;
    case 4: pad2dev = 4; break;
    case 8: pad2dev = 8; break;
    case 0x10: pad2dev = 0; break;
    }
    sub_B2F22();
    MouseSetPos(0xA0, 0x64);
    sub_B29F0();
    joysampling = 0;
}
