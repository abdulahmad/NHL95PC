/* updatePPTeamTime (63B57) - 94G updatePPTeamTime: one more second of power-play time for the team on the power
   play. gmode2 bit 5 = a power play is running, bit 6 = the visitors have it; the counter is the team's tmpptime
   word (94G $352 of the team structure). */
#include "nhl95.h"

void updatePPTeamTime(void)
{
    Team *t;

    if (gmode2 & 0x20) {                /* power play? */
        if ((gmode2 & 0x40) == 0) t = &hmtmstruct;  /* home on the PP */
        else t = &awtmstruct;                       /* visitors on the PP */
        t->tmpptime++;                  /* one more second for the PP team */
    }
}
