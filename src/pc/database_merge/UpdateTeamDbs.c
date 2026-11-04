/* Database merge: refresh the human team databases from the current league. */
#define LeagueCheckStub LeagueCheckStub_decl
#define CopyHumanTeamDBs CopyHumanTeamDBs_decl
#define RebuildLeagueDbs RebuildLeagueDbs_decl
#define MergeLeagueFiles MergeLeagueFiles_decl
#define MergeTeamDbs MergeTeamDbs_decl
#define MergeScheduleDb MergeScheduleDb_decl
#define UpdateSeasonSchedule UpdateSeasonSchedule_decl
#include "nhl95.h"
#undef LeagueCheckStub
#undef CopyHumanTeamDBs
#undef RebuildLeagueDbs
#undef MergeLeagueFiles
#undef MergeTeamDbs
#undef MergeScheduleDb
#undef UpdateSeasonSchedule

int LeagueCheckStub(char *dir, int mode);
int CopyHumanTeamDBs(char *dir, void *teams, int which);
int MergeTeamDbs(char *odir, char *ndir, char *mdir, char *next, char *mext, int who);
int MergeScheduleDb(char *sdir, char *ddir, char *sext, char *dext, int team, int *count);
int UpdateSeasonSchedule(char *dir, char *ext, int day, unsigned char *teams, int team, int flags);

/* UpdateTeamDbs: highlight the dialog, and if this league passes the stub check, read its header.
 When that fails and a saved game exists, say so at the mouse and stop. Otherwise open PINFO.DB, read
 the word at 13h, and if bit 2 is set copy the human team databases (which == -1). If the bit is clear,
 say the league has not been merged. Any error on that path is the update-error box. Restore the dialog
 colours either way. */
void UpdateTeamDbs(void)
{
    struct {
        char path[0x20];
        char name[0x10];
        int fh;
        int btn;
        int my;
        int mx;
        unsigned char flags[4];
    } s;
    int shown;
    int err;
    int io;

    s.fh = -1;
    shown = 0;
    SetDialogColors(0xF9, 0xFA, 0xF8, 0xFA, shown);
    if (LeagueCheckStub((char *)&curleague, 2))
        goto done;
    err = ReadLeagueInfo((char *)&curleague, leagueteams, (char *)masterpw,
        (short *)&leaguemaster, &humancount, &leagueflags, &leaguesaved, (char *)&savedname);
    io = err;
    strcpy(s.name, (char *)&curleague);
    s.name[_fstrcspn(s.name, (char *)&str_dot)] = 0;
    if (!err && leaguesaved) {
        msg_SavedGame_arg = (int)s.name;
        sub_B2DCA(&s.mx, &s.my, &s.btn);
        MessageBox(-1, -1, (char *)msg_SavedGame, 3, err, err, (int)&s.my, (int)&s.btn, -1);
        shown = -1;
    }
    if (shown)
        goto done;
    if (!io) {
        MakePath(s.path, (char *)&curleague, (char *)str_PINFO, (char *)str_extDB);
        io = FileOpenRW(s.path, &s.fh);
    }
    if (!io)
        io = FileReadAt(s.fh, s.flags, 0x13, 2);
    FileClose(&s.fh);
    if (!io) {
        if (s.flags[0] & 4)
            io = CopyHumanTeamDBs((char *)&curleague, leagueteams, -1);
        else {
            *(char **)(mergestatemsg + 4) = s.name;
            *(char **)(mergestatemsg + 8) = (char *)str_HasNotBeenMerged;
            sub_B2DCA(&s.mx, &s.my, &s.btn);
            MessageBox(-1, -1, (char *)mergestatemsg, 3, io, io, (int)&s.my, (int)&s.btn, -1);
        }
    }
    if (io) {
        sub_B2DCA(&s.mx, &s.my, &s.btn);
        MessageBox(-1, -1, (char *)updateerrmsg, 2, 0, 0, (int)&s.my, (int)&s.btn, -1);
    }
done:
    SetDialogColors(0x2A, 0x3F, 0x17, 0x3F, 0);
}

/* MergeLeagueFiles (3B25A, PC only): merge the human teams' copies of the current league back into it. Clear
 byte_DE268 and, if the league passes the stub check, read its header and note whether PLAYER.ID exists. A saved
 game, a master team under coach control (flag 2), a PLAYER.ID or an already merged league (leagueflags bit 2)
 only get their message box. Otherwise open PINFO.DB, find the master team's copy (LocateTeamDbCopy, ext str_Xx
 "%02d" of leaguemaster) and show "merging". For each human team not yet merged (+17h is 1, flag bit 2 clear):
 find its copy (ext str_extxx), open that league's PINFO.DB, merge its team and schedule databases
 (MergeTeamDbs, MergeScheduleDb; not for the master team), mark it merged with its version in both headers and
 set the copy's flags to 4 and ours to 8. Then copy the three league databases from the master copy, read the
 schedule's game count, update the season schedule from there and set the flags to 4. Error 4 with flags 8
 says the merge is incomplete; another error says it failed. Restores the dialog colours. Returns byte_DE268. */
int MergeLeagueFiles(void)
{
    struct {
        char path[0x20];
        char name[0x10];
        unsigned ver;
        char *dir;
        char num[4];
        int rdfh;
        char *mdir;
        int fh;
        int btn;
        int my;
        int mx;
        int i;
        int fh2;
        short ngames;
    } s;
    int err;
    int r;

    s.rdfh = s.fh2 = s.fh = -1;
    SetDialogColors(0xF9, 0xFA, 0xF8, 0xFA, 0);
    r = LeagueCheckStub((char *)&curleague, 2);
    byte_DE268 = 0;
    if (r) goto done;
    err = r = ReadLeagueInfo((char *)&curleague, leagueteams, (char *)masterpw, (short *)&leaguemaster, &humancount,
        &leagueflags, &leaguesaved, (char *)&savedname);
    MakePath(s.path, (char *)&curleague, (char *)str_PLAYER, (char *)str_extID);
    lgplayeridfile = FileExists(s.path);
    if (r) goto done;
    strcpy(s.name, (char *)&curleague);
    s.name[_fstrcspn(s.name, (char *)&str_dot)] = 0;
    if (leaguesaved) {
        msg_SavedGame_arg = (int)s.name;
        sub_B2DCA(&s.mx, &s.my, &s.btn);
        MessageBox(-1, -1, (char *)msg_SavedGame, 3, r, r, (int)&s.my, (int)&s.btn, -1);
    } else if (lgteamflags[leaguemaster * 30] == 2) {
        *(char **)(masterctlmsg + 4) = s.name;
        sub_B2DCA(&s.mx, &s.my, &s.btn);
        MessageBox(-1, -1, (char *)masterctlmsg, 3, r, r, (int)&s.my, (int)&s.btn, -1);
    } else if (lgplayeridfile) {
        *(char **)(masteronlymsg + 8) = s.name;
        sub_B2DCA(&s.mx, &s.my, &s.btn);
        MessageBox(-1, -1, (char *)masteronlymsg, 3, r, r, (int)&s.my, (int)&s.btn, -1);
    } else if (!(leagueflags & 4)) {
        if (!r) {
            MakePath(s.path, (char *)&curleague, (char *)str_PINFO, (char *)str_extDB);
            err = FileOpenRW(s.path, &s.fh);
        }
        if (!err) {
            sprintf(s.num, (char *)str_02d2, leaguemaster);
            strcpy((char *)str_Xx, s.num);
            err = LocateTeamDbCopy(leagueteams, leaguemaster, (char *)&curleague, (char *)&curleague,
                (char *)&str_floppydrv, &s.mdir, &s.ver);
        }
        if (!err) MessageBox(-1, -1, (char *)mergingmsg, 1, err, err, err, err, err);
        for (s.i = 0; s.i < 0x1A && !err; s.i++) {
            if (lgteam_17[s.i * 30] == 1 && !(lgteamflags[s.i * 30] & 4)) {
                sprintf(s.num, (char *)str_02d2, s.i);
                strcpy((char *)str_extxx, s.num);
                err = LocateTeamDbCopy(leagueteams, s.i, (char *)&curleague, (char *)&curleague,
                    (char *)&str_floppydrv, &s.dir, &s.ver);
                if (!err) {
                    if (!dlgsavebuf) MessageBox(-1, -1, (char *)mergingmsg, 1, 0, 0, 0, 0, 0);
                    MakePath(s.path, s.dir, (char *)str_PINFO, (char *)str_extDB);
                    err = FileOpenRW(s.path, &s.fh2);
                }
                if (!err && s.i != leaguemaster) {
                    err = MergeTeamDbs((char *)&curleague, s.dir, s.mdir, (char *)str_extxx, (char *)str_Xx, s.i);
                    if (!err)
                        err = MergeScheduleDb(s.dir, (char *)&curleague, (char *)str_extxx, (char *)str_Xx, s.i,
                            (int *)&s.ngames);
                }
                if (!err) {
                    *(unsigned *)((char *)lgteamver + s.i * 30) = s.ver;
                    lgteamflags[s.i * 30] |= 4;
                    err = WriteLeagueTeamEntry(s.fh, leagueteams + s.i * 30, s.i);
                }
                if (!err) err = WriteLeagueTeamEntry(s.fh2, leagueteams + s.i * 30, s.i);
                if (!err && s.dir != (char *)&curleague) {
                    *(int *)&leagueflags = 4;
                    err = FileWriteAt(s.fh2, &leagueflags, 0x13, 2);
                }
                FileClose(&s.fh2);
                if (!err) {
                    *(int *)&leagueflags = 8;
                    err = FileWriteAt(s.fh, &leagueflags, 0x13, 2);
                }
            }
        }
        if (!err) err = CopyFile((char *)leaguedbnames[4], (char *)str_Xx, (char *)str_extDB, s.mdir, (char *)&curleague);
        if (!err) err = CopyFile((char *)leaguedbnames[5], (char *)str_Xx, (char *)str_extDB, s.mdir, (char *)&curleague);
        if (!err) err = CopyFile((char *)leaguedbnames[6], (char *)str_Xx, (char *)str_extDB, s.mdir, (char *)&curleague);
        RestoreDialogBg();
        if (!err) {
            MakePath(s.path, (char *)&curleague, (char *)leaguedbnames[6], (char *)str_extDB);
            err = FileOpenRead(s.path, &s.rdfh);
        }
        if (!err) err = FileReadAt(s.rdfh, &s.ngames, 0, 2);
        FileClose(&s.rdfh);
        if (!err) {
            MessageBox(-1, -1, (char *)updschedmsg, 1, err, err, err, err, err);
            err = UpdateSeasonSchedule((char *)&curleague, (char *)str_extDB, s.ngames, leagueteams, -1, 7);
        }
        if (!err) {
            *(int *)&leagueflags = 4;
            err = FileWriteAt(s.fh, &leagueflags, 0x13, 2);
        }
        RestoreDialogBg();
        FileClose(&s.fh);
        sub_B2DCA(&s.i, &s.my, &s.btn);
        if (err == 4) {
            if (*(int *)&leagueflags == 8)
                MessageBox(-1, -1, (char *)mergeincompletemsg, 3, 0, 0, (int)&s.my, (int)&s.btn, -1);
        } else if (err) {
            MessageBox(-1, -1, (char *)mergeerrmsg, 1, 0, 0, (int)&s.my, (int)&s.btn, -1);
        }
    } else {
        *(char **)(mergestatemsg + 4) = s.name;
        *(char **)(mergestatemsg + 8) = (char *)str_IsAlreadyMerged;
        sub_B2DCA(&s.i, &s.my, &s.btn);
        MessageBox(-1, -1, (char *)mergestatemsg, 3, r, r, (int)&s.my, (int)&s.btn, -1);
    }
done:
    SetDialogColors(0x2A, 0x3F, 0x17, 0x3F, 0);
    return byte_DE268;
}

/* RebuildLeagueDbs: ask each human team for its password, then the master password. When the stub
 check and those passwords all succeed, open PINFO.DB, read the word at 13h, delete the saved game
 and copy the human team databases. Any error on that path is the update-error box. Restores the
 dialog colours either way. */
void RebuildLeagueDbs(void)
{
    struct {
        char path[0x20];
        int fh;
        int btn;
        int my;
        int mx;
        unsigned char flags[4];
    } s;
    int err;
    int pw;

    s.fh = -1;
    SetDialogColors(0xF9, 0xFA, 0xF8, 0xFA, 0);
    err = LeagueCheckStub((char *)&curleague, 2);
    if (!err) {
        err = ReadLeagueInfo((char *)&curleague, leagueteams, (char *)masterpw,
            (short *)&leaguemaster, &humancount, &leagueflags, &leaguesaved, (char *)&savedname);
        pw = 0;
        for (s.mx = pw; s.mx < 0x1A && pw == 0; s.mx++) {
            if (lgteam_17[s.mx * 30] == 1)
                pw = AskTeamPassword(s.mx, (char *)leagueteams);
        }
        if (pw == 0)
            pw = AskMasterPassword(leaguemaster, (char *)leagueteams, (char *)masterpw);
    }
    if (err == 0 && pw == 0) {
        MakePath(s.path, (char *)&curleague, (char *)str_PINFO, (char *)str_extDB);
        err = FileOpenRW(s.path, &s.fh);
        if (err == 0)
            err = FileReadAt(s.fh, s.flags, 0x13, 2);
        FileClose(&s.fh);
        if (err == 0) {
            strcpy(s.path, (char *)&curleague);
            DeleteFiles(s.path, (char *)str_GAME2, (char *)str_SAV2);
            err = CopyHumanTeamDBs((char *)&curleague, leagueteams, -1);
        }
        if (err != 0) {
            sub_B2DCA(&s.mx, &s.my, &s.btn);
            MessageBox(-1, -1, (char *)updateerrmsg, 2, 0, 0, (int)&s.my, (int)&s.btn, -1);
        }
    }
    SetDialogColors(0x2A, 0x3F, 0x17, 0x3F, 0);
}
