/* Engine player logic: three stars candidates. */
#include "nhl95.h"

/* AddStar (48789) - add (team, pl) to the star list (startm / starpl pairs) at entry n unless one of the first n entries
   already holds it: returns 1 when added, 0 when already there. */
int AddStar(short n, short team, short pl)
{
    int i;

    for (i = 0; i < n; i++) {
        if (team == startm[i * 2] && pl == starpl[i * 2]) return 0;
    }
    startm[n * 2] = team;
    starpl[n * 2] = pl;
    return 1;
}
