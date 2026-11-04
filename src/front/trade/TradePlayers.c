/* Trades: the trade players menu entry. */
#define negone_3DC28 negone_3DC28_decl
#define ExecuteTrade ExecuteTrade_decl
#include "nhl95.h"
#undef negone_3DC28
#undef ExecuteTrade

extern int negone_3DC28;  /* 3DC28: a -1 dword in the code segment */
int ExecuteTrade(char *dir, int *teams, unsigned char *sel);
unsigned strcspn(const char *s, const char *set);  /* Watcom CRT strcspn_ */

typedef struct { char c[6]; } Str6;

/* DRAFT: 1551 vs 1551, 359 of 361 instructions: the second city-name index load uses edx where the EXE uses
   eax (the city name through the nm local put the first one in edx, as in the EXE); see docs/UNSURE.md. */
/* TradePlayers (40183, PC only): trade players between two teams of the current league. Make the 640 x 480
   trade bitmap (dword_DE264) and use the trade screen's dialog colours. Read the league (as AddHumanTeam: a
   saved game in progress stops it, an unmerged league is merged first after asking); then read the schedule's
   game count and the next game: past the trade deadline (a 3 / 16h+ or 4-9 game, or 444h games played) say so.
   With one human team say trading needs two. Else pick the two teams (LeagueTeamSelect), check both passwords,
   show the trade screen (TradeScreen, with "Show <city> Statistics" buttons as wide as the wider label) and do
   the trade (ExecuteTrade); a failed trade says so. Then restore the dialog colours and free the bitmap. */
void TradePlayers(void)
{
    struct {
        char msg1[0x34];
        char msg2[0x34];
        char path[0x20];
        char name[0x10];
        int sel[2];
        unsigned char game[8];
        int btn;
        int negone;
        int y;
        int x;
        int fh;
        int fill;
        int bev1;
        int edge3;
        int edge2;
        int edge1;
        int bev2;
        short ngames;
        short pad;
    } s;
    int err;
    int again;
    int r;
    char *nm;

    s.fh = -1;
    err = 0;
    s.negone = negone_3DC28;
    dword_DE264 = sub_B4F8C(0x280, 0x1E0, err);
    s.fill = dlgfillcol;
    s.edge1 = dlgedgecol1;
    s.edge2 = dlgedgecol2;
    s.edge3 = dlgedgecol3;
    s.bev1 = dlgbevelcol1;
    s.bev2 = dlgbevelcol2;
    dlgfillcol = 0x41;
    dlgedgecol1 = 0x40;
    dlgedgecol2 = 0x42;
    dlgedgecol3 = 0x41;
    dlgbevelcol1 = 0x40;
    dlgbevelcol2 = 0x41;
    do {
        again = 0;
        if (!err)
            err = ReadLeagueInfo((char *)&curleague, leagueteams, (char *)masterpw, (short *)&leaguemaster, &humancount,
                &leagueflags, &leaguesaved, (char *)&savedname);
        if (!err) {
            SetDialogColors(0xF9, 0xFA, 0xF8, 0xFA, 0xF7);
            sub_B2DCA(&s.btn, &s.x, &s.y);
            strcpy(s.name, (char *)&curleague);
            s.name[strcspn(s.name, (char *)&str_dot)] = 0;
            if (leaguesaved) {
                msg_SavedGame_arg = (int)s.name;
                MessageBox(-1, -1, (char *)msg_SavedGame, 3, err, err, (int)&s.x, (int)&s.y, -1);
                err = -1;
            } else if (!(leagueflags & 4)) {
                msg_MasterDB_arg = (int)s.name;
                s.btn = MessageBox(-1, -1, (char *)msg_MasterDB, 4, (int)btn_MasterDB, 2, (int)&s.x, (int)&s.y, -1);
                if (s.btn) {
                    err = -1;
                } else {
                    MergeLeagueFiles();
                    again = -1;
                }
            } else {
                MakePath(s.path, (char *)&curleague, (char *)leaguedbnames[4], (char *)str_extDB);
                err = ReadTeamNames(s.path, (char *)treeteamnames, 1);
            }
        }
    } while (again);
    if (!err) {
        MakePath(s.path, (char *)&curleague, (char *)leaguedbnames[6], (char *)str_extDB);
        err = FileOpenRW(s.path, &s.fh);
        if (!err) err = FileReadAt(s.fh, &s.ngames, 0, 2);
        if (!err && s.ngames < 0x4AD) err = ReadSchedGame(s.fh, s.game, s.ngames);
        FileClose(&s.fh);
        if (!err && (s.game[0] == 3 && s.game[1] >= 0x16 || s.game[0] > 3 && s.game[0] < 0xA || s.ngames >= 0x444)) {
            sub_B2DCA(&s.btn, &s.x, &s.y);
            SetDialogColors(0xF9, 0xFA, 0xF8, 0xFA, 0xF7);
            sub_B2DCA(&s.btn, &s.x, &s.y);
            MessageBox(-1, -1, (char *)msg_TradeDeadline, 2, 0, 0, (int)&s.x, (int)&s.y, -1);
            err = -1;
        }
        if (!err) {
            if (humancount == 1) {
                SetDialogColors(0xF9, 0xFA, 0xF8, 0xFA, 0xF7);
                sub_B2DCA(&s.btn, &s.x, &s.y);
                MessageBox(-1, -1, (char *)msg_OneHuman, 2, err, err, (int)&s.x, (int)&s.y, -1);
            } else {
                LeagueTeamSelect((char *)&curleague, &humancount, treeteamnames, leagueteams, 0x10,
                    (char *)str_SelTradeTeams, s.sel);
                if (s.sel[0] >= 0 && s.sel[1] >= 0) {
                    r = AskTeamPassword(s.sel[0], (char *)leagueteams);
                    if (!r) r = AskTeamPassword(s.sel[1], (char *)leagueteams);
                    if (!r) {
                        *(Str6 *)s.msg1 = *(Str6 *)str_Show;
                        nm = (char *)teamcitynames[s.sel[0]];
                        strcat(s.msg1, nm);
                        strcat(s.msg1, (char *)str_Statistics);
                        dword_C87C8 = (int)s.msg1;
                        *(Str6 *)s.msg2 = *(Str6 *)str_Show;
                        nm = (char *)teamcitynames[s.sel[1]];
                        strcat(s.msg2, nm);
                        strcat(s.msg2, (char *)str_Statistics);
                        dword_C87E8 = (int)s.msg2;
                        s.x = fputchar(s.msg1);
                        s.y = fputchar(s.msg2);
                        dword_C87C0 = dword_C87E0 = (s.y < s.x ? s.x : s.y) + 6;
                        r = TradeScreen((char *)&curleague, s.sel, (int)&s.negone, (int)btn_TradeStats, 3);
                    }
                    if (!r) err = ExecuteTrade((char *)&curleague, s.sel, (unsigned char *)&s.negone);
                }
                if (err) {
                    sub_B2DCA(&s.btn, &s.x, &s.y);
                    MessageBox(-1, -1, (char *)msg_TradeError, 1, 0, 0, (int)&s.x, (int)&s.y, -1);
                }
            }
        }
    }
    dlgfillcol = s.fill;
    dlgedgecol1 = s.edge1;
    dlgedgecol2 = s.edge2;
    dlgedgecol3 = s.edge3;
    dlgbevelcol1 = s.bev1;
    dlgbevelcol2 = s.bev2;
    FreeMemBlock(dword_DE264);
}
