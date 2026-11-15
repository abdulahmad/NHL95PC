/* Main startup: keyboard wait. */
#include "nhl95.h"

/* WaitKeyRelease: wait until key is released (polling the keyboard), then flush (sub_B3A24). */
void WaitKeyRelease(int key)
{
    while (KeyDown(key)) PollKey();
    sub_B3A24();
}
