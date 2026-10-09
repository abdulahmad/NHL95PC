/* Title / intro: text. */
#include "nhl95.h"

/* PrintCenteredText (17573) - print s centred on the 640-pixel screen at y: shadow (textshadow) one pixel down-right,
   then the text (textcolor), and record it in the text grid. */
void PrintCenteredText(int y, char *s)
{
    int x;

    x = (0x280 - fputchar(s)) / 2;
    fontcolor = textshadow;
    sub_91964(s, x + 1, y + 1);
    fontcolor = textcolor;
    sub_91964(s, x, y);
    TextGridPut(x, y, s);
}
