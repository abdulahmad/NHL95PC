/* Engine core: end of period. */
#include "nhl95.h"

/* PeriodOver (5DEA6) - end of a period: clear the line change displays (energywarn, lcblink, lcline -1, lcboxon) and,
   unless quitting (exitgame -1), switch ends (gmode bit 1) and advance gsp. From gsp 3 on: past 3 it goes back
   to 3 (4 with full-length overtime, gameopts bit 9); at exactly 3 full-length overtime keeps the ends; a score
   that is not tied sets gsp 4. */
void PeriodOver(void)
{
    energywarn[0] = energywarn[1] = 0;
    lcblink[0] = lcblink[1] = 0;
    lcline[0] = lcline[1] = -1;
    lcboxon[0] = lcboxon[1] = 0;
    if (exitgame != -1) {
        gmode ^= 2;
        if (++gsp >= 3) {
            if (gsp > 3) {
                gsp = 3;
                if (gameopts.fullot) gsp = 4;
            } else {
                if (gameopts.fullot) gmode ^= 2;
            }
            regd0.w = hmscore[0] - awscore;
            if (regd0.w) gsp = 4;
        }
    }
    IntermissionStart();
}
