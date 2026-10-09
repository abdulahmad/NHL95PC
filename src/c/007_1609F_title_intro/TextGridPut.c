/* Title / intro: text grid. */
#include "nhl95.h"

/* TextGridPut (17793) - when the text grid is allocated and on, copy string s (without its terminator) into the
   100-column grid at the cell of screen pixel (x, y): column x * 100 / 640, row y * 36 / 480. */
void TextGridPut(int x, int y, char *s)
{
    int col;
    int row;
    char *d;

    if (textgrid && textgridon == 1) {
        col = x * 100 / 640;
        row = y * 36 / 480;
        d = (char *)textgrid + (col + row * 100);
        memcpy(d, s, strlen(s));
    }
}
