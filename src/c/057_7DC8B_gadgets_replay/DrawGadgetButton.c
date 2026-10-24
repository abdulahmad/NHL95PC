/* Gadgets replay: gadget button frame; the highlight "Save To" box (segment 058) ends in its exit. */
#define bothneitherstrs bothneitherstrs_fn
#define HilightSaveToDlg HilightSaveToDlg_decl
#include "nhl95.h"
#undef bothneitherstrs
#undef HilightSaveToDlg

extern unsigned char bothneitherstrs[];  /* 7E05F: two string pointers in the code segment (Both Teams, Neither Team) */

/* DrawGadgetButton: draw the frame of replay gadget n (gadgetrects: 7 dwords per gadget, x0, y0,
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

typedef struct { char *s[2]; } StrPair;

/* HilightSaveToDlg (7F724, PC only; highlights segment 058, the same source file: it ends in
   DrawGadgetButton_ret): draw the "Save To" box of the highlight saver: save the text state (sub_8E9E8), the
   highlight font, the box (sub_90D20, two sub_93000 frames), four choice buttons (bevelled 8Ah x 0Eh boxes, 11h
   apart from 4Eh, 50h), then "Save To", "Hilights Reel" and the choices (home and away team names from the team
   records, then "Both Teams" / "Neither Team" from bothneitherstrs) centred in the buttons, first in colour 10h
   one pixel down and right as the shadow, then in 59h. No arguments, no result.
   Its exit is DrawGadgetButton's (DrawGadgetButton_ret), so it sits in this file after it. */
void HilightSaveToDlg(void)
{
    char state[0x40];
    StrPair both;
    int y2;
    int x2;
    int x;
    int y;
    struct { int i; } count;

    both = *(StrPair *)bothneitherstrs;
    sub_8E9E8(state);
    sub_8EA18(hilightfont);
    sub_90D20(0, 0x4B, 0x140, 0x4C, 0x14);
    sub_93000(1, 0x4C, 0x13E, 0x95, 9);
    sub_93000(2, 0x4D, 0x13D, 0x96, 0x10);
    x = 0x4E;
    y = 0x50;
    for (count.i = 0; count.i < 4; count.i++, y += 0x11) {
        sub_B4FAC(x, y, x, y2 = y + 0xE, 0x59);
        sub_B4FAC(x, y, x2 = x + 0x8A, y, 0x59);
        sub_B4FAC(x + 1, y2, x2, y2, 0x10);
        sub_B4FAC(x2, y + 1, x2, y2, 0x10);
        sub_B5DB0(x2, y, 0x13);
        sub_B5DB0(x, y2, 0x13);
    }
    fontcolor = 0x10;
    sub_91964((char *)str_SaveTo, 0xE, 0x6D);
    sub_91964((char *)str_HilightsReel, 0xDF, 0x6D);
    sub_91964((char *)hmteamrec + 5, (0x85 - fputchar((char *)hmteamrec + 5)) / 2 + 0x52, 0x54);
    sub_91964((char *)awteamrec + 5, (0x85 - fputchar((char *)awteamrec + 5)) / 2 + 0x52, 0x65);
    sub_91964(both.s[0], (0x85 - fputchar(both.s[0])) / 2 + 0x52, 0x76);
    sub_91964(both.s[1], (0x85 - fputchar(both.s[1])) / 2 + 0x52, 0x87);
    fontcolor = 0x59;
    sub_91964((char *)str_SaveTo, 0xD, 0x6C);
    sub_91964((char *)str_HilightsReel, 0xDE, 0x6C);
    sub_91964((char *)hmteamrec + 5, (0x85 - fputchar((char *)hmteamrec + 5)) / 2 + 0x51, 0x53);
    sub_91964((char *)awteamrec + 5, (0x85 - fputchar((char *)awteamrec + 5)) / 2 + 0x51, 0x64);
    sub_91964(both.s[0], (0x85 - fputchar(both.s[0])) / 2 + 0x51, 0x75);
    sub_91964(both.s[1], (0x85 - fputchar(both.s[1])) / 2 + 0x51, 0x86);
}
