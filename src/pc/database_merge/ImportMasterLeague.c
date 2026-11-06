/* Database merge: importing a master league from the floppy. */
#define CopyHumanTeamDBs CopyHumanTeamDBs_decl
#define LeagueCheckStub LeagueCheckStub_decl
#define LeagueTeamSelect LeagueTeamSelect_decl
#define ExportTeamToFloppy ExportTeamToFloppy_decl
#define ReadLeagueTeamEntry ReadLeagueTeamEntry_decl
#define MsgCopyingDatabases MsgCopyingDatabases_decl
#define UpdateTeamDbs UpdateTeamDbs_decl
#include "nhl95.h"
#undef CopyHumanTeamDBs
#undef LeagueCheckStub
#undef LeagueTeamSelect
#undef ExportTeamToFloppy
#undef ReadLeagueTeamEntry
#undef MsgCopyingDatabases
#undef UpdateTeamDbs

int mkdir(const char *path);  /* Watcom CRT mkdir_ */
int CopyHumanTeamDBs(char *dir, void *teams, int which);
int LeagueCheckStub(char *dir, int mode);
int LeagueTeamSelect(char *dir, int *count, unsigned char *names, unsigned char *teams, int mode, char *title,
    int *sel);
void ExportTeamToFloppy(char *dir, char *ext, char *ext2, int t, unsigned char *teams, int full, int a);
int ReadLeagueTeamEntry(int fh, void *entry, int n);
void MsgCopyingDatabases(char *name);
void UpdateTeamDbs(void);

typedef struct FindT {
    char reserved[0x15];
    char attrib;
    unsigned short wr_time;
    unsigned short wr_date;
    unsigned long size;
    char name[0x0E];
} FindT;

/* ImportMasterLeague (3C3AF, PC only; owner of ImportMasterLeague_ret): copy a league exported by the master
   (PLAYER.ID on the floppy, A:) into a new league directory. Read the league name from PLAYER.ID (+0Ch, 0Dh
   bytes) and the league info; a league of that name already here says so (lgexistsmsg). Ask the master
   password, say what happens (importmastermsg), make the directory and copy the seven databases, PINFO.DB and
   GAME.SET into it; delete any saved game there, read the human team count (PINFO +13h) and copy the human
   teams' databases. On a copy error say so (updateerrmsg) and remove the directory; on any error say the import
   failed (importerrmsg). No arguments. Result: 0, an I/O error, or -1 when the password was refused. */
int ImportMasterLeague(void)
{
    struct {
        unsigned char find[0x2C];
        char path[0x20];
        char name[0x10];
        int x;
        int y;
        int i;
        int rwfh;
        int fh;
        short count;
    } s;
    int err;
    int pw;

    s.rwfh = s.fh = -1;
    MakePath(s.path, (char *)&str_floppydrv, (char *)str_PLAYER, (char *)str_extID);
    err = FileOpenRead(s.path, &s.fh);
    if (!err) err = FileReadAt(s.fh, &curleague, 0xC, 0xD);
    FileClose(&s.fh);
    if (err) goto fail;
    if (!err)
        err = ReadLeagueInfo((char *)&str_floppydrv, leagueteams, (char *)masterpw, (short *)&leaguemaster,
            &humancount, &leagueflags, &leaguesaved, (char *)&savedname);
    strcpy(s.name, (char *)&curleague);
    if (!unknown_libname_1(s.name, 0x10, s.find)) goto exists;
    pw = AskMasterPassword(leaguemaster, (char *)leagueteams, (char *)masterpw);
    if (pw) goto fail;
    MessageBox(-1, -1, (char *)importmastermsg, 1, 0, 0, (int)&s.y, (int)&s.x, 0);
    err = mkdir(s.name);
    if (!err)
        for (s.i = 0; s.i < 7 && !err; s.i++)
            err = CopyFile((char *)leaguedbnames[s.i], (char *)str_extDB, (char *)str_extDB, (char *)&str_floppydrv,
                (char *)&curleague);
    if (!err)
        err = CopyFile((char *)str_PINFO, (char *)str_extDB, (char *)str_extDB, (char *)&str_floppydrv,
            (char *)&curleague);
    if (!err) CopyFile((char *)str_GAME3, (char *)str_SET, (char *)str_SET, (char *)&str_floppydrv, (char *)&curleague);
    RestoreDialogBg();
    strcpy(s.path, (char *)&curleague);
    DeleteFiles(s.path, (char *)str_GAME3, (char *)str_SAV3);
    MakePath(s.path, (char *)&curleague, (char *)str_PINFO, (char *)str_extDB);
    err = FileOpenRW(s.path, &s.rwfh);
    if (!err) err = FileReadAt(s.rwfh, &s.count, 0x13, 2);
    FileClose(&s.rwfh);
    if (!err) err = CopyHumanTeamDBs((char *)&curleague, leagueteams, -1);
    if (err) {
        sub_B2DCA(&s.i, &s.y, &s.x);
        MessageBox(-1, -1, (char *)updateerrmsg, 2, 0, 0, (int)&s.y, (int)&s.x, -1);
    }
    if (err) DeleteDir(s.name);
    goto fail;
exists:
    sub_B2DCA(&s.i, &s.y, &s.x);
    SetDialogColors(0xF9, 0xFA, 0xF8, 0xFA, 0);
    MessageBox(-1, -1, (char *)lgexistsmsg, 2, 0, 0, (int)&s.y, (int)&s.x, -1);
fail:
    if (err) {
        sub_B2DCA(&s.i, &s.y, &s.x);
        SetDialogColors(0xF9, 0xFA, 0xF8, 0xFA, 0);
        MessageBox(-1, -1, (char *)importerrmsg, 1, 0, 0, (int)&s.y, (int)&s.x, -1);
    }
    if (pw) err = -1;
    return err;
}

/* ImportPlayerTeam (3C6E2, PC only; ends in ImportMasterLeague_ret): import a human team exported to the floppy
   (PLAYER.ID and PINFO.DB on A:): read the team number, league title, league directory (into curleague) and
   version from PLAYER.ID and the team's league entry and export flag from the floppy's PINFO.DB; a team still in
   a saved game says so (insavegamemsg). When the league directory exists, read its info (team databases waiting
   to be merged: ask and update them with UpdateTeamDbs; a saved game: say so and stop). A team that was not
   exported, or whose copy is older, or a league that belongs to another human team says so. Otherwise copy the
   league files (all seven databases when the league has no id yet), GAME.SET, and write the team's entry (marked
   imported) to both PINFO.DB files; a new directory is made first and removed again on an error. Any error says
   the import failed (importerrmsg). No arguments. Result: 0 or the error. */
int ImportPlayerTeam(void)
{
    struct {
        FindT ft;
        char path[0x20];
        unsigned char entry[0x20];
        char name[0x10];
        char lname[0x0C];
        int id;
        int mx;
        int my;
        int fh;
        char ext[4];
        int ver;
        int fh2;
        int fh3;
        int btn;
        int nodir;
        short exported;
        short pad;
        signed char team;
    } s;
    int err;
    int again;
    int quit;
    int d;
    int t;

    s.fh2 = s.fh3 = s.fh = -1;
    quit = 0;
    SetDialogColors(0xF9, 0xFA, 0xF8, 0xFA, quit);
    MakePath(s.path, (char *)&str_floppydrv, (char *)str_PLAYER, (char *)str_extID);
    err = FileOpenRead(s.path, &s.fh);
    if (!err) err = FileReadAt(s.fh, &s.team, 0, 1);
    if (!err) err = FileReadAt(s.fh, s.lname, 1, 0xB);
    if (!err) err = FileReadAt(s.fh, &curleague, 0xC, 0xD);
    if (!err) err = FileReadAt(s.fh, &s.ver, 0x19, 4);
    FileClose(&s.fh);
    if (!err) {
        sprintf(s.ext, (char *)str_02d3, s.team);
        strcpy((char *)str_extxx, s.ext);
        MakePath(s.path, (char *)&str_floppydrv, (char *)str_PINFO, (char *)str_extDB);
        err = FileOpenRW(s.path, &s.fh3);
    }
    if (!err) err = ReadLeagueTeamEntry(s.fh3, s.entry, s.team);
    if (!err) err = FileReadAt(s.fh3, &s.exported, 4, 2);
    FileClose(&s.fh3);
    if (!err && s.exported) {
        strcpy(s.name, (char *)&curleague);
        s.name[_fstrcspn(s.name, (char *)&str_dot)] = 0;
        SetDialogColors(0xF9, 0xFA, 0xF8, 0xFA, err);
        insavegamemsg[0] = (int)s.lname;
        insavegamemsg[2] = (int)s.name;
        sub_B2DCA(&s.mx, &s.my, &s.btn);
        MessageBox(-1, -1, (char *)insavegamemsg, 5, err, err, (int)&s.my, (int)&s.btn, -1);
        goto done;
    }
    if (err) goto done;
    strcpy(s.name, (char *)&curleague);
    again = s.nodir = unknown_libname_1(s.name, 0x10, &s.ft);
    s.name[_fstrcspn(s.name, (char *)&str_dot)] = 0;
    if (!again) {
        do {
            again = 0;
            err = ReadLeagueInfo((char *)&curleague, leagueteams, (char *)masterpw, (short *)&leaguemaster, &humancount,
                &leagueflags, &leaguesaved, (char *)&savedname);
            SetDialogColors(0xF9, 0xFA, 0xF8, 0xFA, again);
            sub_B2DCA(&s.mx, &s.my, &s.btn);
            if (leagueflags & 0xC) {
                *(char **)(playerdbsmsg + 4) = s.name;
                if (MessageBox(-1, -1, (char *)playerdbsmsg, 4, (int)btn_MasterDB, 2, (int)&s.my, (int)&s.btn, -1)) {
                    quit = -1;
                } else {
                    UpdateTeamDbs();
                    again = -1;
                }
            } else if (leaguesaved) {
                msg_SavedGame_arg = (int)s.name;
                MessageBox(-1, -1, (char *)msg_SavedGame, 3, again, again, (int)&s.my, (int)&s.btn, -1);
                quit = -1;
            }
        } while (again);
    }
    SetDialogColors(0xF9, 0xFA, 0xF8, 0xFA, 0);
    if (err || quit) goto fail;
    d = GetLeagueId((char *)&curleague, &s.id);
    if (s.entry[0x16] != 2 || !s.nodir && lgteamflags[s.team * 30] != 2
        && *(unsigned *)(s.entry + 0x1A) <= *(unsigned *)((char *)lgteamver + s.team * 30)) {
        SetDialogColors(0xF9, 0xFA, 0xF8, 0xFA, 0);
        notexportedmsg[0] = (int)s.lname;
        notexportedmsg[2] = (int)s.name;
        sub_B2DCA(&s.mx, &s.my, &s.btn);
        MessageBox(-1, -1, (char *)notexportedmsg, 3, 0, 0, (int)&s.my, (int)&s.btn, -1);
        goto fail;
    }
    if (!s.nodir) {
        t = s.team;
        if (*(unsigned *)(s.entry + 0x1A) < *(unsigned *)((char *)lgteamver + t * 30)) {
            *(char **)(oldcopymsg + 8) = s.name;
            sub_B2DCA(&s.mx, &s.my, &s.btn);
            MessageBox(-1, -1, (char *)oldcopymsg, 3, 0, 0, (int)&s.my, (int)&s.btn, -1);
            goto fail;
        }
        if (d >= 0) {
            if (d != t) {
                *(char **)(lgexistsformsg + 4) = s.name;
                *(unsigned char **)(lgexistsformsg + 0xC) = leagueteams + d * 30;
                sub_B2DCA(&s.mx, &s.my, &s.btn);
                MessageBox(-1, -1, (char *)lgexistsformsg, 4, 0, 0, (int)&s.my, (int)&s.btn, -1);
                goto fail;
            }
            MsgCopyingDatabases(s.lname);
            s.entry[0x16] = 1;
            if (!err) err = CopyLeagueFiles((char *)&str_floppydrv, (char *)&curleague);
            if (!err) err = CopyFile((char *)str_GAME4, (char *)str_SET2, (char *)str_SET2, (char *)&str_floppydrv,
                (char *)&curleague);
            if (!err) {
                MakePath(s.path, (char *)&curleague, (char *)str_PINFO, (char *)str_extDB);
                err = FileOpenRW(s.path, &s.fh2);
            }
            if (!err) err = WriteLeagueTeamEntry(s.fh2, s.entry, s.team);
            FileClose(&s.fh2);
            if (!err) {
                MakePath(s.path, (char *)&str_floppydrv, (char *)str_PINFO, (char *)str_extDB);
                err = FileOpenRW(s.path, &s.fh3);
            }
            if (!err) WriteLeagueTeamEntry(s.fh3, s.entry, s.team);
            FileClose(&s.fh3);
        } else {
            MsgCopyingDatabases(s.lname);
            s.entry[0x16] = 1;
            for (s.mx = 0; s.mx < 7 && !err; s.mx++)
                err = CopyFile((char *)leaguedbnames[s.mx], (char *)str_extxx, (char *)str_extxx, (char *)&str_floppydrv,
                    (char *)&curleague);
            if (!err) err = CopyFile((char *)str_GAME4, (char *)str_SET2, (char *)str_SET2, (char *)&str_floppydrv,
                (char *)&curleague);
            if (!err) {
                MakePath(s.path, (char *)&curleague, (char *)str_PINFO, (char *)str_extDB);
                err = FileOpenRW(s.path, &s.fh2);
            }
            if (!err) err = WriteLeagueTeamEntry(s.fh2, s.entry, s.team);
            FileClose(&s.fh2);
            if (!err) {
                MakePath(s.path, (char *)&str_floppydrv, (char *)str_PINFO, (char *)str_extDB);
                err = FileOpenRW(s.path, &s.fh3);
            }
            if (!err) WriteLeagueTeamEntry(s.fh3, s.entry, s.team);
            FileClose(&s.fh3);
        }
    } else {
        MsgCopyingDatabases(s.lname);
        strcpy(s.name, (char *)&curleague);
        err = mkdir(s.name);
        s.entry[0x16] = 1;
        if (!err) err = CopyLeagueFiles((char *)&str_floppydrv, (char *)&curleague);
        if (!err) err = CopyFile((char *)str_GAME4, (char *)str_SET2, (char *)str_SET2, (char *)&str_floppydrv,
            (char *)&curleague);
        if (!err) {
            MakePath(s.path, (char *)&curleague, (char *)str_PINFO, (char *)str_extDB);
            err = FileOpenRW(s.path, &s.fh2);
        }
        if (!err) err = WriteLeagueTeamEntry(s.fh2, s.entry, s.team);
        FileClose(&s.fh2);
        if (!err) {
            MakePath(s.path, (char *)&str_floppydrv, (char *)str_PINFO, (char *)str_extDB);
            err = FileOpenRW(s.path, &s.fh3);
        }
        if (!err) WriteLeagueTeamEntry(s.fh3, s.entry, s.team);
        FileClose(&s.fh3);
    }
fail:
    if (err && s.nodir) {
        strcpy(s.name, (char *)&curleague);
        DeleteDir(s.name);
    }
done:
    RestoreDialogBg();
    if (err) {
        sub_B2DCA(&s.mx, &s.my, &s.btn);
        MessageBox(-1, -1, (char *)importerrmsg, 1, 0, 0, (int)&s.my, (int)&s.btn, -1);
    }
    return err;
}

/* ExportDbs (3D108, PC only; ends in ImportMasterLeague_ret): export a human team's databases from the current
   league to the floppy. Read the league (LeagueCheckStub 3, ReadLeagueInfo); with team databases waiting
   (leagueflags bits 2 / 3) offer to update them first (playerdbsmsg, UpdateTeamDbs) and read again; a saved
   game in progress stops it (msg_SavedGame). With the team names read, the team is the one this machine plays
   (GetLeagueId) or one picked (LeagueTeamSelect); a team that has already exported (lgteamflags 2) may only
   export again with the master password (forceexportmsg, AskMasterPassword), which bumps its version and
   exports the full databases (.DB instead of .xx). The extension is the team number (".%02d" into str_extxx);
   after the floppy is chosen (SelectFloppyDrive) ExportTeamToFloppy writes it. The dialog colours are reset at
   the end. No arguments, no result. */
void ExportDbs(void)
{
    struct {
        char path[0x20];
        char name[0x10];
        char ext[4];
        int x;
        int id;
        int btn;
        int t;
        int y;
    } s;
    int err;
    int shown;
    int ask;
    char *e;

    err = LeagueCheckStub((char *)&curleague, 3);
    do {
        shown = 0;
        if (!err) {
            err = ReadLeagueInfo((char *)&curleague, leagueteams, (char *)masterpw, (short *)&leaguemaster,
                &humancount, &leagueflags, &leaguesaved, (char *)&savedname);
            strcpy(s.name, (char *)&curleague);
            s.name[_fstrcspn(s.name, (char *)&str_dot)] = 0;
            SetDialogColors(0xF9, 0xFA, 0xF8, 0xFA, shown);
            sub_B2DCA(&s.btn, &s.y, &s.x);
            if (leagueflags & 0xC) {
                ((int *)playerdbsmsg)[1] = (int)s.name;
                s.btn = MessageBox(-1, -1, (char *)playerdbsmsg, 4, (int)btn_MasterDB, 2, (int)&s.y, (int)&s.x,
                    -1);
                if (!s.btn) {
                    UpdateTeamDbs();
                    shown = -1;
                } else
                    err = -1;
            } else if (leaguesaved) {
                msg_SavedGame_arg = (int)s.name;
                MessageBox(-1, -1, (char *)msg_SavedGame, 3, shown, shown, (int)&s.y, (int)&s.x, -1);
                err = -1;
            }
        }
    } while (shown);
    if (err) goto done;
    MakePath(s.path, (char *)&curleague, (char *)leaguedbnames[4], (char *)str_extDB);
    if (ReadTeamNames(s.path, (char *)treeteamnames, 1)) goto done;
    ask = -1;
    s.t = GetLeagueId((char *)&curleague, &s.id);
    if (s.t < 0) {
        LeagueTeamSelect((char *)&curleague, &humancount, treeteamnames, leagueteams, 8, (char *)str_SelectATeamTo2,
            &s.t);
        if (humancount == 1) SetDialogColors(0xF9, 0xFA, 0xF8, 0xFA, shown);
    } else
        ask = 0;
    if (s.t >= 0 && lgteamflags[s.t * 30] == 2) {
        forceexportmsg[0] = (int)s.name;
        forceexportmsg[2] = (int)(leagueteams + s.t * 30);
        sub_B2DCA(&s.btn, &s.y, &s.x);
        s.btn = MessageBox(-1, -1, (char *)forceexportmsg, 4, (int)forceexportbtns, 2, (int)&s.y, (int)&s.x, -1);
        err = -1;
        if (!s.btn) err = AskMasterPassword(leaguemaster, (char *)leagueteams, (char *)masterpw);
        if (!err) {
            shown = -1;
            lgteamver_hi[s.t * 15]++;
        } else
            s.t = -1;
    }
    if (s.t < 0) goto done;
    if (humancount == 1 || !ask) SetDialogColors(0xF9, 0xFA, 0xF8, 0xFA, 0);
    sprintf(s.ext, (char *)str_02d3, s.t);
    strcpy((char *)str_extxx, s.ext);
    e = shown ? (char *)str_extDB : (char *)str_extxx;
    if (!SelectFloppyDrive((int)&curleague, (int)(leagueteams + s.t * 30)))
        ExportTeamToFloppy((char *)&curleague, e, (char *)str_extxx, s.t, leagueteams, shown, -1);
done:
    SetDialogColors(0x2A, 0x3F, 0x17, 0x3F, 0);
}
