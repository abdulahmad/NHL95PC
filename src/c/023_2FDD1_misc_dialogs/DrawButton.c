/* Misc dialogs: buttons and scroll bars (one source block: DrawScrollBar ends in DrawButton's exit). */
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


/* InitScrollBar (30BF3) - set up scroll bar sb (ints: +8 width, +0Ch height) for total items with visible on screen:
   position 0, thumb width = width - 4, thumb length = (height - 4) * visible / total. */
void InitScrollBar(int *sb, int visible, int total)
{
    sb[0x28 / 4] = total;
    sb[0x24 / 4] = visible;
    sb[0x20 / 4] = 0;
    sb[0x10 / 4] = 0;
    sb[0x14 / 4] = 0;
    sb[0x18 / 4] = sb[0x08 / 4] - 4;
    sb[0x1C / 4] = (sb[0x0C / 4] - 4) * sb[0x24 / 4] / sb[0x28 / 4];
}

/* DRAFT (DrawScrollBar): x / y land in ebp / edi, EXE edi / ebp; the rest and the jump to DrawButton_x match. */
/* DrawScrollBar (30C3D) - draw scroll bar sb: its bevelled frame (x, y, w, h at +0..+0Ch) in the box colours, then the
   thumb (offset +10h / +14h plus 2, size +18h / +1Ch), pressed (+2Ch) with light and shade swapped (xor swap). */
void DrawScrollBar(int *sb)
{
    int y;
    int x;

    x = sb[0];
    y = sb[1];
    DrawBevelRect(x, y, sb[2], sb[3], boxfillcolor, boxlitecolor, boxshadecolor);
    if (sb[0x2C / 4] != 0) {
        boxlitecolor ^= boxshadecolor;
        boxshadecolor ^= boxlitecolor;
        boxlitecolor ^= boxshadecolor;
    }
    y += sb[5] + 2;
    DrawBevelRect(x + (sb[4] + 2), y, sb[6], sb[7], boxfillcolor, boxlitecolor, boxshadecolor);
    if (sb[0x2C / 4] != 0) {
        boxlitecolor ^= boxshadecolor;
        boxshadecolor ^= boxlitecolor;
        boxlitecolor ^= boxshadecolor;
    }
}
