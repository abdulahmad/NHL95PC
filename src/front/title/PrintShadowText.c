/* Title intro: shadowed text. */
#include "nhl95.h"

/* PrintShadowText: print s at (x, y) with a shadow one pixel down-right (textshadow, then textcolor), and put it
 in the text grid. */
void PrintShadowText(int x, int y, char *s)
{
    fontcolor = textshadow;
    PrintString(s, x + 1, y + 1);
    fontcolor = textcolor;
    PrintString(s, x, y);
    TextGridPut(x, y, s);
}
