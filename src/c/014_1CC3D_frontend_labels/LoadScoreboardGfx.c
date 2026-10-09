/* Front end labels: scoreboard graphics. */
#include "nhl95.h"

/* LoadScoreboardGfx (1CC3D) - PC only: load the scoreboard shape bank SCRBRD1.PPV (from the CD when it is
   there) into scrbrdshapes and look up its shapes by name lists (sub_90B80): the score, clock and penalty
   digits, the away / home line indicators, the away / home panels ("visp" / "homp", sub_B30B4) and the line
   sprites. */
void LoadScoreboardGfx(void)
{
    char path[16];

    MakePath(path, fileoncd[0x16C] == 1 ? (char *)cddriveptr : 0, (char *)str_scrbrd1, (char *)str_PPV);
    scrbrdshapes = sub_8E8A0(path, 0x20);
    sub_90B80(scrbrdshapes, (char *)str_LineCodes0, scoredigits);
    sub_90B80(scrbrdshapes, (char *)str_LineCodes1, clockdigits);
    sub_90B80(scrbrdshapes, (char *)str_LineCodes2, penaltydigits);
    sub_90B80(scrbrdshapes, (char *)str_VisLineTags, (int *)awlineind);
    sub_90B80(scrbrdshapes, (char *)str_HomeLineTags, (int *)hmlineind);
    awpanelspr = sub_B30B4(scrbrdshapes, (char *)str_Visp);
    hmpanelspr = sub_B30B4(scrbrdshapes, (char *)str_Homp);
    sub_90B80(scrbrdshapes, (char *)str_LineNames, linesprites);
}
