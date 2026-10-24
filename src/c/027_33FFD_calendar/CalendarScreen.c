/* Calendar: the season calendar screen. */
#define CalendarScreen CalendarScreen_decl
#define DrawCalendarDay DrawCalendarDay_decl
#define MenuHitTest MenuHitTest_decl
#define sub_8F98F sub_8F98F_decl
#define sub_8FB8E sub_8FB8E_decl
#include "nhl95.h"
#undef CalendarScreen
#undef DrawCalendarDay
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

void DrawCalendarDay(int month, int *crests, int unused, unsigned char *games, int ngames, int team, int font,
                     int bank);
int MenuHitTest(int x, int y, MenuItem **menus, int i, int *counts, int *origin, int *hitMenu, int *hitItem);
int sub_8F98F(char *path);  /* music library: load a song */
void sub_8FB8E(int song, int handle, int chan, int vol);  /* music library: play a song */

/* DRAFT (first pass from Ghidra; the menu loop follows MainDeskLoop's draft): 6,016 of 6,040 bytes, 258
   differing under 10.0 GA. Every call is in place and the prologue matches (dir pushed, ext in edi, team in
   ebp). Found under GA: DrawMenuBar(calmenubar, 3, ...) written with the constants (the EXE keeps them in esi
   / edi from the menus[0] / nitems[0] stores), the dropdown origin as `depth != 1 ? x2 : x1`. The arrays and
   scalars are declared in tools/wccre/declsearch.py's order (with --conflicts: 30 of 34 slots). Left: the
   slots of day, i, ngames and shown; oldm / oldd in edi / esi (EXE esi / edi; savings 200 / 300); the
   day box clips (the EXE computes k % 7 and k / 7 first, then the four sub_B4BC4 arguments in the order x1,
   y1, x2, y2 into registers before the pushes); the event pointer copied into two registers; the
   DrawMenuItemNorm tail shared from another branch. The (int) compare of day with monthdays reloads day as
   the EXE does. */
/* CalendarScreen (34821, PC only): the season calendar of a league team. Fade out (stopping the music), show the
   loading screen, point the stats callbacks at the calendar screens and load the CALENDAR art and the CALLOGO
   crests (one per team, crestnames). Read today's schedule index from the league's SCHEDULE file, then the
   1,197 games (6 bytes: month + 1, day, home, away, home score, away score; FFh is unplayed or no team) and keep
   the team's games (up to 113, with their schedule indexes): the month shown is that of the first unplayed one
   (that game selected, its sides set for the next game), else that of today's game. Draw the menu bar (Return
   and the month arrows, calnextslot / calprevslot off at the season's ends) and the month (DrawCalendarDay), play
   the CALENDAR song and set the palette. Then follow the mouse as in MainDeskLoop: an item with an action runs it
   (result 1 leaves the calendar at once with 0; a new month or dword_DDD2C redraws the month); a click on a day
   of the month with an unplayed game of the team selects it (any such game while today's schedule index is
   below 444h, after that only the first unplayed one): its day is drawn again with the old selection's day,
   its sides are set, and a second click on the selected game leaves the calendar. Restore the game stats
   callbacks and fade the music. dir: the league directory; ext: the schedule file's extension; team: the
   league team. Result: the selected game's schedule index (calsel; -1 for none), or 0 when an action ended
   the calendar. */
int CalendarScreen(char *dir, char *ext, int team)
{
    unsigned char games[113][6];
    short gameidx[113];
    MenuItem *menus[3];
    int crests[0x1A];
    int fh;
    int bg[3];
    int btn;
    int oldmx;
    unsigned char remap[0x300];  /* 300h bytes in the frame; only the first 100h are the identity remap */
    int h;
    int mx;
    int nitems[3];
    int my;
    char path[0x20];
    short today;
    int w;
    int item;
    int pos[3][2];
    int oldmy;
    int level;
    int hdr;
    int logos;
    short ngames;
    int c3;
    int c1;
    int c2;
    int unused;  /* DrawCalendarDay's third argument: never set (the EXE passes the slot at 7A8h) */
    int ptr;
    short newsel;
    int font;
    int depth;
    short firstgame;
    int sel[3];
    short i;
    short day;
    short selgame;
    short shown;
    short r;
    short tmonth;
    int bits;
    int size;
    int oldm;
    int oldd;
    int k;
    unsigned char *e;

    fh = -1;
    depth = 0;
    c1 = 0xC0;
    c2 = 0x0C;
    c3 = 0x67;
    sub_B4BA8();
    sub_B392C(0);
    if (musicon && songdata) sub_8FCDF(musichandle, 3, 100);
    sub_8FFB0(0, 0x100, savepal);
    FadePalStep(1, savepal, 0x10);
    if (musicon && songdata) {
        while (sub_8FC8A(musicslot, 3) == 0) ;
        sub_8D2F0(songdata);
        songdata = 0;
    }
    ShowLoadingScreen();
    teamstatscb = (int)CalTeamStatsScreen;
    skaterstatscb = (int)CalSkaterStatsScreen;
    goaliestatscb = (int)CalGoalieStatsScreen;
    standingscb = (int)CalStandingsScreen;
    standingsmenucb = (int)CalStandingsMenu;
    SetDialogColors(0x0C, 0xC0, 0x67, 0xC0, 0xFF);
    ngames = 0;
    calsel = -1;
    dword_DDD2C = calexit = 0;
    font = mainfont;
    MakePath(path, fileoncd[0x1C1] == 1 ? (char *)cddriveptr : 0, (char *)str_Calendar, 0);
    calendarshapes = sub_8E83C(path, 0x20);
    MakePath(path, fileoncd[0x1C2] == 1 ? (char *)cddriveptr : 0, (char *)str_Callogo, 0);
    logos = sub_8E83C(path, 0x20);
    for (i = 0; i < 0x100; i++) remap[i] = (unsigned char)i;
    sub_B4DD4(remap);
    for (i = 0; i < 0x1A; i++) crests[i] = sub_B30B4(logos, (char *)crestnames[i]);
    MakePath(path, dir, (char *)leaguedbnames[6], ext);
    if ((r = FileOpenRead(path, &fh)) == 0) r = FileReadAt(fh, &today, 0, 2);
    if (r == 0) {
        /* the team's games: the first unplayed one, and the month of today's game */
        calmonth = -1;
        tmonth = 5;
        selgame = firstgame = -1;
        for (i = 0; i < 0x4AD && r == 0; i++) {
            r = ReadSchedGame(fh, games[ngames], i);
            if (r != 0) continue;
            if (i == today) {
                if (games[ngames][2] != 0xFF && games[ngames][3] != 0xFF) {
                    tmonth = games[ngames][0] - 1;
                    calselmonth = games[ngames][0];
                    calselday = games[ngames][1];
                } else {
                    tmonth = games[ngames - 1][0] - 1;
                    calselmonth = games[ngames][0];
                    calselday = games[ngames][1];
                }
            }
            if (games[ngames][2] == team || games[ngames][3] == team) {
                if (games[ngames][0] != 0xFF && games[ngames][1] != 0xFF) {
                    if (games[ngames][4] == 0xFF && games[ngames][5] == 0xFF && calmonth < 0) {
                        calmonth = games[ngames][0] - 1;
                        firstgame = i;
                        selgame = ngames;
                    }
                    gameidx[ngames] = i;
                    ngames++;
                }
            }
        }
        if (calmonth < 0) calmonth = tmonth;
    }
    if (r) FadeOutPalCycle();
    FileClose(&fh);
    if (firstgame >= 0 && r == 0) {
        SetGameSides(team, games[0], selgame);
        calselmonth = games[selgame][0];
        calselday = games[selgame][1];
        calsel = gameidx[selgame];
    }
    if (r == 0) {
        if (calmonth == 5) calnextslot = 0;
        else calnextslot = (int)CalNextMonth;
        if (calmonth == 9) calprevslot = 0;
        else calprevslot = (int)CalPrevMonth;
        shown = calmonth;
        sub_B4BA8();
        menus[0] = (MenuItem *)calmenubar;
        nitems[0] = 3;
        menus[1] = 0;
        pos[0][1] = pos[0][0] = sel[1] = sel[0] = bg[1] = bg[0] = 0;
        FadeOutPalCycle();
        sub_B4BA8();
        DrawMenuBar((MenuItem *)calmenubar, 3, c1, c2, c3);
        DrawCalendarDay(calmonth, crests, unused, games[0], ngames, team, font, calendarshapes);
        if (musicon && !songdata) {
            MakePath(path, fileoncd[0x1E2] == 1 ? (char *)cddriveptr : 0, (char *)str_Calendar, (char *)str_Iff9);
            songdata = sub_8F98F(path);
            if (songdata && gameopts.music) sub_8FB8E(songdata, musichandle, 3, 0x4C);
        }
        ApplyShapePalette(calendarshapes);
        size = ((((short *)pointerspr)[2] << 2) + 4) * (((short *)pointerspr)[3] + 1) + 0x11;
        ptr = hdr = sub_8CCA8((char *)str_Pointer8, size, 0x20);
        *(Hdr17 *)ptr = *(Hdr17 *)pointerspr;
        ((short *)hdr)[2] = ((short *)pointerspr)[2] + 1;
        ((short *)hdr)[3] = ((short *)pointerspr)[3] + 1;
        sub_B2DCA(&btn, &oldmx, &oldmy);
        mx = oldmx;
        my = oldmy;
        sub_91400(hdr, oldmx, oldmy);
        sub_91370(pointerspr, oldmx, oldmy);
        ClearInputQueue();
        do {
            bits = 0;
            do {
                e = GetInputEvent();
                if (e) bits = ((int (*)(unsigned char *, int *, int *))ptrupdatefn)(e, &mx, &my);
            } while (e && !(bits & 2));
            if (!(bits & 2)) {
                if (mx == oldmx && my == oldmy) continue;
                sub_903F0(ptr, oldmx, oldmy);
                sub_91400(ptr, mx, my);
                sub_91370(pointerspr, mx, my);
                oldmx = mx;
                oldmy = my;
                continue;
            }
            if (MenuHitTest(mx, my, menus, depth, nitems, &pos[0][0], &level, &item)) {
                if (menus[level][item].on1) {
                    if (item == sel[level]) {
                        /* the second click on the selected item: close the dropdowns and run it */
                        sub_903F0(ptr, oldmx, oldmy);
                        for (i = depth; i >= 0; i--) {
                            if (bg[i]) {
                                sub_903F0(bg[i], pos[i][0], pos[i][1]);
                                pos[i][1] = pos[i][0] = 0;
                                FreeMemBlock(bg[i]);
                            }
                        }
                        depth = 0;
                        r = ((int (*)(void))menus[level][item].on1)();
                        sub_B4DD4(remap);
                        menus[1] = 0;
                        nitems[1] = sel[1] = bg[1] = bg[0] = 0;
                        if (r == 1) {
                            FreeMemBlock(ptr);
                            if (musicon && songdata) sub_8FCDF(musichandle, 3, 100);
                            return 0;
                        }
                        MouseSetPos(oldmx, oldmy);
                        mx = oldmx;
                        my = oldmy;
                        ClearInputQueue();
                        if (shown != calmonth) {
                            sub_B4BA8();
                            DrawMenuBar(calmenubar, 3, c1, c2, c3);
                            DrawCalendarDay(calmonth, crests, unused, games[0], ngames, team, font, calendarshapes);
                        }
                        if (dword_DDD2C) {
                            sub_B4BA8();
                            DrawMenuBar(calmenubar, 3, c1, c2, c3);
                            DrawCalendarDay(calmonth, crests, unused, games[0], ngames, team, font, calendarshapes);
                            ApplyShapePalette(calendarshapes);
                            dword_DDD2C = 0;
                        }
                        shown = calmonth;
                    } else {
                        sub_903F0(ptr, oldmx, oldmy);
                        if (depth != level) {
                            for (i = depth; i > level; i--) {
                                sel[i] = 0;
                                if (bg[i]) {
                                    sub_903F0(bg[i], pos[i][0], pos[i][1]);
                                    pos[i][0] = pos[i][1] = 0;
                                    FreeMemBlock(bg[i]);
                                    bg[i] = 0;
                                    menus[i] = 0;
                                    nitems[i] = 0;
                                }
                            }
                            depth = level;
                        }
                        DrawMenuItemSel((struct MenuItem *)&menus[level][sel[level]], pos[level][0], pos[level][1],
                            c1, c2, c3);
                        sel[level] = item;
                        DrawMenuItemNorm((struct MenuItem *)&menus[level][item], pos[level][0], pos[level][1],
                            c1, c2, c3);
                    }
                } else if (menus[level][item].on2) {
                    /* open the submenu */
                    sub_903F0(ptr, oldmx, oldmy);
                    if (depth != level) {
                        for (i = depth; i > level; i--) {
                            sel[i] = 0;
                            if (bg[i]) {
                                sub_903F0(bg[i], pos[i][0], pos[i][1]);
                                FreeMemBlock(bg[i]);
                                pos[i][1] = pos[i][0] = 0;
                                bg[i] = 0;
                                menus[i] = 0;
                                nitems[i] = 0;
                            }
                        }
                        depth = level;
                    }
                    DrawMenuItemSel((struct MenuItem *)&menus[depth][sel[depth]], pos[depth][0], pos[depth][1],
                        c1, c2, c3);
                    sel[depth] = item;
                    DrawMenuItemNorm((struct MenuItem *)&menus[depth][item], pos[depth][0], pos[depth][1],
                        c1, c2, c3);
                    depth++;
                    menus[depth] = (MenuItem *)menus[level][item].on2;
                    nitems[depth] = menus[level][item].pad;
                    pos[depth][0] = (depth != 1 ? menus[level][item].x2 : menus[level][item].x1) + pos[depth - 1][0];
                    pos[depth][1] = (depth != 1 ? menus[level][item].y1 : menus[level][item].y2) + pos[depth - 1][1];
                    w = menus[depth][nitems[depth] - 1].x2 - menus[depth][0].x1 + 1;
                    h = menus[depth][nitems[depth] - 1].y2 - menus[depth][0].y1 + 1;
                    bg[depth] = sub_8CCA8((char *)str_Menubuff5, w * 4 * h + 0x11, 0x20);
                    *(Hdr17 *)bg[depth] = *(Hdr17 *)pointerspr;
                    ((short *)bg[depth])[2] = w;
                    ((short *)bg[depth])[3] = h;
                    sub_91400(bg[depth], pos[depth][0], pos[depth][1]);
                    DrawMenuDropdown(menus[depth], nitems[depth], pos[depth][0], pos[depth][1], c1, c2, c3);
                    sel[depth] = 0;
                    DrawMenuItemNorm((struct MenuItem *)menus[depth], pos[depth][0], pos[depth][1], c1, c2, c3);
                } else {
                    sub_903F0(ptr, oldmx, oldmy);
                    if (depth != level) {
                        for (i = depth; i > level; i--) {
                            sel[i] = 0;
                            if (bg[i]) {
                                sub_903F0(bg[i], pos[i][0], pos[i][1]);
                                pos[i][1] = pos[i][0] = 0;
                                FreeMemBlock(bg[i]);
                                bg[i] = 0;
                                menus[i] = 0;
                                nitems[i] = 0;
                            }
                        }
                        depth = level;
                    }
                    DrawMenuItemSel((struct MenuItem *)&menus[level][sel[level]], pos[level][0], pos[level][1],
                        c1, c2, c3);
                    sel[level] = item;
                    DrawMenuItemNorm((struct MenuItem *)&menus[level][item], pos[level][0], pos[level][1],
                        c1, c2, c3);
                }
            } else {
                sub_903F0(ptr, oldmx, oldmy);
                if (depth != 0) {
                    /* a click outside the menus closes the dropdowns */
                    for (i = depth; i >= 0; i--) {
                        if (bg[i]) {
                            sub_903F0(bg[i], pos[i][0], pos[i][1]);
                            pos[i][1] = pos[i][0] = 0;
                            FreeMemBlock(bg[i]);
                        }
                    }
                    depth = 0;
                    menus[1] = 0;
                    nitems[1] = sel[1] = bg[1] = bg[0] = 0;
                } else {
                    /* a click on a day: select the team's unplayed game there */
                    newsel = -1;
                    if (mx >= 0x52 && mx < 0x25F && my >= 0x44 && my < 0x1B2) {
                        day = (my - 0x44) / 0x3D * 7 + (mx - 0x52) / 0x4B - monthfirstday[calmonth] % 7;
                        if (day >= 0 && (int)day < (int)monthdays[calmonth]) {
                            for (i = 0; i < ngames; i++) {
                                if (games[i][0] != calmonth + 1 || games[i][1] != day + 1 || games[i][4] != 0xFF
                                    || games[i][5] != 0xFF)
                                    continue;
                                if (gameidx[i] == calsel) calexit = -1;
                                if (today < 0x444 || gameidx[i] == firstgame) {
                                    newsel = gameidx[i];
                                    selgame = i;
                                    i = ngames;
                                }
                                oldm = calselmonth;
                                oldd = calselday;
                                calselmonth = games[selgame][0];
                                calselday = games[selgame][1];
                                if (calexit == 0) SetGameSides(team, games[0], selgame);
                                sub_B4BA8();
                                DrawMenuBar(calmenubar, 3, c1, c2, c3);
                                if (oldm == calselmonth && oldd != calselday) {
                                    k = monthfirstday_m1[calselmonth] + oldd - 1;
                                    sub_B4BC4(calcolx[k % 7] - 2, calcolx[k % 7] + 0x4D, calrowy[k / 7] - 2,
                                        calrowy[k / 7] + 0x3F);
                                    DrawCalendarDay(calmonth, crests, unused, games[0], ngames, team, font,
                                        calendarshapes);
                                }
                                k = monthfirstday_m1[calselmonth] + calselday - 1;
                                sub_B4BC4(calcolx[k % 7] - 2, calcolx[k % 7] + 0x4D, calrowy[k / 7] - 2,
                                    calrowy[k / 7] + 0x3F);
                                DrawCalendarDay(calmonth, crests, unused, games[0], ngames, team, font, calendarshapes);
                                sub_B4BC4(0, 0x280, 0, 0x1E0);
                            }
                        }
                    }
                    calsel = newsel;
                }
            }
            sub_91400(ptr, oldmx, oldmy);
            sub_903F0(ptr, oldmx, oldmy);
            sub_91400(ptr, mx, my);
            if (calexit == 0) sub_91370(pointerspr, mx, my);
            oldmx = mx;
            oldmy = my;
        } while (calexit == 0);
    }
    FreeMemBlock(ptr);
    FreeMemBlock(logos);
    teamstatscb = (int)GameTeamStatsScreen;
    FreeMemBlock(calendarshapes);
    calendarshapes = 0;
    skaterstatscb = (int)GameSkaterStatsScreen;
    goaliestatscb = (int)GameGoalieStatsScreen;
    standingscb = (int)GameStandingsScreen;
    standingsmenucb = (int)GameStandingsMenu;
    if (musicon && songdata) sub_8FCDF(musichandle, 3, 100);
    return calsel;
}
