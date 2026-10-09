/* Misc dialogs: draw one button. */
#include "nhl95.h"

/* DrawButton (30B16) - PC only: draw button b (x, y, w, h at +0..+0Ch, pressed +10h, label +18h) as a bevelled box
   in the box colours (a pressed button swaps the light and shade colours, xor swap, for the draw), then its label
   centred in shadow text. */
void DrawButton(Button *b)
{
    int *r;
    char *s;
    int y;

    r = (int *)b;
    if (r[4] != 0) {
        boxlitecolor ^= boxshadecolor;
        boxshadecolor ^= boxlitecolor;
        boxlitecolor ^= boxshadecolor;
    }
    DrawBevelRect(r[0], r[1], r[2], r[3], boxfillcolor, boxlitecolor, boxshadecolor);
    if (r[4] != 0) {
        boxlitecolor ^= boxshadecolor;
        boxshadecolor ^= boxlitecolor;
        boxlitecolor ^= boxshadecolor;
    }
    if (r[6] != 0) {
        s = (char *)r[6];
        y = (r[3] - byte_D42C3) / 2 + r[1];
        PrintShadowText((r[2] - fputchar(s)) / 2 + r[0], y, s);
    }
}
