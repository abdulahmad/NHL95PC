/* ClearPenaltyBuffer (63D3C) - 93G ClearPenaltyBuffer: clear the 32 two-byte entries of PenBuf (E9A16): both the
   player byte (PenBuf_pl, +1) and the first byte. Called from the clock code, the PenGoalStuff role code and
   game_frame. */
#include "nhl95.h"

void ClearPenaltyBuffer(void)
{
    short i;

    for (i = 0; i < 32; i++) {
        PenBuf_pl[i * 2] = 0;
        PenBuf[i * 2] = 0;
    }
}
