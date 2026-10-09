/* Speech: sample requests. */
#include "nhl95.h"

/* ResetSampleReq (83520) - clear the 20 sample request names (13 bytes each) and the three request counters at +104h,
   +108h, +10Ch. */
void ResetSampleReq(void)
{
    int i;

    for (i = 0; i < 20; i++) samplereq[i * 13] = 0;
    *(int *)(samplereq + 0x10C) = 0;
    *(int *)(samplereq + 0x108) = 0;
    *(int *)(samplereq + 0x104) = 0;
}
