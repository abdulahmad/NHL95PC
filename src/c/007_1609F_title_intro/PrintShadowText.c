/* Title / intro: shadowed text. */
#include "nhl95.h"

/* PrintShadowText (175E2) - print s at (x, y) with a shadow one pixel down-right (textshadow, then textcolor), and put it
   in the text grid. */
void PrintShadowText(int x, int y, char *s)
{
    fontcolor = textshadow;
    sub_91964(s, x + 1, y + 1);
    fontcolor = textcolor;
    sub_91964(s, x, y);
    TextGridPut(x, y, s);
}
