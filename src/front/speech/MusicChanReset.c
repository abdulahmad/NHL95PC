/* Speech: reset the music channels. */
#include "nhl95.h"

/* MusicChanReset: when the speech/sound system is up (speechinit), send command 0 and then 1
 to the music handle (StopDigiChannel). */
void MusicChanReset(void)
{
    if (speechinit != 0) {
        StopDigiChannel(musichandle, 0);
        StopDigiChannel(musichandle, 1);
    }
}
