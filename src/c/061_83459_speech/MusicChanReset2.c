/* Speech: music channel reset and speech queue stop. */
#include "nhl95.h"

/* MusicChanReset2 (8373E) - MusicChanReset, then SpeechStopQueue (falls through into it). */
void MusicChanReset2(void)
{
    MusicChanReset();
    SpeechStopQueue();
}

/* SpeechStopQueue (8374D) - stop the speech queue: nothing playing (+60h = 0); the wait time (+5Ch) becomes +50h plus the
   dword after the 400 bank slots (+3B70h). */
void SpeechStopQueue(void)
{
    if (speechinit) {
        ((int *)speechq)[0x60 / 4] = 0;
        ((int *)speechq)[0x5C / 4] = ((int *)speechq)[0x50 / 4] + *(int *)((char *)speechbank + 0x3B70);
    }
}
