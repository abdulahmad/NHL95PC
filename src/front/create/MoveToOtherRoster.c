/* Roster editor: moving the selected players to the other list's team. */
#define FixJerseyNumber FixJerseyNumber_decl
#include "nhl95.h"
#undef FixJerseyNumber

void FixJerseyNumber(int side, int i);

/* MoveToOtherRoster (6F29C, PC only): the roster editor's "move" button. For every selected player of the
   current list (side 0, or 1 when *mode is not 3; the team's rostersel flags, or falistsel when that side shows
   the free agents) find a free slot in the other side's team record: one of the three goalie slots (19h-1Bh)
   for a 'G', else one of the 19h skater slots (+4Ch key numbers, -1 when free). Give the key record that team,
   store the key number in the slot, mark the slot's list entry new (rosterstat 2) and, for a team player,
   remove him from his old team. For each player of the new team wearing his jersey number, set the jersey and
   slot of list entry 1Ch - moved and let FixJerseyNumber pick a new number. If not every selected player found
   a slot, say so at *x / *y (one player or several). After a move the database is dirty and both lists are
   reloaded and redrawn. */
void MoveToOtherRoster(int *mode, int *x, int *y)
{
    int off;
    int moved;
    int src;
    int nsel;
    int key;
    int i;
    int slot;
    int dst;
    int nmoved;
    int j;
    int k;
    unsigned char *p;
    int entry;

    src = *mode != 3;
    dst = !src;
    moved = 0;
    nsel = 0;
    nmoved = 0;
    if (!rosterisfa[src]) {
        i = 0;
        for (; i < 0x1C; i++) {
            if (!rostersel[src * 28 + i]) continue;
            nsel++;
            key = *(int *)((char *)dword_EA994 + src * 0x2F4 + i * 27);
            p = KeyDbPtr(key);
            slot = -1;
            if (rosterlist[src * 0x2F4 + i * 27] == 'G') {
                for (j = 0; j < 3 && slot < 0; j++)
                    if (((int *)(rosterteamrec[dst] + 0xB0))[j] == -1) slot = j + 0x19;
            } else {
                for (j = 0; j < 0x19 && slot < 0; j++)
                    if (((int *)(rosterteamrec[dst] + 0x4C))[j] == -1) slot = j;
            }
            if (slot < 0) continue;
            moved = -1;
            *p = rosterteam[dst];
            nmoved++;
            ((int *)(rosterteamrec[dst] + 0x4C))[slot] = key;
            rosterstat[dst * 0x2F4 + slot * 27] = 2;
            RemovePlayerFromTeam(rosterteam[src], key);
            for (j = 0; j < 0x1C; j++) {
                if (p[1] == KeyDbPtr(((int *)(rosterteamrec[dst] + 0x4C))[j])[1]) {
                    off = dst * 0x2F4;
                    entry = 0x1C - nmoved;
                    k = entry;
                    rosterjersey[off + k * 27] = p[1];
                    rosterslot[off + k * 27] = slot;
                    FixJerseyNumber(dst, k);
                }
            }
        }
    } else {
        for (i = 0; i < facount; i++) {
            if (!((unsigned char *)falistsel)[i]) continue;
            nsel++;
            key = *(int *)(falist + i * 27 + 4);
            p = KeyDbPtr(key);
            slot = -1;
            if (falist[i * 27] == 'G') {
                for (j = 0; j < 3 && slot < 0; j++)
                    if (((int *)(rosterteamrec[dst] + 0xB0))[j] == -1) slot = j + 0x19;
            } else {
                for (j = 0; j < 0x19 && slot < 0; j++)
                    if (((int *)(rosterteamrec[dst] + 0x4C))[j] == -1) slot = j;
            }
            if (slot < 0) continue;
            moved = -1;
            *p = rosterteam[dst];
            nmoved++;
            ((int *)(rosterteamrec[dst] + 0x4C))[slot] = key;
            rosterstat[dst * 0x2F4 + slot * 27] = 2;
            for (j = 0; j < 0x1C; j++) {
                if (p[1] == KeyDbPtr(((int *)(rosterteamrec[dst] + 0x4C))[j])[1]) {
                    off = dst * 0x2F4;
                    k = 0x1C - nmoved;
                    rosterjersey[off + k * 27] = p[1];
                    rosterslot[off + k * 27] = slot;
                    FixJerseyNumber(dst, k);
                }
            }
        }
    }
    if (nmoved != nsel) {
        if (nsel == 1) {
            msglines[0] = (int)str_ThereIsNoSpace;
            msglines[1] = (int)str_TheSelectedPlayer;
            MessageBox(-1, -1, (char *)msglines, 2, 0, 0, (int)x, (int)y, -1);
        } else {
            msglines[0] = (int)str_NotEnoughSpaceTo2;
            msglines[1] = (int)str_AddAllSelectedPlayers;
            MessageBox(-1, -1, (char *)msglines, 2, 0, 0, (int)x, (int)y, -1);
        }
    }
    if (moved) {
        dbdirty = 1;
        LoadRosterList(0);
        LoadRosterList(1);
        DrawEditRosters();
    }
}
