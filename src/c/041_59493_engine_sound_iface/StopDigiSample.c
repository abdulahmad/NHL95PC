/* Engine sound interface: digital samples. */
#include "nhl95.h"

/* StopDigiSample: stop the playing digital sample (digihandle) unless it has already finished (sub_8F80E), and
 mark no sample (-1). */
void StopDigiSample(void)
{
    if (digihandle != -1 && !sub_8F80E(digihandle)) {
        sub_8F67D(digihandle);
        digihandle = -1;
    }
}
