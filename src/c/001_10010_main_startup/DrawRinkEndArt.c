/* Main startup: rink end art. */
#include "nhl95.h"

/* DrawRinkEndArt (11136) - draw the rink end art sprite (rinkendart) at (37h, 225h). */
void DrawRinkEndArt(void)
{
    DrawSprite(rinkendart, 0x37, 0x225, 0, -1, 0);
}
