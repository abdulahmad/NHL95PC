/* Roster / jersey: trade list lookup. */
#include "nhl95.h"

/* FindTradeSlot (3EF3C) - PC only: index of the trade list slot of team side (28 slots of 22 bytes, 268h per
   team) whose first byte is pl, or -1. */
int FindTradeSlot(int side, unsigned char pl)
{
    int found;
    int i;

    found = -1;
    for (i = 0; i < 28; i++) {
        if (tradeslot[side * 0x268 + i * 22] == pl) {
            found = i;
            break;
        }
    }
    return found;
}
