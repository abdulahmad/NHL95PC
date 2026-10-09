/* Database merge: copy a league's files. */
#include "nhl95.h"

/* CopyLeagueFiles (3C310) - PC only: copy the league files from directory src to dst (CopyFile): the 7 league
   databases (leaguedbnames) as .DB and .XX, then PINFO.DB and PLAYER.ID, stopping at the first error. Returns
   the error (0 ok). */
int CopyLeagueFiles(char *src, char *dst)
{
    int err;
    int i;

    err = 0;
    for (i = 0; i < 7 && err == 0; i++) {
        err = CopyFile((char *)leaguedbnames[i], (char *)str_extDB, (char *)str_extDB, src, dst);
        if (err == 0) err = CopyFile((char *)leaguedbnames[i], (char *)str_extxx, (char *)str_extxx, src, dst);
    }
    if (err == 0) err = CopyFile((char *)str_PINFO, (char *)str_extDB, (char *)str_extDB, src, dst);
    if (err == 0) err = CopyFile((char *)str_PLAYER, (char *)str_extID, (char *)str_extID, src, dst);
    return err;
}
