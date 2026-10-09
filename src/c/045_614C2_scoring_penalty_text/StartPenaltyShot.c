/* Scoring / penalty text: penalty shot. */
#include "nhl95.h"

/* StartPenaltyShot (64398) - set up a penalty shot for penshotplayer (team by its object number, word +20h counted), one
   skater a side (tmap 1), remember its roster number and the faceoff spot (penshotfox / penshotfoy) and centre
   the faceoff. */
void StartPenaltyShot(void)
{
    Team *tm;

    if (penshotmode) return;
    penshotteam = penshotplayer > 5;
    if (penshotteam > 0) tm = &awtmstruct;
    else tm = &hmtmstruct;
    ((short *)tm)[0x20 / 2]++;
    awtmap = hmtmap[0] = 1;
    penshotpnum = SortCords[penshotplayer].pnum;
    penshotmode = 1;
    *(int *)&penshotfox = fox;
    *(int *)&penshotfoy = foy;
    foy = fox = 0;
}
