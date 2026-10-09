/* Trades: league id of a database directory. */
#include "nhl95.h"

/* GetLeagueId (41344) - PC only: open PLAYER.ID in directory dir, read the league id byte (offset 0) and the
   4 bytes at 19h into out. Returns the id, or -1 when the file cannot be read. */
int GetLeagueId(char *dir, void *out)
{
    char path[32];
    int fh;
    signed char id;
    int err;

    fh = -1;
    MakePath(path, dir, (char *)str_PLAYER, (char *)str_extID);
    err = FileOpenRead(path, &fh);
    if (err == 0) err = FileReadAt(fh, &id, 0, 1);
    if (err == 0) err = FileReadAt(fh, out, 0x19, 4);
    if (err != 0) id = -1;
    FileClose(&fh);
    return id;
}
