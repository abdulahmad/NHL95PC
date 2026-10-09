/* Front end: sports desk. */
#include "nhl95.h"

/* PostGameDesk (1920F) - after the game: restore the palette, go to 640x480, show the final summary; in a normal game of
   two real teams not left with bit 2, update the other scores, play a random highlight and the coach cut scene
   (waiting up to 10 for a click), then the summary again unless it was skipped. Then the sports desk, game
   result 1, back to 320x200. */
void PostGameDesk(void)
{
    int r;

    sub_8FFB0(0, 0x100, savepal);
    FadePalStep(1, savepal, 0x10);
    SetScreenSize(0x280, 0x1E0);
    sub_1BAF3(0x222E0);
    ShowLoadingScreen();
    FlushGSumQueue();
    ReadGSumTail();
    ReadGSumHeader();
    InputInstall();
    r = GameSummaryScreen(1, 1, curperiod, 0);
    InputRemove();
    if (gamemode == 0 && !(r & 4) && HomeTeam != 0x1A && HomeTeam != 0x1B && VisTeam != 0x1A && VisTeam != 0x1B) {
        UpdateOtherScores(curperiod);
        PlayRandomHighlight();
        SetScreenSize(0x280, 0x1E0);
        sub_1B982();
        if (!(r = CoachCutScene()) || !(r = WaitClickTimeout(10))) {
            ShowLoadingScreen();
            InputInstall();
            GameSummaryScreen(0x20, curperiod, 0, 0);
            InputRemove();
        }
    }
    SportsDesk(2);
    gameresult = 1;
    SetScreenSize(0x140, 0xC8);
}
