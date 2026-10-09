/* WaitDigiSample (599EE) - PC only: busy-wait until the digital sample in digihandle has finished playing
   (sub_8F80E, a sound library status call, returns non-zero). Does nothing when no sample is loaded (-1). */
#include "nhl95.h"

void WaitDigiSample(void)
{
    if (digihandle != -1) {
        do {
        } while (sub_8F80E(digihandle) == 0);
    }
}
