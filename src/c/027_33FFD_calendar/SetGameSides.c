/* Calendar: game setup. */
#include "nhl95.h"

/* SetGameSides: set the controlled teams for game g of the schedule (6-byte records, home +2, away +3): team
 and its opponent, the opponent only when it is a human team (lgteam_17 == 1), else -1. o first holds the
 record address (g * 3 * 2 + games, built in steps) and then the opponent. */
void SetGameSides(int team, unsigned char *games, int g)
{
    int o;

    o = g * 4 - g;
    o += o;
    o += (int)games;
    if (team == ((unsigned char *)o)[2]) {
        o = ((unsigned char *)o)[3];
    } else {
        team = ((unsigned char *)o)[3];
        o = ((unsigned char *)o)[2];
    }
    if (lgteam_17[o * 30] != 1) o = -1;
    SetCtlTeams(team, o, games[g * 6 + 2], games[g * 6 + 3]);
}
