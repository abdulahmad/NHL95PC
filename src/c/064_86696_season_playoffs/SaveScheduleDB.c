/* Season / playoffs: save the league schedule. */
#include "nhl95.h"

/* SaveScheduleDB (89223) - PC only: write the league schedule buf (the bank data from 2 bytes before buf) to
   SCHEDULE.DB in the current league directory, at the size the file library reports for the path
   (sub_92DE0). Its exit is LoadScheduleDB's (shared tail), so it needs LoadScheduleDB.c. Draft: the bytes match,
   but the exit is a short jmp into LoadScheduleDB_x, which the splice tooling refuses (rel8 out of the block). */
void SaveScheduleDB(char *buf)
{
    char path[64];

    MakePath(path, (char *)&curleague, (char *)str_ScheduleDb, 0);
    sub_932D0(path, buf - 2, sub_92DE0(path));
}
