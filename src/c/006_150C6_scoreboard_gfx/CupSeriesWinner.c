/* Scoreboard graphics: playoff series. */
/* DRAFT (CupSeriesWinner): 138 vs 138, 2 differing. `need = games >> 1; need++;` and the for loop (bottom
   test) give the EXE except that Watcom sinks the `inc ebp` below the home / away loads and the two zero
   stores (EXE right after the shr). Tried: `games / 2 + 1`, `(games >> 1) + 1`, `1 + games / 2`, `need += 1`,
   `++need`, `need = need + 1`, `need = games; need >>= 1; need++`, `games >>= 1; need = games + 1`, an int
   need, w2 declared first, the zero stores in the for. */
#include "nhl95.h"

/* CupSeriesWinner: winner of the best-of-games series s (home +2, away +3, then 6-byte game records with the
 home team +2 and scores +4 +5): the first to games 2 + 1 wins; -1 when a needed game is unplayed (FFh). */
int CupSeriesWinner(unsigned char *s, unsigned games)
{
    unsigned need;
    int home;
    int away;
    unsigned w1;
    unsigned w2;

    need = games >> 1;
    need++;
    home = s[2];
    away = s[3];
    w2 = 0;
    w1 = 0;
    for (; w1 < need && w2 < need; s += 6) {
        if (s[4] == 0xFF) return -1;
        if (s[2] == home) {
            if (s[4] > s[5]) w1++;
            else w2++;
        } else {
            if (s[4] > s[5]) w2++;
            else w1++;
        }
    }
    if ((int)w1 > (int)w2) return home;
    return away;
}
