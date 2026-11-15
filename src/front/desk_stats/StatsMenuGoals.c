/* Palette effects: stats menu items. */
#include "nhl95.h"

/* StatsMenuGoals: stats menu item: category 1 (goals). In the league screens (leaguestatsmode) load the SFPAL1 SFPAL2
 palettes, fade in with the first, run LeadersScreen(1) and fade out with the second; otherwise call the
 skaterstatscb handler. Returns the screen's result. */
int StatsMenuGoals(void)
{
    statscategory = 1;
    if (leaguestatsmode) {
        sfpal1 = AllocMemBlock((char *)str_SfPal1, 0x300, 0x20);
        SetPalette(0, 0x100, (unsigned char *)sfpal1);
        sfpal2 = AllocMemBlock((char *)str_SfPal2, 0x300, 0x20);
        SetPalette(0, 0x100, (unsigned char *)sfpal2);
        FadePalStep(1, (unsigned char *)sfpal1, 0x10);
        FreeMemBlock(sfpal1);
        statsmenuresult = LeadersScreen(1);
        FadePalStep(0, (unsigned char *)sfpal2, 0x10);
        FreeMemBlock(sfpal2);
        return statsmenuresult;
    }
    return ((int (*)(int))skaterstatscb)(1);
}
