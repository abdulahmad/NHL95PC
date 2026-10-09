/* Engine core: energy recovery on the bench. */
#include "nhl95.h"

/* RestBench (5C1E2) - when line changes / fatigue are on, every roster player of both teams who is on the
   bench (tmpdst -2) gets 8 energy back (tmpde), at most 1000h (full). Called from the game loop. */
void RestBench(void)
{
    Team *t;
    short i, k;

    if (gameopts.linechanges) {
        for (i = 0, t = &hmtmstruct; i < 2; t = &awtmstruct, i++) {
            k = 27;
            do {
                if (t->tmpdst[k] == PDbench) {
                    t->tmpde[k] += 8;
                    if (t->tmpde[k] > ENERGYMAX) t->tmpde[k] = ENERGYMAX;
                }
            } while (--k >= 0);
        }
    }
}
