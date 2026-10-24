/* Schedule: creating a new league. */
#define CreateNewLeague CreateNewLeague_decl
#define LeagueTeamSelect LeagueTeamSelect_decl
#define CopyHumanTeamDBs CopyHumanTeamDBs_decl
#define RandomizeSchedule RandomizeSchedule_decl
#define WriteLeagueInfo WriteLeagueInfo_decl
#include "nhl95.h"
#undef CreateNewLeague
#undef LeagueTeamSelect
#undef CopyHumanTeamDBs
#undef RandomizeSchedule
#undef WriteLeagueInfo

int LeagueTeamSelect(char *dir, int *count, unsigned char *names, unsigned char *teams, int mode, char *title,
    int *sel);
int CopyHumanTeamDBs(char *dir, void *teams, int which);
int RandomizeSchedule(char *dir, int shuffle);
int mkdir(const char *path);  /* Watcom CRT mkdir_ */
int WriteLeagueInfo(char *dir, void *teams, char *pw, int master, int humans, int flags, int saved, char *name);

/* DRAFT: 1203 vs 1203, one byte register off (`xor bl, bl` for the original's `xor dh, dh` in lgstate[4] = 0);
   see docs/UNSURE.md. The name test guards the body as one if block (same code as the old `goto done`). */
/* CreateNewLeague (44DCF, PC only): create a league. Reset the 26 team records (names cleared, flags 1, 0, 2, 0,
   version 0), ask for the league name (up to 8 characters; .LP is added, it becomes curleague), offer to replace
   an existing league of that name, ask which schedule (s.ans) and which database (AskDatabaseChoice), need 2 KB
   free and make the directory. Then read the team names, let the player pick the human teams, size the
   seven databases (dword_C8D06, copied for each of the 26 teams), clear dword_C9002 when GAMESET exists and
   check the space (DiskSpaceShort from entry B6h, 7 entries earlier per team whose bytes 17h and 18h are 1);
   with teams picked, write the league info, copy the seven databases, write the mode state, make the schedule
   (RandomizeSchedule) and copy the human teams' databases. On an error say so; on an error or no teams remove the directory and clear
   lgstate byte 4. The dialog colours are set for the dialogs and back after. */
void CreateNewLeague(void)
{
    struct {
        char ft[0x2C];
        char path[0x20];
        char name[0x10];
        int sel;
        int y;
        int x;
        int r;
        int ans;
    } s;
    int err;
    int quit;
    int sz;
    int j;

    SetDialogColors(0xF9, 0xFA, 0xF8, 0xFA, 0);
    err = 0;
    quit = 0;
    s.r = 0;
    do {
        memset(leagueteams + s.r * 30, 0, 0xB);
        memset(leagueteams + s.r * 30 + 0xB, 0, 0xB);
        lgteamflags[s.r * 30] = 1;
        lgteam_17[s.r * 30] = 0;
        lgteam_18[s.r * 30] = 2;
        lgteam_19[s.r * 30] = 0;
        *(int *)((char *)lgteamver + s.r * 30) = 0;
    } while (++s.r < 0x1A);
    j = TextInputDialog((char *)str_EnterLeagueName, s.name, 8, 0x30, 0, 0, 0, 0, 5);
    s.r = j;
    if (s.name[0] && j != 0x1B) {
        sub_B2DCA(&s.r, &s.x, &s.y);
        strcat(s.name, (char *)str_extLP);
        strcpy((char *)&curleague, s.name);
        if (!unknown_libname_1(s.name, 0x10, s.ft)) {
            s.ans = MessageBox(-1, -1, (char *)msg_LeagueExists, 2, (int)btn_LeagueExists, 2, (int)&s.x, (int)&s.y, -1);
            if (s.ans == 1)
                DeleteDir(s.name);
            else
                quit = 1;
        }
        if (!quit && (s.ans = MessageBox(-1, -1, (char *)msg_WhichSchedule, 1, (int)btn_WhichSchedule, 2, (int)&s.x, (int)&s.y, -1)) == -1)
            quit = -1;
        if (!quit && AskDatabaseChoice() == -1) quit = -1;
        if (!quit) {
            if ((int)DiskFreeBytes(0) < 0x800) {
                MessageBox(-1, -1, (char *)msg_DiskFull, 1, 0, 0, (int)&s.x, (int)&s.y, 0x1F4);
                err = 1;
            } else {
                err = mkdir(s.name);
            }
        }
        if (!quit && !err) {
            MakePath(s.path, 0, (char *)leaguedbnames[4], (char *)str_extDB);
            err = ReadTeamNames(s.path, (char *)treeteamnames, 1);
            if (!err) {
                LeagueTeamSelect((char *)&curleague, &humancount, treeteamnames, leagueteams, 1, (char *)str_SelHumanTeams, &s.sel);
                sz = 0xB6;
                for (; quit < 0x1A; quit++) {
                    if (lgteam_17[quit * 30] == 1 && lgteam_17[quit * 30] == lgteam_18[quit * 30]) sz -= 7;
                }
                GetLeagueDBSizes(0, dword_C8D06, (char *)dbextension);
                for (quit = 0; quit < 7; quit++)
                    for (j = 1; j <= 0x1A; j++) dword_C8D06[j * 7 + quit] = dword_C8D06[quit];
                MakePath(s.path, (char *)&curleague, (char *)str_gameset, 0);
                if (FileExists(s.path)) dword_C9002 = 0;
                if ((j = DiskSpaceShort(0, dword_C8D06 + sz)) != 0) {
                    sprintf((char *)str_KbytesFreeLine, (char *)str_KbytesFree, j);
                    MessageBox(-1, -1, (char *)msg_NoDiskSpace, 3, 0, 0, (int)&s.x, (int)&s.y, 0x320);
                    err = 1;
                }
                if (!err && s.sel >= 0) {
                    MessageBox(-1, -1, (char *)msg_CreatingLeague, 1, 0, 0, 0, 0, 0);
                    err = WriteLeagueInfo((char *)&curleague, leagueteams, (char *)masterpw, leaguemaster, humancount,
                                          *(int *)&leagueflags, leaguesaved, (char *)&savedname);
                    for (s.r = 0; s.r < 7 && !err; s.r++)
                        err = CopyFile((char *)leaguedbnames[s.r], (char *)dbextension, (char *)str_extDB, 0, (char *)&curleague);
                    if (!err) {
                        WriteModeState(lgstate);
                        err = RandomizeSchedule((char *)&curleague, s.ans);
                    }
                    RestoreDialogBg();
                    if (!err) err = CopyHumanTeamDBs((char *)&curleague, leagueteams, -1);
                }
            }
        }
        if (err || s.sel < 0) {
            if (err) {
                sub_B2DCA(&s.r, &s.x, &s.y);
                MessageBox(-1, -1, (char *)msg_CreateError, 1, 0, 0, (int)&s.x, (int)&s.y, -1);
            }
            ((unsigned char *)lgstate)[4] = 0;
            DeleteDir(s.name);
        }
    }
    SetDialogColors(0x2A, 0x3F, 0x17, 0x3F, 0);
}
