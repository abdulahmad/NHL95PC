/* Season playoffs: fill one conference's seed slots. */
#include "nhl95.h"

/* POPickConfTeams: slots holds the 16 seed dwords. confflag is 3 for the west and 0Ch for the
 east; the empty slots are -confflag. first and count select confteams[first .. first+count).
 HomeTeam and VisTeam are skipped when their division flags overlap confflag. Eight distinct
 indexes are drawn from the rest. If the first two are the same division, the second is swapped
 with a later pick from another division. Those teams replace the -confflag placeholders. */
void POPickConfTeams(int *slots, int confflag, int first, int count)
{
    int pick[8];
    int used;
    int i;

    used = 0;
    if (teamdivflags[HomeTeam] & confflag) {
        for (i = 0; i < count; i++)
            if (HomeTeam == confteams[i + first]) break;
        used |= 1 << i;
    }
    if (teamdivflags[VisTeam] & confflag) {
        for (i = 0; i < count; i++)
            if (VisTeam == confteams[i + first]) break;
        used |= 1 << i;
    }
    for (i = 0; i < 8; i++) {
        pick[i] = randomd0(count);
        while (used & (1 << pick[i]))
            pick[i] = randomd0(count);
        used |= 1 << pick[i];
    }
    if (teamdivflags[confteams[pick[0]]] == teamdivflags[confteams[pick[1]]]) {
        for (i = 2; teamdivflags[confteams[pick[0]]] == teamdivflags[confteams[pick[i]]]; i++)
            ;
        used = pick[1];             /* used is free now: the swap temporary */
        pick[1] = pick[i];
        pick[i] = used;
    }
    i = 0;
    used = 0;                       /* and the next pick to place */
    for (; i < 16; i++) {
        if (slots[i] == -confflag) {
            slots[i] = confteams[pick[used] + first];
            used++;
        }
    }
}
