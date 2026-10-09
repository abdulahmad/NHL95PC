/* Demo / save game: playoff highlights. */
#include "nhl95.h"

/* ViewPlayoffHilights (86647) - PC only: save the exhibition mode state, load the playoff one (gamemode 0) and run
   the highlight viewer, then restore the exhibition state. Returns 0 when the viewer returned nonzero, else 2. */
int ViewPlayoffHilights(void)
{
    SaveModeState(exhstate);
    LoadModeState(postate);
    gamemode = 0;
    if (ViewHilights() == 0) {
        LoadModeState(exhstate);
        return 2;
    }
    LoadModeState(exhstate);
    return 0;
}
