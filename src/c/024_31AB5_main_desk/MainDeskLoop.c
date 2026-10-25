/* Main desk: the desk loop and the desk menu routines that end in its pops. */
#define MainDeskLoop MainDeskLoop_decl
#define LoadModeState LoadModeState_decl
#define WriteModeState WriteModeState_decl
#define MenuNewExhibition MenuNewExhibition_decl
#define PreGameScreen PreGameScreen_decl
#define MenuHitTest MenuHitTest_decl
#define sub_8F98F sub_8F98F_decl
#define sub_8FB8E sub_8FB8E_decl
#include "nhl95.h"
#undef MainDeskLoop
#undef LoadModeState
#undef WriteModeState
#undef MenuNewExhibition
#undef PreGameScreen
#undef MenuHitTest
#undef sub_8F98F
#undef sub_8FB8E

typedef struct MenuItem {
    int x1, y1, x2, y2;
    char *text;
    int on1, on2;
    int pad;
} MenuItem;

typedef struct Hdr17 { char c[17]; } Hdr17;
typedef struct { char c[9]; } Str9;

int MenuHitTest(int x, int y, MenuItem **menus, int i, int *counts, int *origin, int *hitMenu, int *hitItem);
int sub_8F98F(char *path);
void sub_8FB8E(int song, int handle, int a, int b);
int PreGameScreen(int home, int vis);

/* DRAFT (10.0 GA): 67 differing, same 3,158 bytes; kept for its pop / ret tail (MainDeskLoop_x, which
   LoadModeState, WriteModeState and MenuNewExhibition use). Both pointer-bitmap setups compute the size into a
   block-local int before the allocation arguments are pushed (the first one no longer reuses the dead r). The
   submenu lookup precedes the depth increment. Left: the selected item's redraw reloads s.level where the EXE
   keeps it in edx (a store into s.sel may alias s.level in one frame struct), plus register picks; see the lane
   batch notes. */
/* MainDeskLoop (31AB5, PC only; owner of MainDeskLoop_x / MainDeskLoop_x2): the main desk screen. Reset the
   menu state (the menu bar, mainmenubar, with three items; no dropdowns open), centre the mouse on the bar, set
   the side controls, the EASN stats callbacks and the menu pointer bitmap, pick and load the desk song
   (MAINDESK or TONIGHTS, alternating), draw the EASN desk and the menu bar and fade in. Then follow the mouse: a
   click on an item with an action runs it (the second click on the selected item; dropdowns closed first) with
   the game file handle: 1 leaves the desk (result 0), 2 redraws the desk (a new song unless keepdesksong); a
   click on an item with a submenu opens its dropdown (saving the screen under it), another item of an open menu
   moves the selection, a click outside closes the dropdowns. No arguments. Result: 0. */
int MainDeskLoop(void)
{
    struct {
        int pos[4][2];
        char path[0x10];
        MenuItem *menus[4];
        int sel[4];
        int bg[4];
        int nitems[4];
        int w;
        int h;
        int item;
        int level;
        int fh;
        int my;
        int mx;
    } s;
    int ptr;
    int oldmx;
    int oldmy;
    int depth;
    int i;
    int bits;
    int r;
    int bank;
    int slot;
    int newsong;
    unsigned char *e;
    unsigned char *pal;
    MenuItem *m;

    s.fh = -1;
    depth = 0;
    SetScreenTitle(0);
    s.menus[0] = (MenuItem *)mainmenubar;
    s.nitems[0] = 3;
    s.menus[1] = s.menus[2] = s.menus[3] = 0;
    s.bg[0] = s.bg[1] = s.bg[2] = s.bg[3] = 0;
    s.sel[0] = s.sel[1] = s.sel[2] = s.sel[3] = 0;
    s.pos[0][0] = s.pos[0][1] = 0;
    s.mx = oldmx = (mainmenubar[0] + mainmenubar[2]) / 2;
    s.my = oldmy = (mainmenubar[1] + mainmenubar[3]) / 2;
    sub_B2E1B(0, 0, 0x27C, 0x1E0);
    MouseSetPos(oldmx, oldmy);
    ((void (*)(void))mousepollfn)();
    SetSideControls();
    SetupStatsSourceMenu(0);
    teamstatscb = (int)EasnTeamStatsScreen;
    skaterstatscb = (int)EasnSkaterStatsScreen;
    goaliestatscb = (int)EasnGoalieStatsScreen;
    standingscb = (int)EasnStandingsScreen;
    standingsmenucb = (int)EasnStandingsMenu;
    {
        int size;
        size = (((short *)pointerspr)[2] + 1) * (((short *)pointerspr)[3] + 1) + 0x11;
        ptr = sub_8CCA8((char *)str_Pointer7, size, 0x20);
        *(Hdr17 *)ptr = *(Hdr17 *)pointerspr;
        ((short *)ptr)[2] = ((short *)pointerspr)[2] + 1;
        ((short *)ptr)[3] = ((short *)pointerspr)[3] + 1;
    }
    if (musicon && !songdata) {
        if (desksongalt) {
            MakePath(s.path, fileoncd[0x1DB] == 1 ? (char *)cddriveptr : 0, (char *)str_Maindesk, (char *)str_Iff8);
            desksongalt = 0;
        } else {
            MakePath(s.path, fileoncd[0x1DF] == 1 ? (char *)cddriveptr : 0, (char *)str_Tonights2, (char *)str_Iff8);
            desksongalt = 1;
        }
        songdata = sub_8F98F(s.path);
    }
    MakePath(s.path, fileoncd[0x6A] == 1 ? (char *)cddriveptr : 0, (char *)str_Easndesk, 0);
    bank = sub_8E83C(s.path, 0);
    FadeOutPalCycle();
    sub_B4BA8();
    sub_9061C(sub_B30B4(bank, (char *)str_Desk2));
    DrawMenuBar(s.menus[0], s.nitems[0], 0xFA, 0xF9, 0xF8);
    sub_91400(ptr, oldmx, oldmy);
    sub_91370(pointerspr, oldmx, oldmy);
    scrpitch = 0x50;
    if (musicon && songdata && gameopts.music) sub_8FB8E(songdata, musichandle, 3, 0x4C);
    FadePalStep(0, (unsigned char *)sub_B30B4(bank, (char *)str_Pal15) + 0x10, 0x10);
    FreeMemBlock(bank);
    ClearInputQueue();
    for (;;) {
        bits = 0;
        while ((e = GetInputEvent()) != 0) {
            bits = ((int (*)(unsigned char *, int *, int *))ptrupdatefn)(e, &s.mx, &s.my);
            if (bits & 2) break;
        }
        if (!(bits & 2)) {
            if (s.mx == oldmx && s.my == oldmy) continue;
            sub_B4BA8();
            sub_903F0(ptr, oldmx, oldmy);
            sub_91400(ptr, s.mx, s.my);
            sub_91370(pointerspr, s.mx, s.my);
            oldmx = s.mx;
            oldmy = s.my;
            continue;
        }
        if (MenuHitTest(s.mx, s.my, s.menus, depth, s.nitems, &s.pos[0][0], &s.level, &s.item)) {
            m = &s.menus[s.level][s.item];
            if (m->on1) {
                if (s.item == s.sel[s.level]) {
                    int size;
                    sub_903F0(ptr, oldmx, oldmy);
                    for (i = depth; i > 0; i--) {
                        s.sel[i] = 0;
                        if (s.bg[i]) {
                            sub_903F0(s.bg[i], s.pos[i][0], s.pos[i][1]);
                            s.pos[i][0] = s.pos[i][1] = 0;
                            FreeMemBlock(s.bg[i]);
                        }
                    }
                    depth = 0;
                    FreeMemBlock(ptr);
                    keepdesksong = 0;
                    r = ((int (*)(int *))s.menus[s.level][s.item].on1)(&s.fh);
                    FileClose(&s.fh);
                    size = (((short *)pointerspr)[2] + 1) * (((short *)pointerspr)[3] + 1) + 0x11;
                    ptr = sub_8CCA8((char *)str_Pointer7, size, 0x20);
                    *(Hdr17 *)ptr = *(Hdr17 *)pointerspr;
                    ((short *)ptr)[2] = ((short *)pointerspr)[2] + 1;
                    ((short *)ptr)[3] = ((short *)pointerspr)[3] + 1;
                    s.menus[1] = s.menus[2] = s.menus[3] = 0;
                    s.bg[0] = s.bg[1] = s.bg[2] = s.bg[3] = 0;
                    s.sel[1] = s.sel[2] = s.sel[3] = 0;
                    s.nitems[1] = s.nitems[2] = s.nitems[3] = 0;
                    if (r == 1) {
                        ClearInputQueue();
                        InputRemove();
                        FreeMemBlock(ptr);
                        return 0;
                    }
                    if (r == 2) {
                        sub_B4BA8();
                        if (!keepdesksong && musicon && songdata) {
                            sub_8FCDF(musichandle, 3, 0x46);
                            do
                                slot = musicslot;
                            while (sub_8FC8A(slot, 3) == 0);
                            sub_8D2F0(songdata);
                            songdata = 0;
                        } else {
                            keepdesksong = 0;
                        }
                        newsong = 0;
                        if (musicon && !songdata) {
                            newsong = 1;
                            if (desksongalt) {
                                MakePath(s.path, fileoncd[0x1DB] == 1 ? (char *)cddriveptr : 0, (char *)str_Maindesk,
                                    (char *)str_Iff8);
                                desksongalt = 0;
                            } else {
                                MakePath(s.path, fileoncd[0x1DF] == 1 ? (char *)cddriveptr : 0, (char *)str_Tonights2,
                                    (char *)str_Iff8);
                                desksongalt = 1;
                            }
                            songdata = sub_8F98F(s.path);
                        }
                        sub_B4BC4(0, 0x280, 0, 0x1E0);
                        MakePath(s.path, fileoncd[0x6A] == 1 ? (char *)cddriveptr : 0, (char *)str_Easndesk, 0);
                        bank = sub_8E83C(s.path, 0);
                        sub_9061C(sub_B30B4(bank, (char *)str_Desk2));
                        DrawMenuBar(s.menus[0], s.nitems[0], 0xFA, 0xF9, 0xF8);
                        pal = (unsigned char *)sub_B30B4(bank, (char *)str_Pal15) + 0x10;
                        if (musicon && newsong == 1 && gameopts.music && songdata)
                            sub_8FB8E(songdata, musichandle, 3, 0x4C);
                        FadePalStep(0, pal, 0x10);
                        FreeMemBlock(bank);
                    }
                    SetScreenTitle(0);
                    MouseSetPos(oldmx, oldmy);
                    ClearInputQueue();
                } else {
                    sub_903F0(ptr, oldmx, oldmy);
                    if (depth != s.level) {
                        for (i = depth; i > s.level; i--) {
                            s.sel[i] = 0;
                            if (s.bg[i]) {
                                sub_903F0(s.bg[i], s.pos[i][0], s.pos[i][1]);
                                s.pos[i][0] = s.pos[i][1] = 0;
                                FreeMemBlock(s.bg[i]);
                                s.bg[i] = 0;
                                s.menus[i] = 0;
                                s.nitems[i] = 0;
                            }
                        }
                        depth = s.level;
                    }
                    DrawMenuItemSel((struct MenuItem *)&s.menus[s.level][s.sel[s.level]], s.pos[s.level][0],
                        s.pos[s.level][1], 0xFA, 0xF9, 0xF8);
                    s.sel[s.level] = s.item;
                    DrawMenuItemNorm((struct MenuItem *)&s.menus[s.level][s.sel[s.level]], s.pos[s.level][0],
                        s.pos[s.level][1], 0xFA, 0xF9, 0xF8);
                }
            } else if (m->on2) {
                sub_903F0(ptr, oldmx, oldmy);
                if (depth != s.level) {
                    for (i = depth; i > s.level; i--) {
                        s.sel[i] = 0;
                        if (s.bg[i]) {
                            sub_903F0(s.bg[i], s.pos[i][0], s.pos[i][1]);
                            s.pos[i][0] = s.pos[i][1] = 0;
                            FreeMemBlock(s.bg[i]);
                            s.bg[i] = 0;
                            s.menus[i] = 0;
                            s.nitems[i] = 0;
                        }
                    }
                    depth = s.level;
                }
                i = depth;
                DrawMenuItemSel((struct MenuItem *)&s.menus[i][s.sel[i]], s.pos[i][0], s.pos[i][1], 0xFA, 0xF9, 0xF8);
                s.sel[i] = s.item;
                DrawMenuItemNorm((struct MenuItem *)&s.menus[i][s.item], s.pos[i][0], s.pos[i][1], 0xFA, 0xF9, 0xF8);
                m = &s.menus[s.level][s.item];
                depth = i + 1;
                s.menus[depth] = (MenuItem *)m->on2;
                s.nitems[depth] = m->pad;
                s.pos[depth][0] = (depth == 1 ? m->x1 : m->x2) + s.pos[depth - 1][0];
                s.pos[depth][1] = (depth == 1 ? m->y2 : m->y1) + s.pos[depth - 1][1];
                i = depth;
                s.w = s.menus[i][s.nitems[i] - 1].x2 - s.menus[i][0].x1 + 1;
                s.h = s.menus[i][s.nitems[i] - 1].y2 - s.menus[i][0].y1 + 1;
                s.bg[i] = sub_8CCA8((char *)str_Menubuff4, s.w * s.h + 0x11, 0x20);
                *(Hdr17 *)s.bg[i] = *(Hdr17 *)pointerspr;
                ((short *)s.bg[i])[2] = s.w;
                ((short *)s.bg[i])[3] = s.h;
                sub_91400(s.bg[i], s.pos[i][0], s.pos[i][1]);
                DrawMenuDropdown(s.menus[i], s.nitems[i], s.pos[i][0], s.pos[i][1], 0xFA, 0xF9, 0xF8);
                s.sel[i] = 0;
                DrawMenuItemNorm((struct MenuItem *)s.menus[i], s.pos[i][0], s.pos[i][1], 0xFA, 0xF9, 0xF8);
            } else {
                sub_903F0(ptr, oldmx, oldmy);
            }
        } else {
            sub_903F0(ptr, oldmx, oldmy);
            for (i = depth; i > 0; i--) {
                s.sel[i] = 0;
                if (s.bg[i]) {
                    sub_903F0(s.bg[i], s.pos[i][0], s.pos[i][1]);
                    s.pos[i][0] = 0;
                    s.pos[i][1] = s.pos[i][0];
                    FreeMemBlock(s.bg[i]);
                }
            }
            depth = 0;
            s.menus[1] = s.menus[2] = s.menus[3] = 0;
            s.bg[0] = s.bg[1] = s.bg[2] = s.bg[3] = 0;
            s.sel[1] = s.sel[2] = s.sel[3] = 0;
            s.nitems[1] = s.nitems[2] = s.nitems[3] = 0;
        }
        sub_91400(ptr, s.mx, s.my);
        sub_91370(pointerspr, s.mx, s.my);
        oldmx = s.mx;
        oldmy = s.my;
    }
}

/* LoadModeState (327A1, PC only; ends in MainDeskLoop_x): make the saved mode state st (75h bytes: league
   directory, database name formats, game mode, teams, game options, the two controllers' team / device / side)
   current. A device that is no longer available is dropped, an empty one is given the first free of joystick 1,
   joystick 2, keyboard, mouse or none (10h); when exactly one side has no device, the other takes the free side
   and its team. Then start or stop the music and sound effects by the options, set the side controls and, in an
   exhibition, put the team abbreviations (3 letters, or 2 and a space) into the "LA at MTL" title. st: the state.
   No result. */
void LoadModeState(unsigned char *st)
{
    int a;
    int b;

    strcpy((char *)&curleague, (char *)st + 4);
    strcpy((char *)&leaguedbfmt, (char *)st + 0x11);
    strcpy((char *)&leaguedbfmt2, (char *)st + 0x31);
    gamemode = *(int *)st;
    HomeTeam = *(short *)(st + 0x51);
    VisTeam = *(short *)(st + 0x55);
    *(int *)&gameopts = *(int *)(st + 0x59);
    ctl1team[0] = *(int *)(st + 0x5D);
    ctl2team = *(int *)(st + 0x61);
    ctl1dev[0] = *(int *)(st + 0x65);
    ctl2dev = *(int *)(st + 0x69);
    ctl1side[0] = *(int *)(st + 0x6D);
    ctl2side = *(int *)(st + 0x71);
    switch (ctl1dev[0]) {
    case 1:
        if (!(ctlavailmask & 1)) ctl1dev[0] = 0;
        break;
    case 2:
        if (!(ctlavailmask & 2)) ctl1dev[0] = 0;
        break;
    case 4:
        if (!(ctlavailmask & 4)) ctl1dev[0] = 0;
        break;
    }
    switch (ctl2dev) {
    case 1:
        if (!(ctlavailmask & 1)) ctl2dev = 0;
        break;
    case 2:
        if (!(ctlavailmask & 2)) ctl2dev = 0;
        break;
    case 4:
        if (!(ctlavailmask & 4)) ctl2dev = 0;
        break;
    }
    if (ctl1dev[0] == 0) {
        if ((ctlavailmask & 2) && ctl2dev != 2) ctl1dev[0] = 2;
        else if ((ctlavailmask & 4) && ctl2dev != 4) ctl1dev[0] = 4;
        else if ((ctlavailmask & 8) && ctl2dev != 8) ctl1dev[0] = 8;
        else if ((ctlavailmask & 1) && ctl2dev != 1) ctl1dev[0] = 1;
        else ctl1dev[0] = 0x10;
    }
    if (ctl2dev == 0) {
        if ((ctlavailmask & 2) && ctl1dev[0] != 2) ctl2dev = 2;
        else if ((ctlavailmask & 4) && ctl1dev[0] != 4) ctl2dev = 4;
        else if ((ctlavailmask & 8) && ctl1dev[0] != 8) ctl2dev = 8;
        else if ((ctlavailmask & 1) && ctl1dev[0] != 1) ctl2dev = 1;
        else ctl2dev = 0x10;
    }
    if ((ctl2dev == 0x10) ^ (ctl1dev[0] == 0x10)) {
        if (ctl1dev[0] == 0x10) {
            b = 0;
            a = 1;
        } else {
            a = 0;
            b = 1;
        }
        ctl1side[b] = ctl1side[a] == 0;
        ctl1team[b] = (ctl1side[b] == 0) - 2;
    }
    if (gameopts.music) sub_8F979();
    else sub_8F984();
    if (gameopts.sfx) sub_8F963();
    else sub_8F96E();
    SetSideControls();
    if (gamemode) return;
    if (((char *)teamabbrevs[HomeTeam])[2]) {
        strncpy((char *)str_LAAtMTL + 7, (char *)teamabbrevs[HomeTeam], 3);
    } else {
        strncpy((char *)str_LAAtMTL + 7, (char *)teamabbrevs[HomeTeam], 2);
        str_LAAtMTL[9] = ' ';
    }
    if (((char *)teamabbrevs[VisTeam])[2]) {
        strncpy((char *)str_LAAtMTL, (char *)teamabbrevs[VisTeam], 3);
    } else {
        strncpy((char *)str_LAAtMTL, (char *)teamabbrevs[VisTeam], 2);
        str_LAAtMTL[2] = ' ';
    }
}

/* WriteModeState (32B1D, PC only; ends in MainDeskLoop_x): save the current mode state into st (the fields
   LoadModeState reads) and write it to GAME.SET (the league's GAME.SET in a league) when it exists or the disk
   has room (75h bytes); file errors are fatal. Without room say so (setdiskmsg) at the screen centre. st: the
   state buffer. No result. */
void WriteModeState(unsigned char *st)
{
    struct {
        char path[0x20];
        int fh;
        int y;
        int x;
    } s;

    if (gamemode == 0) *(Str9 *)s.path = *(Str9 *)str_GameSet4;
    else MakePath(s.path, (char *)&curleague, (char *)str_Game, (char *)str_Set);
    if (FileExists(s.path) || DiskFreeBytes(0) >= 0x75) {
        strcpy((char *)st + 4, (char *)&curleague);
        strcpy((char *)st + 0x11, (char *)&leaguedbfmt);
        strcpy((char *)st + 0x31, (char *)&leaguedbfmt2);
        *(int *)st = gamemode;
        *(int *)(st + 0x51) = HomeTeam;
        *(int *)(st + 0x55) = VisTeam;
        *(int *)(st + 0x59) = *(int *)&gameopts;
        *(int *)(st + 0x5D) = ctl1team[0];
        *(int *)(st + 0x61) = ctl2team;
        *(int *)(st + 0x65) = ctl1dev[0];
        *(int *)(st + 0x69) = ctl2dev;
        *(int *)(st + 0x6D) = ctl1side[0];
        *(int *)(st + 0x71) = ctl2side;
        if (FileCreate(s.path, &s.fh)) FatalError((char *)str_fee2);
        if (FileWriteAt(s.fh, st, -1, 0x75)) FatalError((char *)str_fee3);
        if (FileClose(&s.fh)) FatalError((char *)str_fee4);
    } else {
        s.x = 0x140;
        s.y = 0xF0;
        MouseSetPos(s.x, s.y);
        MessageBox(-1, -1, (char *)setdiskmsg, 3, 0, 0, (int)&s.x, (int)&s.y, 0x320);
    }
}

/* MenuNewExhibition (32DA9, PC only; segment 025, ends in MainDeskLoop_x): desk menu "new exhibition game".
   Without disk space for the game file return 0. Otherwise switch the stats callbacks to the game screens, set
   the controllers and full-length periods, and for a new game (no saved game open, *fh negative) reset the game
   summary and run the pre-game screen. Unless that was left (bit 2), set the in-game stats menu, fade out to the
   loading screen (a resumed game only), play the game and reset the stats menu. Then fade back to the desk, fade
   out the music, reinstall the input handler and restore the EASN callbacks. fh: the saved-game handle. Result:
   2 (redraw the desk), or 0. */
int MenuNewExhibition(int *fh)
{
    int r;
    int slot;
    unsigned char *pal;
    unsigned char *pal2;

    r = 0;
    if (CheckGameDiskSpace()) return 0;
    schedgameidx = 0;
    teamstatscb = (int)GameTeamStatsScreen;
    skaterstatscb = (int)GameSkaterStatsScreen;
    goaliestatscb = (int)GameGoalieStatsScreen;
    standingscb = (int)GameStandingsScreen;
    standingsmenucb = (int)GameStandingsMenu;
    SetupControllers();
    gameopts.fullot = 1;
    if (*fh < 0) {
        InitGameSummary(0, 0);
        r = PreGameScreen(HomeTeam, VisTeam);
        InputRemove();
    }
    if (!(r & 4)) {
        SetupStatsSourceMenu(1);
        if (*fh >= 0) {
            pal = (unsigned char *)sub_8CCA8((char *)str_Palette2, 0x300, 0x20);
            sub_8FFB0(0, 0x100, pal);
            if (musicon && songdata)
                sub_8FCDF(musichandle, 3, 0x64);
            FadePalStep(1, pal, 0x10);
            FreeMemBlock((int)pal);
            if (musicon && songdata) {
                do
                    slot = musicslot;
                while (sub_8FC8A(slot, 3) == 0);
                sub_8D2F0(songdata);
                songdata = 0;
            }
            ShowLoadingScreen();
        }
        PlayGame(fh);
        SetupStatsSourceMenu(0);
    }
    pal2 = (unsigned char *)sub_8CCA8((char *)str_Temp4, 0x300, 0x20);
    if (musicon && songdata)
        sub_8FCDF(musichandle, 3, 0x19);
    sub_8FFB0(0, 0x100, pal2);
    FadePalStep(1, pal2, 0x10);
    FreeMemBlock((int)pal2);
    if (musicon && songdata) {
        do
            slot = musicslot;
        while (sub_8FC8A(slot, 3) == 0);
        sub_8D2F0(songdata);
        songdata = 0;
    }
    InputInstall();
    teamstatscb = (int)EasnTeamStatsScreen;
    skaterstatscb = (int)EasnSkaterStatsScreen;
    goaliestatscb = (int)EasnGoalieStatsScreen;
    standingscb = (int)EasnStandingsScreen;
    standingsmenucb = (int)EasnStandingsMenu;
    return 2;
}

/* MenuLeagueSettings (332F6, PC only; segment 025, ends in MainDeskLoop_x2): desk menu "league settings". In the
   league state (the exhibition state saved, lgstate loaded) ask the master password (CheckMasterPassword) and
   run the league settings dialog only when it is right; after a finished season (byte_DE268) fade the menu
   palette in first. Then save the league state and reload the exhibition state. No arguments. Result: 2 (redraw
   the desk) after a season, else 0. */
int MenuLeagueSettings(void)
{
    int ok;
    int r;
    unsigned char *pal;

    ok = 0;
    r = 0;
    SaveModeState(exhstate);
    LoadModeState(lgstate);
    if (!((int (*)(void))CheckMasterPassword)()) ok = -1;
    if (byte_DE268) {
        pal = (unsigned char *)sub_8CCA8((char *)str_Temp4, 0x300, 0x20);
        sub_8FFB0(0, 0x100, pal);
        FadePalStep(1, pal, 0x10);
        FreeMemBlock((int)pal);
        r = 2;
    }
    if (ok) LeagueSettingsDlg();
    SaveModeState((unsigned char *)lgstate);
    LoadModeState(exhstate);
    return r;
}
