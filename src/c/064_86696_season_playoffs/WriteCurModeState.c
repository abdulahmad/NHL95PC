/* Season / playoffs: save the current mode state. */
#include "nhl95.h"

/* WriteCurModeState (8B92F) - PC only: write the state block of the current game mode (0 exhibition, 1 playoffs,
   2 league) with WriteModeState (its other register arguments
   pass through untouched); another mode writes nothing. */
void WriteCurModeState(void)
{
    switch ((unsigned)gamemode) {
    case 0:
        WriteModeState(exhstate);
        break;
    case 1:
        WriteModeState(postate);
        break;
    case 2:
        WriteModeState(lgstate);
        break;
    }
}
