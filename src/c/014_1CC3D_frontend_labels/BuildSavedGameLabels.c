/* Front-end labels: saved game menu labels. */
#include "nhl95.h"

/* BuildSavedGameLabels (1D518) - name the saved playoffs / league menu items after their file names (postate+4,
   lgstate+4, up to the dot): titles get the name, menu items name + " Playoffs" / " Season" suffixes. */
void BuildSavedGameLabels(void)
{
    int n;
    int k;

    if (((char *)postate)[4]) {
        n = StrLenToDot((char *)postate + 4);
        ((char *)postate)[n + 4] = 0;
        strcpy((char *)str_POTitle + 1, (char *)postate + 4);
        strcpy((char *)&mi_PlayoffMode + (n + 3), (char *)str_PlayOffsSfx);
        ((char *)postate)[n + 4] = '.';
    }
    if (((char *)lgstate)[4]) {
        n = StrLenToDot((char *)lgstate + 4);
        ((char *)lgstate)[n + 4] = 0;
        strcpy((char *)str_LgSeasonTitle + 1, (char *)lgstate + 4);
        strcpy((char *)str_LgPlayoffsTitle + 1, (char *)lgstate + 4);
        k = n + 3;
        strcpy((char *)&mi_LeagueSeason + k, (char *)str_SeasonSfx);
        strcpy((char *)&mi_LeaguePlayoffs + k, (char *)str_SeasonPlayOffsSfx);
        ((char *)lgstate)[n + 4] = '.';
    }
}
