/* Front end: sports desk. */
#include "nhl95.h"

/* DeskPenaltySummary (1A9AC) - sports desk penalty summary: save the palette, fade the music down and the screen
   out, wait for the music slot to stop and free the song, then show the loading screen and the game summary
   screen in mode 2 (penalties) for the current period. Returns 2. */
int DeskPenaltySummary(void)
{
    sub_8FFB0(0, 0x100, savepal);
    if (musicon && songdata) sub_8FCDF(musichandle, 3, 0x64);
    FadePalStep(1, savepal, 0x10);
    if (musicon && songdata) {
        while (!sub_8FC8A(*(int *)((char *)&musicslot - 3) >> 24, 3));
        sub_8D2F0(songdata);
        songdata = 0;
    }
    ShowLoadingScreen();
    GameSummaryScreen(2, 1, curperiod, 0);
    return 2;
}
