/* Title / intro: outlined text. */
#include "nhl95.h"

/* PrintOutlinedText (17636) - PC only: print s at x, y with an outline: four copies in textshadow at the
   textoutlinedx / textoutlinedy offsets, then the text in textcolor, and record it in the text grid. */
void PrintOutlinedText(int x, int y, char *s)
{
    int i;

    fontcolor = textshadow;
    for (i = 0; i < 4; i++) sub_91964(s, x + textoutlinedx[i], y + textoutlinedy[i]);
    fontcolor = textcolor;
    sub_91964(s, x, y);
    TextGridPut(x, y, s);
}
