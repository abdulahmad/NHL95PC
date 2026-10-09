/* Engine core: periodic events. */
#include "nhl95.h"

/* periodicevents (5C302) - per frame: penalties and crowd decay; at 0:00 of the clock (play on) the horn (sfx 90h),
   LockScroll and clockcont_0. Every 24th frame (lldisp countdown, toggling lldispodd) the goalie / crowd / bench
   checks and the power-play flags (play on); with line changes on, energywarn[side] blinks (odd ticks) while a
   skater of that side is due for a change (newpnum >= 0) and no penalty shot runs. */
void periodicevents(void)
{
    Team *t;
    Player *p;
    short i;
    short k;
    signed char d;

    PenaltyManager();
    DecayCrowdLevel();
    if (!(gmode & 1) && !gameclock && !clockticks[0]) {
        sfx(0x90);
        LockScroll();
        clockcont_0();
    }
    if (word_CBC44) return;
    if ((d = --lldisp) >= 0) return;
    d += 0x18;
    lldisp = d;
    *(unsigned char *)&lldispodd ^= 1;
    ChkGoalies();
    updatecrowdf();
    RestBench();
    if (!(gmode & 1)) UpdatePowerPlayFlags();
    if (!gameopts.linechanges) return;
    i = 0;
    t = &hmtmstruct;
    for (; i < 2; i++) {
        p = t->tmsort;
        k = 6;
        do {
            if (p->position >= 0 && p->newpnum >= 0 && !penshotmode && (lldispodd & 1)) {
                energywarn[i] = 1;
                return;
            }
            p++;
        } while (--k);
        energywarn[i] = k;
        t = &awtmstruct;
    }
}
