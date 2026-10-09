/* Engine sound interface: digital samples. */
#include "nhl95.h"

/* FreeDigiSample (59945) - free the digital sample (digihandle) unless it has already finished, and mark no sample. The
   argument is not used. */
void FreeDigiSample(int unused)
{
    int h;

    h = digihandle;
    if (h != -1 && !sub_8F80E(h)) {
        sub_8F7AE(digihandle);
        digihandle = -1;
    }
}
