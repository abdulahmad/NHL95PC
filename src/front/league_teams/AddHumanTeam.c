/* Trades: adding a human team to a league. */
#define AddHumanTeam AddHumanTeam_decl
#define RemoveHumanTeam RemoveHumanTeam_decl
#define LeagueCheckStub LeagueCheckStub_decl
#define LeagueTeamSelect LeagueTeamSelect_decl
#define CopyHumanTeamDBs CopyHumanTeamDBs_decl
#include "nhl95.h"
#undef AddHumanTeam
#undef RemoveHumanTeam
#undef LeagueCheckStub
#undef LeagueTeamSelect
#undef CopyHumanTeamDBs

int LeagueCheckStub(char *dir, int mode);
int LeagueTeamSelect(char *dir, int *count, unsigned char *names, unsigned char *teams, int mode, char *title,
    int *sel);
int CopyHumanTeamDBs(char *dir, void *teams, int which);

/* AddHumanTeam (408F5, PC only; owner of AddHumanTeam_exit / AddHumanTeam_msgbox): let one more team of the
   current league be human controlled. Read the league (LeagueCheckStub, ReadLeagueInfo); a league with a saved
   game in progress says so (msg_SavedGame) and stops; one not merged yet asks (msg_MasterDB) and merges
   (MergeLeagueFiles) before reading it again. With byte_DE268 set the desk palette (EASNDESK, BANGPAL) and the
   three dialog colours are restored. With all 1Ah teams human say so (msg_AllHuman); else pick the new human
   team (LeagueTeamSelect over the team names) and, when one was added, write the league info and copy the
   human teams' databases (CopyHumanTeamDBs). No arguments, no result. */
void AddHumanTeam(void)
{
    struct {
        char path[0x20];
        char name[0x10];
        int x;
        int y;
        int btn;
        int sel;
        unsigned char rgb[4];
    } s;
    int err;
    int shown;
    int bank;
    int n;

    byte_DE268 = 0;
    err = LeagueCheckStub((char *)&curleague, 2);
    do {
        shown = 0;
        if (!err)
            err = ReadLeagueInfo((char *)&curleague, leagueteams, (char *)masterpw,
                (short *)&leaguemaster, &humancount, &leagueflags, &leaguesaved, (char *)&savedname);
        if (!err) {
            strcpy(s.name, (char *)&curleague);
            s.name[_fstrcspn(s.name, (char *)&str_dot)] = 0;
            sub_B2DCA(&s.btn, &s.y, &s.x);
            SetDialogColors(0xF9, 0xFA, 0xF8, 0xFA, err);
            if (leaguesaved) {
                msg_SavedGame_arg = (int)s.name;
                MessageBox(-1, -1, (char *)msg_SavedGame, 3, err, err, (int)&s.y, (int)&s.x, -1);
                err = -1;
            } else if ((leagueflags & 4) == 0) {
                msg_MasterDB_arg = (int)s.name;
                s.btn = MessageBox(-1, -1, (char *)msg_MasterDB, 4, (int)btn_MasterDB, 2,
                    (int)&s.y, (int)&s.x, -1);
                if (!s.btn) {
                    MergeLeagueFiles();
                    shown = -1;
                } else
                    err = -1;
            }
        }
    } while (shown);
    if (byte_DE268) {
        sub_B392C(shown);
        MakePath(s.path, fileoncd[0x6A] == 1 ? (char *)cddriveptr : 0, (char *)str_easndesk, 0);
        bank = sub_8E83C(s.path, 0);
        sub_B4B88(0, 0x100, (unsigned char *)sub_B30B4(bank, (char *)str_bangpal) + 0x10);
        FreeMemBlock(bank);
        s.rgb[2] = s.rgb[1] = s.rgb[0] = 0x17;
        sub_B4B88(0xF8, 1, s.rgb);
        s.rgb[2] = s.rgb[1] = s.rgb[0] = 0x2A;
        sub_B4B88(0xF9, 1, s.rgb);
        s.rgb[2] = s.rgb[1] = s.rgb[0] = 0x3F;
        sub_B4B88(0xFA, 1, s.rgb);
    }
    if (err) return;
    if (humancount < 0x1A) {
        n = humancount;
        MakePath(s.path, (char *)&curleague, (char *)leaguedbnames[4], (char *)str_extDB);
        ReadTeamNames(s.path, (char *)treeteamnames, 1);
        LeagueTeamSelect((char *)&curleague, &humancount, treeteamnames, leagueteams, 2, (char *)str_SelNewHuman,
            &s.sel);
        if (s.sel < 0) return;
        if (n == humancount) return;
        if (((int (*)(char *, void *, char *, int, int, int, int, char *))WriteLeagueInfo)((char *)&curleague,
            leagueteams, (char *)masterpw, leaguemaster, humancount, *(int *)&leagueflags, leaguesaved,
            (char *)&savedname)) return;
        CopyHumanTeamDBs((char *)&curleague, leagueteams, -1);
    } else {
        sub_B2DCA(&s.btn, &s.y, &s.x);
        MessageBox(-1, -1, (char *)msg_AllHuman, 1, err, err, (int)&s.y, (int)&s.x, -1);
    }
}

/* RemoveHumanTeam (40C29, PC only; ends in AddHumanTeam_exit / AddHumanTeam_msgbox): let one human team of the
   current league go back to the computer, the reverse of AddHumanTeam: read (and if needed merge) the league
   the same way, then with more than one human team pick the team to remove (LeagueTeamSelect) and write the
   league info when one was removed; with only one say so (msg_OneHuman). No arguments, no result. */
void RemoveHumanTeam(void)
{
    struct {
        char path[0x20];
        char name[0x10];
        int x;
        int y;
        int sel;
        int btn;
        unsigned char rgb[4];
    } s;
    int err;
    int shown;
    int bank;
    int n;

    byte_DE268 = 0;
    err = LeagueCheckStub((char *)&curleague, 2);
    do {
        shown = 0;
        if (!err)
            err = ReadLeagueInfo((char *)&curleague, leagueteams, (char *)masterpw,
                (short *)&leaguemaster, &humancount, &leagueflags, &leaguesaved, (char *)&savedname);
        if (!err) {
            strcpy(s.name, (char *)&curleague);
            s.name[_fstrcspn(s.name, (char *)&str_dot)] = 0;
            sub_B2DCA(&s.btn, &s.y, &s.x);
            SetDialogColors(0xF9, 0xFA, 0xF8, 0xFA, err);
            if (leaguesaved) {
                msg_SavedGame_arg = (int)s.name;
                MessageBox(-1, -1, (char *)msg_SavedGame, 3, err, err, (int)&s.y, (int)&s.x, -1);
                err = -1;
            } else if ((leagueflags & 4) == 0) {
                msg_MasterDB_arg = (int)s.name;
                s.btn = MessageBox(-1, -1, (char *)msg_MasterDB, 4, (int)btn_MasterDB, 2,
                    (int)&s.y, (int)&s.x, -1);
                if (!s.btn) {
                    MergeLeagueFiles();
                    shown = -1;
                } else
                    err = -1;
            }
        }
    } while (shown);
    if (byte_DE268) {
        sub_B392C(shown);
        MakePath(s.path, fileoncd[0x6A] == 1 ? (char *)cddriveptr : 0, (char *)str_easndesk, 0);
        bank = sub_8E83C(s.path, 0);
        sub_B4B88(0, 0x100, (unsigned char *)sub_B30B4(bank, (char *)str_bangpal) + 0x10);
        FreeMemBlock(bank);
        s.rgb[2] = s.rgb[1] = s.rgb[0] = 0x17;
        sub_B4B88(0xF8, 1, s.rgb);
        s.rgb[2] = s.rgb[1] = s.rgb[0] = 0x2A;
        sub_B4B88(0xF9, 1, s.rgb);
        s.rgb[2] = s.rgb[1] = s.rgb[0] = 0x3F;
        sub_B4B88(0xFA, 1, s.rgb);
    }
    if (err) return;
    if (humancount > 1) {
        n = humancount;
        MakePath(s.path, (char *)&curleague, (char *)leaguedbnames[4], (char *)str_extDB);
        ReadTeamNames(s.path, (char *)treeteamnames, 1);
        LeagueTeamSelect((char *)&curleague, &humancount, treeteamnames, leagueteams, 4,
            (char *)str_SelRemoveHuman, &s.sel);
        if (s.sel < 0) return;
        if (n == humancount) return;
        ((int (*)(char *, void *, char *, int, int, int, int, char *))WriteLeagueInfo)((char *)&curleague,
            leagueteams, (char *)masterpw, leaguemaster, humancount, *(int *)&leagueflags, leaguesaved,
            (char *)&savedname);
    } else {
        SetDialogColors(0xF9, 0xFA, 0xF8, 0xFA, err);
        sub_B2DCA(&s.btn, &s.y, &s.x);
        MessageBox(-1, -1, (char *)msg_OneHuman, 2, err, err, (int)&s.y, (int)&s.x, -1);
    }
}
