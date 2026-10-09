/* Scoreboard graphics: playoff series. */
#include "nhl95.h"

/* CupSeriesWinner (15CE1) - winner of the best-of-games series s (home +2, away +3, then 6-byte game records with the
   home team +2 and scores +4 / +5): the first to games / 2 + 1 wins; -1 when a needed game is unplayed (FFh). */
int CupSeriesWinner(unsigned char *s, unsigned games)
{
    unsigned need;
    int home;
    int away;
    unsigned w1;
    unsigned w2;

    need = games / 2 + 1;
    home = s[2];
    away = s[3];
    w2 = 0;
    w1 = 0;
    while (w1 < need && w2 < need) {
        if (s[4] == 0xFF) return -1;
        if (s[2] == home) {
            if (s[4] > s[5]) w1++;
            else w2++;
        } else {
            if (s[4] > s[5]) w2++;
            else w1++;
        }
        s += 6;
    }
    if ((int)w1 > (int)w2) return home;
    return away;
}
