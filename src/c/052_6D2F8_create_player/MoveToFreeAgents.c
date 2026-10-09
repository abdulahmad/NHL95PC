/* MoveToFreeAgents - roster editor: for every player selected in the current list (side 0, or 1 when *mode is not
   3; rostersel, 28 per side) while the free agent list has room (facount < 30), ask "Move <initial> <last name> to
   free agent list?" at *x/*y; on yes mark the key record (first byte FFh) and remove him from his team (team < 1Ah).
   If not all selected players fit say there is not enough space. After a move the database is dirty and the lists
   (and the other side when it is the free agent list) are reloaded and redrawn. */
#include "nhl95.h"

void MoveToFreeAgents(int *mode, int *x, int *y)
{
    char name[32];
    int ntried;
    int moved;
    int nsel;
    int other;
    int key;
    int side;
    int i;
    unsigned char *p;

    moved = 0;
    nsel = 0;
    ntried = 0;
    side = *mode != 3;
    other = *mode == 3;
    for (i = 0; i < 0x1C; i++) {
        if (!rostersel[side * 28 + i]) continue;
        nsel++;
        if (facount >= 0x1E) continue;
        ntried++;
        key = *(int *)((char *)dword_EA994 + side * 0x2F4 + i * 27);
        p = KeyDbPtr(key);
        msglines[0] = (int)str_Move;
        strcpy(name, (char *)p + 3);
        strcat(name, (char *)&str_space);
        strcat(name, (char *)p + 0x13);
        msglines[1] = (int)name;
        msglines[2] = (int)str_ToFreeAgentList;
        if (MessageBox(-1, -1, (char *)msglines, 3, (int)btn_LeagueExists, 2, (int)x, (int)y, -1) != 1) continue;
        moved = 1;
        if (rosterteam[side] >= 0x1A) continue;
        p[0] = 0xFF;
        RemovePlayerFromTeam(rosterteam[side], key);
    }
    if (nsel != ntried) {
        msglines[0] = (int)str_NotEnoughSpaceFA;
        msglines[1] = (int)str_InTheFreeAgent;
        msglines[2] = (int)str_ForAllSelectedPlayers;
        MessageBox(-1, -1, (char *)msglines, 3, 0, 0, (int)x, (int)y, -1);
    }
    if (moved) {
        dbdirty = 1;
        LoadRosterList(side);
        if (rosterisfa[other] == 1) LoadRosterList(other);
        DrawEditRosters();
    }
}
