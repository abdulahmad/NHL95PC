/* Engine core: coach AI. */
#include "nhl95.h"

/* InitCoachModes (5A669) - start-of-period coach AI state for both teams (Team bytes D2h-D5h, dword D6h): defaults 3/2;
   overtime (curperiod > 3) D9Ah / 2, away flags 1 / 8; the third period through SetCoachMode; earlier periods
   CCCh / 0, away flags 81h / 1. Clears the line counters; with line changes on, a computer-run home team starts
   with tmlcnt 2 and a computer-run away team with line 3, tmlcnt 2. */
void InitCoachModes(void)
{
    byte_DF6E8 = byte_DF7E8 = 0;
    byte_DF6E6 = 3;
    byte_DF6E7 = 2;
    byte_DF7E6 = 3;
    byte_DF7E7 = 2;
    if (curperiod > 3) {
        dword_DF6EA = 0xD9A;
        byte_DF6E9 = 2;
        dword_DF7EA = 0xD9A;
        byte_DF7E8 = 1;
        byte_DF7E9 = 8;
    } else if (curperiod == 3) {
        SetCoachMode(0);
        SetCoachMode(1);
    } else {
        dword_DF6EA = 0xCCC;
        byte_DF6E9 = 0;
        dword_DF7EA = 0xCCC;
        byte_DF7E8 = 0x81;
        byte_DF7E9 = 1;
    }
    hmtmline[0] = hmtmlcnt = awtmline = awtmlcnt = 0;
    if (!gameopts.linechanges) return;
    if (cont1team != 1 && cont2team != 1) hmtmlcnt = 2;
    if (cont1team != 2 && cont2team != 2) {
        awtmline = 3;
        awtmlcnt = 2;
    }
}
