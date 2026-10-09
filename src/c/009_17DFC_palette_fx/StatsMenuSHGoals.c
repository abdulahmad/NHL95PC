/* Palette effects: stats menu items. */
#include "nhl95.h"

/* StatsMenuSHGoals (186CE) - stats menu item: category 4 (short-handed goals). In the league screens (dword_DC738) load the SFPAL1 / SFPAL2
   palettes, fade in with the first, run LeadersScreen(4) and fade out with the second; otherwise call the
   skaterstatscb handler. Returns the screen's result. */
int StatsMenuSHGoals(void)
{
    statscategory = 4;
    if (dword_DC738) {
        sfpal1 = sub_8CCA8((char *)str_SfPal1, 0x300, 0x20);
        sub_8FFB0(0, 0x100, (unsigned char *)sfpal1);
        sfpal2 = sub_8CCA8((char *)str_SfPal2, 0x300, 0x20);
        sub_8FFB0(0, 0x100, (unsigned char *)sfpal2);
        FadePalStep(1, (unsigned char *)sfpal1, 0x10);
        jctime(sfpal1);
        dword_DC6A8 = LeadersScreen(4);
        FadePalStep(0, (unsigned char *)sfpal2, 0x10);
        jctime(sfpal2);
        return dword_DC6A8;
    }
    return ((int (*)(int))skaterstatscb)(4);
}
