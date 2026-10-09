/* Misc dialogs: text measuring. */
#include "nhl95.h"

/* MeasureTextLine (309E4) - widen *maxw to the pixel width of line s and add the line height add to *total. */
void MeasureTextLine(char *s, int *maxw, int *total, int add)
{
    int w;

    w = fputchar(s);
    if (w > *maxw) *maxw = w;
    *total += add;
}
