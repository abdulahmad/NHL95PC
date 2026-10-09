/* Announcer: playoff round clips. */
#include "nhl95.h"

/* PlayoffRoundClipU (8438F) - buf = the speech clip name for playoff round round of conference conf (1 East, 2 West:
   quarter-final, semi-final, final) or the Stanley Cup final (conf 3); u (up) variant. Unknown pairs leave buf. */
void PlayoffRoundClipU(char *buf, unsigned conf, unsigned round)
{
    switch (conf) {
    case 1:
        switch (round) {
        case 1: sprintf(buf, (char *)str_EastquauBar); break;
        case 2: sprintf(buf, (char *)str_EastsemuBar); break;
        case 3: sprintf(buf, (char *)str_EastfinuBar); break;
        }
        break;
    case 2:
        switch (round) {
        case 1: sprintf(buf, (char *)str_WestquauBar); break;
        case 2: sprintf(buf, (char *)str_WestsemuBar); break;
        case 3: sprintf(buf, (char *)str_WestfinuBar); break;
        }
        break;
    case 3:
        sprintf(buf, (char *)str_StanleyuBar);
        break;
    }
}
