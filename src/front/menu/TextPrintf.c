/* Menu system: formatted text output. */
#include "nhl95.h"

/* TextPrintf: sprintf fmt with one argument into printfbuf, then print it at (x, y)
 (PrintString). */
void TextPrintf(int x, int y, char *fmt, int a)
{
    sprintf((char *)printfbuf, fmt, a);
    PrintString((char *)printfbuf, x, y);
}

/* TextPrintf2: as TextPrintf with two arguments (the second on the stack). */
void TextPrintf2(int x, int y, char *fmt, int a, int b)
{
    sprintf((char *)printfbuf, fmt, a, b);
    PrintString((char *)printfbuf, x, y);
}
