/* Engine sound interface: digital samples. */
#include "nhl95.h"

/* StopDigiSample (59981) - stop the playing digital sample (digihandle) unless it has already finished (sub_8F80E), and
   mark no sample (-1). */
void StopDigiSample(void)
{
    int h;

    h = digihandle;
    if (h != -1 && !sub_8F80E(h)) {
        sub_8F67D(digihandle);
        digihandle = -1;
    }
}
