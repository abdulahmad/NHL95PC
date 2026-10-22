/* Title intro: text grid. */
#include "nhl95.h"

/* TextGridPut: when the text grid is allocated and on, copy string s (without its terminator) into the
 100-column grid at the cell of screen pixel (x, y): column x * 100 / 640, row y * 36 / 480.
 DRAFT: same size, 2 instructions: the EXE loads textgrid into esi before the row * 100 copy (mov edx, eax),
 this compiles it after. The split row = y * 36; row /= 480 and d = textgrid; d += ... give the EXE y * 36
 (shl edx / add edx, esi); one expression copies y twice (+2 bytes). */
void TextGridPut(int x, int y, char *s)
{
    int col;
    int row;
    char *d;

    if (textgrid && textgridon == 1) {
        col = x * 100 / 640;
        row = y * 36;
        row /= 480;
        d = (char *)textgrid;
        d += col + row * 100;
        memcpy(d, s, strlen(s));
    }
}
