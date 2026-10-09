/* Announcer: playoff round clips. */
#include "nhl95.h"

/* PlayoffRoundClipD (84306) - buf = the speech clip name for playoff round round of conference conf (1 East, 2 West:
   quarter-final, semi-final, final) or the Stanley Cup final (conf 3); d (down) variant. Unknown pairs leave buf. */
void PlayoffRoundClipD(char *buf, unsigned conf, unsigned round)
{
    switch (conf) {
    case 1:
        switch (round) {
        case 1: sprintf(buf, (char *)str_EastquadBar); break;
        case 2: sprintf(buf, (char *)str_EastsemdBar); break;
        case 3: sprintf(buf, (char *)str_EastfindBar); break;
        }
        break;
    case 2:
        switch (round) {
        case 1: sprintf(buf, (char *)str_WestquadBar); break;
        case 2: sprintf(buf, (char *)str_WestsemdBar); break;
        case 3: sprintf(buf, (char *)str_WestfindBar); break;
        }
        break;
    case 3:
        sprintf(buf, (char *)str_StanleydBar);
        break;
    }
}
