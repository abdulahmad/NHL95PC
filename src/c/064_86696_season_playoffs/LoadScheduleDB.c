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

/* SaveScheduleDB (89223) - PC only: write the league schedule buf (the bank data from 2 bytes before buf) to
   SCHEDULE.DB in the current league directory, at the size the file library reports for the path
   (sub_92DE0). Its exit is LoadScheduleDB's (shared tail), so both are in this file. */
void SaveScheduleDB(char *buf)
{
    char path[64];

    MakePath(path, (char *)&curleague, (char *)str_ScheduleDb, 0);
    sub_932D0(path, buf - 2, sub_92DE0(path));
}
