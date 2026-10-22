/* Game setup: other games around the league. */
#include "nhl95.h"

/* PickOtherGames: pick the six "other games" shown during intermissions: two random teams each (of 26), never
 home or vis, no team twice, and a first team whose teamstartlag is not above home's; periods and scores
 start at 0. h and v are the home and visiting team numbers (byte parameters).
 DRAFT: 293 vs 294 (10.0 GA). Only the second team's store and first compare differ: the original
 computes i * 2 into eax (lea eax, [edi+edi]) for othergamesb / othergames, this draft uses
 [edi*2+...]. */
void PickOtherGames(unsigned char h, unsigned char v)
{
    unsigned char lag;
    unsigned char g;
    int i;
    int j;
    int bad;

    lag = teamstartlag[h];
    for (i = 0; i < 6; i++) {
        otherperiod[i] = 0;
        otherscores[i * 2] = 0;
        otherscoresb[i * 2] = 0;
        do {
            bad = 0;
            othergames[i * 2] = rand() % 0x1A;
            if (h == othergames[i * 2] || othergames[i * 2] == v || teamstartlag[othergames[i * 2]] > lag) bad = -1;
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
