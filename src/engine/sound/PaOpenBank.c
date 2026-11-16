/* PaOpenBank: when sound is on (MusicOn), retry OpenAnnouncerBank until it succeeds. */
#include "nhl95.h"

void PaOpenBank(void)
{
    if (MusicOn) {
        while (OpenAnnouncerBank() == 0) ;
    }
}
