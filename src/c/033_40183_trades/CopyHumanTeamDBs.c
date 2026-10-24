/* Trades: copying the human teams' databases. */
#define CopyHumanTeamDBs CopyHumanTeamDBs_decl
#define ExportTeamToFloppy ExportTeamToFloppy_decl
#include "nhl95.h"
#undef CopyHumanTeamDBs
#undef ExportTeamToFloppy

void ExportTeamToFloppy(char *dir, char *ext, char *ext2, int t, unsigned char *teams, int full, int a);

/* DRAFT (10.0 GA): 7 differing, 2 bytes short. A plain current-team local keeps the number across
   sprintf / strcpy, and the exported team's entry goes through its own block-local pointer (in edx, so the
   copy loop index gets edi). Left: s.which loaded into ecx (EXE eax), retry = 0 through edi (EXE eax), and
   zero = 0 stored from the known-zero err (EXE `xor edx, edx`). */
/* CopyHumanTeamDBs (41516, PC only): give each human team of the league in dir (teams +17h == 1; only team which
   when which is not negative) its own copy of the league databases, named by the team number (".%02d" into
   str_extxx). A team played on another computer (+18h == 2) that has not exported yet (+16h bit 0 clear) gets
   its databases on a floppy: ask for the team's disk (msg_InsertDisk, SelectFloppyDrive), check its PLAYER.ID
   names the team and the league (else msg_WrongDisk, which may ask again), and write it (ExportTeamToFloppy).
   Any other human team gets the seven databases copied over to its extension (MsgCopyingDatabases, DeleteFiles,
   CopyFile) and is marked exported in PINFO (WriteLeagueTeamEntry). Finally PINFO +13h is cleared. Stops at the
   first error. dir: the league directory; teams: the league's team table (1Eh bytes each); which: one team, or
   -1 for all. Result: 0, an I/O error, or -1 when the disk was refused. */
int CopyHumanTeamDBs(char *dir, unsigned char *teams, int which)
{
    struct {
        char msg[0x40];
        char path[0x20];
        char dir[0x10];
        char lg[0x10];
        char name[0xC];
        char ext[8];
        int rfh;
        int wfh;
        int x;
        int y;
        int btn;
        int which;
        unsigned char *teams;
        int retry;
        int t;
        int zero;
    } s;
    int t;
    int err;
    int r;
    int i;
    unsigned char *tp;

    s.teams = teams;
    s.which = which;
    s.wfh = s.rfh = -1;
    err = 0;
    for (s.t = 0; s.t < 0x1A && !err; s.t++) {
        if (s.teams[s.t * 30 + 0x17] != 1) continue;
        if (s.which >= 0 && s.which != s.t) continue;
        t = s.t;
        sprintf(s.msg, (char *)str_extnum, t);
        strcpy((char *)str_extxx, s.msg);
        if (s.teams[t * 30 + 0x18] == 2 && !(s.teams[t * 30 + 0x16] & 1)) {
            do {
                s.retry = 0;
                tp = s.teams + s.t * 30;
                strcpy(s.name, (char *)tp);
                msg_InsertDisk_arg = (int)s.name;
                sub_B2DCA(&s.btn, &s.y, &s.x);
                r = MessageBox(-1, -1, (char *)msg_InsertDisk, 4, 0, 0, (int)&s.y, (int)&s.x, -1);
                if (!r) r = SelectFloppyDrive((int)dir, (int)tp);
                if (!r) {
                    MakePath(s.path, (char *)&str_floppydrv, (char *)str_PLAYER, (char *)str_extID);
                    if (!FileOpenRead(s.path, &s.rfh)) {
                        FileReadAt(s.rfh, s.name, 1, 0xB);
                        FileReadAt(s.rfh, s.lg, -1, 0xD);
                        if (stricmp((char *)s.teams + s.t * 30, s.name) || stricmp(dir, s.lg)) {
                            FmtFromLeague(s.msg, s.name, s.lg);
                            msg_WrongDisk_arg = (int)s.msg;
                            sub_B2DCA(&s.btn, &s.y, &s.x);
                            s.btn = MessageBox(-1, -1, (char *)msg_WrongDisk, 3, (int)btn_WrongDisk, 2, (int)&s.y,
                                (int)&s.x, -1);
                            if (s.btn == 1 || s.btn < 0) s.retry = 1;
                        }
                    }
                    FileClose(&s.rfh);
                }
            } while (s.retry && !r);
            ClearInputQueue();
            if (!r) err = ((int (*)(char *, char *, char *, int, unsigned char *, int, int))ExportTeamToFloppy)(dir,
                (char *)str_extDB, (char *)str_extxx, s.t, s.teams, -1, r);
            else err = -1;
            continue;
        }
        MsgCopyingDatabases((int)(s.teams + s.t * 30));
        for (i = 0; i < 7 && !err; i++) {
            strcpy(s.dir, dir);
            strcpy(s.path, (char *)leaguedbnames[i]);
            strcpy(s.ext, (char *)str_extxx);
            DeleteFiles(s.dir, s.path, s.ext + 1);
            err = CopyFile((char *)leaguedbnames[i], (char *)str_extDB, (char *)str_extxx, dir, dir);
        }
        if (!err) {
            MakePath(s.path, dir, (char *)str_PINFO, (char *)str_extDB);
            err = FileOpenRW(s.path, &s.wfh);
        }
        if (!err) {
            unsigned char *p;

            p = s.teams + s.t * 30;
            p[0x16] = 1;
            err = WriteLeagueTeamEntry(s.wfh, p, s.t);
        }
        FileClose(&s.wfh);
        RestoreDialogBg();
    }
    if (!err) {
        MakePath(s.path, dir, (char *)str_PINFO, (char *)str_extDB);
        err = FileOpenRW(s.path, &s.wfh);
    }
    if (!err) {
        s.zero = 0;
        err = FileWriteAt(s.wfh, &s.zero, 0x13, 2);
    }
    FileClose(&s.wfh);
    return err;
}
