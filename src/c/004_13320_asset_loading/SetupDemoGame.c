/* Asset loading: demo game. */
#include "nhl95.h"

/* SetupDemoGame (13FA7) - set up the attract-mode game: default lines for both teams, no game state (gsp -1), quiet crowd,
   game variables reset, then the pre-game; returns -1 when that fails. Afterwards gsp 0 and a second reset that
   keeps introskipped; fadeinpending only when the intro was skipped or dword_CC0EC is set. */
int SetupDemoGame(void)
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
    crowdlevel = 0;
    crowdsmooth = 0;
    if (StartPreGame(0) < 0) return -1;
    s = introskipped;
    if (s) fadeinpending = 1;
    gsp = 0;
    ResetGameVars();
    introskipped = s;
    if (!dword_CC0EC && !s) fadeinpending = 0;
    return 0;
}
