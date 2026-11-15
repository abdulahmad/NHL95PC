/* Season playoffs: desk line menus. */
#include "nhl95.h"

/* SetSideControls: enable the desk's home visitor lines menu items (handler + item data) for the sides a
 human controls: both controllers on one side (ctl1side 0 home), else by ctl1team/ctl2team (-1 none home,
 -2 none visitor). */
void SetSideControls(void)
{
    if (ctl1side[0] == ctl2side) {
        if (!ctl1side[0]) {
            menuact_homelines = (int)DeskHomeLines;
            menuact_visitorlines = 0;
            menusub_hmgoalie = (int)hmgoaliemenu;
            menusub_awgoalie = 0;
        } else {
            menuact_homelines = 0;
            menuact_visitorlines = (int)DeskVisitorLines;
            menusub_hmgoalie = 0;
            menusub_awgoalie = (int)awgoaliemenu;
        }
        return;
    }
    if (ctl1team[0] == -1 || ctl2team == -1) {
        menuact_homelines = 0;
        menusub_hmgoalie = 0;
    } else {
        menuact_homelines = (int)DeskHomeLines;
        menusub_hmgoalie = (int)hmgoaliemenu;
    }
    if (ctl1team[0] == -2 || ctl2team == -2) {
        menuact_visitorlines = 0;
        menusub_awgoalie = 0;
    } else {
        menuact_visitorlines = (int)DeskVisitorLines;
        menusub_awgoalie = (int)awgoaliemenu;
    }
}
