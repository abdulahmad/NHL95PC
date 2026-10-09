/* Engine physics / AI: goalie pulls. */
#include "nhl95.h"

/* ChkGoalies (59265) - per team while play is on (not gmode bit 0) with a goalie in net and the puck with that team:
   during a stoppage (gmode bit 3) a requested goalie change takes effect (tmgoalie high byte FFh, the goalie
   menu items checked / unchecked, setpersonel); otherwise a computer team may pull its goalie (CPgoalie). */
void ChkGoalies(void)
{
    Team *t;
    Team *o;
    short i;
    signed char c;

    if (gmode & 1) return;
    i = 0;
    t = &hmtmstruct;
    o = &awtmstruct;
    for (; i < 2; i++) {
        if (t->tmgoalie >= 0) {
            c = *puckc;
            if (c >= 0 && !((c < 6) ^ (i == 0))) {
                if (gmode & 8) {
                    ((unsigned char *)&t->tmgoalie)[1] = 0xFF;
                    *(unsigned char *)((int (*)[3])off_CD498)[i][(short)(t->tmgoalie & 0xF)] = 2;
                    *(unsigned char *)((int (*)[3])off_CD4A0)[i][0] = 1;
                    setpersonel(t);
                } else if (cont1team != i + 1 && cont2team != i + 1) {
                    CPgoalie(t, o, *pucky);
                }
            }
        }
        t = &awtmstruct;
        o = &hmtmstruct;
    }
}
