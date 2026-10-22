/* Database merge: choose which floppy has this league file. */
#define SelectFloppyDrive SelectFloppyDrive_decl
#include "nhl95.h"
#undef SelectFloppyDrive

typedef struct DiskFree {
    unsigned short total_clusters;
    unsigned short avail_clusters;
    unsigned short sectors_per_cluster;
    unsigned short bytes_per_sector;
} DiskFree;

/* SelectFloppyDrive: probe A: and B: for PLAYER.ID. file is the id and name is the league name.
 A drive that answers is marked in floppyok. The name at offset 1 and the id must both match.
 While neither drive answers, ask to insert the disk. If both answer and neither file matches,
 ask which drive. Returns the last box result (0 when a drive was chosen without a cancel). */
int SelectFloppyDrive(char *file, char *name)
{
    struct {
        char path[0x20];
        char idbuf[0x10];
        char namebuf[0x0C];
        DiskFree df;
        int fh;
        int x;
        int y;
        int drive;
        int result;
    } s;
    char *pfile;
    char *pname;
    int found;

    pfile = file;
    pname = name;
    s.fh = -1;
    floppyprobe = -1;
    do {
        s.result = 0;
        found = 0;
        for (s.drive = 0; s.drive < 2 && !found; s.drive++) {
            criterrflag = 0;
            floppyok[s.drive] = -1;
            _dos_getdiskfree(s.drive + 1, &s.df);
            if (criterrflag)
                floppyok[s.drive] = 0;
            else if (pfile && pname) {
                str_floppydrv = s.drive + 0x41;
                MakePath(s.path, (char *)&str_floppydrv, (char *)str_PLAYER, (char *)str_extID);
                if (!FileOpenRead(s.path, &s.fh)) {
                    FileReadAt(s.fh, s.namebuf, 1, 0x0B);
                    FileReadAt(s.fh, s.idbuf, -1, 0x0D);
                    if (!stricmp(pname, s.namebuf) && !stricmp(pfile, s.idbuf))
                        found = -1;
                }
                FileClose(&s.fh);
            }
        }
        if (floppyok[0] == 0 && floppyok[1] == 0) {
            sub_B2DCA(&s.drive, &s.y, &s.x);
            s.result = MessageBox(-1, -1, (char *)insertfloppymsg, 1, 0, 0, (int)&s.y, (int)&s.x, -1);
        }
    } while (floppyok[0] == 0 && floppyok[1] == 0 && s.result != 4);
    floppyprobe = 0;
    if (!found && s.result != 4) {
        if (floppyok[0] != 0 && floppyok[1] != 0) {
            sub_B2DCA(&s.drive, &s.y, &s.x);
            str_floppydrv = MessageBox(-1, -1, (char *)whichdrivemsg, 1, (int)drivebtns, 2, (int)&s.y, (int)&s.x, -1) + 0x41;
        } else if (floppyok[0] != 0)
            str_floppydrv = 0x41;
        else
            str_floppydrv = 0x42;
    }
    return s.result;
}
