/* Engine sound interface: announcer preload. */
#include "nhl95.h"

/* PaPreloadClips (59D71) - with music / speech on (musicon), call PreloadAnnouncerClips(a, b) until it reports
   done (nonzero). */
void PaPreloadClips(int a, int b)
{
    if (musicon) {
        while (!PreloadAnnouncerClips((char *)a, (char *)b));
    }
}
