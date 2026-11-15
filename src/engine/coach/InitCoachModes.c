/* Engine core: coach AI. */
#include "nhl95.h"

/* InitCoachModes: start-of-period coach AI state for both teams (Team bytes D2h-D5h, dword D6h): defaults 3/2
 overtime (curperiod > 3) D9Ah 2, away flags 1 8; the third period through SetCoachMode; earlier periods
 CCCh 0, away flags 81h 1. Clears the line counters; with line changes on, a computer-run home team starts
 with tmlcnt 2 and a computer-run away team with line 3, tmlcnt 2. */
void InitCoachModes(void)
{
    hmtmcoachflags = awtmcoachflags = 0;
    hmtmcoach_d2 = 3;
    hmtmcoach_d3 = 2;
    awtmcoach_d2 = 3;
    awtmcoach_d3 = 2;
    if (curperiod > 3) {
        hmtmcoachenergy = 0xD9A;
        hmtmcoachmode = 2;
        awtmcoachenergy = 0xD9A;
        awtmcoachflags = 1;
        awtmcoachmode = 8;
    } else if (curperiod == 3) {
        SetCoachMode(0);
        SetCoachMode(1);
    } else {
        hmtmcoachenergy = 0xCCC;
        hmtmcoachmode = 0;
        awtmcoachenergy = 0xCCC;
        awtmcoachflags = 0x81;
        awtmcoachmode = 1;
    }
    hmtmline[0] = hmtmlcnt = awtmline = awtmlcnt = 0;
    if (!gameopts.linechanges) return;
    if (cont1team != 1 && cont2team != 1) hmtmlcnt = 2;
    if (cont1team != 2 && cont2team != 2) {
        awtmline = 3;
        awtmlcnt = 2;
    }
}
