/* Misc dialogs: scroll bars. */
#include "nhl95.h"

/* InitScrollBar (30BF3) - set up scroll bar sb (ints: +8 width, +0Ch height) for total items with visible on screen:
   position 0, thumb width = width - 4, thumb length = (height - 4) * visible / total. */
void InitScrollBar(int *sb, int visible, int total)
{
    sb[0x28 / 4] = total;
    sb[0x24 / 4] = visible;
    sb[0x20 / 4] = 0;
    sb[0x10 / 4] = 0;
    sb[0x14 / 4] = 0;
    sb[0x18 / 4] = sb[0x08 / 4] - 4;
    sb[0x1C / 4] = (sb[0x0C / 4] - 4) * sb[0x24 / 4] / sb[0x28 / 4];
}
