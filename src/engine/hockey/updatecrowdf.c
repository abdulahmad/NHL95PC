/* Engine core: once-a-second crowd excitement update (PC version). */
#include "nhl95.h"

/* updatecrowdf: once a second (from periodicevents): crowd excitement bookkeeping. The PC version
 differs from (which steps the crowd animation): word_E9AA4 keeps the peak CwdExciteLvl, dword_E009C
 the sum and word_E9AA6 the count (an average for the stats), then CwdExciteLvl decays by 1 (not below 0).
 While the clock is stopped (gmode gmclock) and the crowd is loud (crowdlevel > 258h), a random crowd
 sound: 1 in max((3E8h - crowdlevel) 4, 25) for sfx A6h, the same for sfx 96h. */
void updatecrowdf(void)
{
    int t;
    int n;

    if (CwdExciteLvl > word_E9AA4) word_E9AA4 = CwdExciteLvl;  /* peak */
    dword_E009C += CwdExciteLvl;                /* sum */
    word_E9AA6++;                               /* count */
    if (--CwdExciteLvl < 0) CwdExciteLvl = 0;
    if ((gmode & gmclock) && crowdlevel > 0x258) {
        t = (1000 - crowdlevel) / 4;
        n = t;
        if (t < 25) n = 25;
        n = randomd0(n);                        /* n reused for the draw (keeps it in edx) */
        if (n == 0) sfx(0xA6);
        else if (n == 1) sfx(0x96);
    }
}
