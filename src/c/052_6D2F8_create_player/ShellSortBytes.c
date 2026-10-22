/* Create player: sort records. */
#include "nhl95.h"

/* ShellSortBytes: shell sort n records of width bytes at base. cmp(left, right) < 0 leaves the pair; otherwise
 the records are swapped a byte at a time (xor). The gap starts at n/2 and halves. */
void ShellSortBytes(unsigned char *base, int n, int width, int (*cmp)(void *, void *))
{
    int gap;
    int i;
    int j;
    int k;
    unsigned char *b;
    unsigned char *a;
    unsigned char *p;

    p = base;
    for (gap = n >> 1; gap > 0; gap >>= 1) {
        for (i = gap; i < n; i++) {
            for (j = i - gap; j >= 0; j -= gap) {
                a = p + j * width;
                b = p + (j + gap) * width;
                if (cmp(a, b) < 0) break;
                for (k = 0; k < width; k++) {
                    a[k] ^= b[k];
                    b[k] ^= a[k];
                    a[k] ^= b[k];
                }
            }
        }
    }
}

/* DRAFT (first pass from Ghidra): the EXE splits it. Its body (LoadRosterList_fa, LoadRosterList_team) follows
   ShellSortBytes and its entry (6DE94) follows LoadBothRosterLists, which falls into it. */
/* LoadRosterList (6DE94, PC only): rebuild the roster list of side (0 left, 1 right) of the edit rosters screen.
   For the free agents (rosterisfa[side] 1): free the old lists, count the key database's free agents (team byte
   FFh), allocate the list (1Bh bytes each) and its selection bytes, fill (BuildFreeAgentList) and sort it by
   ComparePlayerEntry, clear the selections and set up the scroll bar when there are more than 28; the left side
   also clears its to-free-agent menu action. For a team: point rosterteamptr at its record (CarTeamRecPtr), build
   and sort its 28 entries (BuildTeamRosterList), clear the selections and set the move-to-other-roster menu
   action when the other side has a selection (CountSelected). No result. */
void LoadRosterList(int side)
{
    int i;

    if (rosterisfa[side] == 1) {
        if (falistsel) {
            FreeMemBlock(falistsel);
            falistsel = 0;
        }
        if (falist) {
            FreeMemBlock((int)falist);
            falist = 0;
        }
        facount = 0;
        for (i = 0; i < keydb_size / 0x34; i++)
            if ((signed char)keydb[i * 0x34] == -1) facount++;
        falist = (unsigned char *)sub_8CCA8((char *)str_Uar, facount * 0x1B, 0);
        falistsel = sub_8CCA8((char *)str_Uarm, facount, 0);
        BuildFreeAgentList();
        ShellSortBytes(falist, facount, 0x1B, (int (*)(void *, void *))ComparePlayerEntry);
        for (i = 0; i < facount; i++) ((char *)falistsel)[i] = 0;
        dword_EBCA4 = 0;
        if (facount < 0x1D) dword_D0C20 = 0;
        else {
            dword_D0C20 = -1;
            InitScrollBar((int *)unk_D0BF0, 0x1C, facount);
        }
        if (side) menu_r2_tofa = 0;
        else menu_r1_tofa = 0;
        menu_r1_toroster2 = 0;
        menu_r2_toroster1 = 0;
    } else {
        rosterteamptr[side] = (int)CarTeamRecPtr(rosterteam[side]);
        BuildTeamRosterList(rosterteam[side], rosterlist + side * 0x2F4, (unsigned char **)&rosterteamrec[side]);
        ShellSortBytes(rosterlist + side * 0x2F4, 0x1C, 0x1B, (int (*)(void *, void *))ComparePlayerEntry);
        for (i = 0; i < 0x1C; i++) rostersel[side * 0x1C + i] = 0;
        if (side == 0) {
            menu_r1_tofa = 0;
            menu_r1_toroster2 = 0;
            if (CountSelected(rosterisfa[1] == 1 ? (char *)falistsel : (char *)rostersel + 0x1C))
                menu_r2_toroster1 = (int)MoveToOtherRoster;
        } else {
            menu_r2_tofa = 0;
            menu_r2_toroster1 = 0;
            if (CountSelected(rosterisfa[0] == 1 ? (char *)falistsel : (char *)rostersel))
                menu_r1_toroster2 = (int)MoveToOtherRoster;
        }
    }
}

/* LoadBothRosterLists (6DE7E, PC only): rebuild both roster lists of the edit rosters screen (LoadRosterList 0,
   then 1, which it falls into). No result. */
void LoadBothRosterLists(void)
{
    LoadRosterList(0);
    LoadRosterList(1);
}

