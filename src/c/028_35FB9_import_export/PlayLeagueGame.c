/* Import/export: playing a league game and posting its result to the league files. */
#define CheckLeagueDiskSync CheckLeagueDiskSync_decl
#define LeagueCheckStub LeagueCheckStub_decl
#define LeagueTeamSelect LeagueTeamSelect_decl
#define UpdateTeamDbs UpdateTeamDbs_decl
#define CalendarScreen CalendarScreen_decl
#define PreGameScreen PreGameScreen_decl
#define UpdatePlayoffSeries UpdatePlayoffSeries_decl
#define UpdateSeasonSchedule UpdateSeasonSchedule_decl
#define PostGameToTeamDb PostGameToTeamDb_decl
#include "nhl95.h"
#undef CheckLeagueDiskSync
#undef LeagueCheckStub
#undef LeagueTeamSelect
#undef UpdateTeamDbs
#undef CalendarScreen
#undef PreGameScreen
#undef UpdatePlayoffSeries
#undef UpdateSeasonSchedule
#undef PostGameToTeamDb

int CheckLeagueDiskSync(char *dir, char *teams, int team, int sync, int probe);
int LeagueCheckStub(char *dir, int mode);
int LeagueTeamSelect(char *dir, int *count, unsigned char *names, unsigned char *teams, int mode, char *title,
    int *sel);
void UpdateTeamDbs(void);
int CalendarScreen(char *dir, char *ext, int team);
int PreGameScreen(unsigned char home, unsigned char away);
int UpdatePlayoffSeries(int sched, int teams, int game);
int UpdateSeasonSchedule(char *dir, char *ext, int day, unsigned char *teams, int team, int flags);
int PostGameToTeamDb(char *dir, char *ext, int team, int side, int game, char *gdir);

/* DRAFT (first pass from Ghidra): 4,095 of 4,095 bytes, 28 instructions differ: both FileOpenRW calls on the
   first schedule copy the result into edx too (mov edx, eax); the opponent pick keeps dword_DDD34 in eax where
   the EXE compares with lgplayteam in edx (xor eax, edx) and reloads it; a few pushed registers differ. The frame
   struct follows the EXE's esp offsets (0 to 90h). */
/* PlayLeagueGame (36B93, PC only): play one league game and post its result. fh points to the handle of a
   saved game (GAME.SAV; -1 for a new game); a saved game's reference is loaded first. Read the league (a
   league still to be merged or updated asks first, then merges / updates and reads it again) and its team
   names. For a new game find the human team (GetLeagueId, else LeagueTeamSelect), check its disk and
   password and set its directory (savleague1, the league or the floppy) and extension (str_extxx, the team
   number); fade out. For a saved game only ask the password. Then loop: pick the game on the calendar (new
   games, and every pass after the first), read the schedule's game count and the game; when the opponent is
   a human team (dword_DDD3C) check its disk too and set its directory (savleague2) and extension (str_Xx),
   read its game count and ask its password. Play the game: fade out and stop the music, build both teams'
   database names (leaguedbfmt / leaguedbfmt2), set gameopts.fullot for a regular-season game (index below
   444h; clear for the playoffs), the teams and the controllers, show the pre-game screen (unless there is no
   disk space: 4), install the in-game stats callbacks and play (PlayGame); a finished game keeps the score
   (dword_DDD44 / byte_DDD45, the schedule record at byte_DDD40). Then post it: load the desk palette, say
   the schedule is being updated, clear the saved game in PINFO.DB, write the game into the schedule(s),
   count the game (regular season: the games-played word; playoffs: UpdatePlayoffSeries on the team files),
   and update the season schedule and post the game to both teams' databases (PostGameToTeamDb). An error
   other than a failed password or 4 shows a message. Fade out, and go again while a game was picked, there
   was no error and no game was saved. No result. */
void PlayLeagueGame(int *fh)
{
    struct {
        char path[0x20];
        char name[0x10];
        unsigned char info[0x10];
        int fhteam2;
        int id;
        int zero;
        int mx;
        int my;
        int btn;
        int fhteam1;
        int fhsched2;
        char num[4];
        int fhinfo;
        int bank;
        int fhsched1;
        int again;
        int side;
        int pwfail;
        int game;
        unsigned char *pal;
        int ok;
        int picked;
        unsigned char *pal2;
        int retry;
    } s;
    int err;
    int other;
    int slot;
    unsigned char *pal;

    s.fhsched1 = -1;
    s.fhsched2 = -1;
    s.fhteam1 = -1;
    s.fhteam2 = -1;
    s.fhinfo = -1;
    s.again = 0;
    s.pwfail = 0;
    s.ok = 0;
    lggameidx = -1;
    sub_B2E1B(0, 0, 0x280, 0x1E0);
    if (*fh >= 0) LoadLeagueGameRef(*fh);
    err = LeagueCheckStub((char *)&curleague, 3);
    do {
        s.retry = 0;
        if (!err)
            err = ReadLeagueInfo((char *)&curleague, leagueteams, (char *)masterpw, (short *)&leaguemaster,
                &humancount, &leagueflags, &leaguesaved, (char *)&savedname);
        if (!err) {
            strcpy(s.name, (char *)&curleague);
            s.name[_fstrcspn(s.name, (char *)&str_dot)] = 0;
            if (leagueflags & 0xC) {
                sub_B2DCA(&s.btn, &s.my, &s.mx);
                SetDialogColors(0xF9, 0xFA, 0xF8, 0xFA, 0);
                if (leagueflags & 8) {
                    dword_C7F0B = (int)s.name;
                    s.btn = MessageBox(-1, -1, (char *)unk_C7F07, 5, (int)unk_C7F1B, 2, (int)&s.my, (int)&s.mx, -1);
                } else {
                    ((int *)playerdbsmsg)[1] = (int)s.name;
                    s.btn = MessageBox(-1, -1, (char *)playerdbsmsg, 4, (int)btn_MasterDB, 2, (int)&s.my, (int)&s.mx,
                        -1);
                }
                if (s.btn == 0) {
                    if (leagueflags & 8) MergeLeagueFiles();
                    UpdateTeamDbs();
                    s.retry = -1;
                } else
                    err = -1;
            } else {
                MakePath(s.path, (char *)&curleague, (char *)leaguedbnames[4], (char *)str_extDB);
                err = ReadTeamNames(s.path, (char *)treeteamnames, 1);
            }
        }
    } while (s.retry);
    if (*fh < 0) {
        s.picked = 0;
        if (!err) {
            SetDialogColors(0xF9, 0xFA, 0xF8, 0xFA, 0);
            lgplayteam = GetLeagueId((char *)&curleague, &s.id);
        }
        if (!err && lgplayteam < 0) {
            LeagueTeamSelect((char *)&curleague, &humancount, treeteamnames, leagueteams, 8, (char *)str_SelectATeamTo,
                &lgplayteam);
            s.picked = -1;
        }
        if (!err && lgplayteam >= 0) {
            err = CheckLeagueDiskSync((char *)&curleague, (char *)leagueteams, lgplayteam, 0, 0);
            if (!err) {
                sprintf(s.num, (char *)str_02d, lgplayteam);
                strcpy((char *)str_extxx, s.num);
                strcpy((char *)savleague1,
                    (lgteamflags[lgplayteam * 30] & 1) ? (char *)&curleague : (char *)&str_floppydrv);
                if (humancount == 1 || !s.picked) SetDialogColors(0xF9, 0xFA, 0xF8, 0xFA, 0);
                err = AskTeamPassword(lgplayteam, (char *)leagueteams);
            }
            if (!err) {
                MakePath(s.path, (char *)&curleague, (char *)leaguedbnames[4], (char *)str_extDB);
                err = ReadTeamNames(s.path, (char *)treeteamnames, 0);
            }
            if (!err) s.ok = -1;
        }
        s.pal = (unsigned char *)sub_8CCA8((char *)str_Pal18, 0x300, 0x20);
        if (musicon && songdata) sub_8FCDF(musichandle, 3, 0x64);
        sub_8FFB0(0, 0x100, s.pal);
        FadePalStep(1, s.pal, 0x10);
        FreeMemBlock((int)s.pal);
        if (musicon && songdata) {
            do
                slot = musicslot;
            while (sub_8FC8A(slot, 3) == 0);
            sub_8D2F0(songdata);
            songdata = 0;
        }
    } else {
        SetDialogColors(0xF9, 0xFA, 0xF8, 0xFA, 0);
        sprintf(s.num, (char *)str_02d, lgplayteam);
        strcpy((char *)str_extxx, s.num);
        err = AskTeamPassword(lgplayteam, (char *)leagueteams);
        if (!err) s.ok = -1;
    }
    if (!s.ok) goto done;
    do {
        if ((lggameidx == -1 && *fh < 0) || s.again)
            lggameidx = CalendarScreen((char *)savleague1, (char *)str_extxx, lgplayteam);
        if (lggameidx >= 0) {
            MakePath(s.path, (char *)savleague1, (char *)leaguedbnames[6], (char *)str_extxx);
            err = FileOpenRW(s.path, &s.fhsched1);
            if (*fh < 0) {
                if (!err) err = FileReadAt(s.fhsched1, &word_DDD48, 0, 2);
                if (!err) err = ReadSchedGame(s.fhsched1, &byte_DDD40, lggameidx);
                if (!err) {
                    dword_DDD34 = byte_DDD42 == lgplayteam ? byte_DDD43 : byte_DDD42;
                    dword_DDD3C = -1;
                    if (lgteam_17[dword_DDD34 * 30] == 0) dword_DDD3C = 0;
                }
            }
            FileClose(&s.fhsched1);
            if (dword_DDD3C) {
                if (!err) {
                    err = CheckLeagueDiskSync((char *)&curleague, (char *)leagueteams, dword_DDD34, -1, 0);
                    if (!err) {
                        sprintf(s.num, (char *)str_02d, dword_DDD34);
                        strcpy((char *)str_Xx, s.num);
                        strcpy((char *)savleague2, (lgteamflags[dword_DDD34 * 30] & 1) && s.picked ?
                            (char *)&curleague : (char *)&str_floppydrv);
                    }
                }
                if (!err) {
                    MakePath(s.path, (char *)savleague2, (char *)leaguedbnames[6], (char *)str_Xx);
                    err = FileOpenRW(s.path, &s.fhsched2);
                }
                if (*fh < 0 && !err) err = FileReadAt(s.fhsched2, &word_DDD4A, 0, 2);
                FileClose(&s.fhsched2);
                if (!err) {
                    sprintf(s.num, (char *)str_02d, dword_DDD34);
                    strcpy((char *)str_Xx, s.num);
                    err = AskTeamPassword(dword_DDD34, (char *)leagueteams);
                    if (err) s.pwfail = -1;
                }
            }
            if (!err) {
                if (*fh >= 0) {
                    pal = (unsigned char *)sub_8CCA8((char *)str_Temp5, 0x300, 0x20);
                    sub_8FFB0(0, 0x100, pal);
                    FadePalStep(1, pal, 0x10);
                    FreeMemBlock((int)pal);
                }
                if (musicon && songdata) {
                    sub_8FCDF(musichandle, 3, 0x64);
                    do
                        slot = musicslot;
                    while (sub_8FC8A(slot, 3) == 0);
                    sub_8D2F0(songdata);
                    songdata = 0;
                }
                if (*fh >= 0) ShowLoadingScreen();
                if (byte_DDD42 == lgplayteam) {
                    s.side = 0;
                    other = 1;
                    MakeTeamDbFmt((char *)&leaguedbfmt, (char *)savleague1, leagueteams, byte_DDD42);
                    MakeTeamDbFmt((char *)&leaguedbfmt2, (char *)savleague2, leagueteams, byte_DDD43);
                } else {
                    s.side = 1;
                    other = 0;
                    MakeTeamDbFmt((char *)&leaguedbfmt, (char *)savleague2, leagueteams, byte_DDD42);
                    MakeTeamDbFmt((char *)&leaguedbfmt2, (char *)savleague1, leagueteams, byte_DDD43);
                }
                if (leaguedbfmt2 == 0) strcpy((char *)&leaguedbfmt2, (char *)&leaguedbfmt);
                if (leaguedbfmt == 0) strcpy((char *)&leaguedbfmt, (char *)&leaguedbfmt2);
                schedgameidx = lggameidx;
                if (lggameidx < 0x444)
                    gameopts.fullot = 1;
                else
                    gameopts.fullot = 0;
                if (*fh < 0) {
                    byte_DC268 = byte_DDD40;
                    byte_DC267 = byte_DDD41;
                    HomeTeam = byte_DDD42;
                    VisTeam = byte_DDD43;
                }
                SetupControllers();
                err = 0;
                if (*fh < 0) {
                    if (!CheckGameDiskSpace()) {
                        InitGameSummary(byte_DC268, byte_DC267);
                        err = PreGameScreen(HomeTeam, VisTeam);
                    } else
                        err = 4;
                }
                if (err != 4) {
                    teamstatscb = (int)GameTeamStatsScreen;
                    skaterstatscb = (int)GameSkaterStatsScreen;
                    goaliestatscb = (int)GameGoalieStatsScreen;
                    standingscb = (int)GameStandingsScreen;
                    standingsmenucb = (int)GameStandingsMenu;
                    InputRemove();
                    PlayGame(fh);
                    InputInstall();
                    if (gameresult == 1) {
                        dword_DDD44 = hmscore[0];
                        byte_DDD45 = awscore;
                    }
                } else
                    gameresult = 2;
            }
            if (!err && gameresult == 1) {
                s.game = lggameidx;
                sub_B392C(0);
                MakePath(s.path, fileoncd[0x6A] == 1 ? (char *)cddriveptr : 0, (char *)str_Easndesk2, 0);
                s.bank = sub_8E83C(s.path, 0);
                sub_B4B88(0, 0x100, (unsigned char *)(sub_B30B4(s.bank, (char *)str_Pal17) + 0x10));
                FreeMemBlock(s.bank);
                s.num[0] = 0x17;
                s.num[1] = 0x17;
                s.num[2] = 0x17;
                sub_B4B88(0xF8, 1, (unsigned char *)s.num);
                s.num[0] = 0x2A;
                s.num[1] = 0x2A;
                s.num[2] = 0x2A;
                sub_B4B88(0xF9, 1, (unsigned char *)s.num);
                s.num[0] = 0x3F;
                s.num[1] = 0x3F;
                s.num[2] = 0x3F;
                sub_B4B88(0xFA, 1, (unsigned char *)s.num);
                SetDialogColors(0xF9, 0xFA, 0xF8, 0xFA, 0);
                if (dword_DDD3C) {
                    err = CheckLeagueDiskSync((char *)&curleague, (char *)leagueteams, dword_DDD34, -1, -1);
                    if (!err) {
                        sprintf(s.num, (char *)str_02d, dword_DDD34);
                        strcpy((char *)str_Xx, s.num);
                        strcpy((char *)savleague2, (lgteamflags[dword_DDD34 * 30] & 1) && s.picked ?
                            (char *)&curleague : (char *)&str_floppydrv);
                    }
                }
                if (!err) {
                    MakePath(s.path, (char *)savleague1, (char *)leaguedbnames[6], (char *)str_extxx);
                    err = FileOpenRW(s.path, &s.fhsched1);
                    if (dword_DDD3C && !err) {
                        MakePath(s.path, (char *)savleague2, (char *)leaguedbnames[6], (char *)str_Xx);
                        err = FileOpenRW(s.path, &s.fhsched2);
                    }
                }
                if (!err) {
                    MessageBox(-1, -1, (char *)updschedmsg, 1, err, err, err, err, err);
                    s.zero = err;
                    s.info[0] = 0;
                }
                if (!err) {
                    MakePath(s.path, (char *)savleague1, (char *)str_PINFO, (char *)str_extDB);
                    err = FileOpenWrite(s.path, &s.fhinfo);
                }
                if (!err) err = FileWriteAt(s.fhinfo, &s.zero, 4, 2);
                if (!err) err = FileWriteAt(s.fhinfo, s.info, 6, 0xD);
                FileClose(&s.fhinfo);
                if (dword_DDD3C) {
                    if (!err) {
                        MakePath(s.path, (char *)savleague2, (char *)str_PINFO, (char *)str_extDB);
                        err = FileOpenWrite(s.path, &s.fhinfo);
                    }
                    if (!err) err = FileWriteAt(s.fhinfo, &s.zero, 4, 2);
                    if (!err) err = FileWriteAt(s.fhinfo, s.info, 6, 0xD);
                    FileClose(&s.fhinfo);
                }
                if (!err) err = WriteSchedGame(s.fhsched1, &byte_DDD40, lggameidx);
                if (!err && dword_DDD3C) err = WriteSchedGame(s.fhsched2, &byte_DDD40, lggameidx);
                if (!err) {
                    if (lggameidx >= 0x444) {
                        MakePath(s.path, (char *)savleague1, (char *)leaguedbnames[4], (char *)str_extxx);
                        err = FileOpenRW(s.path, &s.fhteam1);
                        if (!err) err = UpdatePlayoffSeries(s.fhsched1, s.fhteam1, lggameidx);
                        FileClose(&s.fhteam1);
                        if (!err && dword_DDD3C) {
                            MakePath(s.path, (char *)savleague2, (char *)leaguedbnames[4], (char *)str_Xx);
                            err = FileOpenRW(s.path, &s.fhteam2);
                            if (!err) err = UpdatePlayoffSeries(s.fhsched2, s.fhteam2, lggameidx);
                            FileClose(&s.fhteam2);
                        }
                    } else {
                        if (++lggameidx > word_DDD48) err = FileWriteAt(s.fhsched1, &lggameidx, 0, 2);
                        if (!err && dword_DDD3C && lggameidx > word_DDD4A)
                            err = FileWriteAt(s.fhsched2, &lggameidx, 0, 2);
                    }
                }
                if (!err) {
                    err = UpdateSeasonSchedule((char *)savleague1, (char *)str_extxx, lggameidx - 1, leagueteams,
                        lgplayteam, 2);
                    if (!err)
                        err = PostGameToTeamDb((char *)savleague1, (char *)str_extxx, lgplayteam, s.side, s.game,
                            (char *)savleague1);
                    if (!err) {
                        if (dword_DDD3C) {
                            err = UpdateSeasonSchedule((char *)savleague2, (char *)str_Xx, lggameidx, leagueteams,
                                dword_DDD34, 2);
                            if (!err)
                                err = PostGameToTeamDb((char *)savleague2, (char *)str_Xx, dword_DDD34, other, s.game,
                                    (char *)savleague1);
                        } else
                            err = PostGameToTeamDb((char *)savleague1, (char *)str_extxx, dword_DDD34, other, s.game,
                                (char *)savleague1);
                    }
                }
                RestoreDialogBg();
                sub_B392C(0);
            }
            if (err && !s.pwfail && err != 4) {
                sub_B2DCA(&s.btn, &s.my, &s.mx);
                MessageBox(-1, -1, (char *)unk_C7805, 1, 0, 0, (int)&s.my, (int)&s.mx, -1);
            }
            if (dword_DDD3C) FileClose(&s.fhsched2);
            FileClose(&s.fhsched1);
        }
        s.pal2 = (unsigned char *)sub_8CCA8((char *)str_Temp5, 0x300, 0x20);
        if (musicon && songdata) sub_8FCDF(musichandle, 3, 0x64);
        sub_8FFB0(0, 0x100, s.pal2);
        FadePalStep(1, s.pal2, 0x10);
        FreeMemBlock((int)s.pal2);
        if (musicon && songdata) {
            do
                slot = musicslot;
            while (sub_8FC8A(slot, 3) == 0);
            sub_8D2F0(songdata);
            songdata = 0;
        }
        InputInstall();
        s.again = -1;
        if (err == 4) err = 0;
        MakePath(s.path, (char *)&curleague, (char *)str_GAME, (char *)str_SAV);
    } while (lggameidx >= 0 && !err && !FileExists(s.path));
done:
    sub_B2E1B(0, 0, 0x280, 0x1E0);
}
