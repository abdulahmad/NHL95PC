/* Misc dialogs: scroll bar. DRAFT: must live in DrawButton.c (ends in DrawButton_x); there it differs only in x / y landing in ebp / edi (EXE edi / ebp). */
#include "nhl95.h"

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
