/* Main startup: keyboard wait. */
#include "nhl95.h"

/* WaitKeyRelease (11161) - wait until key is released (polling the keyboard), then flush (sub_B3A24). */
void WaitKeyRelease(int key)
{
    while (sub_B2CBE(key)) PollKey();
    sub_B3A24();
}
