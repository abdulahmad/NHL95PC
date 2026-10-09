/* Scoring / penalties: penalty clock (93G updatepentime). */
#include "nhl95.h"

/* updatepentime (63B85) - 93G updatepentime: clear sflags3 bit 6 (a second went by); while the clock runs and
   no penalty shot is on, count Penaltytimer down; when it passes 0 set bit 6, add 24 frames back and do the
   once-a-second work: chkatop, updatePPTeamTime and both teams' ProcessPenaltyList. */
void updatepentime(void)
{
    unsigned char f;

    f = sflags3 & 0xBF;
    sflags3 = f;
    if (gmode & 1) return;
    if (penshotlive != 0) return;
    if (--Penaltytimer < 0) {
        sflags3 = f | 0x40;
        Penaltytimer += 24;
        chkatop();
        updatePPTeamTime();
        ProcessPenaltyList(&hmtmstruct);
        ProcessPenaltyList(&awtmstruct);
    }
}
