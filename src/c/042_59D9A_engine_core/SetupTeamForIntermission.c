/* Engine core: get both teams ready for the next period (93G/94G penalty94 SetupTeamForIntermission). */
#include "nhl95.h"

/* SetupTeamForIntermission (5DDDA) - get both teams ready for the next period (93G/94G penalty94
   SetupTeamForIntermission): ResetBench, then for each team refill the energy (reenergizeteam) and pick the
   starting line: tmline 0, or with line changes on (gameopts bit 2) and unequal strength (tmap, players
   allowed on the ice) the first power-play line for the stronger team and the first penalty-kill line for the
   weaker. The PC line numbers are 4 (power play) and 6 (penalty kill); 94G uses 3 (Pw1) and 5 (PK1). */
void SetupTeamForIntermission(void)
{
    Team *t;
    Team *op;
    short i;
    short d;

    ResetBench();
    for (i = 0, t = &hmtmstruct, op = &awtmstruct; i < 2; t = &awtmstruct, op = &hmtmstruct, i++) {
        reenergizeteam(t);
        t->tmline = 0;
        if (gameopts.linechanges) {
            d = t->tmap - op->tmap;
            if (d != 0) {
                if (d > 0) t->tmline = 4;       /* power play */
                else t->tmline = 6;             /* penalty kill */
            }
        }
    }
}
