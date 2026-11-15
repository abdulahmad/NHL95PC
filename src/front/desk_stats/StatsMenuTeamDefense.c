/* Palette effects: stats menu items. */
#include "nhl95.h"

/* StatsMenuTeamDefense: stats menu item: category 1 (team defense). In the league screens (leaguestatsmode) load the SFPAL1 SFPAL2
 palettes, fade in with the first, run TeamStatsScreen(1) and fade out with the second; otherwise call the
 teamstatscb handler. Returns the screen's result. */
int StatsMenuTeamDefense(void)
{
    statscategory = 1;
    if (leaguestatsmode) {
        sfpal1 = sub_8CCA8((char *)str_SfPal1, 0x300, 0x20);
        sub_8FFB0(0, 0x100, (unsigned char *)sfpal1);
        sfpal2 = sub_8CCA8((char *)str_SfPal2, 0x300, 0x20);
        sub_8FFB0(0, 0x100, (unsigned char *)sfpal2);
        FadePalStep(1, (unsigned char *)sfpal1, 0x10);
        FreeMemBlock(sfpal1);
        statsmenuresult = TeamStatsScreen(1);
        FadePalStep(0, (unsigned char *)sfpal2, 0x10);
        FreeMemBlock(sfpal2);
        return statsmenuresult;
    }
    return ((int (*)(int))teamstatscb)(1);
}
