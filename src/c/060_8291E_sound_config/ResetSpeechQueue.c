/* Sound config: empty the speech queue. */
#include "nhl95.h"

/* __STOSD: the Watcom library dword fill (n dwords of v at p). */
void __STOSD(void *p, int v, int n);
#pragma aux __STOSD "__STOSD" parm [eax] [edx] [ecx] modify [eax edx ecx];

/* ResetSpeechQueue: empty the speech queue: no clip playing (+60h), the 20 slots set to -1,
 the counters at +54h, +58h, +50h and the pending clip (+5Ch) 0. */
void ResetSpeechQueue(void)
{
    *(int *)(speechq + 0x60) = 0;
    __STOSD((void *)speechq, -1, 0x14);
    *(int *)(speechq + 0x54) = 0;
    *(int *)(speechq + 0x58) = 0;
    *(int *)(speechq + 0x50) = 0;
    *(int *)(speechq + 0x5C) = 0;
}
