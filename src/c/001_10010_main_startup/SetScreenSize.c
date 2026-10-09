/* Main / startup: screen size switch. */
#include "nhl95.h"

/* SetScreenSize (10E9F) - PC only: switch the screen to w x h when it is another size: black palette (unk_C4E30),
   clear at the old size, set the video mode size (sub_8E080), black palette again, clip window and view to the
   new size, then store screenw / screenh. */
void SetScreenSize(int w, int h)
{
    if (w == screenw && h == screenh) return;
    sub_B4B88(0, 0x100, unk_C4E30);
    sub_B4BA8();
    sub_B4BC4(0, screenw, 0, screenh);
    sub_B392C(0);
    sub_B3989(0x28);
    sub_B4C33();
    sub_8E080(w, h);
    sub_B4B88(0, 0x100, unk_C4E30);
    sub_B4BC4(0, w, 0, h);
    sub_B392C(0);
    sub_B2E1B(0, 0, w, h);
    screenw = w;
    screenh = h;
    sub_B3999();
}
