/* GameOver: role: request the end of the game. Sets the main-loop request flag gameover once; the game loop then runs IntermissionStart (when gsp = 4) and leaves the game. */
#include "nhl95.h"

void GameOver(void)
{
    if (gameover == 0) gameover = 1;
}
