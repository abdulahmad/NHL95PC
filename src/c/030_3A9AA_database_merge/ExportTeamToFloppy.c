/* Database merge: exporting a human team's league to the floppy. */
/* DRAFT: 1925 vs 1929 bytes, every instruction but three register picks; see docs/UNSURE.md. The export
   and the force-export message are the two arms of one if / else (the same code as the old labelled jumps:
   Watcom puts the else arm last and shares the MessageBox tail). */
#define ExportTeamToFloppy ExportTeamToFloppy_decl
#define ReadLeagueTeamEntry ReadLeagueTeamEntry_decl
#define MsgCopyingDatabases MsgCopyingDatabases_decl
#define WaitLeagueFloppy WaitLeagueFloppy_decl
#include "nhl95.h"
#undef ExportTeamToFloppy
#undef ReadLeagueTeamEntry
#undef MsgCopyingDatabases
#undef WaitLeagueFloppy

int ReadLeagueTeamEntry(int fh, void *entry, int n);
void MsgCopyingDatabases(unsigned char *name);
int WaitLeagueFloppy(char *dir, unsigned char *entry, int n);

/* ExportTeamToFloppy (3BB87, PC only): export human team `team` of league `dir` to the floppy in A:. With check
   set, first make sure the floppy is the right one: read the team's entry from its PINFO.DB and the team id and
   league name from its PLAYER.ID; a floppy of another team or league asks to swap disks (msg_WrongDisk: retry or
   cancel), and a team that was exported before (flags bit 1) with no league on the floppy offers a new floppy
   (WaitLeagueFloppy, newfloppymsg); repeat until it fits or fails. Unless full is set, a team that is not
   exported (status 1) on both sides only says so (forceexportmsg with the league and team names). Otherwise
   show the copying message, delete the seven databases, PINFO.* and PLAYER.ID on the floppy, copy the databases
   (as ext / ext2 and as .DB), PINFO.DB and the game settings there, count the export (+1Ah), mark the team as
   exported (status 2, flags bit 1), write PLAYER.ID (team, id, league name, count) and the floppy's PINFO.DB (a
   zero header word, the team entry), then the team entry of the league's own PINFO.DB. If anything failed the
   team goes back to status 1 (flags bit 0) and exporterrmsg says so. dir: the league directory; ext, ext2: the
   source and destination extensions of the database copies; team: the team; teams: the 30-byte team entries;
   full: export without the status test; check: check the floppy first. Result: 0, or the error. */
int ExportTeamToFloppy(char *dir, char *ext, char *ext2, int team, unsigned char *teams, int full, int check)
{
    struct {
        char msg[0x40];
        char path[0x20];
        char name[0x20];
        unsigned char entry[0x20];
        char lname[0x10];
        char lgname[0x10];
        char id[0x0C];
        int fhid;
        int fh2;
        int fh3;
        int btn;
        int mx;
        int my;
        int i;
        int fhp;
        int done;
        int openfail;
        char *ext2;
        char *ext;
        int team;
        int diff;
        int zero;
        unsigned char tb;
    } s;
    unsigned char *t;
    int err;

    s.ext = ext;
    s.ext2 = ext2;
    s.team = team;
    s.fhid = s.fhp = s.fh2 = s.fh3 = -1;
    t = teams + team * 30;
    err = 0;
    if (check) {
        s.done = 0;
        do {
            err = 0;
            s.openfail = 0;
            s.diff = 0;
            MakePath(s.path, (char *)&str_floppydrv, (char *)str_PINFO, (char *)str_extDB);
            if (FileOpenRW(s.path, &s.fhp) == 0) {
                err = ReadLeagueTeamEntry(s.fhp, s.entry, s.team);
                if (!err) {
                    MakePath(s.path, (char *)&str_floppydrv, (char *)str_PLAYER, (char *)str_extID);
                    err = FileOpenRead(s.path, &s.fhid);
                }
                if (!err) err = FileReadAt(s.fhid, s.id, 1, 0xB);
                if (!err) err = FileReadAt(s.fhid, s.lgname, 0xC, 0xD);
                FileClose(&s.fhid);
                if (!err) {
                    s.diff = strcmp(s.id, (char *)t) + strcmp(s.lgname, dir);
                    if (!s.diff) s.done = 1;
                }
            } else {
                s.openfail = -1;
            }
            if (s.diff) {
                FmtFromLeague(s.msg, s.id, s.lgname);
                msg_WrongDisk_arg = (int)s.msg;
                sub_B2DCA(&s.btn, &s.my, &s.mx);
                s.btn = MessageBox(-1, -1, (char *)msg_WrongDisk, 3, (int)btn_WrongDisk, 2, (int)&s.my, (int)&s.mx, -1);
                if (!s.btn) s.done = -1;
                else err = -1;
            }
            if (!err) {
                if ((t[0x18] & 2) && s.openfail) {
                    err = WaitLeagueFloppy(dir, t, 1);
                    if (err > 0) {
                        err = 0;
                        sub_B2DCA(&s.i, &s.my, &s.mx);
                        s.btn = MessageBox(-1, -1, (char *)newfloppymsg, 2, (int)newfloppybtns, 2, (int)&s.my, (int)&s.mx, -1);
                        if (!s.btn) {
                            s.entry[0x16] = 1;
                            s.done = 1;
                        }
                        if (s.btn < 0) err = -1;
                    }
                } else {
                    s.entry[0x16] = 1;
                    err = 0;
                    s.done = 1;
                }
            }
            FileClose(&s.fhp);
        } while (!s.done && !err);
    }
    if (!err) {
        if (full || (t[0x16] == 1 && t[0x16] == s.entry[0x16])) {
            MsgCopyingDatabases(teams + s.team * 30);
            for (s.i = 0; s.i < 7 && !err; s.i++) {
                strcpy(s.path, (char *)&str_floppydrv);
                strcpy(s.name, (char *)leaguedbnames[s.i]);
                DeleteFiles(s.path, s.name, (char *)str_wildcard);
            }
            strcpy(s.path, (char *)&str_floppydrv);
            strcpy(s.name, (char *)str_PINFO);
            DeleteFiles(s.path, s.name, (char *)str_wildcard);
            strcpy(s.path, (char *)&str_floppydrv);
            strcpy(s.name, (char *)str_PLAYER);
            DeleteFiles(s.path, s.name, (char *)str_ID);
            for (s.i = 0; s.i < 7 && !err; s.i++) {
                err = CopyFile((char *)leaguedbnames[s.i], s.ext, s.ext2, dir, (char *)&str_floppydrv);
                if (!err)
                    err = CopyFile((char *)leaguedbnames[s.i], (char *)str_extDB, (char *)str_extDB, dir,
                                   (char *)&str_floppydrv);
            }
            if (!err)
                err = CopyFile((char *)str_PINFO, (char *)str_extDB, (char *)str_extDB, dir, (char *)&str_floppydrv);
            if (!err) {
                MakePath(s.path, dir, (char *)str_GAME4, (char *)str_SET2);
                MakePath(s.name, (char *)&str_floppydrv, (char *)str_GAME4, (char *)str_SET2);
                err = CopyGameSettings(s.path, s.name);
            }
            (*(int *)(t + 0x1A))++;
            t[0x16] = 2;
            t[0x18] |= 2;
            if (!err) {
                MakePath(s.path, (char *)&str_floppydrv, (char *)str_PLAYER, (char *)str_extID);
                err = FileCreate(s.path, &s.fh3);
            }
            if (!err) {
                s.tb = s.team;
                err = FileWriteAt(s.fh3, &s.tb, 0, 1);
            }
            if (!err) err = FileWriteAt(s.fh3, t, -1, 0xB);
            if (!err) err = FileWriteAt(s.fh3, dir, -1, 0xD);
            if (!err) err = FileWriteAt(s.fh3, t + 0x1A, -1, 4);
            FileClose(&s.fh3);
            if (!err) {
                MakePath(s.path, (char *)&str_floppydrv, (char *)str_PINFO, (char *)str_extDB);
                err = FileOpenWrite(s.path, &s.fhp);
            }
            if (!err) {
                s.zero = 0;
                err = FileWriteAt(s.fhp, &s.zero, 0x13, 2);
            }
            if (!err) err = WriteLeagueTeamEntry(s.fhp, t, s.team);
            FileClose(&s.fhp);
            if (!err) {
                MakePath(s.path, dir, (char *)str_PINFO, (char *)str_extDB);
                err = FileOpenRW(s.path, &s.fh2);
            }
            if (!err) err = WriteLeagueTeamEntry(s.fh2, t, s.team);
            RestoreDialogBg();
            if (err) {
            t[0x16] = 1;
            t[0x18] |= 1;
            WriteLeagueTeamEntry(s.fh2, t, s.team);
            sub_B2DCA(&s.i, &s.my, &s.mx);
            MessageBox(-1, -1, (char *)exporterrmsg, 2, 0, 0, (int)&s.my, (int)&s.mx, -1);
            }
        } else {
            strcpy(s.lname, dir);
            s.lname[_fstrcspn(s.lname, (char *)&str_dot)] = 0;
            forceexportmsg[0] = (int)s.lname;
            forceexportmsg[2] = (int)t;
            sub_B2DCA(&s.i, &s.my, &s.mx);
            MessageBox(-1, -1, (char *)forceexportmsg, 3, 0, 0, (int)&s.my, (int)&s.mx, -1);
        }
    }
    FileClose(&s.fh2);
    return err;
}
