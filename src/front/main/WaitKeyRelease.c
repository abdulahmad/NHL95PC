/* Main startup: keyboard wait. */
#include "nhl95.h"

/* WaitKeyRelease: wait until key is released (polling the keyboard), then flush (KbdFlush). */
void WaitKeyRelease(int key)
{
    while (KeyDown(key)) PollKey();
    KbdFlush();
}
