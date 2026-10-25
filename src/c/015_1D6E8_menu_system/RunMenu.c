/* Menu system: the menu bar loops. */
#define RunMenu RunMenu_decl
#define MenuHitTest MenuHitTest_decl
#define RunTeamPickMenu RunTeamPickMenu_decl
#define RunPlayerPickMenu RunPlayerPickMenu_decl
#define TeamFromMouse TeamFromMouse_decl
#define sub_90F38 sub_90F38_decl
#define statsteambuf statsteambuf_decl
#include "nhl95.h"
#undef RunMenu
#undef MenuHitTest
#undef RunTeamPickMenu
#undef RunPlayerPickMenu
#undef TeamFromMouse
#undef sub_90F38
#undef statsteambuf

extern unsigned char *statsteambuf;

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

/* DRAFT under 10.0 GA: 2,075 bytes as the EXE, 6 differing instructions. The menu state is plain locals (in
   one frame struct a store to sel[level] could alias level, so level was reloaded where the EXE keeps it in a
   register), in the declaration order declsearch --conflicts finds for the EXE's slots (all as in the EXE). The
   submenu branch reads the clicked item in place (the EXE keeps &menus[level][item] for on2, pad and x, and
   reloads it for y after the pos store), closes the deeper dropdowns in a for loop (the EXE jumps to its test)
   and counts depth up after the second DrawMenuItemNorm. Both the hit and the miss branch end in their own
   sub_91400 (the EXE merges the two calls, so the arms of the hit branch share one push sequence and the
   reselect arm cross-jumps into the last arm's DrawMenuItemNorm). Left: register picks, the pointer-size
   product (`lea ebx, [eax+1]` vs `inc ebx`) and &menus[level][item] (item << 5 in eax vs EXE ebx); see
   docs/UNSURE.md. */
/* RunMenu (1D6E8, PC only; owner of RunMenu_ret4): run a menu bar of n items in the colours col1-col3 until an
   action returns 1. Save the screen under the pointer (POINTERM block, the pointer bitmap's size plus one) and
   centre the pointer on the bar. Then follow the mouse: a click on an item with an action runs it on the second
   click of the selected item (dropdowns closed first; the menu state reset after it); another item of an open
   menu moves the selection; an item with a submenu opens its dropdown (the screen under it saved in a MENUBUFF
   block); a click outside closes the dropdowns. bar: the items; n: their number; col1-col3: the item colours.
   Result: 0. */
int RunMenu(MenuItem *bar, int n, int col1, int col2, int col3)
{
    int sel[4];
    int oldmy;
    int ptr;
    MenuItem *menus[4];
    int nitems[4];
    int h;
    unsigned char *e;
    int mx;
    int pos[4][2];
    int depth;
    int bg[4];
    int size;
    int level;
    MenuItem *m;
    int my;
    int oldmx;
    int i;
    int bits;
    int item;
    int r;
    int w;

    depth = 0;
    menus[0] = bar;
    nitems[0] = n;
    menus[1] = menus[2] = menus[3] = 0;
    bg[0] = bg[1] = bg[2] = bg[3] = 0;
    sel[0] = sel[1] = sel[2] = sel[3] = 0;
    pos[0][0] = pos[0][1] = 0;
    size = (((short *)pointerspr)[2] + 1) * (((short *)pointerspr)[3] + 1) + 0x11;
    ptr = sub_8CCA8((char *)str_PointerMenu, size, 0x20);
    *(MenuHdr17 *)ptr = *(MenuHdr17 *)pointerspr;
    ((short *)ptr)[2] = ((short *)pointerspr)[2] + 1;
    ((short *)ptr)[3] = ((short *)pointerspr)[3] + 1;
    mx = oldmx = (menus[0]->x1 + menus[0]->x2) / 2;
    my = oldmy = (menus[0]->y1 + menus[0]->y2) / 2;
    sub_91400(ptr, oldmx, oldmy);
    sub_91370(pointerspr, oldmx, oldmy);
    sub_B2E1B(0, 0, 0x280, 0x1E0);
    MouseSetPos(oldmx, oldmy);
    ((void (*)(void))mousepollfn)();
    ClearInputQueue();
    for (;;) {
        bits = 0;
        while ((e = GetInputEvent()) != 0) {
            bits = ((int (*)(unsigned char *, int *, int *))ptrupdatefn)(e, &mx, &my);
            if (bits & 2) break;
        }
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
            m = &menus[level][item];
            if (m->on1) {
                if (item == sel[level]) {
                    sub_903F0(ptr, oldmx, oldmy);
                    for (i = 3; i >= 0; i--) {
                        if (bg[i]) {
                            sub_903F0(bg[i], pos[i][0], pos[i][1]);
                            pos[i][0] = pos[i][1] = 0;
                            FreeMemBlock(bg[i]);
                        }
                    }
                    depth = 0;
                    r = ((int (*)(void))menus[level][item].on1)();
                    menus[1] = menus[2] = menus[3] = 0;
                    bg[0] = bg[1] = bg[2] = bg[3] = 0;
                    sel[1] = sel[2] = sel[3] = 0;
                    nitems[1] = nitems[2] = nitems[3] = 0;
                    if (r == 1) {
                        FreeMemBlock(ptr);
                        return 0;
                    }
                    MouseSetPos(oldmx, oldmy);
                    mx = oldmx;
                    my = oldmy;
                    ClearInputQueue();
                } else {
                    sub_903F0(ptr, oldmx, oldmy);
                    DrawMenuItemSel(&menus[level][sel[level]], pos[level][0],
                        pos[level][1], col1, col2, col3);
                    sel[level] = item;
                    DrawMenuItemNorm(&menus[level][sel[level]], pos[level][0],
                        pos[level][1], col1, col2, col3);
                }
            } else if (m->on2) {
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
                i = depth;
                DrawMenuItemSel(&menus[i][sel[i]], pos[i][0], pos[i][1], col1, col2, col3);
                sel[i] = item;
                DrawMenuItemNorm(&menus[i][item], pos[i][0], pos[i][1], col1, col2, col3);
                depth++;
                menus[depth] = (MenuItem *)menus[level][item].on2;
                nitems[depth] = menus[level][item].pad;
                pos[depth][0] = (depth != 1 ? menus[level][item].x2 : menus[level][item].x1) + pos[depth - 1][0];
                pos[depth][1] = (depth != 1 ? menus[level][item].y1 : menus[level][item].y2) + pos[depth - 1][1];
                w = menus[depth][nitems[depth] - 1].x2 - menus[depth][0].x1 + 1;
                h = menus[depth][nitems[depth] - 1].y2 - menus[depth][0].y1 + 1;
                bg[depth] = sub_8CCA8((char *)str_menubuff, w * h + 0x11, 0x20);
                *(MenuHdr17 *)bg[depth] = *(MenuHdr17 *)pointerspr;
                ((short *)bg[depth])[2] = w;
                ((short *)bg[depth])[3] = h;
                sub_91400(bg[depth], pos[depth][0], pos[depth][1]);
                DrawMenuDropdown(menus[depth], nitems[depth], pos[depth][0], pos[depth][1], col1, col2,
                    col3);
                sel[depth] = 0;
                DrawMenuItemNorm(menus[depth], pos[depth][0], pos[depth][1], col1, col2,
                    col3);
            } else {
                sub_903F0(ptr, oldmx, oldmy);
                DrawMenuItemSel(&menus[level][sel[level]], pos[level][0],
                    pos[level][1], col1, col2, col3);
                sel[level] = item;
                DrawMenuItemNorm(&menus[level][item], pos[level][0], pos[level][1],
                    col1, col2, col3);
            }
            sub_91400(ptr, oldmx, oldmy);
        } else {
            sub_903F0(ptr, oldmx, oldmy);
            for (i = 3; i >= 0; i--) {
                if (bg[i]) {
                    sub_903F0(bg[i], pos[i][0], pos[i][1]);
                    pos[i][0] = pos[i][1] = 0;
                    FreeMemBlock(bg[i]);
                }
            }
            depth = 0;
            menus[1] = menus[2] = menus[3] = 0;
            bg[0] = bg[1] = bg[2] = bg[3] = 0;
            sel[1] = sel[2] = sel[3] = 0;
            nitems[1] = nitems[2] = nitems[3] = 0;
            sub_91400(ptr, oldmx, oldmy);
        }
        sub_903F0(ptr, oldmx, oldmy);
        sub_91400(ptr, mx, my);
        sub_91370(pointerspr, mx, my);
        oldmx = mx;
        oldmy = my;
    }
}

#define TEAMBYTE(c) (((unsigned char *)statsteambuf)[statsteamorder[c] * 26 + 0xD])
#define HILITE(c) \
    y = TEAMBYTE(c) % 2 ? 0x14A : 0xA5; \
    x = TEAMBYTE(c) < 2 ? 0 : 0x140; \
    y += ((c) < 12 ? (c) % 6 : ((c) - 12) % 7) * 13; \
    sub_90F38(x, y, 0x140, 0xD, 0x80)

/* DRAFT under 10.0 GA: same size, 181 differing. The pointer moves are handled in an inner loop that breaks
   out on a click (Watcom then rotates it as the EXE does: input first, the tree and pointer redraw before it,
   the click's redraw cross-jumping into the inner loop's). The menu state is plain locals, as in RunMenu, in the
   order declsearch --conflicts finds for the EXE's slots (all 18 as in the EXE); the first reselect arm draws
   through sel[level] and the submenu branch counts depth up before reading on2 in place, as in RunMenu; the
   search for the picked team after an action compares statsteamorder[i] == pick; the highlight picks its half
   by a ternary like its row (with the if / else for x the slots and the first highlights' registers differ).
   Left: register picks (the size product, the tree-close loop, the reselect arm's sel[level], the highlights
   of a clicked team: the EXE keeps the team in edi / ebp) and the merged pointer redraw at the loop end; see
   docs/UNSURE.md. */
/* RunTeamPickMenu (1DF03, PC only; ends in RunMenu_ret4): RunMenu with a team picker under it, for the team stats
   screens. The selected team (statsteamsel) is shown by an xor bar on the standings grid (sub_90F38: the left or
   right half by its division, the row by its place) or, for the playoffs (statsplayoffs), by the tree highlight
   (MoveTreeHighlight). A click on another team moves the highlight; a second click on the selected team picks it
   (statscategory / statsteamsel, DeskSetExit3b) and returns; in the playoffs moving over the tree redraws it
   (PlayoffTreeHitTest, PlayoffTreeScreen). The menu bar works as in RunMenu, an action re-reading the selected
   team after it runs. bar: the items; n: their number; col1-col3: the item colours. Result: 0. */
int RunTeamPickMenu(MenuItem *bar, int n, int col1, int col2, int col3)
{
    int w;
    int nitems[4];
    short hit;
    int ptr;
    int h;
    int mx;
    int bg[4];
    int pick;
    int cur;
    MenuItem *menus[4];
    int pos[4][2];
    int level;
    int item;
    int my;
    int oldmx;
    int oldmy;
    int depth;
    int sel[4];
    int size;
    int i;
    int x;
    int y;
    int r;
    unsigned char *e;
    MenuItem *m;

    cur = pick = 0;
    depth = 0;
    menus[0] = bar;
    nitems[0] = n;
    menus[1] = menus[2] = menus[3] = 0;
    bg[0] = bg[1] = bg[2] = bg[3] = 0;
    sel[0] = sel[1] = sel[2] = sel[3] = 0;
    pos[0][0] = pos[0][1] = 0;
    size = (((short *)pointerspr)[2] + 1) * (((short *)pointerspr)[3] + 1) + 0x11;
    ptr = sub_8CCA8((char *)str_PointerMenu, size, 0x20);
    *(MenuHdr17 *)ptr = *(MenuHdr17 *)pointerspr;
    ((short *)ptr)[2] = ((short *)pointerspr)[2] + 1;
    ((short *)ptr)[3] = ((short *)pointerspr)[3] + 1;
    mx = oldmx = (menus[0]->x1 + menus[0]->x2) / 2;
    my = oldmy = (menus[0]->y1 + menus[0]->y2) / 2;
    if (!statsplayoffs) {
        for (i = 0; i < 0x1A; i++)
            if (statsteamsel == statsteamorder[i]) cur = i;
        HILITE(cur);
    } else {
        cur = statsteamsel;
        if (playofftree[cur] != 0x1A) MoveTreeHighlight(&cur, 0);
    }
    sub_91400(ptr, oldmx, oldmy);
    sub_91370(pointerspr, oldmx, oldmy);
    sub_B2E1B(0, 0, 0x280, 0x1E0);
    MouseSetPos(oldmx, oldmy);
    ((void (*)(void))mousepollfn)();
    ClearInputQueue();
    for (;;) {
        for (;;) {
            int bits;

            bits = 0;
            while ((e = GetInputEvent()) != 0) {
                bits = ((int (*)(unsigned char *, int *, int *))ptrupdatefn)(e, &mx, &my);
                if (bits & 2) break;
            }
            if (bits & 2) break;
            hit = 0;
            if (statsplayoffs == 1 && (hit = PlayoffTreeHitTest(mx, (int)&cur, ptr, oldmx, oldmy)) != 0) {
                if (depth) {
                    for (i = depth; i >= 0; i--) {
                        if (bg[i]) {
                            sub_903F0(bg[i], pos[i][0], pos[i][1]);
                            pos[i][1] = 0;
                            pos[i][0] = 0;
                            FreeMemBlock(bg[i]);
                            nitems[i] = (int)(menus[i] = (MenuItem *)(bg[i] = 0));
                        }
                    }
                    depth = 0;
                }
                PlayoffTreeScreen();
                if (playofftree[cur] != 0x1A) MoveTreeHighlight(&cur, 0);
                sub_91400(ptr, oldmx, oldmy);
            }
            if (mx == oldmx && my == oldmy && !hit) continue;
            sub_903F0(ptr, oldmx, oldmy);
            sub_91400(ptr, mx, my);
            sub_91370(pointerspr, mx, my);
            oldmx = mx;
            oldmy = my;
        }
        if (MenuHitTest(mx, my, menus, depth, nitems, &pos[0][0], &level, &item)) {
            m = &menus[level][item];
            if (m->on1) {
                if (item == sel[level]) {
                    sub_903F0(ptr, oldmx, oldmy);
                    for (i = 3; i >= 0; i--) {
                        if (bg[i]) {
                            sub_903F0(bg[i], pos[i][0], pos[i][1]);
                            pos[i][0] = pos[i][1] = 0;
                            FreeMemBlock(bg[i]);
                        }
                    }
                    depth = 0;
                    if (!statsplayoffs) {
                        statsteamsel = statscategory = pick = statsteamorder[cur];
                    } else {
                        statscategory = playofftree[cur];
                        statsteamsel = cur;
                    }
                    if (!statsplayoffs) {
                        HILITE(cur);
                    } else {
                        cur = statsteamsel;
                        if (playofftree[cur] != 0x1A) MoveTreeHighlight(&cur, 0);
                    }
                    r = ((int (*)(void))menus[level][item].on1)();
                    menus[1] = menus[2] = menus[3] = 0;
                    bg[0] = bg[1] = bg[2] = 0;
                    sel[1] = sel[2] = sel[3] = 0;
                    nitems[1] = nitems[2] = nitems[3] = 0;
                    if (r == 1) {
                        FreeMemBlock(ptr);
                        return 0;
                    }
                    if (!statsplayoffs) {
                        for (i = 0; i < 0x1A; i++)
                            if (statsteamorder[i] == pick) cur = i;
                        HILITE(cur);
                    } else {
                        cur = statsteamsel;
                        if (playofftree[cur] != 0x1A) MoveTreeHighlight(&cur, 0);
                    }
                    MouseSetPos(oldmx, oldmy);
                    mx = oldmx;
                    my = oldmy;
                    ClearInputQueue();
                } else {
                    sub_903F0(ptr, oldmx, oldmy);
                    DrawMenuItemSel((struct MenuItem *)&menus[level][sel[level]], pos[level][0],
                        pos[level][1], col1, col2, col3);
                    sel[level] = item;
                    DrawMenuItemNorm((struct MenuItem *)&menus[level][sel[level]], pos[level][0],
                        pos[level][1], col1, col2, col3);
                }
            } else if (m->on2) {
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
                i = depth;
                DrawMenuItemSel((struct MenuItem *)&menus[i][sel[i]], pos[i][0], pos[i][1], col1, col2, col3);
                sel[i] = item;
                DrawMenuItemNorm((struct MenuItem *)&menus[i][item], pos[i][0], pos[i][1], col1, col2, col3);
                depth++;
                menus[depth] = (MenuItem *)menus[level][item].on2;
                m = &menus[level][item];
                nitems[depth] = m->pad;
                pos[depth][0] = (depth != 1 ? m->x2 : m->x1) + pos[depth - 1][0];
                pos[depth][1] = (depth != 1 ? menus[level][item].y1 : menus[level][item].y2) + pos[depth - 1][1];
                w = menus[depth][nitems[depth] - 1].x2 - menus[depth][0].x1 + 1;
                h = menus[depth][nitems[depth] - 1].y2 - menus[depth][0].y1 + 1;
                bg[depth] = sub_8CCA8((char *)str_menubuff, w * h + 0x11, 0x20);
                *(MenuHdr17 *)bg[depth] = *(MenuHdr17 *)pointerspr;
                ((short *)bg[depth])[2] = w;
                ((short *)bg[depth])[3] = h;
                sub_91400(bg[depth], pos[depth][0], pos[depth][1]);
                DrawMenuDropdown(menus[depth], nitems[depth], pos[depth][0], pos[depth][1], col1, col2,
                    col3);
                sel[depth] = 0;
                DrawMenuItemNorm((struct MenuItem *)menus[depth], pos[depth][0], pos[depth][1], col1, col2,
                    col3);
            } else {
                sub_903F0(ptr, oldmx, oldmy);
                DrawMenuItemSel((struct MenuItem *)&menus[level][sel[level]], pos[level][0],
                    pos[level][1], col1, col2, col3);
                sel[level] = item;
                DrawMenuItemNorm((struct MenuItem *)&menus[level][item], pos[level][0], pos[level][1],
                    col1, col2, col3);
            }
        } else {
            sub_903F0(ptr, oldmx, oldmy);
            if (TeamFromMouse(mx, my, &pick)) {
                if (cur != pick) {
                    if (!statsplayoffs) {
                        HILITE(cur);
                        cur = pick;
                        HILITE(pick);
                    } else if (playofftree[pick] != 0x1A && playofftree[cur] != 0x1A) {
                        MoveTreeHighlight(&cur, &pick);
                    }
                } else if (!statsplayoffs || playofftree[cur] != 0x1A) {
                    for (i = 3; i >= 0; i--) {
                        if (bg[i]) {
                            sub_903F0(bg[i], pos[i][0], pos[i][1]);
                            pos[i][0] = pos[i][1] = 0;
                            FreeMemBlock(bg[i]);
                        }
                    }
                    if (!statsplayoffs) {
                        statsteamsel = statscategory = pick = statsteamorder[cur];
                    } else {
                        statscategory = playofftree[cur];
                        statsteamsel = cur;
                    }
                    DeskSetExit3b();
                    menus[1] = menus[2] = menus[3] = 0;
                    bg[0] = bg[1] = bg[2] = bg[3] = 0;
                    sel[1] = sel[2] = sel[3] = 0;
                    nitems[1] = nitems[2] = nitems[3] = 0;
                    FreeMemBlock(ptr);
                    return 0;
                }
            } else {
                sub_903F0(ptr, oldmx, oldmy);
                for (i = 3; i >= 0; i--) {
                    if (bg[i]) {
                        sub_903F0(bg[i], pos[i][0], pos[i][1]);
                        pos[i][1] = 0;
                        pos[i][0] = 0;
                        FreeMemBlock(bg[i]);
                    }
                }
                depth = 0;
                menus[1] = menus[2] = menus[3] = 0;
                bg[0] = bg[1] = bg[2] = 0;
                sel[1] = sel[2] = sel[3] = 0;
                nitems[1] = nitems[2] = nitems[3] = 0;
            }
        }
        sub_91400(ptr, mx, my);
        sub_91370(pointerspr, mx, my);
        oldmx = mx;
        oldmy = my;
    }
}

typedef struct { char c[0x34]; } PlayerRec52;

#define PHILITE(c) \
    k = (c) < statsnumskaters ? (c) * 13 + 0x43 : ((c) - statsnumskaters) * 13 + 0x1A8; \
    sub_90F38(0, k, 0x280, 0xD, 0x80)
#define PREC(c) \
    ((c) < statsnumskaters ? statsskaterplr[statsskaterorder[c]] : statsgoalieplr[statsgoalieorder[(c) - statsnumskaters]])
#define PCLOSE() \
    for (i = 3; i >= 0; i--) { \
        if (bg[i]) { \
            sub_903F0(bg[i], pos[i][0], pos[i][1]); \
            pos[i][0] = pos[i][1] = 0; \
            FreeMemBlock(bg[i]); \
        } \
    }
#define PZERO() \
    menus[1] = menus[2] = menus[3] = 0; \
    bg[0] = bg[1] = bg[2] = bg[3] = 0; \
    sel[1] = sel[2] = sel[3] = 0; \
    nitems[1] = nitems[2] = nitems[3] = 0

/* DRAFT under 10.0 GA: 3,345 bytes as the EXE, 103 differing. The highlight row is computed into k before the
   sub_90F38 call: with the ternary inside the pushed arguments Watcom gave the function a biased ebp frame (and
   20 bytes of spills); as an if / else with a call per arm the constant pushes move ahead of the row (the EXE
   computes the row first). The menu state is plain locals, as in RunMenu, in the order declsearch --conflicts
   finds for the EXE's slots (all 17 as in the EXE); bits is local to the loop body, as in RunTeamPickMenu. Both reselect arms draw the new item through sel[level] (the EXE
   cross-jumps the last arm into the first after the pushes, once the registers agree); depth++ before the
   dropdown. Left: register picks from the size product on (the name-search loops, the StrPrefixDiffers address
   sums, the item kept in eax after `sel[i] = item`); see docs/UNSURE.md. */
/* RunPlayerPickMenu (1ED96, PC only; ends in RunMenu_ret4): RunMenu with a player picker under it, for the player
   stats screens. The selected player (statsplayer, found in the shown list by his first and last name with
   StrPrefixDiffers, goalies when the position letter is G) is shown by an xor bar (sub_90F38: skaters from row 43h,
   goalies from 1A8h, 0Dh apart). A click on another player moves the bar; a second click on the selected one copies
   his record into statsplayer, resets the stats palette and shows him (ShowPlayerStatsItem), then returns. The menu
   bar works as in RunMenu: an action takes the picked player's record first and finds the player again after it.
   bar: the items; n: their number; col1-col3: the item colours. Result: 0. */
int RunPlayerPickMenu(MenuItem *bar, int n, int col1, int col2, int col3)
{
    int w;
    int h;
    MenuItem *menus[4];
    int mx;
    int my;
    int pick;
    int nitems[4];
    int depth;
    int level;
    int pos[4][2];
    int ptr;
    int oldmy;
    int oldmx;
    int sel[4];
    int cur;
    int item;
    int bg[4];
    int i;
    int k;
    int r;
    unsigned char *e;
    MenuItem *m;
    int size;

    depth = cur = pick = 0;
    menus[0] = bar;
    nitems[0] = n;
    menus[1] = menus[2] = menus[3] = 0;
    bg[0] = bg[1] = bg[2] = bg[3] = 0;
    sel[0] = sel[1] = sel[2] = sel[3] = 0;
    pos[0][0] = pos[0][1] = 0;
    size = (((short *)pointerspr)[2] + 1) * (((short *)pointerspr)[3] + 1) + 0x11;
    ptr = sub_8CCA8((char *)str_PointerMenu, size, 0x20);
    *(MenuHdr17 *)ptr = *(MenuHdr17 *)pointerspr;
    ((short *)ptr)[2] = ((short *)pointerspr)[2] + 1;
    ((short *)ptr)[3] = ((short *)pointerspr)[3] + 1;
    mx = oldmx = (menus[0]->x1 + menus[0]->x2) / 2;
    my = oldmy = (menus[0]->y1 + menus[0]->y2) / 2;
    if (statsplayer[2] == 'G' || statsplayer[2] == 'g') {
        for (i = 0; i < statsnumgoalies; i++) {
            k = statsgoalieplr[statsgoalieorder[i]] * 0x34;
            if (!StrPrefixDiffers((char *)statsplayer + 3, (char *)statsplayerbuf + k + 3)
                && !StrPrefixDiffers((char *)statsplayer + 0x13, (char *)statsplayerbuf + k + 0x13)) {
                cur = statsnumskaters + i;
                break;
            }
        }
    } else if (statsplayer[2]) {
        for (i = 0; i < statsnumskaters; i++) {
            k = statsskaterplr[statsskaterorder[i]] * 0x34;
            if (!StrPrefixDiffers((char *)statsplayer + 3, (char *)statsplayerbuf + k + 3)
                && !StrPrefixDiffers((char *)statsplayer + 0x13, (char *)statsplayerbuf + k + 0x13)) {
                cur = i;
                break;
            }
        }
    }
    PHILITE(cur);
    sub_91400(ptr, oldmx, oldmy);
    sub_91370(pointerspr, oldmx, oldmy);
    sub_B2E1B(0, 0, 0x280, 0x1E0);
    MouseSetPos(oldmx, oldmy);
    ((void (*)(void))mousepollfn)();
    ClearInputQueue();
    for (;;) {
        int bits;

        bits = 0;
        while ((e = GetInputEvent()) != 0) {
            bits = ((int (*)(unsigned char *, int *, int *))ptrupdatefn)(e, &mx, &my);
            if (bits & 2) break;
        }
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
            m = &menus[level][item];
            if (m->on1) {
                if (item == sel[level]) {
                    sub_903F0(ptr, oldmx, oldmy);
                    PCLOSE();
                    depth = 0;
                    *(PlayerRec52 *)statsplayer = *(PlayerRec52 *)(statsplayerbuf + PREC(pick) * 0x34);
                    PHILITE(cur);
                    r = ((int (*)(void))menus[level][item].on1)();
                    PZERO();
                    if (r == 1) {
                        FreeMemBlock(ptr);
                        return 0;
                    }
                    if (statsplayer[2] == 'G') {
                        for (i = 0; i < statsnumgoalies; i++) {
                            k = statsgoalieplr[statsgoalieorder[i]] * 0x34;
                            if (!StrPrefixDiffers((char *)statsplayer + 3, (char *)statsplayerbuf + k + 3)
                                && !StrPrefixDiffers((char *)statsplayer + 0x13, (char *)statsplayerbuf + k + 0x13)) {
                                cur = statsnumskaters + i;
                                break;
                            }
                        }
                    } else if (statsplayer[2]) {
                        for (i = 0; i < statsnumskaters; i++) {
                            k = statsskaterplr[statsskaterorder[i]] * 0x34;
                            if (!StrPrefixDiffers((char *)statsplayer + 3, (char *)statsplayerbuf + k + 3)
                                && !StrPrefixDiffers((char *)statsplayer + 0x13, (char *)statsplayerbuf + k + 0x13)) {
                                cur = i;
                                break;
                            }
                        }
                    }
                    PHILITE(cur);
                    MouseSetPos(oldmx, oldmy);
                    mx = oldmx;
                    my = oldmy;
                    ClearInputQueue();
                } else {
                    sub_903F0(ptr, oldmx, oldmy);
                    DrawMenuItemSel((struct MenuItem *)&menus[level][sel[level]], pos[level][0],
                        pos[level][1], col1, col2, col3);
                    sel[level] = item;
                    DrawMenuItemNorm((struct MenuItem *)&menus[level][sel[level]], pos[level][0],
                        pos[level][1], col1, col2, col3);
                }
            } else if (m->on2) {
                sub_903F0(ptr, oldmx, oldmy);
                if (depth != level) {
                    for (i = depth; i > level; i--) {
                        sel[i] = 0;
                        if (bg[i]) {
                            sub_903F0(bg[i], pos[i][0], pos[i][1]);
                            pos[i][1] = 0;
                            pos[i][0] = 0;
                            FreeMemBlock(bg[i]);
                            bg[i] = 0;
                            menus[i] = 0;
                            nitems[i] = 0;
                        }
                    }
                    depth = level;
                }
                i = depth;
                DrawMenuItemSel((struct MenuItem *)&menus[i][sel[i]], pos[i][0], pos[i][1], col1, col2, col3);
                sel[i] = item;
                DrawMenuItemNorm((struct MenuItem *)&menus[i][item], pos[i][0], pos[i][1], col1, col2, col3);
                depth++;
                menus[depth] = (MenuItem *)menus[level][item].on2;
                m = &menus[level][item];
                nitems[depth] = m->pad;
                pos[depth][0] = (depth != 1 ? m->x2 : m->x1) + pos[depth - 1][0];
                pos[depth][1] = (depth != 1 ? menus[level][item].y1 : menus[level][item].y2) + pos[depth - 1][1];
                w = menus[depth][nitems[depth] - 1].x2 - menus[depth][0].x1 + 1;
                h = menus[depth][nitems[depth] - 1].y2 - menus[depth][0].y1 + 1;
                bg[depth] = sub_8CCA8((char *)str_menubuff, w * h + 0x11, 0x20);
                *(MenuHdr17 *)bg[depth] = *(MenuHdr17 *)pointerspr;
                ((short *)bg[depth])[2] = w;
                ((short *)bg[depth])[3] = h;
                sub_91400(bg[depth], pos[depth][0], pos[depth][1]);
                DrawMenuDropdown(menus[depth], nitems[depth], pos[depth][0], pos[depth][1], col1, col2,
                    col3);
                sel[depth] = 0;
                DrawMenuItemNorm((struct MenuItem *)menus[depth], pos[depth][0], pos[depth][1], col1, col2,
                    col3);
            } else {
                sub_903F0(ptr, oldmx, oldmy);
                DrawMenuItemSel((struct MenuItem *)&menus[level][sel[level]], pos[level][0],
                    pos[level][1], col1, col2, col3);
                sel[level] = item;
                DrawMenuItemNorm((struct MenuItem *)&menus[level][sel[level]], pos[level][0], pos[level][1],
                    col1, col2, col3);
            }
        } else {
            sub_903F0(ptr, oldmx, oldmy);
            if (PlayerFromMouseY(mx, my, &pick)) {
                PCLOSE();
                depth = 0;
                PZERO();
                if (cur != pick) {
                    PHILITE(cur);
                    cur = pick;
                    PHILITE(pick);
                } else {
                    PCLOSE();
                    *(PlayerRec52 *)statsplayer = *(PlayerRec52 *)(statsplayerbuf + PREC(pick) * 0x34);
                    statspal = statspalvalid = 0;
                    ShowPlayerStatsItem();
                    PZERO();
                    FreeMemBlock(ptr);
                    return 0;
                }
            } else {
                sub_903F0(ptr, oldmx, oldmy);
                PCLOSE();
                depth = 0;
                PZERO();
            }
        }
        sub_91400(ptr, mx, my);
        sub_91370(pointerspr, mx, my);
        oldmx = mx;
        oldmy = my;
    }
}
