/* Speech: reset the music channels. */
#include "nhl95.h"

/* MusicChanReset (837A8) - PC only: when the speech/sound system is up (speechinit), send command 0 and then 1
   to the music handle (sub_8FCAC). */
void MusicChanReset(void)
{
    if (speechinit != 0) {
        sub_8FCAC(musichandle, 0);
        sub_8FCAC(musichandle, 1);
    }
}
