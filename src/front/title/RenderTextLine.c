/* Title intro: text lines. */
#include "nhl95.h"

/* RenderTextLine: draw s with its shadow into an off-screen bitmap (width rounded up to 64 pixels, one line high,
 cleared to colour FFh) and copy it to the screen at x y. */
void RenderTextLine(int x, int y, char *s)
{
    char save[0x60];
    int bmp;
    int w;
    int h;

    w = (fputchar(s) & 0xFFC0) + 0x40;
    h = byte_D42C3 + 1;
    bmp = CreateBitmap(w, h, 0);
    sub_B3A88(save);
    SetDrawBitmap(bmp);
    ClearScreen(0xFF);
    PrintShadowText(0, 0, s);
    sub_B3AA1(save);
    DrawArt(((int *)bmp)[0x2C / 4], x, y);
    sub_9132C(bmp);
}
