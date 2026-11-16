/* Engine sound interface: digital samples. */
#include "nhl95.h"

/* StopDigiSample: stop the playing digital sample (digihandle) unless it has already finished (SongFinished), and
 mark no sample (-1). */
void StopDigiSample(void)
{
    if (digihandle != -1 && !SongFinished(digihandle)) {
        StopSongId(digihandle);
        digihandle = -1;
    }
}
