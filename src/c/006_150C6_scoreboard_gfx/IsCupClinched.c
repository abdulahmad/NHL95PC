/* Scoreboard graphics: playoff series. */
#include "nhl95.h"

/* IsCupClinched (15C30) - PC only: 1 when the cup series (cupseries) would be decided by a game with scores
   home / away: the scores go into the first unplayed game record (byte +4 = FFh), CupSeriesWinner checks
   the series (games from gameopts bits 12-14 in mode 1, else SeriesLength), and the record is set back to
   unplayed (FFh). 0 when there is no series or no winner yet. */
int IsCupClinched(unsigned char home, unsigned char away)
{
    int i;
    unsigned char *g;
    unsigned games;
    int winner;

    if (cupseries == 0) return 0;
    for (i = 0; (g = cupseries + i * 6)[4] != 0xFF; i++) ;
    g[4] = home;
    (cupseries + i * 6)[5] = away;
    if (gamemode == 1) games = gameopts.optbits12;
    else games = SeriesLength(cupseries);
    winner = CupSeriesWinner(cupseries, games);
    (cupseries + i * 6)[4] = (cupseries + i * 6)[5] = 0xFF;
    if (winner < 0) return 0;
    return 1;
}
