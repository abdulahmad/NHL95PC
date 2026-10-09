/* Temp files: league highlights menu. */
#include "nhl95.h"

/* MenuLeagueHilights (3366F) - view the league highlights: save the exhibition mode state, load the league state (game
   mode 0), run ViewHilights, then restore the exhibition state. Returns 2 when the viewer returned 0, else 0. */
int MenuLeagueHilights(void)
{
    SaveModeState(exhstate);
    LoadModeState(lgstate);
    gamemode = 0;
    if (!ViewHilights()) {
        LoadModeState(exhstate);
        return 2;
    }
    LoadModeState(exhstate);
    return 0;
}
