/* Speech music: channel command. */
#include "nhl95.h"

/* MusicChanCmd3: send command 3 to the music handle (sound library StopDigiChannel). */
void MusicChanCmd3(void)
{
    StopDigiChannel(musichandle, 3);
}
