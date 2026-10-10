/* Title / intro: formatted shadowed text. */
#include "nhl95.h"

/* PrintFmt1 (176AE) - sprintf fmt with one argument into a local buffer and draw it with PrintShadowText at
   (x, y). */
void PrintFmt1(int x, int y, char *fmt, int a)
{
    char buf[0x54];

    sprintf(buf, fmt, a);
    PrintShadowText(x, y, buf);
}

/* PrintFmt2 (176DB) - as PrintFmt1 with two arguments (the second on the stack). */
void PrintFmt2(int x, int y, char *fmt, int a, int b)
{
    char buf[0x54];

    sprintf(buf, fmt, a, b);
    PrintShadowText(x, y, buf);
}
