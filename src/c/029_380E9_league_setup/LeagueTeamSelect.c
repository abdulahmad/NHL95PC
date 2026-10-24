/* League setup: the team selection grid. */
#define BuildStandingsGrid BuildStandingsGrid_decl
#define ChooseLeagueController ChooseLeagueController_decl
#define MenuHitTest MenuHitTest_decl
#define sub_8F98F sub_8F98F_decl
#define sub_8FB8E sub_8FB8E_decl
#include "nhl95.h"
#undef BuildStandingsGrid
#undef ChooseLeagueController
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
typedef struct Str19 { char c[19]; } Str19;

int BuildStandingsGrid(int fd, unsigned char (*order)[7]);
void ChooseLeagueController(unsigned char *teams, int n, int y, int x);
#pragma aux ChooseLeagueController parm [eax] [edx] [ecx] [ebx];
int MenuHitTest(int x, int y, MenuItem **menus, int i, int *counts, int *origin, int *hitMenu, int *hitItem);
int sub_8F98F(char *path);  /* music library: load a song */
void sub_8FB8E(int song, int handle, int chan, int vol);  /* music library: play a song */

/* DRAFT (first pass from Ghidra; the menu loop follows MainDeskLoop's draft): 5,893 vs 5,888 bytes, 50
   differing under 10.0 GA. Every call is in place and the frame size matches. Found under GA: the dropdown
   close loops' position reset as two stores (`pos[i][0] = 0; pos[i][1] = 0;`; the chained form shifts every
   slot), the arrays declared menus, bg, nitems, the origin ternaries as `depth != 1 ? x2 : x1`, and the
   address-taken scalars declared among the arrays as below: they have no register conflict, so their slots
   follow their declaration order through Watcom's size sort (docs/WCC_INTERNALS.md "Stack slots"); this order
   gives the EXE's h, item, level, w, my, mx, oldmy, oldmx, hit, fh upward from 220h. The last branch's
   DrawMenuItemNorm reads the item back as sel[level] (the EXE reloads it there). Left: the sprite-size
   product's registers (L165), the bg[i] register in the FreeMemBlock loop, the two ClearInputQueue tails
   merged, and the first select copy: the EXE keeps item in eax from the sel[level] store and jumps into the
   last copy's call; C reloads item and keeps its own call. */
/* LeagueTeamSelect (38B4F, PC only): the league setup team grid. Set the text state and the identity colour
   remap, then build the 4 x 7 grid of team numbers by division: the default order (divisionteams) for a new
   league (mode bit 0), else the standings read from the league's teams database (BuildStandingsGrid). Unless
   that failed, or the mode is 8 with a single human, fade out (stopping the music), copy the 26 team entries
   (1Eh bytes: name, password at +0Bh, human flag +17h, controller +19h), draw the EMBNHL background, the grid
   with the title and the menu bar (teamselmenubar: Done / Cancel, plus the settings item, lgsetmenu or
   lgsetshowmenu, for modes 1 and 8), select the first grid team, play the LEAGUETM song and fade in. Then follow
   the mouse as in MainDeskLoop: a menu item with an action runs it (TeamSelDone / TeamSelCancel set
   teamselresult; Cancel clears the pick and fades out, Done ends the loop when the mode's condition holds: a
   human for modes 1, 2 and 4, a human pick for mode 8, two human picks for mode 10h); a click on the grid moves
   the pick, and a second click on the picked team acts on it: modes 8 and 10h take a human team (10h then picks
   the second team, which may not be the first), mode 4 removes a human team (asked, with its password; not the
   league controller) while more than one is left, modes 1 and 2 add one (the player's name, unique, then the
   password twice, stored encrypted). At the end store the human count, and for a picked team outside mode 8
   let a new league choose its controller, ask which teams to export and copy the entries back. With no grid
   shown (mode 8, one human) the pick is the first human team. dir: the league directory; humans: the human
   team count (in and out); names: the team names (21 bytes each, the 24th as "Mighty Ducks of Anaheim");
   teams: the 26 team entries; mode: 1 new league, 2 add a human, 4 remove one, 8 pick a human team, 10h pick
   two teams; title: the grid title; picks: the picked team (two for mode 10h; -1 when cancelled). No
   result. */
void LeagueTeamSelect(char *dir, int *humans, char *names, unsigned char *teams, int mode, char *title,
    int *picks)
{
    unsigned char remap[0x100];
    char msg[0x54];
    unsigned char textstate[0x40];
    char path[0x20];
    unsigned char grid[4][7];
    int hit;
    int sel[4];
    int pos[2][2];
    char pw2[12];  /* the password again */
    char pw1[12];  /* the player's name, then the password */
    int oldmy;
    MenuItem *menus[2];
    int my;
    int w;
    int fh;
    int bg[2];
    int nitems[2];
    int level;
    int item;
    int oldmx;
    int h;
    int mx;
    int bank;
    int art;
    int done;
    int n;
    int c40;
    int c42;
    int c41;
    int ptr;
    int depth;
    int cur;
    int i;
    int err;
    int bits;
    int r;
    int k;
    int size;
    int v;  /* the Pal20 bank, then the old pick */
    unsigned char *pal;
    unsigned char *e;
    unsigned char *copy;

    c40 = 0x40;
    c41 = 0x41;
    c42 = 0x42;
    depth = 0;
    sub_8E9E8(textstate);
    sub_8EA18(mainfont);
    sub_B4BA8();
    for (i = 0; i < 0x100; i++) remap[i] = i;
    sub_B4DD4(remap);
    SetDialogColors(0x41, 0x40, 0x42, 0x40, 0);
    if (mode & 1) {
        err = 0;
        memcpy(grid, divisionteams, 0x1C);
    } else {
        MakePath(path, dir, (char *)leaguedbnames[4], (char *)str_extDB);
        if ((err = FileOpenRead(path, &fh)) == 0) err = BuildStandingsGrid(fh, grid);
        FileClose(&fh);
    }
    if (err == 0 && (mode != 8 || *humans != 1 ? 1 : 0)) {
        sub_8FCDF(musichandle, 3, 100);
        pal = (unsigned char *)sub_8CCA8((char *)str_Pal19, 0x300, 0x20);
        sub_8FFB0(0, 0x100, pal);
        FadePalStep(1, pal, 0x10);
        FreeMemBlock((int)pal);
        if (musicon && songdata) {
            while (sub_8FC8A(musicslot, 3) == 0) ;
            sub_8D2F0(songdata);
            songdata = 0;
        }
        copy = (unsigned char *)sub_8CCA8((char *)str_TPI, 0x30C, 0x20);
        memcpy(copy, teams, 0x30C);
        MakePath(path, fileoncd[0x8C] == 1 ? (char *)cddriveptr : 0, (char *)str_Embnhl, 0);
        bank = sub_8E83C(path, 0);
        art = sub_B30B4(bank, (char *)str_Bkgd8);
        sub_B4BA8();
        sub_B392C(0);
        SetTextColors(0x40, 0x43);
        sub_91370(art, 0, 0);
        DrawTeamGrid(copy, title, (unsigned char *)grid, art);
        if (mode & 1) {
            *(unsigned char **)&teamselsetslot = lgsetmenu;
            nitems[0] = 2;
        } else if (mode & 8) {
            *(unsigned char **)&teamselsetslot = lgsetshowmenu;
            nitems[0] = 2;
        } else {
            teamselsetslot = 0;
            nitems[0] = 1;
        }
        menus[0] = (MenuItem *)teamselmenubar;
        menus[1] = 0;
        pos[0][1] = pos[0][0] = sel[1] = sel[0] = bg[1] = bg[0] = 0;
        DrawMenuBar(menus[0], nitems[0], c40, c41, c42);
        cur = 0;
        picks[0] = grid[0][0];
        HighlightGridCell(picks[0], (unsigned char *)grid, -1);
        if (mode == 1) n = 0;
        else n = *humans;
        size = ((((short *)pointerspr)[2] << 2) + 4) * (((short *)pointerspr)[3] + 1) + 0x11;
        ptr = sub_8CCA8((char *)str_Pointer9, size, 0x20);
        *(Hdr17 *)ptr = *(Hdr17 *)pointerspr;
        ((short *)ptr)[2] = ((short *)pointerspr)[2] + 1;
        ((short *)ptr)[3] = ((short *)pointerspr)[3] + 1;
        if (musicon && !songdata) {
            MakePath(path, fileoncd[0x1E0] == 1 ? (char *)cddriveptr : 0, (char *)str_Leaguetm2, (char *)str_Iff10);
            songdata = sub_8F98F(path);
            if (songdata && gameopts.music) sub_8FB8E(songdata, musichandle, 3, 0x4C);
        }
        MakePath(path, fileoncd[0x1AD] == 1 ? (char *)cddriveptr : 0, (char *)str_Tspal, 0);
        v = sub_8E83C(path, 0);
        FadePalStep(0, (unsigned char *)sub_B30B4(v, (char *)str_Pal20) + 0x10, 0x10);
        FreeMemBlock(v);
        sub_B2DCA(&hit, &oldmx, &oldmy);
        mx = oldmx;
        my = oldmy;
        sub_91400(ptr, oldmx - 4, oldmy);
        sub_91370(pointerspr, oldmx - 4, oldmy);
        ClearInputQueue();
        done = 0;
        teamselresult = 0;
        do {
            bits = 0;
            do {
                e = GetInputEvent();
                if (e) bits = ((int (*)(unsigned char *, int *, int *))ptrupdatefn)(e, &mx, &my);
            } while (e && !(bits & 2));
            if (!(bits & 2)) {
                if (mx == oldmx && my == oldmy) continue;
                sub_903F0(ptr, oldmx - 4, oldmy);
                sub_91400(ptr, mx - 4, my);
                sub_91370(pointerspr, mx - 4, my);
                oldmx = mx;
                oldmy = my;
                continue;
            }
            if (MenuHitTest(mx, my, menus, depth, nitems, &pos[0][0], &level, &item)) {
                if (menus[level][item].on1) {
                    if (item == sel[level]) {
                        /* the second click on the selected item: close the dropdowns and run it */
                        sub_903F0(ptr, oldmx - 4, oldmy);
                        for (i = 1; i >= 0; i--) {
                            if (bg[i]) {
                                sub_903F0(bg[i], pos[i][0], pos[i][1]);
                                pos[i][1] = pos[i][0] = 0;
                                FreeMemBlock(bg[i]);
                            }
                        }
                        depth = 0;
                        ((void (*)(void))menus[level][item].on1)();
                        if (teamselresult == -1) {
                            picks[cur] = -1;
                            pal = (unsigned char *)sub_8CCA8((char *)str_Pal19, 0x300, 0x20);
                            if (musicon && songdata) sub_8FCDF(musichandle, 3, 100);
                            sub_8FFB0(0, 0x100, pal);
                            FadePalStep(1, pal, 0x10);
                            FreeMemBlock((int)pal);
                            done = -1;
                        } else if (teamselresult == 1
                            && (((mode & 7) && n >= 1)
                                || ((mode & 8) && copy[picks[cur] * 30 + 0x17] == 1)
                                || ((mode & 0x10) && cur == 1 && copy[picks[0] * 30 + 0x17] == 1
                                    && copy[picks[1] * 30 + 0x17] == 1))) {
                            done = -1;
                        }
                        menus[1] = 0;
                        nitems[1] = sel[1] = bg[1] = bg[0] = 0;
                        MouseSetPos(oldmx, oldmy);
                        mx = oldmx;
                        my = oldmy;
                        ClearInputQueue();
                    } else {
                        sub_903F0(ptr, oldmx - 4, oldmy);
                        DrawMenuItemSel((struct MenuItem *)&menus[level][sel[level]], pos[level][0], pos[level][1],
                            c40, c41, c42);
                        sel[level] = item;
                        DrawMenuItemNorm((struct MenuItem *)&menus[level][item], pos[level][0], pos[level][1],
                            c40, c41, c42);
                    }
                } else if (menus[level][item].on2) {
                    /* open the submenu */
                    sub_903F0(ptr, oldmx - 4, oldmy);
                    if (depth != level) {
                        for (i = depth; i > level; i--) {
                            sel[i] = 0;
                            if (bg[i]) {
                                sub_903F0(bg[i], pos[i][0], pos[i][1]);
                                pos[i][0] = 0;
                                pos[i][1] = 0;
                                FreeMemBlock(bg[i]);
                                bg[i] = 0;
                                menus[i] = 0;
                                nitems[i] = 0;
                            }
                        }
                        depth = level;
                    }
                    DrawMenuItemSel((struct MenuItem *)&menus[depth][sel[depth]], pos[depth][0], pos[depth][1],
                        c40, c41, c42);
                    sel[depth] = item;
                    DrawMenuItemNorm((struct MenuItem *)&menus[depth][item], pos[depth][0], pos[depth][1],
                        c40, c41, c42);
                    depth++;
                    menus[depth] = (MenuItem *)menus[level][item].on2;
                    nitems[depth] = menus[level][item].pad;
                    pos[depth][0] = (depth != 1 ? menus[level][item].x2 : menus[level][item].x1) + pos[depth - 1][0];
                    pos[depth][1] = (depth != 1 ? menus[level][item].y1 : menus[level][item].y2) + pos[depth - 1][1];
                    w = menus[depth][nitems[depth] - 1].x2 - menus[depth][0].x1 + 1;
                    h = menus[depth][nitems[depth] - 1].y2 - menus[depth][0].y1 + 1;
                    bg[depth] = sub_8CCA8((char *)str_Menubuff6, w * 4 * h + 0x11, 0x20);
                    *(Hdr17 *)bg[depth] = *(Hdr17 *)pointerspr;
                    ((short *)bg[depth])[2] = w;
                    ((short *)bg[depth])[3] = h;
                    sub_91400(bg[depth], pos[depth][0], pos[depth][1]);
                    DrawMenuDropdown(menus[depth], nitems[depth], pos[depth][0], pos[depth][1], c40, c41, c42);
                    sel[depth] = 0;
                    DrawMenuItemNorm((struct MenuItem *)menus[depth], pos[depth][0], pos[depth][1], c40, c41, c42);
                } else {
                    sub_903F0(ptr, oldmx - 4, oldmy);
                    DrawMenuItemSel((struct MenuItem *)&menus[level][sel[level]], pos[level][0], pos[level][1],
                        c40, c41, c42);
                    sel[level] = item;
                    DrawMenuItemNorm((struct MenuItem *)&menus[level][sel[level]], pos[level][0], pos[level][1],
                        c40, c41, c42);
                }
            } else {
                sub_903F0(ptr, oldmx - 4, oldmy);
                if (depth != 0) {
                    /* a click outside the menus closes the dropdowns */
                    for (i = 1; i >= 0; i--) {
                        if (bg[i]) {
                            sub_903F0(bg[i], pos[i][0], pos[i][1]);
                            pos[i][0] = 0;
                            pos[i][1] = 0;
                            FreeMemBlock(bg[i]);
                        }
                    }
                    depth = 0;
                    menus[1] = 0;
                    nitems[1] = sel[1] = bg[1] = bg[0] = 0;
                } else {
                    /* a click on the grid */
                    hit = TeamGridHitTest(mx, my, (unsigned char *)grid);
                    if (mode == 0x10 && cur == 1 && hit == picks[0]) hit = -1;
                    if (hit >= 0) {
                        v = picks[cur];
                        picks[cur] = hit;
                        if (v == hit) {
                            if ((mode & 0x18) && copy[picks[cur] * 30 + 0x17] == 1) {
                                /* pick a human team */
                                HighlightGridCell(v, (unsigned char *)grid, 0);
                                HighlightGridCell(picks[cur], (unsigned char *)grid, -1);
                                if (cur == 0 && (mode & 0x10)) {
                                    cur++;
                                    picks[cur] = -1;
                                } else {
                                    done = -1;
                                }
                            } else if ((mode & 4) && n > 1 && copy[picks[cur] * 30 + 0x19] == 0
                                && copy[picks[cur] * 30 + 0x17] == 1) {
                                /* remove a human team */
                                SaveGridCellBg(picks[cur], (unsigned char *)grid, ptr, oldmx, oldmy);
                                HighlightGridCell(picks[cur], (unsigned char *)grid, 0);
                                HighlightGridCell(picks[cur], (unsigned char *)grid, -1);
                                *(unsigned char **)(removeteammsg + 4) = copy + picks[cur] * 30;
                                if (MessageBox(-1, -1, (char *)removeteammsg, 2, (int)removeteambtns, 2, (int)&oldmx,
                                        (int)&oldmy, -1) == 0
                                    && AskTeamPassword(picks[cur], (char *)copy) == 0) {
                                    copy[picks[cur] * 30 + 0x17] = 0;
                                    n--;
                                    memset(copy + picks[cur] * 30, 0, 0xB);
                                    memset(copy + picks[cur] * 30 + 0xB, 0, 0xB);
                                    RestoreGridCellBg(picks[cur], (int)grid);
                                    DrawTeamGridName(picks[cur], (char *)copy, art, (unsigned char *)grid);
                                } else {
                                    RestoreGridCellBg(picks[cur], (int)grid);
                                }
                            } else if ((mode & 3) && copy[picks[cur] * 30 + 0x17] == 0) {
                                /* add a human team: the player's name, then the password */
                                SaveGridCellBg(picks[cur], (unsigned char *)grid, ptr, oldmx, oldmy);
                                HighlightGridCell(picks[cur], (unsigned char *)grid, 0);
                                HighlightGridCell(picks[cur], (unsigned char *)grid, -1);
                                memset(copy + picks[cur] * 30, 0, 0xB);
                                memset(copy + picks[cur] * 30 + 0xB, 0, 0xB);
                                *(Str19 *)msg = *(Str19 *)str_WhoWillPlayThe;
                                strcat(msg, picks[cur] == 0x18 ? (char *)str_MightyDucksOfAnaheim3
                                    : names + picks[cur] * 21);
                                strcat(msg, (char *)unk_C1900);
                                do {
                                    r = TextInputDialog(msg, pw1, 10, 0x46, 0, 0, 0, 1, 4);
                                    if (r != 0x1B) {
                                        strcpy((char *)copy + picks[cur] * 30, pw1);
                                        r = 0;
                                        for (k = 0; k < 0x1A; k++) {
                                            if (k != picks[cur] && copy[k * 30 + 0x17] == 1
                                                && stricmp((char *)copy + picks[cur] * 30,
                                                       (char *)copy + k * 30) == 0) {
                                                MessageBox(-1, -1, (char *)unk_C7592, 1, 0, 0, (int)&mx, (int)&my, -1);
                                                r = 1;
                                            }
                                        }
                                    }
                                } while (r != 0 && r != 0x1B);
                                if (r != 0x1B) {
                                    do {
                                        strcpy(msg, (char *)str_EnterPasswordFor);
                                        strcat(msg, (char *)copy + picks[cur] * 30);
                                        r = TextInputDialog(msg, pw1, 10, 0x3C, 0, 0, 0, 0, 6);
                                        if (r != 0x1B) {
                                            strcpy(msg, (char *)str_VerifyPasswordFor);
                                            strcat(msg, (char *)copy + picks[cur] * 30);
                                            r = TextInputDialog(msg, pw2, 10, 0x3C, 0, 0, 0, 0, 6);
                                        }
                                        if (r != 0x1B) {
                                            r = 0;
                                            if (strcmp(pw1, pw2) != 0) {
                                                MessageBox(-1, -1, (char *)pwmismatchmsg, 2, 0, 0, (int)&oldmx,
                                                    (int)&oldmy, -1);
                                                r = -1;
                                            }
                                        }
                                    } while (r != 0 && r != 0x1B);
                                }
                                if (r != 0x1B) {
                                    copy[picks[cur] * 30 + 0x17] = 1;
                                    n++;
                                    strcpy((char *)copy + picks[cur] * 30 + 0xB, pw1);
                                    EncryptPassword((char *)copy + picks[cur] * 30 + 0xB, picks[cur]);
                                    RestoreGridCellBg(picks[cur], (int)grid);
                                    DrawTeamGridName(picks[cur], (char *)copy, art, (unsigned char *)grid);
                                } else {
                                    RestoreGridCellBg(picks[cur], (int)grid);
                                }
                                ClearInputQueue();
                            }
                        } else {
                            /* move the pick */
                            if (v >= 0) HighlightGridCell(v, (unsigned char *)grid, -1);
                            HighlightGridCell(picks[cur], (unsigned char *)grid, -1);
                        }
                    }
                }
            }
            sub_91400(ptr, oldmx - 4, oldmy);
            sub_903F0(ptr, oldmx - 4, oldmy);
            sub_91400(ptr, mx - 4, my);
            if (done == 0) sub_91370(pointerspr, mx - 4, my);
            oldmx = mx;
            oldmy = my;
        } while (done == 0);
        *humans = n;
        FreeMemBlock(ptr);
        if (picks[cur] >= 0 && !(mode & 8)) {
            if (mode & 1) ChooseLeagueController(copy, *humans, (int)&oldmy, (int)&oldmx);
            AskExportToFloppy(copy, teams, mode, *humans);
            memcpy(teams, copy, 0x30C);
        }
        FreeMemBlock((int)copy);
        FreeMemBlock(bank);
    } else if (err == 0) {
        /* no grid: the first human team */
        for (i = 0; i < 0x1A; i++) {
            if (teams[i * 30 + 0x17] == 1) {
                picks[0] = i;
                i = 0x1A;
            }
        }
    }
    sub_8EA00(textstate);
}
