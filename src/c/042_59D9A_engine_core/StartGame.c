/* StartGame (5E086) - 93G hockey93_01 StartGame role: reset the game state for a new game (cleargamevars,
   clearteams), set the game state gsp to 0, restoreteams, then start the first period (IntermissionStart). */
#include "nhl95.h"

void StartGame(void)
{
    cleargamevars();
    clearteams();
    gsp = 0;
    restoreteams();
    IntermissionStart();
}
