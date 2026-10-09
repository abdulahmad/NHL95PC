/* ReplayRecordReset (67564) - PC only: restart replay recording. replaytick = 1 makes the next updatereplay call
   record a frame; replaysfx = -1 means no sound effect recorded yet. Called from the period start and load code. */
#include "nhl95.h"

void ReplayRecordReset(void)
{
    replaytick = 1;
    replaysfx = -1;
}
