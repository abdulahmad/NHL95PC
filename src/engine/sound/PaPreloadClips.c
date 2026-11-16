/* Engine sound interface: announcer preload. */
#include "nhl95.h"

/* PaPreloadClips: with music speech on (MusicOn), call PreloadAnnouncerClips(a, b) until it reports
 done (nonzero). */
void PaPreloadClips(int a, int b)
{
    if (MusicOn) {
        while (!PreloadAnnouncerClips((char *)a, (char *)b));
    }
}
