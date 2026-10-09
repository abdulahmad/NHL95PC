/* Title / intro: text grid buffer. */
#include "nhl95.h"

/* TextGridOpen (17711) - allocate the text grid (E74h bytes) if needed, switch it on and clear its 36 x 100 cells to
   spaces. */
void TextGridOpen(void)
{
    if (!textgrid) textgrid = (int)_nmalloc(0xE74);
    textgridon = 1;
    memset((void *)textgrid, ' ', 0xE10);
}
