/* Asset loading: game setup. */
#define StartPreGame StartPreGameDecl
#include "nhl95.h"
#undef StartPreGame

/* The call passes a second 0 in edx. The one-argument prototype leaves edx alone. */
int StartPreGame(int mode, int zero);

/* SetupGame: set up a game: default lines for both teams, clock state (gsp -1), crowd and game variables, the
 HUD panel, then the pre-game show (StartPreGame; < 0: return -1). After it gsp 0 and the game variables are
 reset again (keeping introskipped); a skipped intro restores the palette (savepal). PlacePlayersAtStart
 runs when line changes are on or the intro was not skipped. Returns 0. */
int SetupGame(void)
{
    int s;

    BuildDefaultLines();
    SetupTeamLines(0);
    SetupTeamLines(1);
    gsp = -1;
    crowdlevel = 0;
    CrowdNoiseReset();
    introskipped = 0;
    ResetGameVars();
    DrawHudPanel(HomeTeam, VisTeam, 1, 1);
    crowdlevel = 0;
    crowdsmooth = 0;
    if (StartPreGame(0, 0) < 0) return -1;
    s = introskipped;
    if (s) fadeinpending = 1;
    gsp = 0;
    ResetGameVars();
    introskipped = s;
    if (s) {
        sub_8FFB0(0, 0x100, savepal);
        FadePalette(1, savepal, 0x10);
    }
    if (gameopts.linechanges || !introskipped) PlacePlayersAtStart();
    if (!dword_CC0EC && !introskipped) fadeinpending = 0;
    return 0;
}
