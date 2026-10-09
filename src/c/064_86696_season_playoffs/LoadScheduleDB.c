/* Season / playoffs: load the league schedule. */
#include "nhl95.h"

/* LoadScheduleDB (891B2) - PC only: load SCHEDULE through the league database path (leaguedbfmt) into *db, or
   through the second path (leaguedbfmt2) when that fails (sub_8E8B8, bank 20h). Returns 0. */
int LoadScheduleDB(int *db)
{
    char path[64];

    sprintf(path, (char *)&leaguedbfmt, (char *)str_Schedule);
    if ((*db = (int)sub_8E8B8(path, 0x20)) == NULL) {
        sprintf(path, (char *)&leaguedbfmt2, (char *)str_Schedule);
        *db = (int)sub_8E8B8(path, 0x20);
    }
    return 0;
}
