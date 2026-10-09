/* joyq_flush (4FD47) - PC only: empty the controller input queue (joyqcount = 0) and restart its tick counter
   (joyqtick = 0). */
#include "nhl95.h"

void joyq_flush(void)
{
    joyqtick = joyqcount = 0;
}
