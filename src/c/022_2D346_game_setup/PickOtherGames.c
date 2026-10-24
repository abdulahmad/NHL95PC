/* Game setup: other games around the league. */
#include "nhl95.h"

/* PickOtherGames: pick the six "other games" shown during intermissions: two random teams each (of 26), never
 home or vis, no team twice, and a first team whose teamstartlag is not above home's; periods and scores
 start at 0. h and v are the home and visiting team numbers (byte parameters). Both teams are read back
 from their elements as the first is (the original's lea eax, [edi+edi] for the pair); i is declared after j
 and bad (the tied j-loop index temporaries then take eax / ebx as in the EXE). */
void PickOtherGames(unsigned char h, unsigned char v)
{
    unsigned char lag;
    int j;
    int bad;
    int i;

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
            othergamesb[i * 2] = rand() % 0x1A;
            if (othergamesb[i * 2] == othergames[i * 2] || h == othergamesb[i * 2] || othergamesb[i * 2] == v) bad = -1;
            for (j = 0; j < i && !bad; j++)
                if (othergamesb[i * 2] == othergames[j * 2] || othergamesb[i * 2] == othergamesb[j * 2]) bad = -1;
        } while (bad);
    }
}
