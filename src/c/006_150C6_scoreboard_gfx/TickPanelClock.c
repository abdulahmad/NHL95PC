/* Scoreboard graphics: clock. */
#include "nhl95.h"

/* TickPanelClock (15374) - run the scoreboard clock down by hund hundredths (previous value kept in dword_C5710..18);
   at 0:00.00 it stops there and returns 0, else 1. */
int TickPanelClock(int hund)
{
    dword_C5710 = hudclockmin;
    dword_C5714 = hudclocksec;
    dword_C5718 = hudclockhund;
    hudclockhund -= hund;
    if (hudclockhund < 0) {
        hudclockhund += 100;
        if (--hudclocksec < 0) {
            hudclocksec = 59;
            if (--hudclockmin < 0) {
                hudclockmin = hudclocksec = hudclockhund = 0;
                return 0;
            }
        }
    }
    return 1;
}
