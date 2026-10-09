/* Sound config: empty the speech queue. */
#include "nhl95.h"

/* ResetSpeechQueue (833FA) - PC only: empty the speech queue: no clip playing (+60h), the 20 slots set to -1,
   the counters at +54h, +58h, +50h and the pending clip (+5Ch) 0. */
void ResetSpeechQueue(void)
{
    *(int *)(speechq + 0x60) = 0;
    memset((void *)speechq, -1, 0x50);
    *(int *)(speechq + 0x54) = 0;
    *(int *)(speechq + 0x58) = 0;
    *(int *)(speechq + 0x50) = 0;
    *(int *)(speechq + 0x5C) = 0;
}
