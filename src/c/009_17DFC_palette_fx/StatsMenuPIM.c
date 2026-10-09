/* Palette effects: stats menu items. */
#include "nhl95.h"

/* StatsMenuPIM (18894) - stats menu item: category 6 (penalty minutes). In the league screens (dword_DC738) load the SFPAL1 / SFPAL2
   palettes, fade in with the first, run LeadersScreen(6) and fade out with the second; otherwise call the
   skaterstatscb handler. Returns the screen's result. */
int StatsMenuPIM(void)
{
    statscategory = 6;
    if (dword_DC738) {
        sfpal1 = sub_8CCA8((char *)str_SfPal1, 0x300, 0x20);
        sub_8FFB0(0, 0x100, (unsigned char *)sfpal1);
        sfpal2 = sub_8CCA8((char *)str_SfPal2, 0x300, 0x20);
        sub_8FFB0(0, 0x100, (unsigned char *)sfpal2);
        FadePalStep(1, (unsigned char *)sfpal1, 0x10);
        jctime(sfpal1);
        dword_DC6A8 = LeadersScreen(6);
        FadePalStep(0, (unsigned char *)sfpal2, 0x10);
        jctime(sfpal2);
        return dword_DC6A8;
    }
    return ((int (*)(int))skaterstatscb)(6);
}
