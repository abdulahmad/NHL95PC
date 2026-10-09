/* Front end labels: dirty rectangles. */
#include "nhl95.h"

/* AddDirtyRect (1D02F) - PC only: add the rectangle x, y, w, h to the dirty list of the hidden VGA page (index
   vgapage == 0): 16-byte entries x / 4, y, width in 4-pixel columns, h; count it. */
void AddDirtyRect(short x, short y, short w, short h)
{
    ((int *)dirtyrectptr[vgapage == 0])[2] = ((unsigned)(x + w) >> 2) - ((unsigned)x >> 2) + 1;
    ((int *)dirtyrectptr[vgapage == 0])[3] = h;
    ((int *)dirtyrectptr[vgapage == 0])[0] = (unsigned)x >> 2;
    ((int *)dirtyrectptr[vgapage == 0])[1] = y;
    dirtyrectcount[vgapage == 0]++;
    dirtyrectptr[vgapage == 0] += 0x10;
}
