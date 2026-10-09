/* Game save I/O: replay buffer state. */
#include "nhl95.h"

/* ReplayIsEmpty (12034) - 1 when nothing has been recorded: the replay record pointer is still at the start of
   the buffer and sflags bit 4 (buffer wrapped) is clear; else 0. */
int ReplayIsEmpty(void)
{
    if (recbpr == replaystart && !(sflags & 0x10)) return 1;
    return 0;
}
