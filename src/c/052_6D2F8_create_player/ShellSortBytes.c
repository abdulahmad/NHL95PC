/* Create player: sort records. */
#define RunEditRosters RunEditRosters_decl
#define EditRosters EditRosters_decl
#include "nhl95.h"
#undef RunEditRosters
#undef EditRosters

void EditRosters(unsigned char *menu, int mode, int c, int d, int e);

typedef struct { char c[8]; } Hdr8;
typedef struct { char c[17]; } Hdr17;

/* Compile context (matched in RunEditRosters.c): RunEditRosters: paint the roster editor, run EditRosters, then put the dialog
 colours back. The text state and the five saved colours are one 54h-byte local.
 RunEditRosters_ret6 and _ret5 are the pops other screens jump to. */
void RunEditRosters(void)
{
    struct {
        unsigned char state[0x40];
        int lite;
        int bg;
        int fg;
        int shade;
        int fill;
    } s;
    unsigned char *pal;
    int c40;
    int c42;
    int sz;

    s.lite = boxlitecolor;
    s.shade = boxshadecolor;
    s.fill = boxfillcolor;
    s.fg = dlgtextfg;
    s.bg = dlgtextbg;
    boxfillcolor = 0x41;
    c40 = 0x40;
    boxlitecolor = c40;
    c42 = 0x42;
    boxshadecolor = c42;
    dlgtextfg = c40;
    dlgtextbg = c42;
    pal = 0;
    editrosters_exit = (int)pal;
    dword_D0B12 = (int)pal;
    pal = (unsigned char *)sub_8CCA8((char *)str_Temp7, 0x300, 0x20);
    if (musicon && songdata)
        sub_8FCDF(musichandle, 3, 0x32);
    sub_8FFB0(0, 0x100, pal);
    FadePalStep(1, pal, 0x10);
    *(Hdr8 *)curdbname = *(Hdr8 *)str_Current3;
    sub_B4BA8();
    dword_EA2B0 = mainfont;
    sub_8EA18(dword_EA2B0);
    sub_8E9E8(s.state);
    if (musicon && songdata) {
        while (!sub_8FC8A(*(int *)((char *)&musicslot - 3) >> 24, 3));
        sub_8D2F0(songdata);
        songdata = 0;
    }
    fullscrbmp = sub_B4F8C(0x280, 0x1E0, 0x20);
    sz = ((*(int *)(pointerspr + 2) >> 16) + 1) * ((*(int *)(pointerspr + 4) >> 16) + 1) + 0x11;
    editptrspr = sub_8CCA8((char *)str_Pointer11, sz, 0x20);
    *(Hdr17 *)editptrspr = *(Hdr17 *)pointerspr;
    ((short *)editptrspr)[2] = ((short *)pointerspr)[2] + 1;
    ((short *)editptrspr)[3] = ((short *)pointerspr)[3] + 1;
    LoadLeagueDbsMem((char *)str_extDB);
    EditRosters(unk_D0450, 6, 0x40, 0x41, 0x42);
    FreeLeagueDbsMem();
    FreeMemBlock(editptrspr);
    if (musicon && songdata)
        sub_8FCDF(musichandle, 3, 0x32);
    sub_8FFB0(0, 0x100, pal);
    FadePalStep(1, pal, 0x10);
    FreeMemBlock((int)pal);
    sub_8EA00(s.state);
    FreeMemBlock(fullscrbmp);
    boxfillcolor = s.fill;
    boxlitecolor = s.lite;
    boxshadecolor = s.shade;
    dlgtextfg = s.fg;
    dlgtextbg = s.bg;
    if (musicon && songdata) {
        while (!sub_8FC8A(*(int *)((char *)&musicslot - 3) >> 24, 3));
        sub_8D2F0(songdata);
        songdata = 0;
    }
}



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

/* The EXE splits it: its body (LoadRosterList_fa, LoadRosterList_team) follows ShellSortBytes and its entry
   (6DE94) follows LoadBothRosterLists, which falls into it. Each piece is its own marked block (tools/splice.py);
   the entry is built with LoadBothRosterLists. Both body pieces end in a jump to RunEditRosters_ret5: the
   original module spans segments 051-052, so RunEditRosters is compiled first in this file as context. */
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
    int n;

    if (rosterisfa[side] == 1) {
        if (falistsel) {
            FreeMemBlock(falistsel);
            falistsel = 0;
        }
        if (falist) {
            FreeMemBlock((int)falist);
            falist = 0;
        }
        n = (unsigned)keydb_size / 0x34;
        facount = 0;
        for (i = 0; i < n; i++)
            if (keydb[i * 0x34] == 0xFF) facount++;
        falist = (unsigned char *)sub_8CCA8((char *)str_Uar, facount * 0x1B, 0);
        falistsel = sub_8CCA8((char *)str_Uarm, facount, 0);
        BuildFreeAgentList();
        ShellSortBytes(falist, facount, 0x1B, (int (*)(void *, void *))ComparePlayerEntry);
        for (i = 0; i < facount; i++) ((char *)falistsel)[i] = 0;
        dword_EBCA4 = 0;
        if (facount <= 0x1C) dword_D0C20 = 0;
        else {
            dword_D0C20 = -1;
            InitScrollBar((int *)unk_D0BF0, 0x1C, facount);
        }
        if (side == 0) menu_r1_tofa = 0;
        else menu_r2_tofa = 0;
        menu_r1_toroster2 = 0;
        menu_r2_toroster1 = 0;
    } else {
        rosterteamptr[side] = (int)CarTeamRecPtr(rosterteam[side]);
        BuildTeamRosterList(rosterteam[side], rosterlist + side * 0x2F4, (unsigned char **)&rosterteamrec[side]);
        ShellSortBytes(rosterlist + side * 0x2F4, 0x1C, 0x1B, (int (*)(void *, void *))ComparePlayerEntry);
        i = 0;
        for (; i < 0x1C; i++) rostersel[side * 0x1C + i] = 0;
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

