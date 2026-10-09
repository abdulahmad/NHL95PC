/* ReplayPrevFrame (675A0) - 94G suba4 role for the record pointer: the replay frame before recbpr (frames are
   80h bytes). At the buffer start it wraps to the last frame (replaystart + 9580h) if the buffer has wrapped
   (sflags bit 4, 94G sfwrap); otherwise it stays at the start. */
#include "nhl95.h"

unsigned char *ReplayPrevFrame(void)
{
    if (recbpr == replaystart) {
        if (sflags & sfwrap) return replaystart + REPLAYSIZE - 0x80;
        return replaystart;
    }
    return recbpr - 0x80;
}
