/* Game setup: other games around the league. */
#include "nhl95.h"

/* PickOtherGames (2F2B1) - pick the six "other games" shown during intermissions: two random teams each (of 26), never
   home or vis, no team twice, and a first team whose teamstartlag is not above home's; periods and scores
   start at 0. */
void PickOtherGames(int home, int vis)
{
    unsigned char h;
    unsigned char v;
    unsigned char lag;
    unsigned char g;
    int i;
    int j;
    int bad;

    h = home;
    v = vis;
    lag = teamstartlag[h];
    for (i = 0; i < 6; i++) {
        otherperiod[i] = 0;
        otherscores[i * 2] = 0;
        otherscoresb[i * 2] = 0;
        do {
            bad = 0;
            g = rand() % 0x1A;
            othergames[i * 2] = g;
            if (h == g || g == v || teamstartlag[g] > lag) bad = -1;
            for (j = 0; j < i && !bad; j++)
                if (othergames[i * 2] == othergames[j * 2] || othergames[i * 2] == othergamesb[j * 2]) bad = -1;
        } while (bad);
        do {
            bad = 0;
            g = rand() % 0x1A;
            othergamesb[i * 2] = g;
            if (g == othergames[i * 2] || h == g || g == v) bad = -1;
            for (j = 0; j < i && !bad; j++)
                if (othergamesb[i * 2] == othergames[j * 2] || othergamesb[i * 2] == othergamesb[j * 2]) bad = -1;
        } while (bad);
    }
}
