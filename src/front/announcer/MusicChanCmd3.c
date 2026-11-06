/* Speech music: channel command. */
#include "nhl95.h"

/* MusicChanCmd3: send command 3 to the music handle (sound library sub_8FCAC). */
void MusicChanCmd3(void)
{
    sub_8FCAC(musichandle, 3);
}
