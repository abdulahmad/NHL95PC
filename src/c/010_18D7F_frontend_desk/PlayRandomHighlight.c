/* Front end: sports desk. */
#include "nhl95.h"

/* PlayRandomHighlight (18F8D) - mark the other games that finished (period >= 5) since the last look as played; if all
   six are, return 0. Otherwise pick a random unplayed game, play a highlight of it (StartHL2 with its two teams,
   scores and period; a finished game is shown in the third period with one goal less each) and keep the scores
   it ends with for a game still in progress (period 4 becomes final, 5). Remember the periods in dword_DC868 and
   return StartHL2's result. */
int PlayRandomHighlight(void)
{
    int b;
    int a;
    int g;
    int i;
    int per;

    for (i = 0; i < 6; i++)
        if (otherperiod[i] >= 5 && otherperiod[i] != dword_DC868[i]) hlplayedmask |= 1 << i;
    if (hlplayedmask == 0x3F) return 0;
    do {
        g = randomd0(6);
    } while ((1 << g) & hlplayedmask);
    hlplayedmask |= 1 << g;
    a = otherscores[g * 2];
    b = otherscoresb[g * 2];
    per = otherperiod[g];
    if (per >= 5) {
        per = 3;
        a--;
        b--;
    }
    per = StartHL2(othergames[g * 2], othergamesb[g * 2], &a, &b, per);
    if (otherperiod[g] <= 4) {
        otherscores[g * 2] = a;
        otherscoresb[g * 2] = b;
        if (otherperiod[g] == 4) otherperiod[g] = 5;
    }
    for (i = 0; i < 6; i++) dword_DC868[i] = otherperiod[i];
    return per;
}
