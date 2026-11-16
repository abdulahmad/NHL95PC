/* Front end labels: scoreboard graphics. */
#include "nhl95.h"

/* LoadScoreboardGfx: load the scoreboard shape bank SCRBRD1.PPV (from the CD when it is
 there) into scrbrdshapes and look up its shapes by name lists (ProjectPointList): the score, clock and penalty
 digits, the away home line indicators, the away home panels ("visp" "homp", FindShape) and the line
 sprites. */
void LoadScoreboardGfx(void)
{
    char path[16];

    MakePath(path, fileoncd[0x16C] == 1 ? (char *)cddriveptr : 0, (char *)str_scrbrd1, (char *)str_PPV);
    scrbrdshapes = sub_8E8A0(path, 0x20);
    ProjectPointList(scrbrdshapes, (char *)str_LineCodes0, scoredigits);
    ProjectPointList(scrbrdshapes, (char *)str_LineCodes1, clockdigits);
    ProjectPointList(scrbrdshapes, (char *)str_LineCodes2, penaltydigits);
    ProjectPointList(scrbrdshapes, (char *)str_VisLineTags, (int *)awlineind);
    ProjectPointList(scrbrdshapes, (char *)str_HomeLineTags, (int *)hmlineind);
    awpanelspr = FindShape(scrbrdshapes, (char *)str_Visp);
    hmpanelspr = FindShape(scrbrdshapes, (char *)str_Homp);
    ProjectPointList(scrbrdshapes, (char *)str_LineNames, linesprites);
}
