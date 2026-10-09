/* Main / startup: draw a photo sprite. */
#include "nhl95.h"

/* DrawFrameSprite (110E0) - PC only: draw photo n (0-46Dh, when loaded in photoptrs) at screen x + C0h,
   140h - y with attributes a / b (DrawSprite, flag 1). */
void DrawFrameSprite(short n, short x, short y, short a, short b)
{
    if (n < 0 || n >= 0x46E) return;
    if (photoptrs[n] == 0) return;
    x += 0xC0;
    y = 0x140 - y;
    DrawSprite(photoptrs[n], x, y, a, b, 1);
}
