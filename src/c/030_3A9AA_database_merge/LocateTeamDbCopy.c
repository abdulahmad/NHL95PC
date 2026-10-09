/* Database merge: find a team's database copy. */
#include "nhl95.h"

/* LocateTeamDbCopy (3AF70) - PC only: where team i's database copy is (30-byte league team entries tab): a team on
   the hard disk (byte +18h or +16h = 1) uses hddir and its stored league id (+1Ah); otherwise the floppy flopdir:
   wait for its disk (WaitLeagueFloppy) and read the league id there (GetLeagueId). An older copy than the stored
   one (and the disk not skipped, 4) shows oldcopymsg (file name at +8) and gives -1. *dir / *id get the place and
   id. Returns the WaitLeagueFloppy result (0 for the hard disk) or -1. */
int LocateTeamDbCopy(unsigned char *tab, int i, char *file, char *hddir, char *flopdir, char **dir, unsigned *id)
{
    int mx;
    unsigned char *e;
    int r;
    int btn;
    int my;

    r = 0;
    e = tab + i * 30;
    if (e[0x18] == 1 || e[0x16] == 1) {
        *dir = hddir;
        *id = *(unsigned *)(tab + i * 30 + 0x1A);
    } else {
        *dir = flopdir;
        r = WaitLeagueFloppy(file, (char *)e, 0);
        GetLeagueId(flopdir, id);
        if (r != 4 && *id < *(unsigned *)(e + 0x1A)) {
            *(char **)(oldcopymsg + 8) = file;
            sub_B2DCA(&btn, &mx, &my);
            MessageBox(-1, -1, (char *)oldcopymsg, 3, 0, 0, (int)&mx, (int)&my, -1);
            r = -1;
        }
    }
    return r;
}
