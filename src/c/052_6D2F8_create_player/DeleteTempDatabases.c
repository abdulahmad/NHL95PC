/* Create player: temporary databases. */
#include "nhl95.h"

/* DeleteTempDatabases (7125C) - delete the six league database work copies (leaguedbnames with the .TMP extension). */
void DeleteTempDatabases(void)
{
    MakePath((char *)unk_EA968, 0, (char *)leaguedbnames[5], (char *)str_TMP);
    j_unlink((char *)unk_EA968);
    MakePath((char *)unk_EA968, 0, (char *)leaguedbnames[1], (char *)str_TMP);
    j_unlink((char *)unk_EA968);
    MakePath((char *)unk_EA968, 0, (char *)leaguedbnames[3], (char *)str_TMP);
    j_unlink((char *)unk_EA968);
    MakePath((char *)unk_EA968, 0, (char *)leaguedbnames[0], (char *)str_TMP);
    j_unlink((char *)unk_EA968);
    MakePath((char *)unk_EA968, 0, (char *)leaguedbnames[4], (char *)str_TMP);
    j_unlink((char *)unk_EA968);
    MakePath((char *)unk_EA968, 0, (char *)leaguedbnames[2], (char *)str_TMP);
    j_unlink((char *)unk_EA968);
}
