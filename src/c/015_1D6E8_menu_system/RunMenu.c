/* Menu system: the menu bar loops. */
#define RunMenu RunMenu_decl
#define MenuHitTest MenuHitTest_decl
#define RunTeamPickMenu RunTeamPickMenu_decl
#define RunPlayerPickMenu RunPlayerPickMenu_decl
#define TeamFromMouse TeamFromMouse_decl
#define sub_90F38 sub_90F38_decl
#include "nhl95.h"
#undef RunMenu
#undef MenuHitTest
#undef RunTeamPickMenu
#undef RunPlayerPickMenu
#undef TeamFromMouse
#undef sub_90F38

typedef struct MenuItem {
    int x1, y1, x2, y2;
    char *text;
    int on1, on2;
    int pad;
} MenuItem;

typedef struct { char c[17]; } MenuHdr17;

int MenuHitTest(int x, int y, MenuItem **menus, int i, int *counts, int *origin, int *hitMenu, int *hitItem);
int RunMenu(MenuItem *bar, int n, int col1, int col2, int col3);
int RunTeamPickMenu(MenuItem *bar, int n, int col1, int col2, int col3);
int RunPlayerPickMenu(MenuItem *bar, int n, int col1, int col2, int col3);
int TeamFromMouse(int x, int y, int *idx);  /* 26B5A */
void __cdecl sub_90F38(int x, int y, int w, int h, int col);  /* graphics library: xor a box */

/* DRAFT: 2,024 vs 2,075 bytes, 305 lines (the EXE keeps the pointer block and position in registers early on;
   see docs/UNSURE.md). */
/* RunMenu (1D6E8, PC only; owner of RunMenu_ret4): run a menu bar of n items in the colours col1-col3 until an
   action returns 1. Save the screen under the pointer (POINTERM block, the pointer bitmap's size plus one) and
   centre the pointer on the bar. Then follow the mouse: a click on an item with an action runs it on the second
   click of the selected item (dropdowns closed first; the menu state reset after it); another item of an open
   menu moves the selection; an item with a submenu opens its dropdown (the screen under it saved in a MENUBUFF
   block); a click outside closes the dropdowns. bar: the items; n: their number; col1-col3: the item colours.
   Result: 0. */
int RunMenu(MenuItem *bar, int n, int col1, int col2, int col3)
{
    struct {
        int pos[4][2];
        int sel[4];
        MenuItem *menus[4];
        int bg[4];
        int nitems[4];
        int item;
        int level;
        int my;
        int mx;
        int h;
        int w;
        int at;
        int ptr;
        int oldmx;
        int oldmy;
        int depth;
    } s;
    int i;
    int bits;
    int r;
    unsigned char *e;
    MenuItem *m;

    s.depth = 0;
    s.menus[0] = bar;
    s.nitems[0] = n;
    s.menus[1] = s.menus[2] = s.menus[3] = 0;
    s.bg[0] = s.bg[1] = s.bg[2] = s.bg[3] = 0;
    s.sel[0] = s.sel[1] = s.sel[2] = s.sel[3] = 0;
    s.pos[0][0] = s.pos[0][1] = 0;
    s.ptr = sub_8CCA8((char *)str_PointerMenu, (((short *)pointerspr)[2] + 1) * (((short *)pointerspr)[3] + 1) + 0x11,
        0x20);
    *(MenuHdr17 *)s.ptr = *(MenuHdr17 *)pointerspr;
    ((short *)s.ptr)[2] = ((short *)pointerspr)[2] + 1;
    ((short *)s.ptr)[3] = ((short *)pointerspr)[3] + 1;
    s.mx = s.oldmx = (s.menus[0]->x1 + s.menus[0]->x2) / 2;
    s.my = s.oldmy = (s.menus[0]->y1 + s.menus[0]->y2) / 2;
    sub_91400(s.ptr, s.oldmx, s.oldmy);
    sub_91370(pointerspr, s.oldmx, s.oldmy);
    sub_B2E1B(0, 0, 0x280, 0x1E0);
    MouseSetPos(s.oldmx, s.oldmy);
    ((void (*)(void))mousepollfn)();
    ClearInputQueue();
    for (;;) {
        bits = 0;
        while ((e = GetInputEvent()) != 0) {
            bits = ((int (*)(unsigned char *, int *, int *))ptrupdatefn)(e, &s.mx, &s.my);
            if (bits & 2) break;
        }
        if (!(bits & 2)) {
            if (s.mx == s.oldmx && s.my == s.oldmy) continue;
            sub_903F0(s.ptr, s.oldmx, s.oldmy);
            sub_91400(s.ptr, s.mx, s.my);
            sub_91370(pointerspr, s.mx, s.my);
            s.oldmx = s.mx;
            s.oldmy = s.my;
            continue;
        }
        if (MenuHitTest(s.mx, s.my, s.menus, s.depth, s.nitems, &s.pos[0][0], &s.level, &s.item)) {
            m = &s.menus[s.level][s.item];
            if (m->on1) {
                if (s.item == s.sel[s.level]) {
                    sub_903F0(s.ptr, s.oldmx, s.oldmy);
                    for (i = 3; i >= 0; i--) {
                        if (s.bg[i]) {
                            sub_903F0(s.bg[i], s.pos[i][0], s.pos[i][1]);
                            s.pos[i][0] = s.pos[i][1] = 0;
                            FreeMemBlock(s.bg[i]);
                        }
                    }
                    s.depth = 0;
                    r = ((int (*)(void))s.menus[s.level][s.item].on1)();
                    s.menus[1] = s.menus[2] = s.menus[3] = 0;
                    s.bg[0] = s.bg[1] = s.bg[2] = s.bg[3] = 0;
                    s.sel[1] = s.sel[2] = s.sel[3] = 0;
                    s.nitems[1] = s.nitems[2] = s.nitems[3] = 0;
                    if (r == 1) {
                        FreeMemBlock(s.ptr);
                        return 0;
                    }
                    MouseSetPos(s.oldmx, s.oldmy);
                    s.mx = s.oldmx;
                    s.my = s.oldmy;
                    ClearInputQueue();
                } else {
                    sub_903F0(s.ptr, s.oldmx, s.oldmy);
                    DrawMenuItemSel((struct MenuItem *)&s.menus[s.level][s.sel[s.level]], s.pos[s.level][0],
                        s.pos[s.level][1], col1, col2, col3);
                    s.sel[s.level] = s.item;
                    DrawMenuItemNorm((struct MenuItem *)&s.menus[s.level][s.item], s.pos[s.level][0],
                        s.pos[s.level][1], col1, col2, col3);
                }
            } else if (m->on2) {
                sub_903F0(s.ptr, s.oldmx, s.oldmy);
                if (s.depth != s.level) {
                    for (i = s.depth; i > s.level; i--) {
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
                    s.depth = s.level;
                }
                i = s.depth;
                DrawMenuItemSel((struct MenuItem *)&s.menus[i][s.sel[i]], s.pos[i][0], s.pos[i][1], col1, col2, col3);
                s.sel[i] = s.item;
                DrawMenuItemNorm((struct MenuItem *)&s.menus[i][s.item], s.pos[i][0], s.pos[i][1], col1, col2, col3);
                m = &s.menus[s.level][s.item];
                s.depth = i + 1;
                s.menus[s.depth] = (MenuItem *)m->on2;
                s.nitems[s.depth] = m->pad;
                s.pos[s.depth][0] = (s.depth == 1 ? m->x1 : m->x2) + s.pos[s.depth - 1][0];
                s.pos[s.depth][1] = (s.depth == 1 ? m->y2 : m->y1) + s.pos[s.depth - 1][1];
                s.w = s.menus[s.depth][s.nitems[s.depth] - 1].x2 - s.menus[s.depth][0].x1 + 1;
                s.h = s.menus[s.depth][s.nitems[s.depth] - 1].y2 - s.menus[s.depth][0].y1 + 1;
                s.bg[s.depth] = sub_8CCA8((char *)str_menubuff, s.w * s.h + 0x11, 0x20);
                *(MenuHdr17 *)s.bg[s.depth] = *(MenuHdr17 *)pointerspr;
                ((short *)s.bg[s.depth])[2] = s.w;
                ((short *)s.bg[s.depth])[3] = s.h;
                sub_91400(s.bg[s.depth], s.pos[s.depth][0], s.pos[s.depth][1]);
                DrawMenuDropdown(s.menus[s.depth], s.nitems[s.depth], s.pos[s.depth][0], s.pos[s.depth][1], col1, col2,
                    col3);
                s.sel[s.depth] = 0;
                DrawMenuItemNorm((struct MenuItem *)s.menus[s.depth], s.pos[s.depth][0], s.pos[s.depth][1], col1, col2,
                    col3);
            } else {
                sub_903F0(s.ptr, s.oldmx, s.oldmy);
                DrawMenuItemSel((struct MenuItem *)&s.menus[s.level][s.sel[s.level]], s.pos[s.level][0],
                    s.pos[s.level][1], col1, col2, col3);
                s.sel[s.level] = s.item;
                DrawMenuItemNorm((struct MenuItem *)&s.menus[s.level][s.item], s.pos[s.level][0], s.pos[s.level][1],
                    col1, col2, col3);
            }
        } else {
            sub_903F0(s.ptr, s.oldmx, s.oldmy);
            for (i = 3; i >= 0; i--) {
                if (s.bg[i]) {
                    sub_903F0(s.bg[i], s.pos[i][0], s.pos[i][1]);
                    s.pos[i][0] = s.pos[i][1] = 0;
                    FreeMemBlock(s.bg[i]);
                }
            }
            s.depth = 0;
            s.menus[1] = s.menus[2] = s.menus[3] = 0;
            s.bg[0] = s.bg[1] = s.bg[2] = s.bg[3] = 0;
            s.sel[1] = s.sel[2] = s.sel[3] = 0;
            s.nitems[1] = s.nitems[2] = s.nitems[3] = 0;
        }
        sub_91400(s.ptr, s.oldmx, s.oldmy);
        sub_903F0(s.ptr, s.oldmx, s.oldmy);
        sub_91400(s.ptr, s.mx, s.my);
        sub_91370(pointerspr, s.mx, s.my);
        s.oldmx = s.mx;
        s.oldmy = s.my;
    }
}

#define TEAMBYTE(c) (((unsigned char *)statsteambuf)[statsteamorder[c] * 26 + 0xD])
#define HILITE(c) \
    y = TEAMBYTE(c) % 2 ? 0x14A : 0xA5; \
    x = TEAMBYTE(c) >= 2 ? 0x140 : 0; \
    y += ((c) < 12 ? (c) % 6 : ((c) - 12) % 7) * 13; \
    sub_90F38(x, y, 0x140, 0xD, 0x80)

/* DRAFT: first pass, 459 lines (the EXE rotates the loop: input first, the tree and pointer redraw before it);
   see docs/UNSURE.md. */
/* RunTeamPickMenu (1DF03, PC only; ends in RunMenu_ret4): RunMenu with a team picker under it, for the team stats
   screens. The selected team (statsteamsel) is shown by an xor bar on the standings grid (sub_90F38: the left or
   right half by its division, the row by its place) or, for the playoffs (statsplayoffs), by the tree highlight
   (MoveTreeHighlight). A click on another team moves the highlight; a second click on the selected team picks it
   (statscategory / statsteamsel, DeskSetExit3b) and returns; in the playoffs moving over the tree redraws it
   (PlayoffTreeHitTest, PlayoffTreeScreen). The menu bar works as in RunMenu, an action re-reading the selected
   team after it runs. bar: the items; n: their number; col1-col3: the item colours. Result: 0. */
int RunTeamPickMenu(MenuItem *bar, int n, int col1, int col2, int col3)
{
    struct {
        int pos[4][2];
        int nitems[4];
        int sel[4];
        int bg[4];
        MenuItem *menus[4];
        int item;
        int level;
        int cur;
        int pick;
        int my;
        int mx;
        int h;
        int w;
        int at;
        int ptr;
        int oldmx;
        int oldmy;
        int depth;
        short hit;
    } s;
    int i;
    int x;
    int y;
    int bits;
    int r;
    unsigned char *e;
    MenuItem *m;

    s.cur = s.pick = 0;
    s.depth = 0;
    s.menus[0] = bar;
    s.nitems[0] = n;
    s.menus[1] = s.menus[2] = s.menus[3] = 0;
    s.bg[0] = s.bg[1] = s.bg[2] = s.bg[3] = 0;
    s.sel[0] = s.sel[1] = s.sel[2] = s.sel[3] = 0;
    s.pos[0][0] = s.pos[0][1] = 0;
    s.ptr = sub_8CCA8((char *)str_PointerMenu, (((short *)pointerspr)[2] + 1) * (((short *)pointerspr)[3] + 1) + 0x11,
        0x20);
    *(MenuHdr17 *)s.ptr = *(MenuHdr17 *)pointerspr;
    ((short *)s.ptr)[2] = ((short *)pointerspr)[2] + 1;
    ((short *)s.ptr)[3] = ((short *)pointerspr)[3] + 1;
    s.mx = s.oldmx = (s.menus[0]->x1 + s.menus[0]->x2) / 2;
    s.my = s.oldmy = (s.menus[0]->y1 + s.menus[0]->y2) / 2;
    if (!statsplayoffs) {
        for (i = 0; i < 0x1A; i++)
            if (statsteamsel == statsteamorder[i]) s.cur = i;
        HILITE(s.cur);
    } else {
        s.cur = statsteamsel;
        if (playofftree[s.cur] != 0x1A) MoveTreeHighlight(&s.cur, 0);
    }
    sub_91400(s.ptr, s.oldmx, s.oldmy);
    sub_91370(pointerspr, s.oldmx, s.oldmy);
    sub_B2E1B(0, 0, 0x280, 0x1E0);
    MouseSetPos(s.oldmx, s.oldmy);
    ((void (*)(void))mousepollfn)();
    ClearInputQueue();
    for (;;) {
        bits = 0;
        while ((e = GetInputEvent()) != 0) {
            bits = ((int (*)(unsigned char *, int *, int *))ptrupdatefn)(e, &s.mx, &s.my);
            if (bits & 2) break;
        }
        if (!(bits & 2)) {
            s.hit = 0;
            if (statsplayoffs == 1 && (s.hit = PlayoffTreeHitTest(s.mx, (int)&s.cur, s.ptr, s.oldmx, s.oldmy)) != 0) {
                if (s.depth) {
                    for (i = s.depth; i >= 0; i--) {
                        if (s.bg[i]) {
                            sub_903F0(s.bg[i], s.pos[i][0], s.pos[i][1]);
                            s.pos[i][0] = s.pos[i][1] = 0;
                            FreeMemBlock(s.bg[i]);
                            s.nitems[i] = (int)(s.menus[i] = (MenuItem *)(s.bg[i] = 0));
                        }
                    }
                    s.depth = 0;
                }
                PlayoffTreeScreen();
                if (playofftree[s.cur] != 0x1A) MoveTreeHighlight(&s.cur, 0);
                sub_91400(s.ptr, s.oldmx, s.oldmy);
            }
            if (s.mx == s.oldmx && s.my == s.oldmy && !s.hit) continue;
            sub_903F0(s.ptr, s.oldmx, s.oldmy);
        } else if (MenuHitTest(s.mx, s.my, s.menus, s.depth, s.nitems, &s.pos[0][0], &s.level, &s.item)) {
            m = &s.menus[s.level][s.item];
            if (m->on1) {
                if (s.item == s.sel[s.level]) {
                    sub_903F0(s.ptr, s.oldmx, s.oldmy);
                    for (i = 3; i >= 0; i--) {
                        if (s.bg[i]) {
                            sub_903F0(s.bg[i], s.pos[i][0], s.pos[i][1]);
                            s.pos[i][0] = s.pos[i][1] = 0;
                            FreeMemBlock(s.bg[i]);
                        }
                    }
                    s.depth = 0;
                    if (!statsplayoffs) {
                        statsteamsel = statscategory = s.pick = statsteamorder[s.cur];
                    } else {
                        statscategory = playofftree[s.cur];
                        statsteamsel = s.cur;
                    }
                    if (!statsplayoffs) {
                        HILITE(s.cur);
                    } else {
                        s.cur = statsteamsel;
                        if (playofftree[s.cur] != 0x1A) MoveTreeHighlight(&s.cur, 0);
                    }
                    r = ((int (*)(void))s.menus[s.level][s.item].on1)();
                    s.menus[1] = s.menus[2] = s.menus[3] = 0;
                    s.bg[0] = s.bg[1] = s.bg[2] = 0;
                    s.sel[1] = s.sel[2] = s.sel[3] = 0;
                    s.nitems[1] = s.nitems[2] = s.nitems[3] = 0;
                    if (r == 1) {
                        FreeMemBlock(s.ptr);
                        return 0;
                    }
                    if (!statsplayoffs) {
                        for (i = 0; i < 0x1A; i++)
                            if (s.pick == statsteamorder[i]) s.cur = i;
                        HILITE(s.cur);
                    } else {
                        s.cur = statsteamsel;
                        if (playofftree[s.cur] != 0x1A) MoveTreeHighlight(&s.cur, 0);
                    }
                    MouseSetPos(s.oldmx, s.oldmy);
                    s.mx = s.oldmx;
                    s.my = s.oldmy;
                    ClearInputQueue();
                } else {
                    sub_903F0(s.ptr, s.oldmx, s.oldmy);
                    DrawMenuItemSel((struct MenuItem *)&s.menus[s.level][s.sel[s.level]], s.pos[s.level][0],
                        s.pos[s.level][1], col1, col2, col3);
                    s.sel[s.level] = s.item;
                    DrawMenuItemNorm((struct MenuItem *)&s.menus[s.level][s.item], s.pos[s.level][0],
                        s.pos[s.level][1], col1, col2, col3);
                }
            } else if (m->on2) {
                sub_903F0(s.ptr, s.oldmx, s.oldmy);
                if (s.depth != s.level) {
                    for (i = s.depth; i > s.level; i--) {
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
                    s.depth = s.level;
                }
                i = s.depth;
                DrawMenuItemSel((struct MenuItem *)&s.menus[i][s.sel[i]], s.pos[i][0], s.pos[i][1], col1, col2, col3);
                s.sel[i] = s.item;
                DrawMenuItemNorm((struct MenuItem *)&s.menus[i][s.item], s.pos[i][0], s.pos[i][1], col1, col2, col3);
                m = &s.menus[s.level][s.item];
                s.depth = i + 1;
                s.menus[s.depth] = (MenuItem *)m->on2;
                s.nitems[s.depth] = m->pad;
                s.pos[s.depth][0] = (s.depth == 1 ? m->x1 : m->x2) + s.pos[s.depth - 1][0];
                s.pos[s.depth][1] = (s.depth == 1 ? m->y2 : m->y1) + s.pos[s.depth - 1][1];
                s.w = s.menus[s.depth][s.nitems[s.depth] - 1].x2 - s.menus[s.depth][0].x1 + 1;
                s.h = s.menus[s.depth][s.nitems[s.depth] - 1].y2 - s.menus[s.depth][0].y1 + 1;
                s.bg[s.depth] = sub_8CCA8((char *)str_menubuff, s.w * s.h + 0x11, 0x20);
                *(MenuHdr17 *)s.bg[s.depth] = *(MenuHdr17 *)pointerspr;
                ((short *)s.bg[s.depth])[2] = s.w;
                ((short *)s.bg[s.depth])[3] = s.h;
                sub_91400(s.bg[s.depth], s.pos[s.depth][0], s.pos[s.depth][1]);
                DrawMenuDropdown(s.menus[s.depth], s.nitems[s.depth], s.pos[s.depth][0], s.pos[s.depth][1], col1, col2,
                    col3);
                s.sel[s.depth] = 0;
                DrawMenuItemNorm((struct MenuItem *)s.menus[s.depth], s.pos[s.depth][0], s.pos[s.depth][1], col1, col2,
                    col3);
            } else {
                sub_903F0(s.ptr, s.oldmx, s.oldmy);
                DrawMenuItemSel((struct MenuItem *)&s.menus[s.level][s.sel[s.level]], s.pos[s.level][0],
                    s.pos[s.level][1], col1, col2, col3);
                s.sel[s.level] = s.item;
                DrawMenuItemNorm((struct MenuItem *)&s.menus[s.level][s.item], s.pos[s.level][0], s.pos[s.level][1],
                    col1, col2, col3);
            }
        } else {
            sub_903F0(s.ptr, s.oldmx, s.oldmy);
            if (TeamFromMouse(s.mx, s.my, &s.pick)) {
                if (s.cur != s.pick) {
                    if (!statsplayoffs) {
                        HILITE(s.cur);
                        s.cur = s.pick;
                        HILITE(s.pick);
                    } else if (playofftree[s.pick] != 0x1A && playofftree[s.cur] != 0x1A) {
                        MoveTreeHighlight(&s.cur, &s.pick);
                    }
                } else if (!statsplayoffs || playofftree[s.cur] != 0x1A) {
                    for (i = 3; i >= 0; i--) {
                        if (s.bg[i]) {
                            sub_903F0(s.bg[i], s.pos[i][0], s.pos[i][1]);
                            s.pos[i][0] = s.pos[i][1] = 0;
                            FreeMemBlock(s.bg[i]);
                        }
                    }
                    if (!statsplayoffs) {
                        statsteamsel = statscategory = s.pick = statsteamorder[s.cur];
                    } else {
                        statscategory = playofftree[s.cur];
                        statsteamsel = s.cur;
                    }
                    DeskSetExit3b();
                    s.menus[1] = s.menus[2] = s.menus[3] = 0;
                    s.bg[0] = s.bg[1] = s.bg[2] = s.bg[3] = 0;
                    s.sel[1] = s.sel[2] = s.sel[3] = 0;
                    s.nitems[1] = s.nitems[2] = s.nitems[3] = 0;
                    FreeMemBlock(s.ptr);
                    return 0;
                }
            } else {
                sub_903F0(s.ptr, s.oldmx, s.oldmy);
                for (i = 3; i >= 0; i--) {
                    if (s.bg[i]) {
                        sub_903F0(s.bg[i], s.pos[i][0], s.pos[i][1]);
                        s.pos[i][0] = s.pos[i][1] = 0;
                        FreeMemBlock(s.bg[i]);
                    }
                }
                s.depth = 0;
                s.menus[1] = s.menus[2] = s.menus[3] = 0;
                s.bg[0] = s.bg[1] = s.bg[2] = 0;
                s.sel[1] = s.sel[2] = s.sel[3] = 0;
                s.nitems[1] = s.nitems[2] = s.nitems[3] = 0;
            }
        }
        sub_91400(s.ptr, s.mx, s.my);
        sub_91370(pointerspr, s.mx, s.my);
        s.oldmx = s.mx;
        s.oldmy = s.my;
    }
}

typedef struct { char c[0x34]; } PlayerRec52;

#define PHILITE(c) \
    sub_90F38(0, (c) < statsnumskaters ? (c) * 13 + 0x43 : ((c) - statsnumskaters) * 13 + 0x1A8, 0x280, 0xD, 0x80)
#define PREC(c) \
    ((c) < statsnumskaters ? statsskaterplr[statsskaterorder[c]] : statsgoalieplr[statsgoalieorder[(c) - statsnumskaters]])
#define PCLOSE() \
    for (i = 3; i >= 0; i--) { \
        if (s.bg[i]) { \
            sub_903F0(s.bg[i], s.pos[i][0], s.pos[i][1]); \
            s.pos[i][0] = s.pos[i][1] = 0; \
            FreeMemBlock(s.bg[i]); \
        } \
    }
#define PZERO() \
    s.menus[1] = s.menus[2] = s.menus[3] = 0; \
    s.bg[0] = s.bg[1] = s.bg[2] = s.bg[3] = 0; \
    s.sel[1] = s.sel[2] = s.sel[3] = 0; \
    s.nitems[1] = s.nitems[2] = s.nitems[3] = 0

/* DRAFT: first pass, 2,945 vs 3,345 bytes (C gets a biased ebp frame the EXE does not have); see docs/UNSURE.md. */
/* RunPlayerPickMenu (1ED96, PC only; ends in RunMenu_ret4): RunMenu with a player picker under it, for the player
   stats screens. The selected player (statsplayer, found in the shown list by his first and last name with
   StrPrefixDiffers, goalies when the position letter is G) is shown by an xor bar (sub_90F38: skaters from row 43h,
   goalies from 1A8h, 0Dh apart). A click on another player moves the bar; a second click on the selected one copies
   his record into statsplayer, resets the stats palette and shows him (ShowPlayerStatsItem), then returns. The menu
   bar works as in RunMenu: an action takes the picked player's record first and finds the player again after it.
   bar: the items; n: their number; col1-col3: the item colours. Result: 0. */
int RunPlayerPickMenu(MenuItem *bar, int n, int col1, int col2, int col3)
{
    struct {
        int pos[4][2];
        MenuItem *menus[4];
        int nitems[4];
        int bg[4];
        int sel[4];
        int item;
        int level;
        int pick;
        int my;
        int mx;
        int h;
        int w;
        int at;
        int ptr;
        int oldmx;
        int oldmy;
        int cur;
        int depth;
    } s;
    int i;
    int k;
    int bits;
    int r;
    unsigned char *e;
    MenuItem *m;

    s.depth = s.cur = s.pick = 0;
    s.menus[0] = bar;
    s.nitems[0] = n;
    s.menus[1] = s.menus[2] = s.menus[3] = 0;
    s.bg[0] = s.bg[1] = s.bg[2] = s.bg[3] = 0;
    s.sel[0] = s.sel[1] = s.sel[2] = s.sel[3] = 0;
    s.pos[0][0] = s.pos[0][1] = 0;
    s.ptr = sub_8CCA8((char *)str_PointerMenu, (((short *)pointerspr)[2] + 1) * (((short *)pointerspr)[3] + 1) + 0x11,
        0x20);
    *(MenuHdr17 *)s.ptr = *(MenuHdr17 *)pointerspr;
    ((short *)s.ptr)[2] = ((short *)pointerspr)[2] + 1;
    ((short *)s.ptr)[3] = ((short *)pointerspr)[3] + 1;
    s.mx = s.oldmx = (s.menus[0]->x1 + s.menus[0]->x2) / 2;
    s.my = s.oldmy = (s.menus[0]->y1 + s.menus[0]->y2) / 2;
    if (statsplayer[2] == 'G' || statsplayer[2] == 'g') {
        for (i = 0; i < statsnumgoalies; i++) {
            k = statsgoalieplr[statsgoalieorder[i]] * 0x34;
            if (!StrPrefixDiffers((char *)statsplayer + 3, (char *)statsplayerbuf + k + 3)
                && !StrPrefixDiffers((char *)statsplayer + 0x13, (char *)statsplayerbuf + k + 0x13)) {
                s.cur = statsnumskaters + i;
                break;
            }
        }
    } else if (statsplayer[2]) {
        for (i = 0; i < statsnumskaters; i++) {
            k = statsskaterplr[statsskaterorder[i]] * 0x34;
            if (!StrPrefixDiffers((char *)statsplayer + 3, (char *)statsplayerbuf + k + 3)
                && !StrPrefixDiffers((char *)statsplayer + 0x13, (char *)statsplayerbuf + k + 0x13)) {
                s.cur = i;
                break;
            }
        }
    }
    PHILITE(s.cur);
    sub_91400(s.ptr, s.oldmx, s.oldmy);
    sub_91370(pointerspr, s.oldmx, s.oldmy);
    sub_B2E1B(0, 0, 0x280, 0x1E0);
    MouseSetPos(s.oldmx, s.oldmy);
    ((void (*)(void))mousepollfn)();
    ClearInputQueue();
    for (;;) {
        bits = 0;
        while ((e = GetInputEvent()) != 0) {
            bits = ((int (*)(unsigned char *, int *, int *))ptrupdatefn)(e, &s.mx, &s.my);
            if (bits & 2) break;
        }
        if (!(bits & 2)) {
            if (s.mx == s.oldmx && s.my == s.oldmy) continue;
            sub_903F0(s.ptr, s.oldmx, s.oldmy);
            sub_91400(s.ptr, s.mx, s.my);
            sub_91370(pointerspr, s.mx, s.my);
            s.oldmx = s.mx;
            s.oldmy = s.my;
            continue;
        }
        if (MenuHitTest(s.mx, s.my, s.menus, s.depth, s.nitems, &s.pos[0][0], &s.level, &s.item)) {
            m = &s.menus[s.level][s.item];
            if (m->on1) {
                if (s.item == s.sel[s.level]) {
                    sub_903F0(s.ptr, s.oldmx, s.oldmy);
                    PCLOSE();
                    s.depth = 0;
                    *(PlayerRec52 *)statsplayer = *(PlayerRec52 *)(statsplayerbuf + PREC(s.pick) * 0x34);
                    PHILITE(s.cur);
                    r = ((int (*)(void))s.menus[s.level][s.item].on1)();
                    PZERO();
                    if (r == 1) {
                        FreeMemBlock(s.ptr);
                        return 0;
                    }
                    if (statsplayer[2] == 'G') {
                        for (i = 0; i < statsnumgoalies; i++) {
                            k = statsgoalieplr[statsgoalieorder[i]] * 0x34;
                            if (!StrPrefixDiffers((char *)statsplayer + 3, (char *)statsplayerbuf + k + 3)
                                && !StrPrefixDiffers((char *)statsplayer + 0x13, (char *)statsplayerbuf + k + 0x13)) {
                                s.cur = statsnumskaters + i;
                                break;
                            }
                        }
                    } else if (statsplayer[2]) {
                        for (i = 0; i < statsnumskaters; i++) {
                            k = statsskaterplr[statsskaterorder[i]] * 0x34;
                            if (!StrPrefixDiffers((char *)statsplayer + 3, (char *)statsplayerbuf + k + 3)
                                && !StrPrefixDiffers((char *)statsplayer + 0x13, (char *)statsplayerbuf + k + 0x13)) {
                                s.cur = i;
                                break;
                            }
                        }
                    }
                    PHILITE(s.cur);
                    MouseSetPos(s.oldmx, s.oldmy);
                    s.mx = s.oldmx;
                    s.my = s.oldmy;
                    ClearInputQueue();
                } else {
                    sub_903F0(s.ptr, s.oldmx, s.oldmy);
                    DrawMenuItemSel((struct MenuItem *)&s.menus[s.level][s.sel[s.level]], s.pos[s.level][0],
                        s.pos[s.level][1], col1, col2, col3);
                    s.sel[s.level] = s.item;
                    DrawMenuItemNorm((struct MenuItem *)&s.menus[s.level][s.item], s.pos[s.level][0],
                        s.pos[s.level][1], col1, col2, col3);
                }
            } else if (m->on2) {
                sub_903F0(s.ptr, s.oldmx, s.oldmy);
                if (s.depth != s.level) {
                    for (i = s.depth; i > s.level; i--) {
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
                    s.depth = s.level;
                }
                i = s.depth;
                DrawMenuItemSel((struct MenuItem *)&s.menus[i][s.sel[i]], s.pos[i][0], s.pos[i][1], col1, col2, col3);
                s.sel[i] = s.item;
                DrawMenuItemNorm((struct MenuItem *)&s.menus[i][s.item], s.pos[i][0], s.pos[i][1], col1, col2, col3);
                m = &s.menus[s.level][s.item];
                s.depth = i + 1;
                s.menus[s.depth] = (MenuItem *)m->on2;
                s.nitems[s.depth] = m->pad;
                s.pos[s.depth][0] = (s.depth == 1 ? m->x1 : m->x2) + s.pos[s.depth - 1][0];
                s.pos[s.depth][1] = (s.depth == 1 ? m->y2 : m->y1) + s.pos[s.depth - 1][1];
                s.w = s.menus[s.depth][s.nitems[s.depth] - 1].x2 - s.menus[s.depth][0].x1 + 1;
                s.h = s.menus[s.depth][s.nitems[s.depth] - 1].y2 - s.menus[s.depth][0].y1 + 1;
                s.bg[s.depth] = sub_8CCA8((char *)str_menubuff, s.w * s.h + 0x11, 0x20);
                *(MenuHdr17 *)s.bg[s.depth] = *(MenuHdr17 *)pointerspr;
                ((short *)s.bg[s.depth])[2] = s.w;
                ((short *)s.bg[s.depth])[3] = s.h;
                sub_91400(s.bg[s.depth], s.pos[s.depth][0], s.pos[s.depth][1]);
                DrawMenuDropdown(s.menus[s.depth], s.nitems[s.depth], s.pos[s.depth][0], s.pos[s.depth][1], col1, col2,
                    col3);
                s.sel[s.depth] = 0;
                DrawMenuItemNorm((struct MenuItem *)s.menus[s.depth], s.pos[s.depth][0], s.pos[s.depth][1], col1, col2,
                    col3);
            } else {
                sub_903F0(s.ptr, s.oldmx, s.oldmy);
                DrawMenuItemSel((struct MenuItem *)&s.menus[s.level][s.sel[s.level]], s.pos[s.level][0],
                    s.pos[s.level][1], col1, col2, col3);
                s.sel[s.level] = s.item;
                DrawMenuItemNorm((struct MenuItem *)&s.menus[s.level][s.item], s.pos[s.level][0], s.pos[s.level][1],
                    col1, col2, col3);
            }
        } else {
            sub_903F0(s.ptr, s.oldmx, s.oldmy);
            if (PlayerFromMouseY(s.mx, s.my, &s.pick)) {
                PCLOSE();
                s.depth = 0;
                PZERO();
                if (s.cur != s.pick) {
                    PHILITE(s.cur);
                    s.cur = s.pick;
                    PHILITE(s.pick);
                } else {
                    PCLOSE();
                    *(PlayerRec52 *)statsplayer = *(PlayerRec52 *)(statsplayerbuf + PREC(s.pick) * 0x34);
                    statspal = statspalvalid = 0;
                    ShowPlayerStatsItem();
                    PZERO();
                    FreeMemBlock(s.ptr);
                    return 0;
                }
            } else {
                sub_903F0(s.ptr, s.oldmx, s.oldmy);
                PCLOSE();
                s.depth = 0;
                PZERO();
            }
        }
        sub_91400(s.ptr, s.mx, s.my);
        sub_91370(pointerspr, s.mx, s.my);
        s.oldmx = s.mx;
        s.oldmy = s.my;
    }
}
