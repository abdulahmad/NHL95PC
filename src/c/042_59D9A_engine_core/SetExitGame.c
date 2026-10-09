/* SetExitGame (5DDBC) - PC only: request leaving the game (main-loop request flag exitgame, CBC46), once. Called
   from the assignment code. */
#include "nhl95.h"

void SetExitGame(void)
{
    if (exitgame == 0) exitgame = 1;
}
