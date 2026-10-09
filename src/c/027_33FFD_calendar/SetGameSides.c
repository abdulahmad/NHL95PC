/* Calendar: game setup. */
#include "nhl95.h"

/* SetGameSides (347B7) - set the controlled teams for game g of the schedule (6-byte records, home +2, away +3): team
   and its opponent, the opponent only when it is a human team (lgteam_17 == 1), else -1. */
void SetGameSides(int team, unsigned char *games, int g)
{
    unsigned char *rec;
    int o;

    rec = games + g * 6;
    if (team == rec[2]) {
        o = rec[3];
    } else {
        team = rec[3];
        o = rec[2];
    }
    if (lgteam_17[o * 30] != 1) o = -1;
    SetCtlTeams(team, o, games[g * 6 + 2], games[g * 6 + 3]);
}
