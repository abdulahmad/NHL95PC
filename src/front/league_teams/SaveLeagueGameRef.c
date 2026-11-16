/* Trades: write the league game reference and the two PINFO files. */
#define SaveLeagueGameRef SaveLeagueGameRef_decl
#include "nhl95.h"
#undef SaveLeagueGameRef

typedef struct { char c[6]; } T6;

/* SaveLeagueGameRef: append the league-game fields to fh, then if that succeeded write "saved"
 and a -1 marker into savleague1's PINFO file and close it. When lgopphuman is set, do the same for savleague2.
 Returns whatever FileClose returned. */
int SaveLeagueGameRef(int fh)
{
    int err;
    char path[0x20];
    char saved[13];
    int mark;
    int handle;

    handle = -1;
    err = FileWriteAt(fh, &lgplayteam, -1, 4);
    if (!err) err = FileWriteAt(fh, &lgoppteam, -1, 4);
    if (!err) err = FileWriteAt(fh, &lgopphuman, -1, 4);
    if (!err) err = FileWriteAt(fh, &lggamecount, -1, 4);
    if (!err) err = FileWriteAt(fh, &lgoppgamecount, -1, 4);
    if (!err) err = FileWriteAt(fh, &lggameidx, -1, 4);
    if (!err) err = FileWriteAt(fh, savleague1, -1, 0xD);
    if (!err) err = FileWriteAt(fh, savleague2, -1, 0xD);
    if (!err) err = FileWriteAt(fh, &lgschedrec, -1, 6);
    mark = -1;
    *(T6 *)saved = *(T6 *)str_saved;
    if (!err) {
        MakePath(path, (char *)savleague1, (char *)str_PINFO, (char *)str_extDB);
        err = FileOpenWrite(path, &handle);
    }
    if (!err) err = FileWriteAt(handle, &mark, 4, 2);
    if (!err) err = FileWriteAt(handle, saved, 6, 0xD);
    fh = FileClose(&handle);
    if (!lgopphuman) return fh;
    if (!err) {
        MakePath(path, (char *)savleague2, (char *)str_PINFO, (char *)str_extDB);
        err = FileOpenWrite(path, &handle);
    }
    if (!err) err = FileWriteAt(handle, &mark, 4, 2);
    if (!err) FileWriteAt(handle, saved, 6, 0xD);
    return FileClose(&handle);
}
