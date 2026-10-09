/* Temp files: free the rink graphics. */
#include "nhl95.h"

/* FreeRinkGfx (33727) - PC only: free the rink bitmap and the rink tile bitmap when loaded; freeing the tiles
   also forgets the loaded rink (currink -1). */
void FreeRinkGfx(void)
{
    if (rinkbm != 0) {
        jctime(rinkbm);
        rinkbm = 0;
    }
    if (rinktilebm != 0) {
        jctime(rinktilebm);
        rinktilebm = 0;
        currink = -1;
    }
}
