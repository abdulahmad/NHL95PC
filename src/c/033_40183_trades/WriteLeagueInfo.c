/* Trades: league info file. */
#include "nhl95.h"

/* WriteLeagueInfo (413CD) - PC only: create PINFO.DB in directory dir and write the league header: words a at
   0, b at 2, c at 4, the 13-byte name at 6, word d at 13h, the 11-byte password pw at 15h and the 30Ch-byte team
   table teams at 20h, stopping at the first error. Returns the error (0 ok). */
int WriteLeagueInfo(char *dir, void *teams, char *pw, int b, short a, short d, short c, char *name)
{
    char path[32];
    int fh;
    int err;

    fh = -1;
    MakePath(path, dir, (char *)str_PINFO, (char *)str_extDB);
    err = FileCreate(path, &fh);
    if (err == 0) err = FileWriteAt(fh, &a, 0, 2);
    if (err == 0) err = FileWriteAt(fh, &b, 2, 2);
    if (err == 0) err = FileWriteAt(fh, &c, 4, 2);
    if (err == 0) err = FileWriteAt(fh, name, 6, 13);
    if (err == 0) err = FileWriteAt(fh, &d, 0x13, 2);
    if (err == 0) err = FileWriteAt(fh, pw, 0x15, 11);
    if (err == 0) err = FileWriteAt(fh, teams, 0x20, 0x30C);
    FileClose(&fh);
    return err;
}
