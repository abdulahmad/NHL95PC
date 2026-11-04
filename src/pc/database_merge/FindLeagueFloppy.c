/* Database merge: look on A: and B: for this league's player file. */
#include "nhl95.h"

typedef struct DiskFree {
    unsigned short total_clusters;
    unsigned short avail_clusters;
    unsigned short sectors_per_cluster;
    unsigned short bytes_per_sector;
} DiskFree;

/* FindLeagueFloppy: probe drives A and B for PLAYER.ID. A drive that answers is marked in floppyok.
 The id at the start of the file and the name at offset 1 must both match. While neither drive has
 the league, ask again with the not-for-this-league box. Returns the last open or the box result. */
int FindLeagueFloppy(char *file, char *name, char *dir)
{
    struct {
        char fmt[0x40];
        char path[0x20];
        char idbuf[0x10];
        char namebuf[0x0C];
        DiskFree df;
        int x;
        int y;
        int drive;
        int fh;
        int result;
    } s;
    char *pfile;
    char *pname;
    int notfound;

    pfile = file;
    pname = name;
    s.fh = -1;
    do {
        notfound = -1;
        floppyprobe = notfound;
        for (s.drive = 0; s.drive < 2 && notfound; s.drive++) {
            notfound = 0;
            criterrflag = notfound;
            floppyok[s.drive] = -1;
            _dos_getdiskfree(s.drive + 1, &s.df);
            if (!criterrflag) {
                str_floppydrv = s.drive + 0x41;
                MakePath(s.path, (char *)&str_floppydrv, (char *)str_PLAYER, (char *)str_extID);
                s.result = FileOpenRead(s.path, &s.fh);
                if (!s.result) {
                    FileReadAt(s.fh, s.namebuf, 1, 0x0B);
                    FileReadAt(s.fh, s.idbuf, -1, 0x0D);
                    if (stricmp(pname, s.namebuf) || stricmp(pfile, s.idbuf)) notfound = -1;
                } else {
                    notfound = -1;
                }
                FileClose(&s.fh);
            } else {
                notfound = -1;
            }
        }
        floppyprobe = 0;
        if (notfound) {
            FmtFromLeague(s.fmt, pname, pfile);
            *(int *)(notforlgmsg + 4) = (int)s.fmt;
            sub_B2DCA(&s.drive, &s.y, &s.x);
            s.result = MessageBox(-1, -1, (char *)notforlgmsg, 6, 0, 0, (int)&s.y, (int)&s.x, -1);
            if (s.result) notfound = 0;
        }
    } while (notfound);
    return s.result;
}
