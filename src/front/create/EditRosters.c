/* Create player / edit rosters: the roster editing screen's loop. */
/* DRAFT under 10.0 GA: 2,589 vs 2,604 bytes, 108 differing instructions. Plain locals instead of the frame struct
   (a store into the struct made Watcom reload &menus[level][item] for every field of the submenu path; the EXE
   keeps it in eax), col1 / col2 copied into c1 / c2 (the EXE homes them at +6Ch / +68h), the declaration order
   from tools/wccre/declsearch.py --conflicts (every local in its EXE slot), the other-item path drawing
   &menus[level][sel[level]] (the EXE reloads sel[level] there and jumps into the select-item copy), the
   resets in the EXE's store order (pos[i][1] first, sel[i] before nitems[i]) and the close-all loop as a for
   loop (the EXE jumps to its test). Left: a register-cycle offset of three from the move-mode branch on (its
   pointer pushes ebp / eax / edx in the EXE), so the tails after the move-mode and RosterPanelClick branches
   merge further than in the EXE (15 bytes). */
#define EditRosters EditRosters_decl
#define MenuHitTest MenuHitTest_decl
#define LoadBothRosterLists LoadBothRosterLists_decl
#define TrackScrollBars TrackScrollBars_decl
#define RosterPanelClick RosterPanelClick_decl
#include "nhl95.h"
#undef EditRosters
#undef MenuHitTest
#undef LoadBothRosterLists
#undef TrackScrollBars
#undef RosterPanelClick

typedef struct MenuItem {
    int x1, y1, x2, y2;
    char *text;
    int on1, on2;
    int pad;
} MenuItem;

typedef struct { char c[17]; } EdHdr17;

int MenuHitTest(int x, int y, MenuItem **menus, int i, int *counts, int *origin, int *hitMenu, int *hitItem);
void LoadBothRosterLists(void);  /* 6DE7E */
int TrackScrollBars(void *bars, int n, int x, int y, int buttons);  /* 30D0E */
void RosterPanelClick(int x, int y);  /* 6DAC3 */
int EditRosters(MenuItem *bar, int n, int col1, int col2, int col3);

/* EditRosters (6E089, PC only): the roster editing screen. Load both roster lists and draw the screen; then follow
   the mouse until editrosters_exit is set: stop a finished song; with the free agent list shown (rosterisfa) the
   up / down buttons and the scroll bar move it (falisttop, redrawn by DrawEditRosters); in the move mode
   (rostereditmode 2) only its two buttons work; a click goes to the menu bar (three levels, as RunMenu; an action gets
   the selected items and the pointer position) or to the roster panels (RosterPanelClick). Leaving with unsaved
   changes (dbdirty) asks first ("The database has not been saved..."). bar / n / col1-col3: as RunMenu. Result: 0. */
int EditRosters(MenuItem *bar, int n, int col1, int col2, int col3)
{
    int sel[3];
    int pos[3][2];
    int oldmy;
    MenuItem *menus[3];
    int mx;
    int bits;
    int my;
    int c1;
    int level;
    int bg[3];
    int w;
    int nitems[3];
    int item;
    int depth;
    int c2;
    int oldmx;
    int h;
    int at;
    int i;
    int k;
    unsigned char *e;
    MenuItem *m;

    c1 = col1;
    c2 = col2;
    depth = 0;
    dbdirty = 0;
    LoadBothRosterLists();
    DrawEditRosters();
    menus[0] = bar;
    nitems[0] = n;
    pos[0][1] = pos[0][0] = 0;
    for (i = 0; i < 3; i++) {
        bg[i] = 0;
        sel[i] = 0;
        if (i > 0) {
            menus[i] = 0;
            nitems[i] = 0;
        }
    }
    mx = oldmx = (menus[0]->x1 + menus[0]->x2) / 2;
    my = oldmy = (menus[0]->y1 + menus[0]->y2) / 2;
    GrabBlock(editptrspr, oldmx, oldmy);
    DrawArt(pointerspr, oldmx, oldmy);
    FadePalStep(0, savepal, 0x10);
    SetViewRect(0, 0, 0x280, 0x1E0);
    MouseSetPos(oldmx, oldmy);
    ((void (*)(void))mousepollfn)();
    ClearInputQueue();
    do {
        if (musicon && songdata && sub_8FC8A(musicslot, 3)) {
            sub_8D2F0(songdata);
            songdata = 0;
        }
        bits = 0;
        do {
            e = GetInputEvent();
            if (e) bits = ((int (*)(unsigned char *, int *, int *))ptrupdatefn)(e, &mx, &my);
        } while (e && !(bits & 2));
        if (dword_D0C20 && (rosterisfa[0] == 1 || rosterisfa[1] == 1) && rostereditmode != 2 && bits) {
            PutBlock(editptrspr, oldmx, oldmy);
            k = TrackButtons((int *)btn_RosterList, 2, mx, my, bits);
            if (k == 0 && falisttop > 0) {
                falisttop--;
                DrawEditRosters();
            } else if (k == 1 && facount - 0x1C > falisttop) {
                falisttop += k;
                DrawEditRosters();
            }
            if (TrackScrollBars(fascrollbar, 1, mx, my, bits) >= 0 && falisttop != fascrollbar_top) {
                falisttop = fascrollbar_top;
                DrawEditRosters();
            }
            GrabBlock(editptrspr, mx, my);
            DrawArt(pointerspr, mx, my);
            oldmx = mx;
            oldmy = my;
        }
        if (rostereditmode == 2 && bits & 1) {
            PutBlock(editptrspr, oldmx, oldmy);
            TrackButtons((int *)btn_EditRosters, 2, mx, my, bits);
            GrabBlock(editptrspr, mx, my);
            DrawArt(pointerspr, mx, my);
            oldmx = mx;
            oldmy = my;
        } else if (!(bits & 2)) {
            if (mx != oldmx || my != oldmy) {
                PutBlock(editptrspr, oldmx, oldmy);
                GrabBlock(editptrspr, mx, my);
                DrawArt(pointerspr, mx, my);
                oldmx = mx;
                oldmy = my;
            }
        } else {
            if (rostereditmode == 2) {
                PutBlock(editptrspr, oldmx, oldmy);
            } else if (MenuHitTest(mx, my, menus, depth, nitems, &pos[0][0], &level, &item)) {
                m = &menus[level][item];
                if (m->on1) {
                    if (item == sel[level]) {
                        PutBlock(editptrspr, oldmx, oldmy);
                        for (i = 2; i >= 0; i--) {
                            if (bg[i]) {
                                PutBlock(bg[i], pos[i][0], pos[i][1]);
                                pos[i][0] = pos[i][1] = 0;
                                FreeMemBlock(bg[i]);
                            }
                        }
                        depth = 0;
                        ((void (*)(int *, int *, int *))menus[level][item].on1)(sel, &oldmx, &oldmy);
                        for (i = 0; i < 3; i++) {
                            bg[i] = 0;
                            if (i > 0) {
                                menus[i] = 0;
                                sel[i] = 0;
                                nitems[i] = 0;
                            }
                        }
                        MouseSetPos(oldmx, oldmy);
                        mx = oldmx;
                        my = oldmy;
                        ClearInputQueue();
                    } else {
                        PutBlock(editptrspr, oldmx, oldmy);
                        if (depth != level) {
                            for (i = depth; i > level; i--) {
                                sel[i] = 0;
                                if (bg[i]) {
                                    PutBlock(bg[i], pos[i][0], pos[i][1]);
                                    pos[i][0] = pos[i][1] = 0;
                                    FreeMemBlock(bg[i]);
                                    bg[i] = 0;
                                    menus[i] = 0;
                                    nitems[i] = 0;
                                }
                            }
                            depth = level;
                        }
                        DrawMenuItemSel((struct MenuItem *)&menus[level][sel[level]], pos[level][0],
                            pos[level][1], c1, c2, col3);
                        sel[level] = item;
                        DrawMenuItemNorm((struct MenuItem *)&menus[level][sel[level]], pos[level][0],
                            pos[level][1], c1, c2, col3);
                    }
                } else if (m->on2) {
                    PutBlock(editptrspr, oldmx, oldmy);
                    if (depth != level) {
                        for (i = depth; i > level; i--) {
                            sel[i] = 0;
                            if (bg[i]) {
                                PutBlock(bg[i], pos[i][0], pos[i][1]);
                                pos[i][0] = pos[i][1] = 0;
                                FreeMemBlock(bg[i]);
                                bg[i] = 0;
                                menus[i] = 0;
                                nitems[i] = 0;
                            }
                        }
                        depth = level;
                    }
                    i = depth;
                    DrawMenuItemSel((struct MenuItem *)&menus[i][sel[i]], pos[i][0], pos[i][1], c1, c2,
                        col3);
                    sel[i] = item;
                    DrawMenuItemNorm((struct MenuItem *)&menus[i][item], pos[i][0], pos[i][1], c1, c2,
                        col3);
                    depth++;
                    menus[depth] = (MenuItem *)menus[level][item].on2;
                    nitems[depth] = menus[level][item].pad;
                    pos[depth][0] = (depth != 1 ? menus[level][item].x2 : menus[level][item].x1) + pos[depth - 1][0];
                    pos[depth][1] = (depth != 1 ? menus[level][item].y1 : menus[level][item].y2) + pos[depth - 1][1];
                    w = menus[depth][nitems[depth] - 1].x2 - menus[depth][0].x1 + 1;
                    h = menus[depth][nitems[depth] - 1].y2 - menus[depth][0].y1 + 1;
                    bg[depth] = AllocMemBlock((char *)str_Menubuff, 0x11 + (w << 2) * h, 0);
                    *(EdHdr17 *)bg[depth] = *(EdHdr17 *)pointerspr;
                    ((short *)bg[depth])[2] = w;
                    ((short *)bg[depth])[3] = h;
                    GrabBlock(bg[depth], pos[depth][0], pos[depth][1]);
                    DrawMenuDropdown(menus[depth], nitems[depth], pos[depth][0], pos[depth][1], c1,
                        c2, col3);
                    sel[depth] = 0;
                    DrawMenuItemNorm((struct MenuItem *)menus[depth], pos[depth][0], pos[depth][1], c1,
                        c2, col3);
                } else {
                    PutBlock(editptrspr, oldmx, oldmy);
                    DrawMenuItemSel((struct MenuItem *)&menus[level][sel[level]], pos[level][0],
                        pos[level][1], c1, c2, col3);
                    sel[level] = item;
                    DrawMenuItemNorm((struct MenuItem *)&menus[level][item], pos[level][0],
                        pos[level][1], c1, c2, col3);
                }
            } else {
                PutBlock(editptrspr, oldmx, oldmy);
                for (i = 2; i >= 0; i--) {
                    if (bg[i]) {
                        PutBlock(bg[i], pos[i][0], pos[i][1]);
                        pos[i][0] = pos[i][1] = 0;
                        FreeMemBlock(bg[i]);
                    }
                }
                depth = 0;
                for (i = 0; i < 3; i++) {
                    bg[i] = 0;
                    if (i > 0) {
                        menus[i] = 0;
                        nitems[i] = sel[i] = 0;
                    }
                }
                RosterPanelClick(mx, my);
            }
            GrabBlock(editptrspr, oldmx, oldmy);
            PutBlock(editptrspr, oldmx, oldmy);
            GrabBlock(editptrspr, mx, my);
            DrawArt(pointerspr, mx, my);
            oldmx = mx;
            oldmy = my;
        }
        if (editrosters_exit == -1) {
            PutBlock(editptrspr, oldmx, oldmy);
            if (dbdirty) {
                msglines[0] = (int)str_TheDatabaseHasNot;
                msglines[1] = (int)str_AreYouSureYou;
                if (MessageBox(-1, -1, (char *)msglines, 2, (int)btn_LeagueExists, 2, (int)&mx, (int)&my,
                        -1) <= 0)
                    editrosters_exit = 0;
            }
        }
    } while (!editrosters_exit);
    return 0;
}
