/* File utils: disk space for a game summary. */
#include "nhl95.h"

typedef struct { char res[0x1A]; unsigned size; char rest[0x2C - 0x1E]; } FindT;
typedef struct { unsigned short total, avail, sectors, bytes; } DiskFree;

/* CheckGameDiskSpace (148A5) - is there room on the current drive for the league's game summary (GSUMMARY.DB, 8 KB
   in clusters, less what the existing file already holds when clusters are under 8 KB)? Fatal error when the free
   space can't be read. Returns 0 when it fits, else says how many KB are needed (message box at 140h / F0h) and
   returns 1. */
int CheckGameDiskSpace(void)
{
    FindT ft;
    char path[32];
    DiskFree df;
    int x;
    int y;
    int csize;
    int need;

    x = 0x140;
    y = 0xF0;
    if (_dos_getdiskfree(0, &df)) FatalError((char *)str_ErrDiskFree5);
    csize = df.sectors * df.bytes;
    need = (csize + 0x1FFF) / csize;
    MakePath(path, (char *)&curleague, (char *)str_GsummaryDb, 0);
    if (!unknown_libname_1(path, 0, &ft)) {
        if (csize >= 0x2000) return 0;
        need -= (ft.size + csize - 1) / csize;
    }
    if (need <= df.avail) return 0;
    sprintf((char *)msg_NeedKbytes, (char *)str_NeedKbytesFmt, need * csize / 1024);
    MouseSetPos(x, y);
    MessageBox(-1, -1, (char *)off_C56B5, 3, 0, 0, (int)&x, (int)&y, 0x320);
    return 1;
}
