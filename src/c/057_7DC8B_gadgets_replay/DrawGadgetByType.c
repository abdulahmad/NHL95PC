/* Gadgets / replay: draw a gadget. */
#include "nhl95.h"

/* DrawGadgetByType (7DF4E) - PC only: draw the shapes (sub_913B4) of a replay gadget from its shape list shp by gadget
   type: 4, 8, 10h: frame (+28h), face (+24h) and the icon +1Ch / +4 / +0; 20h: the +2Ch frame and the +0Ch icon;
   anything else: frame, the +20h face and the state icon (state 0-3: +0Ch.. +18h, else +8). b, c, d unused. */
void DrawGadgetByType(unsigned type, unsigned char state, int b, int *shp, int c, int d)
{
    switch (type) {
    case 4:
        sub_913B4(shp[10]);
        sub_913B4(shp[9]);
        sub_913B4(shp[7]);
        return;
    case 8:
        sub_913B4(shp[10]);
        sub_913B4(shp[9]);
        sub_913B4(shp[1]);
        return;
    case 0x10:
        sub_913B4(shp[10]);
        sub_913B4(shp[9]);
        sub_913B4(shp[0]);
        return;
    case 0x20:
        sub_913B4(shp[11]);
        sub_913B4(shp[3]);
        return;
    }
    sub_913B4(shp[10]);
    sub_913B4(shp[8]);
    sub_913B4(shp[state >= 4 ? 2 : state + 3]);
}
