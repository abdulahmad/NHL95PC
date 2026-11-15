/* Scoreboard graphics: clock. */
#include "nhl95.h"

/* TickPanelClock: run the scoreboard clock down by hund hundredths (previous value kept in panelprevmin..18)
 at 0:00.00 it stops there and returns 0, else 1. */
int TickPanelClock(int hund)
{
    panelprevmin = hudclockmin;
    panelprevsec = hudclocksec;
    panelprevhund = hudclockhund;
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
