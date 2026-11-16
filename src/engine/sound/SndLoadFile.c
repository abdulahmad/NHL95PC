/* Engine sound interface: load a sound file. */
#include "nhl95.h"

/* SndLoadFile: load sound file name into the current sound bank (cursndbank) through the sound
 library (OpenArtArchive). The first argument is not used. */
void SndLoadFile(int unused, char *name)
{
    OpenArtArchive(name, cursndbank);
}

/* SndLoadFile2: as SndLoadFile through the other library loader (LoadFileAllocQuiet); shares its tail. */
void SndLoadFile2(int unused, char *name)
{
    LoadFileAllocQuiet(name, cursndbank);
}
