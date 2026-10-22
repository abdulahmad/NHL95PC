/* Line editor: clip a rectangle before the page blit. */
#include "nhl95.h"

/* BlitClipRect: clip x, y, w, h to the blit clip box. When the rectangle misses the box, return.
 Otherwise set the draw target (sub_B4BA8) and copy the clipped rectangle between VGA pages.
 Under 10.0 GA the plain sums `x2 = x + w` stay in the incoming registers (eax, edx) with x saved in edi and
 y in esi, as in the EXE. */
void BlitClipRect(int x, int y, int w, int h)
{
    int x2;
    int y2;

    x2 = x + w;
    y2 = y + h;
    if (x >= blitclipright) return;
    if (y >= blitclipbottom) return;
    if (x2 < blitclipleft) return;
    if (y2 < blitcliptop) return;
    if (x < blitclipleft) x = blitclipleft;
    if (y < blitcliptop) y = blitcliptop;
    if (x2 > blitclipright) x2 = blitclipright;
    if (y2 > blitclipbottom) y2 = blitclipbottom;
    w = x2 - x;
    h = y2 - y;
    sub_B4BA8();
    stub_8C218(vgapage == 0, x, y, w, h, 0);
}
