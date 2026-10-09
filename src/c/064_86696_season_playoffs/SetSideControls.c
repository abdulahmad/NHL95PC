/* Season / playoffs: desk line menus. */
#include "nhl95.h"

/* SetSideControls (8B85B) - enable the desk's home / visitor lines menu items (handler + item data) for the sides a
   human controls: both controllers on one side (ctl1side 0 home), else by ctl1team/ctl2team (-1 none home,
   -2 none visitor). */
void SetSideControls(void)
{
    if (ctl1side[0] == ctl2side) {
        if (!ctl1side[0]) {
            off_CEF43 = (int)DeskHomeLines;
            off_CEF63 = 0;
            dword_CEDE7 = (int)unk_CEE4F;
            dword_CEE07 = 0;
        } else {
            off_CEF43 = 0;
            off_CEF63 = (int)DeskVisitorLines;
            dword_CEDE7 = 0;
            dword_CEE07 = (int)unk_CEEAF;
        }
        return;
    }
    if (ctl1team[0] == -1 || ctl2team == -1) {
        off_CEF43 = 0;
        dword_CEDE7 = 0;
    } else {
        off_CEF43 = (int)DeskHomeLines;
        dword_CEDE7 = (int)unk_CEE4F;
    }
    if (ctl1team[0] == -2 || ctl2team == -2) {
        off_CEF63 = 0;
        dword_CEE07 = 0;
    } else {
        off_CEF63 = (int)DeskVisitorLines;
        dword_CEE07 = (int)unk_CEEAF;
    }
}
