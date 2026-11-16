/* PaSpeechBusy: is the announcer still talking? SpeechBusy when sound is on (MusicOn) and
 the announcer option (gameopts bit 8) is set, else 0. */
#include "nhl95.h"

int PaSpeechBusy(void)
{
    if (MusicOn && gameopts.speech) return SpeechBusy();
    return 0;
}
