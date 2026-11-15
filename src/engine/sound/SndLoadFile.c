/* Engine sound interface: load a sound file. */
#include "nhl95.h"

/* SndLoadFile: load sound file name into the current sound bank (cursndbank) through the sound
 library (sub_8E8B8). The first argument is not used. */
void SndLoadFile(int unused, char *name)
{
    sub_8E8B8(name, cursndbank);
}

/* SndLoadFile2: as SndLoadFile through the other library loader (sub_8E908); shares its tail. */
void SndLoadFile2(int unused, char *name)
{
    sub_8E908(name, cursndbank);
}
