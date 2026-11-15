/* Main startup: screen size switch. */
#include "nhl95.h"

/* SetScreenSize: switch the screen to w x h when it is another size: black palette (blackpal),
 clear at the old size, set the video mode size (initgraphics), black palette again, clip window and view to the
 new size, then store screenw screenh. */
void SetScreenSize(int w, int h)
{
    if (w == screenw && h == screenh) return;
    VgaSetPalette(0, 0x100, blackpal);
    sub_B4BA8();
    SetClipWindow(0, screenw, 0, screenh);
    ClearScreen(0);
    SetTickDeadline(0x28);
    sub_B4C33();
    initgraphics(w, h);
    VgaSetPalette(0, 0x100, blackpal);
    SetClipWindow(0, w, 0, h);
    ClearScreen(0);
    SetViewRect(0, 0, w, h);
    screenw = w;
    screenh = h;
    WaitTickDeadline();
}
