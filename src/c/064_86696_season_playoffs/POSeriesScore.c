/* Season playoffs: series score. */
#include "nhl95.h"

/* POSeriesScore: count the games won in best-of-7 series s (home team +2, away +3, then 6-byte
 game records with the record's home team at +2 and the scores at +4 +5) until one side has 4. *home and
 *away get the teams, *hw *aw the wins. Returns 0, or -1 at a game not yet played (FFh). */
int POSeriesScore(unsigned char *s, int *hw, int *aw, int *home, int *away)
{
    *home = s[2];
    *away = s[3];
    *hw = *aw = 0;
    for (; *hw < 4 && *aw < 4; s += 6) {
        if (s[4] == 0xFF) return -1;
        if (s[2] == *home) {
            if (s[4] > s[5]) (*hw)++;
            else (*aw)++;
        } else {
            if (s[4] > s[5]) (*aw)++;
            else (*hw)++;
        }
    }
    return 0;
}
