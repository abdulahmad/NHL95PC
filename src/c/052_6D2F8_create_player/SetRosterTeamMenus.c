/* Create player: roster menus. */
#include "nhl95.h"

/* SetRosterTeamMenus (7183D) - update side's roster menus when it switches to team: the old team (rosterteam[side]; FFh
   free agents) gets its menu item handler back (division menu item +14h = SelectRosterTeam, or ShowFreeAgents);
   the new team's item is disabled (handler 0) and "edit lines" is enabled for it (EditTeamLines). Team 64h (free
   agents) disables edit lines and the free agents items. Division index teamdivflags >> 1 (4 counts as 3). */
typedef struct MenuItem20 { int f[5]; int handler; int g[2]; } MenuItem20;  /* 20h-byte menu item, handler at +14h */

void SetRosterTeamMenus(int side, int team)
{
    int t;
    int d;
    int i;

    t = rosterteam[side];
    if (t == 0xFF) {
        menu_r2_freeagents = menu_r1_freeagents = (int)ShowFreeAgents;
    } else {
        d = teamdivflags[t] >> 1;
        if (d == 4) d--;
        for (i = 0; i < 7; i++) if (((unsigned char (*)[7])divisionteams)[d][i] == t) break;
        ((MenuItem20 *)roster1divmenus[d * 8])[i].handler = (int)SelectRosterTeam;
        ((MenuItem20 *)roster2divmenus[d * 8])[i].handler = (int)SelectRosterTeam;
    }
    if (team == 0x64) {
        if (!side) menu_r1_editlines = 0;
        else menu_r2_editlines = 0;
        menu_r2_freeagents = menu_r1_freeagents = 0;
        return;
    }
    d = teamdivflags[team] >> 1;
    if (d == 4) d--;
    for (i = 0; i < 7; i++) if (((unsigned char (*)[7])divisionteams)[d][i] == team) break;
    ((MenuItem20 *)roster1divmenus[d * 8])[i].handler = 0;
    ((MenuItem20 *)roster2divmenus[d * 8])[i].handler = 0;
    if (!side) menu_r1_editlines = (int)EditTeamLines;
    else menu_r2_editlines = (int)EditTeamLines;
}
