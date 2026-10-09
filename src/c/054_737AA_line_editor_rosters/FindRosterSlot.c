/* Line editor / rosters: roster slot lookup. */
#include "nhl95.h"

/* FindRosterSlot (739B6) - PC only: slot (0-27) of team side's roster (27-byte slots, 2F4h per team) whose first
   byte is pl; the loop ends by setting the index to 28. Not found: an unset value is returned. */
unsigned char FindRosterSlot(unsigned char pl, unsigned char side)
{
    unsigned char found;
    unsigned char i;

    for (i = 0; i < 28; i++) {
        if (rosterslot[side * 0x2F4 + i * 27] == pl) {
            found = i;
            i = 28;
        }
    }
    return found;
}
