/* Scoring / penalty text: penalty shot. */
#include "nhl95.h"

/* EndPenaltyShot (64439) - end a live penalty shot: clear the penalty shot state, log it (AddPenalty2 on the puck,
   kind 5), put the faceoff at the penalty shot spot (penshotfox / penshotfoy) and give object 16 assignment
   21h. */
void EndPenaltyShot(void)
{
    if (penshotlive && penshotmode) {
        penshotlive = penshotmode = 0;
        penshotplayer = -1;
        AddPenalty2(puckstruct, 5);
        ltx = penshotfox;
        lty = penshotfoy;
        assreplace(&SortCords[16], 0x21);
    }
}
