/* Engine assign / faceoff: penalties. */
#include "nhl95.h"

/* SetPenaltyStrength (510A9) - for each team: every roster player with box time (tmpdst > 0) takes one skater slot
   away (down to 4); the freed SortCords slots get position -1 and temp5 -100. tmap = skaters left (6..4). */
void SetPenaltyStrength(void)
{
    Team *tm;
    int t;
    int n;
    int i;

    for (t = 0, tm = &hmtmstruct; t < 2; t++) {
        n = 6;
        for (i = 0x1B; i >= 0; i--) {
            if (tm->tmpdst[i] > 0 && n > 4) {
                n--;
                SortCords[t * 6 + n].position = -1;
                SortCords[t * 6 + n].temp5 = -100;
            }
        }
        tm->tmap = n;
        tm = &awtmstruct;
    }
}
