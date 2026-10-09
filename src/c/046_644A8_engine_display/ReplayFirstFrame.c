/* ReplayFirstFrame (67581) - PC only: the oldest frame of the replay buffer. Once the buffer has wrapped (sflags
   bit 4, 94G sfwrap) that is the record pointer recbpr, else the buffer start replaystart. */
#include "nhl95.h"

unsigned char *ReplayFirstFrame(void)
{
    if ((sflags & sfwrap) == 0) return replaystart;
    return recbpr;
}
