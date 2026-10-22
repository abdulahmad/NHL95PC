/* Engine sound interface: digital samples. */
#include "nhl95.h"

/* FreeDigiSample: free the digital sample (digihandle) unless it has already finished, and mark no sample.
 fade goes to the library's free (sub_8F7AE's second argument, the sample's release count). */
void FreeDigiSample(int fade)
{
    if (digihandle != -1 && !sub_8F80E(digihandle)) {
        sub_8F7AE(digihandle, fade);
        digihandle = -1;
    }
}
