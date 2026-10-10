/* Asm helpers: select the draw target bitmap. */
#include "nhl95.h"

/* SelectScreenBM (8C1C2) - SetDrawBitmap(screenbm): draw into the screen bitmap descriptor. */
void SelectScreenBM(void)
{
    SetDrawBitmap(screenbm);
}

/* SelectRinkBM (8C1E2) - SetDrawBitmap(rinkbm): draw into the rink bitmap (shares SelectScreenBM's tail). */
void SelectRinkBM(void)
{
    SetDrawBitmap(rinkbm);
}
