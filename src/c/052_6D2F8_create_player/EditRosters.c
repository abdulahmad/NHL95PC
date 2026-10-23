/* Create player / edit rosters: the roster editing screen's loop. */
/* DRAFT under 10.0 GA: 2,537 vs 2,604 bytes, 175 differing instructions; menu-branch register picks remain. */
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
   up / down buttons and the scroll bar move it (dword_EBCA4, redrawn by DrawEditRosters); in the move mode
   (dword_D0B12 2) only its two buttons work; a click goes to the menu bar (three levels, as RunMenu; an action gets
   the selected items and the pointer position) or to the roster panels (RosterPanelClick). Leaving with unsaved
   changes (dbdirty) asks first ("The database has not been saved..."). bar / n / col1-col3: as RunMenu. Result: 0. */
int EditRosters(MenuItem *bar, int n, int col1, int col2, int col3)
{
    struct {
        int pos[3][2];
        MenuItem *menus[3];
        int bg[3];
        int sel[3];
        int nitems[3];
        int h;
        int w;
        int item;
        int level;
        int my;
        int mx;
        int oldmy;
        int oldmx;
        int col2;
        int col1;
    } s;
    int bits;
    int depth;
    int at;
    int i;
    int k;
    unsigned char *e;
    MenuItem *m;

    s.col1 = col1;
    s.col2 = col2;
    depth = 0;
    dbdirty = 0;
    LoadBothRosterLists();
    DrawEditRosters();
    s.menus[0] = bar;
    s.nitems[0] = n;
    s.pos[0][1] = s.pos[0][0] = 0;
    for (i = 0; i < 3; i++) {
        s.bg[i] = 0;
        s.sel[i] = 0;
        if (i > 0) {
            s.menus[i] = 0;
            s.nitems[i] = 0;
        }
    }
    s.mx = s.oldmx = (s.menus[0]->x1 + s.menus[0]->x2) / 2;
    s.my = s.oldmy = (s.menus[0]->y1 + s.menus[0]->y2) / 2;
    sub_91400(editptrspr, s.oldmx, s.oldmy);
    sub_91370(pointerspr, s.oldmx, s.oldmy);
    FadePalStep(0, savepal, 0x10);
    sub_B2E1B(0, 0, 0x280, 0x1E0);
    MouseSetPos(s.oldmx, s.oldmy);
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
            if (e) bits = ((int (*)(unsigned char *, int *, int *))ptrupdatefn)(e, &s.mx, &s.my);
        } while (e && !(bits & 2));
        if (dword_D0C20 && (rosterisfa[0] == 1 || rosterisfa[1] == 1) && dword_D0B12 != 2 && bits) {
            sub_903F0(editptrspr, s.oldmx, s.oldmy);
            k = TrackButtons((int *)unk_D0BB8, 2, s.mx, s.my, bits);
            if (k == 0 && dword_EBCA4 > 0) {
                dword_EBCA4--;
                DrawEditRosters();
            } else if (k == 1 && facount - 0x1C > dword_EBCA4) {
                dword_EBCA4 += k;
                DrawEditRosters();
            }
            if (TrackScrollBars(unk_D0BF0, 1, s.mx, s.my, bits) >= 0 && dword_EBCA4 != dword_D0C10) {
                dword_EBCA4 = dword_D0C10;
                DrawEditRosters();
            }
            sub_91400(editptrspr, s.mx, s.my);
            sub_91370(pointerspr, s.mx, s.my);
            s.oldmx = s.mx;
            s.oldmy = s.my;
        }
        if (dword_D0B12 == 2 && bits & 1) {
            sub_903F0(editptrspr, s.oldmx, s.oldmy);
            TrackButtons((int *)unk_D0B80, 2, s.mx, s.my, bits);
            sub_91400(editptrspr, s.mx, s.my);
            sub_91370(pointerspr, s.mx, s.my);
            s.oldmx = s.mx;
            s.oldmy = s.my;
        } else if (!(bits & 2)) {
            if (s.mx != s.oldmx || s.my != s.oldmy) {
                sub_903F0(editptrspr, s.oldmx, s.oldmy);
                sub_91400(editptrspr, s.mx, s.my);
                sub_91370(pointerspr, s.mx, s.my);
                s.oldmx = s.mx;
                s.oldmy = s.my;
            }
        } else {
            if (dword_D0B12 == 2) {
                sub_903F0(editptrspr, s.oldmx, s.oldmy);
            } else if (MenuHitTest(s.mx, s.my, s.menus, depth, s.nitems, &s.pos[0][0], &s.level, &s.item)) {
                m = &s.menus[s.level][s.item];
                if (m->on1) {
                    if (s.item == s.sel[s.level]) {
                        sub_903F0(editptrspr, s.oldmx, s.oldmy);
                        for (i = 2; i >= 0; i--) {
                            if (s.bg[i]) {
                                sub_903F0(s.bg[i], s.pos[i][0], s.pos[i][1]);
                                s.pos[i][1] = s.pos[i][0] = 0;
                                FreeMemBlock(s.bg[i]);
                            }
                        }
                        depth = 0;
                        ((void (*)(int *, int *, int *))s.menus[s.level][s.item].on1)(s.sel, &s.oldmx, &s.oldmy);
                        for (i = 0; i < 3; i++) {
                            s.bg[i] = 0;
                            if (i > 0) {
                                s.menus[i] = 0;
                                s.sel[i] = 0;
                                s.nitems[i] = 0;
                            }
                        }
                        MouseSetPos(s.oldmx, s.oldmy);
                        s.mx = s.oldmx;
                        s.my = s.oldmy;
                        ClearInputQueue();
                    } else {
                        sub_903F0(editptrspr, s.oldmx, s.oldmy);
                        if (depth != s.level) {
                            for (i = depth; i > s.level; i--) {
                                s.sel[i] = 0;
                                if (s.bg[i]) {
                                    sub_903F0(s.bg[i], s.pos[i][0], s.pos[i][1]);
                                    s.pos[i][0] = 0;
                                    s.pos[i][1] = s.pos[i][0];
                                    FreeMemBlock(s.bg[i]);
                                    s.bg[i] = 0;
                                    s.menus[i] = 0;
                                    s.nitems[i] = 0;
                                }
                            }
                            depth = s.level;
                        }
                        DrawMenuItemSel((struct MenuItem *)&s.menus[s.level][s.sel[s.level]], s.pos[s.level][0],
                            s.pos[s.level][1], s.col1, s.col2, col3);
                        s.sel[s.level] = s.item;
                        DrawMenuItemNorm((struct MenuItem *)&s.menus[s.level][s.item], s.pos[s.level][0],
                            s.pos[s.level][1], s.col1, s.col2, col3);
                    }
                } else if (m->on2) {
                    sub_903F0(editptrspr, s.oldmx, s.oldmy);
                    if (depth != s.level) {
                        for (i = depth; i > s.level; i--) {
                            s.sel[i] = 0;
                            if (s.bg[i]) {
                                sub_903F0(s.bg[i], s.pos[i][0], s.pos[i][1]);
                                s.pos[i][0] = 0;
                                s.pos[i][1] = s.pos[i][0];
                                FreeMemBlock(s.bg[i]);
                                s.bg[i] = 0;
                                s.menus[i] = 0;
                                s.nitems[i] = 0;
                            }
                        }
                        depth = s.level;
                    }
                    i = depth;
                    DrawMenuItemSel((struct MenuItem *)&s.menus[i][s.sel[i]], s.pos[i][0], s.pos[i][1], s.col1, s.col2,
                        col3);
                    s.sel[i] = s.item;
                    DrawMenuItemNorm((struct MenuItem *)&s.menus[i][s.item], s.pos[i][0], s.pos[i][1], s.col1, s.col2,
                        col3);
                    depth++;
                    s.menus[depth] = (MenuItem *)s.menus[s.level][s.item].on2;
                    s.nitems[depth] = s.menus[s.level][s.item].pad;
                    s.pos[depth][0] = (depth != 1 ? s.menus[s.level][s.item].x2 : s.menus[s.level][s.item].x1) + s.pos[depth - 1][0];
                    s.pos[depth][1] = (depth != 1 ? s.menus[s.level][s.item].y1 : s.menus[s.level][s.item].y2) + s.pos[depth - 1][1];
                    s.w = s.menus[depth][s.nitems[depth] - 1].x2 - s.menus[depth][0].x1 + 1;
                    s.h = s.menus[depth][s.nitems[depth] - 1].y2 - s.menus[depth][0].y1 + 1;
                    s.bg[depth] = sub_8CCA8((char *)str_Menubuff, 0x11 + (s.w << 2) * s.h, 0);
                    *(EdHdr17 *)s.bg[depth] = *(EdHdr17 *)pointerspr;
                    ((short *)s.bg[depth])[2] = s.w;
                    ((short *)s.bg[depth])[3] = s.h;
                    sub_91400(s.bg[depth], s.pos[depth][0], s.pos[depth][1]);
                    DrawMenuDropdown(s.menus[depth], s.nitems[depth], s.pos[depth][0], s.pos[depth][1], s.col1,
                        s.col2, col3);
                    s.sel[depth] = 0;
                    DrawMenuItemNorm((struct MenuItem *)s.menus[depth], s.pos[depth][0], s.pos[depth][1], s.col1,
                        s.col2, col3);
                } else {
                    sub_903F0(editptrspr, s.oldmx, s.oldmy);
                    DrawMenuItemSel((struct MenuItem *)&s.menus[s.level][s.sel[s.level]], s.pos[s.level][0],
                        s.pos[s.level][1], s.col1, s.col2, col3);
                    s.sel[s.level] = s.item;
                    DrawMenuItemNorm((struct MenuItem *)&s.menus[s.level][s.item], s.pos[s.level][0],
                        s.pos[s.level][1], s.col1, s.col2, col3);
                }
            } else {
                sub_903F0(editptrspr, s.oldmx, s.oldmy);
                i = 2;
                do {
                    if (s.bg[i]) {
                        sub_903F0(s.bg[i], s.pos[i][0], s.pos[i][1]);
                        s.pos[i][1] = s.pos[i][0] = 0;
                        FreeMemBlock(s.bg[i]);
                    }
                    i--;
                } while (i >= 0);
                depth = 0;
                for (i = 0; i < 3; i++) {
                    s.bg[i] = 0;
                    if (i > 0) {
                        s.menus[i] = 0;
                        s.sel[i] = s.nitems[i] = 0;
                    }
                }
                RosterPanelClick(s.mx, s.my);
            }
            sub_91400(editptrspr, s.oldmx, s.oldmy);
            sub_903F0(editptrspr, s.oldmx, s.oldmy);
            sub_91400(editptrspr, s.mx, s.my);
            sub_91370(pointerspr, s.mx, s.my);
            s.oldmx = s.mx;
            s.oldmy = s.my;
        }
        if (editrosters_exit == -1) {
            sub_903F0(editptrspr, s.oldmx, s.oldmy);
            if (dbdirty) {
                msglines[0] = (int)str_TheDatabaseHasNot;
                msglines[1] = (int)str_AreYouSureYou;
                if (MessageBox(-1, -1, (char *)msglines, 2, (int)btn_LeagueExists, 2, (int)&s.mx, (int)&s.my,
                        -1) <= 0)
                    editrosters_exit = 0;
            }
        }
    } while (!editrosters_exit);
    return 0;
}
