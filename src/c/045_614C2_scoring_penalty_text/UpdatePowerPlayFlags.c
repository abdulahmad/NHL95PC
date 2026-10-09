/* Scoring / penalties: power-play state. */
#include "nhl95.h"

/* UpdatePowerPlayFlags (63C73) - PC only: compare the teams' tmap (players short). Equal: clear gmode2 bit 5
   (power play running). Otherwise bit 6 tells which team is on the power play (set when the home team is
   short); when it changes the bits 5-6 are rewritten. A power play that was not running yet (bit 5 clear)
   starts: bit 5 set, the team's tmpp (power plays) + 1, and while the clock runs a crowd sample (1 home,
   4 away) when speech or music is off. */
void UpdatePowerPlayFlags(void)
{
    Team *t;
    short diff;
    short mode;
    int crowd;

    t = &awtmstruct;
    if ((diff = hmtmstruct.tmap - awtmstruct.tmap) == 0) {
        gmode2 &= 0xDF;
        return;
    }
    mode = *(short *)&gmode2;
    *(unsigned char *)&mode &= 0x9F;
    if (diff > 0) {
        t = &hmtmstruct;
        if ((gmode2 & 0x40) == 0) goto start;
    } else {
        if (gmode2 & 0x40) goto start;
        *(short *)&gmode2 = mode;
        *(unsigned char *)&mode |= 0x40;
    }
    *(short *)&gmode2 = mode;
start:
    if ((gmode2 & 0x20) == 0) {
        gmode2 |= 0x20;
        t->tmpp++;
        if (gmode & 1) {
            if (gameopts.speech == 0 || musicon == 0) crowd = 1;
            else crowd = 0;
            if (crowd) PlayCrowdSample(t == &hmtmstruct ? 1 : 4);
        }
    }
}
