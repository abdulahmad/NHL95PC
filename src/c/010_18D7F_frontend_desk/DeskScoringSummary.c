/* Front end: sports desk. */
#include "nhl95.h"

/* DeskScoringSummary (1AA6D) - sports desk scoring summary: save the palette, fade out, show the loading screen
   and the game summary screen in mode 1 (scoring) for the current period. Returns 2. Its tail (DeskSummary_common,
   DeskItem_ret2) is where the other desk items end. */
int DeskScoringSummary(void)
{
    sub_8FFB0(0, 0x100, savepal);
    FadePalStep(1, savepal, 0x10);
    ShowLoadingScreen();
    GameSummaryScreen(1, 1, curperiod, 0);
    return 2;
}
