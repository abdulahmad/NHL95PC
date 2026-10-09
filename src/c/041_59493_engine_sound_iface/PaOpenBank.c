/* PaOpenBank (59D54) - PC only: when sound is on (musicon), retry OpenAnnouncerBank until it succeeds. */
#include "nhl95.h"

void PaOpenBank(void)
{
    if (musicon) {
        while (OpenAnnouncerBank() == 0) ;
    }
}
