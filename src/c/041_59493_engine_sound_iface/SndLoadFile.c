/* Engine sound interface: load a sound file. */
#include "nhl95.h"

/* SndLoadFile (59493) - load sound file name into the current sound bank (dword_CCC94) through the sound
   library (sub_8E8B8). The first argument is not used. */
void SndLoadFile(int unused, char *name)
{
    sub_8E8B8(name, dword_CCC94);
}
