/* Palette effects: stats menu item that returns to the desk. */
#include "nhl95.h"

/* ShowPlayerStatsItem: a goalie (statsplayer[2] == 'G') sets deskexit to 4, anyone else to 5,
   then returns 1 through DeskSetExit_ret1. */
void ShowPlayerStatsItem(void)
{
    deskexit = (statsplayer[2] != 0x47) + 4;
    DeskSetExit_ret1();
}
