/* Scoreboard graphics: playoff series. */
#include "nhl95.h"

/* CupSeriesWinner: winner of the best-of-games series s (home +2, away +3, then 6-byte game records with the
 home team +2 and scores +4 +5): the first to games / 2 + 1 wins; -1 when a needed game is unplayed (FFh).
 The win target reuses the games parameter (`inc ebp` right after the shift), and the declaration order
 away, w1, home, w2 gives the hoisted w1 + 1 / w2 + 1 their registers (edi / esi). */
int CupSeriesWinner(unsigned char *s, unsigned games)
{
    int away;
    unsigned w1;
    int home;
    unsigned w2;

    games = games / 2 + 1;
    home = s[2];
    away = s[3];
    w2 = 0;
    w1 = 0;
    for (; w1 < games && w2 < games; s += 6) {
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
