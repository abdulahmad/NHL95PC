/* Front-end desk: return to the game. */
#include "nhl95.h"

/* DeskReloadGame (1A534) - reload the game graphics after the desk: rink for the home team (team 26+ use rink 12),
   player photos, the saved palette (fade in over 16 steps); sets the reload flags dword_C66D0 / dword_C66D4. */
void DeskReloadGame(void)
{
    LoadRink(HomeTeam >= 0x1A ? 0xC : HomeTeam);
    LoadPlayerPhotos();
    sub_8FFB0(0, 0x100, savepal);
    FadePalStep(1, savepal, 0x10);
    dword_C66D0 = dword_C66D4 = 1;
}
