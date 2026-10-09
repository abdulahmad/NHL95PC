/* Roster / jersey: trade dialog done button. */
#include "nhl95.h"

/* TradeDone (3EDAA) - trade dialog "done" callback (a-h unused; sel: the selected slots of both sides, byte 0/1
   and 2/3): a side with one of its pair picked and not the other is an unequal trade: save palette entries FBh-FEh
   (DONEPAL buffer), set them to the message colours, show "unequal trade" at the mouse, restore the palette and
   the mouse position. Otherwise traderesult = 1. */
void TradeDone(int a, int b, int c, int d, int e, int f, int g, int h, unsigned char *sel)
{
    unsigned char rgb[4];
    int i;
    int mx;
    int my;
    int bad;
    unsigned char *buf;

    bad = 0;
    for (i = 0; i < 2; i++) {
        if ((sel[i] == 0xFF && sel[i] != sel[i + 2]) || (sel[i] != 0xFF && sel[i + 2] == 0xFF)) bad = -1;
    }
    if (bad) {
        buf = (unsigned char *)sub_8CCA8((char *)str_Donepal, 0xC, 0x20);
        sub_8FFB0(0xFB, 4, buf);
        rgb[0] = 0x18;
        rgb[2] = rgb[1] = 0;
        sub_B4B88(0xFB, 1, rgb);
        rgb[0] = 0x2A;
        rgb[2] = rgb[1] = 0;
        sub_B4B88(0xFC, 1, rgb);
        rgb[0] = 0x3B;
        rgb[1] = 0x12;
        rgb[2] = 0;
        sub_B4B88(0xFD, 1, rgb);
        rgb[2] = rgb[1] = rgb[0] = 0x3B;
        sub_B4B88(0xFE, 1, rgb);
        sub_B2DCA(&i, &mx, &my);
        MessageBox(-1, -1, (char *)unequaltrademsg, 3, 0, 0, (int)&mx, (int)&my, -1);
        sub_B4B88(0xFB, 4, buf);
        jctime((int)buf);
        MouseSetPos(mx, my);
    } else {
        traderesult = 1;
    }
}
