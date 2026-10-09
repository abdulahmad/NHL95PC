/* Gadgets / replay: gadget button frame. */
#include "nhl95.h"

/* DrawGadgetButton (7E067) - PC only: draw the frame of replay gadget n (gadgetrects: 7 dwords per gadget, x0, y0,
   x1, y1; y made relative to the panel at A8h): top and left edges in colour 10h, right and bottom in 15h. */
void DrawGadgetButton(int n)
{
    int x0;
    int y0;
    int x1;
    int y1;

    n *= 7;
    x0 = gadgetrects[n];
    y0 = gadgetrect_y0[n] - 0xA8;
    x1 = gadgetrect_x1[n];
    y1 = gadgetrect_y1[n] - 0xA8;
    sub_B4FAC(x0, y0, x1, y0, 0x10);
    sub_B4FAC(x0, y0, x0, y1, 0x10);
    sub_B4FAC(x1, y0, x1, y1, 0x15);
    sub_B4FAC(x0, y1, x1, y1, 0x15);
}
