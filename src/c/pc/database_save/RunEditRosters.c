/* Database save: the edit-rosters screen. */
#define RunEditRosters RunEditRosters_decl
#define EditRosters EditRosters_decl
#include "nhl95.h"
#undef RunEditRosters
#undef EditRosters

void EditRosters(unsigned char *menu, int mode, int c, int d, int e);

typedef struct { char c[8]; } Hdr8;
typedef struct { char c[17]; } Hdr17;

/* RunEditRosters: paint the roster editor, run EditRosters, then put the dialog
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

/* DrawEditRosters (6D2F8, PC only; create-player segment 052, the same source file: it ends in
   RunEditRosters_ret5): redraw the Edit Rosters screen on the full-screen bitmap: the menu bar (unk_D0450), the
   prez2 background (palette into savepal, the "ea" art drawn full screen below line 13h), both roster panels
   (DrawRosterPanel) and, in ratings mode (dword_D0B12 == 2), the ratings box: a dialog frame with bevelled edges,
   "Ratings " + the first roster team's name centred, the nine rating names (off_D0AC2) with their values from the
   team record (+2DCh, picked by byte_D0AE6), and the two buttons (unk_D0B80). Then the bitmap is shown
   (sub_9121C). No arguments, no result. */
void DrawEditRosters(void)
{
    char buf[0x54];
    int bank;
    int shape;
    unsigned char *vals;
    int y;
    int i;

    SetDrawBitmap(fullscrbmp);
    SetTextColors(0x40, 0x43);
    DrawMenuBar(unk_D0450, 5, 0x40, 0x41, 0x42);
    MakePath(buf, fileoncd[0x1C3] == 1 ? (char *)cddriveptr : 0, (char *)str_Prez2, 0);
    bank = sub_8E83C(buf, 0);
    memcpy(savepal, (char *)sub_B30B4(bank, (char *)str_Pal) + 0x10, 0x300);
    shape = sub_B30B4(bank, (char *)str_ea);
    sub_B4BC4(0, 0x280, 0x13, 0x1E0);
    sub_913B4(shape);
    sub_B4BC4(0, 0x280, 0, 0x1E0);
    FreeMemBlock(bank);
    DrawRosterPanel(0);
    DrawRosterPanel(1);
    if (dword_D0B12 == 2) {
        DrawDlgFrame(0xB4, 0x8C, 0x1CC, 0x154, 1);
        sub_90D20(0xB4, 0x8C, 0x119, 0xC9, 0x41);
        sub_B4FAC(0xB4, 0x8C, 0x1CB, 0x8C, 0x40);
        sub_B4FAC(0xB4, 0x8C, 0xB4, 0x153, 0x40);
        sub_B4FAC(0x1CC, 0x8D, 0x1CC, 0x154, 0x42);
        sub_B4FAC(0xB5, 0x154, 0x1CC, 0x154, 0x42);
        sub_B5DB0(0xB4, 0x154, 0x41);
        sub_B5DB0(0x1CC, 0x8C, 0x41);
        strcpy(buf, (char *)str_Ratings);
        strcat(buf, (char *)&str_space);
        strcat(buf, (char *)rosterteamrec[0] + 0x1A);
        PrintShadowText((0x118 - fputchar(buf)) / 2 + 0xB4, 0x99, buf);
        vals = (unsigned char *)rosterteamrec[0] + 0x2DC;
        y = 0xB0;
        i = 0;
        do {
            PrintShadowText(0xD2, y, (char *)off_D0AC2[i]);
            sprintf(buf, (char *)str_fmt2d, vals[byte_D0AE6[i]]);
            PrintShadowText(0x1A9, y, buf);
            i++;
            y += 0xD;
        } while (i < 9);
        DrawButtons((Button *)unk_D0B80, 2);
    }
    sub_B4BA8();
    sub_9121C(((int *)fullscrbmp)[0x2C / 4]);
}

typedef struct MenuItem20 { int f[5]; int handler; int g[2]; } MenuItem20;  /* 20h-byte menu item, handler at +14h */
typedef struct DivMenu { MenuItem20 *items; int pad[7]; } DivMenu;  /* roster1divmenus / roster2divmenus: 20h per division */

/* SelectRosterTeam (6D5D0, PC only; segment 052, ends in RunEditRosters_ret6): a team item of a roster division
   submenu. item: the menu callback argument (item[0] 1 for roster 1, else roster 2; item[1] the division, item[2]
   the slot in divisionteams). The side shows that team (rosterteam); the team it showed before gets its item back
   (SelectRosterTeam in both division menus), or the "Free Agents" items come back (ShowFreeAgents) when it showed
   the free agents; the new teams items are disabled, the sides "Edit Team Lines" item enabled (EditTeamLines)
   and rosterisfa cleared. Then LoadRosterList and DrawEditRosters. No result.
   DRAFT: 267 vs 267. Under 10.0 GA old declared before div gives the EXE's div / slot registers and the first
   clear of the new team's items. Left: the second clear adds the menu pointer into edx (the EXE keeps it in eax:
   `mov dword [edx+eax+14h], 0`), and rosterisfa is zeroed through cl (EXE bh). See docs/UNSURE.md. */
void SelectRosterTeam(int *item)
{
    int side;
    int slot;
    unsigned char old;
    int div;
    int d;
    int i;

    side = *item != 1;
    div = item[1];
    slot = item[2];
    old = rosterteam[side];
    rosterteam[side] = ((unsigned char (*)[7])divisionteams)[div][slot];
    if (old == 0xFF) {
        menu_r2_freeagents = menu_r1_freeagents = (int)ShowFreeAgents;
    } else {
        d = teamdivflags[old] >> 1;
        if (d == 4) d--;
        i = 0;
        do {
            if (old == ((unsigned char (*)[7])divisionteams)[d][i]) break;
        } while (++i < 7);
        ((DivMenu *)roster1divmenus)[d].items[i].handler = (int)SelectRosterTeam;
        ((DivMenu *)roster2divmenus)[d].items[i].handler = (int)SelectRosterTeam;
    }
    ((MenuItem20 *)roster1divmenus[div * 8])[slot].handler = 0;
    ((MenuItem20 *)roster2divmenus[div * 8])[slot].handler = 0;
    if (!side) menu_r1_editlines = (int)EditTeamLines;
    else menu_r2_editlines = (int)EditTeamLines;
    rosterisfa[side] = 0;
    LoadRosterList(side);
    DrawEditRosters();
}

/* ShowFreeAgents (6D6DB, PC only; segment 052, the same source file: it ends in RunEditRosters_ret5): the
   "Free Agents" item of a roster menu. The side whose menu it is (side 0 when *which is 1) gives its current team
   menu item back (handler SelectRosterTeam in both division menus; division teamdivflags >> 1, 4 counts as 3),
   disables both "Free Agents" items and its "Edit Team Lines" item, shows the free agents (rosterteam FFh,
   rosterisfa 1), reloads the list (LoadRosterList) and redraws (DrawEditRosters). which: the menu callback
   argument. No result. */
void ShowFreeAgents(int *which)
{
    int side;
    int team;
    int d;
    int i;

    side = *which != 1;
    team = rosterteam[side];
    d = teamdivflags[team] >> 1;
    if (d == 4) d--;
    i = 0;
    do {
        if (((unsigned char (*)[7])divisionteams)[d][i] == team) break;
    } while (++i < 7);
    ((DivMenu *)roster1divmenus)[d].items[i].handler = (int)SelectRosterTeam;
    ((DivMenu *)roster2divmenus)[d].items[i].handler = (int)SelectRosterTeam;
    menu_r2_freeagents = menu_r1_freeagents = 0;
    if (!side) menu_r1_editlines = 0;
    else menu_r2_editlines = 0;
    rosterteam[side] = 0xFF;
    rosterisfa[side] = 1;
    LoadRosterList(side);
    DrawEditRosters();
}

typedef struct TeamRec2E8 { int d[0xBA]; } TeamRec2E8;  /* a team record (hmteamrec: home, then away), 2E8h bytes */

/* EditTeamLines (6DF06, PC only; segment 052, ends in RunEditRosters_ret5): the "Edit Team Lines" item of a
   roster menu (side 0 when *which is 3). The side's game team (HomeTeam / VisTeam) becomes the roster's team and
   its game team record is replaced by the roster's record (rosterteamrec) while the line editor (DbLineEditor, on
   the record's lines at +0BCh, unk_D05F4, 3) runs; the free-agent lists are freed first (falistsel, falist). Then
   the screen is cleared, the record copy goes back (into the home record, hmteamrec, for either side), the team
   is restored, a roster that shows the free agents on the other side is reloaded (LoadRosterList), and the editor
   is redrawn (DrawEditRosters) and faded in (savepal). which: the menu callback argument. No result. */
void EditTeamLines(int *which)
{
    TeamRec2E8 tmp;
    int side;
    short old;

    side = *which != 3;
    if (!side) {
        old = HomeTeam;
        HomeTeam = rosterteam[0];
    } else {
        old = VisTeam;
        VisTeam = rosterteam[1];
    }
    if (falistsel) {
        FreeMemBlock(falistsel);
        falistsel = 0;
    }
    if (falist) {
        FreeMemBlock((int)falist);
        falist = 0;
    }
    tmp = ((TeamRec2E8 *)hmteamrec)[side];
    ((TeamRec2E8 *)hmteamrec)[side] = *(TeamRec2E8 *)rosterteamrec[side];
    DbLineEditor(side, rosterteamrec[side] + 0xBC, (int)unk_D05F4, 3);
    sub_B4BA8();
    sub_B392C(0);
    *(TeamRec2E8 *)hmteamrec = tmp;
    if (!side) HomeTeam = old;
    else VisTeam = old;
    if (rosterteam[!side] == 0xFF) LoadRosterList(!side);
    DrawEditRosters();
    FadePalStep(0, savepal, 0x10);
}
