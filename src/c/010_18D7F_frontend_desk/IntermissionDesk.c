/* Front end: sports desk. */
#include "nhl95.h"

/* IntermissionDesk (190BE) - between periods: unless the game was quit (exitgame -1, then just fade the palette cycle),
   show the period summary; in a normal game of two real teams pick the other games after the first period
   (saving otherperiod to dword_DC868) and, unless the summary was left with bit 2, update the other scores and
   play a random highlight with its summary. Then the sports desk, clear the per-period goal/shot counters,
   write the summary header and go back to 320x200. */
void IntermissionDesk(void)
{
    int r;
    int i;

    if ((*(int *)((char *)&exitgame - 2) >> 16) != -1) {
        ShowLoadingScreen();
        FlushGSumQueue();
        ReadGSumTail();
        InputInstall();
        r = GameSummaryScreen(1, curperiod, curperiod, 0);
        InputRemove();
        if (gamemode == 0 && HomeTeam != 0x1A && HomeTeam != 0x1B && VisTeam != 0x1A && VisTeam != 0x1B) {
            if (curperiod == 1) {
                hlplayedmask = 0;
                PickOtherGames(*(int *)((char *)&HomeTeam - 2) >> 16, *(int *)((char *)&VisTeam - 2) >> 16);
                for (i = 0; i < 6; i++) dword_DC868[i] = otherperiod[i];
            }
            if (!(r & 4)) {
                UpdateOtherScores(curperiod);
                if (PlayRandomHighlight() >= 0) {
                    InputInstall();
                    GameSummaryScreen(0x20, curperiod, 0, 0);
                    InputRemove();
                }
            }
        }
    } else {
        FadeOutPalCycle();
    }
    exitgame = -1;
    SportsDesk(1);
    hmgoalcnt = 0;
    hmshotcnt = 0;
    awgoalcnt = 0;
    awshotcnt = 0;
    WriteGSumHeader();
    SetScreenSize(0x140, 0xC8);
}
