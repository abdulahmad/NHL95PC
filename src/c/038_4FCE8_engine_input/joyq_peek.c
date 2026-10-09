/* joyq_peek (4FD62) - PC only: the oldest entry of the controller input queue, or 0 when it is empty. Entries are
   3 bytes (joyqueue + joyqhead * 3). The main loop stores the result in joyrec for Readjoy1/Readjoy2. */
#include "nhl95.h"

unsigned char *joyq_peek(void)
{
    if (joyqcount == 0) return 0;
    return joyqueue + joyqhead * 3;
}
