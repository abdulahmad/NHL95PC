/* Create player: finding a player by name. */
#define ListDialog ListDialog_decl
#include "nhl95.h"
#undef ListDialog

int ListDialog(char **items, int n, char *title, int a, int b, char *buf);

/* FindPlayer (71961, PC only): the roster editor's "find" button. Ask for a player's name, split it into first
   and last name (lower case) and collect the teams whose roster has a match (last name and first name, or the
   last name alone when no first name was given), then the free-agent list (team 64h). None: say so. Several:
   let the player pick the team (ListDialog with the team cities). Then show that team in the current list (side
   0, or 1 when *mode is not 1), unless the other list already shows it (say so; for a team, switch to the
   other list), select the matching players and redraw, and enable the move-to-free-agents / move-to-other-
   roster buttons of that list when players are selected (else clear them). x, y: where the message boxes go. */
void FindPlayer(int *mode, int *x, int *y)
{
    struct {
        char *names[0x1C];
        char buf[0x70];
        int found[0x1B];
        char name[0x20];
        char first[0x10];
        char rfirst[0x10];
        char rlast[0x10];
        char last[0x10];
        int other;
        int team;
        int side;
    } s;
    int n;
    int t;
    unsigned char *rec;
    int i;
    unsigned char *k;
    int j;
    unsigned char *p;

    s.side = *mode != 1;
    s.other = !s.side;
    s.name[0] = 0;
    msglines[0] = (int)str_EnterNameOfPlayer;
    InputDialog(msglines, 1, s.name, 0x1F, 0xBA, 0, 0, 0, 0);
    strlwr(s.name);
    SplitPlayerName(s.name, s.last, s.first);
    if (!s.first[0] && !s.last[0]) return;
    n = 0;
    for (t = 0; t < 0x1A; t++) {
        rec = TeamRecPtr(t);
        s.found[n] = -1;
        for (i = 0; i < 0x1C && s.found[n] < 0; i++) {
            k = KeyDbPtr(((int *)(rec + 0x4C))[i]);
            strcpy(s.rfirst, (char *)k + 3);
            strcpy(s.rlast, (char *)k + 0x13);
            strlwr(s.rfirst);
            strlwr(s.rlast);
            if (!strcmp(s.last, s.rfirst) && !strcmp(s.first, s.rlast) || !s.first[0] && !strcmp(s.last, s.rlast)) {
                s.found[n] = t;
                n++;
            }
        }
    }
    t = (unsigned)keydb_size / 0x34;
    s.found[n] = -1;
    for (j = 0; j < t && s.found[n] < 0; j++) {
        p = keydb + j * 0x34;
        if (*p == 0xFF) {
            strcpy(s.rfirst, (char *)p + 3);
            strcpy(s.rlast, (char *)p + 0x13);
            strlwr(s.rfirst);
            strlwr(s.rlast);
            if (!strcmp(s.last, s.rfirst) && !strcmp(s.first, s.rlast) || !s.first[0] && !strcmp(s.last, s.rlast)) {
                s.found[n] = 0x64;
                n++;
            }
        }
    }
    if (n > 0) {
        if (n > 1) {
            for (i = 0, t = 0; t < n; i++, t++) {
                if (s.found[t] == 0x64) s.names[i] = (char *)str_FreeAgentList;
                else if (s.found[t] < 0x1A) s.names[i] = (char *)teamcitynames[s.found[t]];
            }
            s.team = s.found[ListDialog(s.names, n, (char *)str_ChooseWhichTeamTo, 0, 0, s.buf)];
        } else {
            s.team = s.found[0];
        }
        if (s.team == 0x64) {
            if (rosterisfa[s.other] == 1) {
                msglines[0] = (int)s.name;
                msglines[1] = (int)str_IsAlreadyDisplayedOn;
                msglines[2] = !s.side ? (int)str_Roster2 : (int)str_Roster1;
                MessageBox(-1, -1, (char *)msglines, 3, 0, 0, (int)x, (int)y, -1);
            } else if (rosterisfa[s.side] != 1) {
                SetRosterTeamMenus(s.side, s.team);
                rosterisfa[s.side] = 1;
                LoadRosterList(s.side);
                rosterteam[s.side] = 0xFF;
            }
        } else if (rosterteam[s.other] == s.team) {
            msglines[0] = (int)s.name;
            msglines[1] = (int)str_IsAlreadyDisplayedOn;
            msglines[2] = !s.side ? (int)str_Roster2 : (int)str_Roster1;
            MessageBox(-1, -1, (char *)msglines, 3, 0, 0, (int)x, (int)y, -1);
            s.side = s.other;
        } else if (rosterteam[s.side] != s.team) {
            SetRosterTeamMenus(s.side, s.team);
            rosterisfa[s.side] = 0;
            rosterteam[s.side] = s.team;
            LoadRosterList(s.side);
        }
        SelectMatchingPlayers(s.last, s.first, s.side);
        DrawEditRosters();
        if (CountSelected(rosterisfa[s.side] == 1 ? (char *)falistsel : (char *)rostersel + s.side * 28) > 0) {
            if (s.side == 0) {
                if (rosterisfa[0] != 1 && facount < 0x1E) menu_r1_tofa = (int)MoveToFreeAgents;
                if (rosterisfa[1] != 1) menu_r1_toroster2 = (int)MoveToOtherRoster;
            } else {
                if (rosterisfa[1] != 1 && facount < 0x1E) menu_r2_tofa = (int)MoveToFreeAgents;
                if (rosterisfa[0] != 1) menu_r2_toroster1 = (int)MoveToOtherRoster;
            }
        } else if (s.side == 0) {
            menu_r1_tofa = s.side;
            menu_r1_toroster2 = s.side;
        } else {
            menu_r2_tofa = 0;
            menu_r2_toroster1 = 0;
        }
    } else {
        msglines[0] = (int)s.name;
        msglines[1] = (int)str_DoesNotExist;
        MessageBox(-1, -1, (char *)msglines, 2, 0, 0, (int)x, (int)y, -1);
    }
}
