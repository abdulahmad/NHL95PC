/* Menu system: formatted text output. */
#include "nhl95.h"

/* TextPrintf (1FB1C) - PC only: sprintf fmt with one argument into printfbuf, then print it at (x, y)
   (sub_91964). */
void TextPrintf(int x, int y, char *fmt, int a)
{
    sprintf((char *)printfbuf, fmt, a);
    sub_91964((char *)printfbuf, x, y);
}

/* TextPrintf2 (1FB49) - PC only: as TextPrintf with two arguments (the second on the stack). */
void TextPrintf2(int x, int y, char *fmt, int a, int b)
{
    sprintf((char *)printfbuf, fmt, a, b);
    sub_91964((char *)printfbuf, x, y);
}
