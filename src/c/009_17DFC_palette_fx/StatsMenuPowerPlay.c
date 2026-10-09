/* Palette effects: stats menu items. */
#include "nhl95.h"

/* StatsMenuPowerPlay (18182) - stats menu item: category 3 (power play). In the league screens (dword_DC738) load the SFPAL1 / SFPAL2
   palettes, fade in with the first, run TeamStatsScreen(3) and fade out with the second; otherwise call the
   teamstatscb handler. Returns the screen's result. */
int StatsMenuPowerPlay(void)
{
    statscategory = 3;
    if (dword_DC738) {
        sfpal1 = sub_8CCA8((char *)str_SfPal1, 0x300, 0x20);
        sub_8FFB0(0, 0x100, (unsigned char *)sfpal1);
        sfpal2 = sub_8CCA8((char *)str_SfPal2, 0x300, 0x20);
        sub_8FFB0(0, 0x100, (unsigned char *)sfpal2);
        FadePalStep(1, (unsigned char *)sfpal1, 0x10);
        jctime(sfpal1);
        dword_DC6A8 = TeamStatsScreen(3);
        FadePalStep(0, (unsigned char *)sfpal2, 0x10);
        jctime(sfpal2);
        return dword_DC6A8;
    }
    return ((int (*)(int))teamstatscb)(3);
}
