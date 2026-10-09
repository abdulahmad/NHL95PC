/* Engine display: line table refill. */
#include "nhl95.h"

/* RefillLineSlots (6552E) - PC only: free the player in slot slot of team side's line table (home hmlinetab, away
   awlinetab; byte_E9E18: 25 used flags per team), then for from .. to - 1 refill slot, slot + step, ... with
   PickForLineSlot, marking each pick in a skater slot (below 18) as free again. */
void RefillLineSlots(short side, short slot, short from, short to, short step)
{
    signed char *tab;
    signed char pl;

    tab = (signed char *)(side ? awlinetab : hmlinetab);
    byte_E9E18[side * 25 + tab[slot]] = 0;
    for (; from < to; from++) {
        pl = PickForLineSlot(side, slot);
        tab[slot] = pl;
        if (slot < 18) byte_E9E18[side * 25 + pl] = 0;
        slot += step;
    }
}
