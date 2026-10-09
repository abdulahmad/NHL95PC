/* Settings dialogs: controller teams. */
#include "nhl95.h"

/* SetCtlTeams (7DB67) - set the game's teams (HomeTeam, VisTeam) and the controllers' teams and sides: controller 1 on
   t1 (on the computer device 10h: -1 home / -2 away); t2 < 0 puts controller 2 on the computer (device 10h) on
   the other side, else on t2 with the first free device of 2, 4, 8 (ctlavailmask) or 1 (keyboard). Then
   SetSideControls. */
void SetCtlTeams(int t1, int t2, int home, int away)
{
    HomeTeam = home;
    VisTeam = away;
    ctl1team[0] = t1;
    if (t1 == home) {
        if (ctl1dev[0] == 0x10) ctl1team[0] = -1;
        ctl1side[0] = 0;
    } else {
        if (ctl1dev[0] == 0x10) ctl1team[0] = -2;
        ctl1side[0] = 1;
    }
    if (t2 < 0) {
        ctl2side = ctl1side[0] == 0;
        ctl2team = (t1 != home) - 2;
        ctl2dev = 0x10;
    } else {
        ctl2team = t2;
        ctl2side = t2 != home;
        if (ctl2dev == 0x10) {
            if ((ctlavailmask & 2) && ctl1dev[0] != 2) ctl2dev = 2;
            else if ((ctlavailmask & 4) && ctl1dev[0] != 4) ctl2dev = 4;
            else if ((ctlavailmask & 8) && ctl1dev[0] != 8) ctl2dev = 8;
            else ctl2dev = 1;
        }
    }
    SetSideControls();
}
