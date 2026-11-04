/* Asm helpers: select the draw target bitmap. */
#include "nhl95.h"

/* SelectScreenBM: SetDrawBitmap(screenbm): draw into the screen bitmap descriptor. */
void SelectScreenBM(void)
{
    SetDrawBitmap(screenbm);
}

/* SelectRinkBM: SetDrawBitmap(rinkbm): draw into the rink bitmap (shares SelectScreenBM's tail). */
void SelectRinkBM(void)
{
    SetDrawBitmap(rinkbm);
}
