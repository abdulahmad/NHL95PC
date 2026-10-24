/* Season playoffs: the playoff tree screen's menu loop. */
/* DRAFT: 2,723 vs 2,688 bytes, 126 differing under 10.0 GA; see docs/UNSURE.md. Plain locals instead of the
   frame struct (a store into one of the struct's arrays made Watcom reload the others and every member after
   each call; the EXE keeps the pointer block in ebp and &menus[level][item] in eax). The submenu path uses
   depth itself and `depth++` (the EXE caches it in esi and increments it in place), and the two select-item
   paths draw &menus[level][sel[level]] after the store (the EXE reloads sel[level]). The declaration order is
   tools/wccre/declsearch.py --conflicts' (12 of 20 locals in their EXE slot). Left: the scalar slots of tree,
   slot, slot2, w, h, depth, oldmx and ptr (the EXE upward from A0h: level, item, mx, my, ptr, oldmx, depth, h,
   w, slot2, slot, tree, oldmy), the close-all loop's counter copy and pos reset order, the last
   select-item copy (the EXE jumps into the first one's call) and the loop end (the EXE jumps into the move
   path's sub_91400 call). */
#define PlayoffTreeMenu PlayoffTreeMenu_decl
#define MenuHitTest MenuHitTest_decl
#define POHiliteSlot POHiliteSlot_decl
#define DrawPlayoffTree DrawPlayoffTree_decl
#include "nhl95.h"
#undef PlayoffTreeMenu
#undef MenuHitTest
#undef POHiliteSlot
#undef DrawPlayoffTree

typedef struct MenuItem {
    int x1, y1, x2, y2;
    char *text;
    int on1, on2;
    int pad;
} MenuItem;

typedef struct { char c[17]; } TreeHdr17;

int MenuHitTest(int x, int y, MenuItem **menus, int i, int *counts, int *origin, int *hitMenu, int *hitItem);
void POHiliteSlot(int n, int m);
void DrawPlayoffTree(void);
int PlayoffTreeMenu(MenuItem *bar, int n, int col1, int col2, int col3, int series);

/* PlayoffTreeMenu (89BD2, PC only): the playoff tree screen's menu bar (RunMenu's loop) with the series of the
   human team highlighted (POHiliteSlot, its two tree slots; the final has one). An action runs on the second click
   of the selected item, with the dialog colours FBh-FEh set and the pointer save block freed and made again around
   it; result 1 is returned, 4 returns 0, 2 redraws the screen (the EMBSCUP background loaded if needed, the tree,
   the menu bar, the BangPal fade-in); the tree is redrawn when the action changed the shown round (word_C6D24) and
   the highlight put back. bar / n / col1-col3: as RunMenu; series: the highlighted series. Result: 1 or 0. */
int PlayoffTreeMenu(MenuItem *bar, int n, int col1, int col2, int col3, int series)
{
    MenuItem *menus[4];
    unsigned char pal[12];
    int nitems[4];
    int ptr;
    int pos[4][2];
    char path[0x20];
    int bg[4];
    int oldmx;
    int oldmy;
    int size;
    int mx;
    int my;
    int h;
    int level;
    int tree;
    int item;
    int sel[4];
    int slot2;
    int slot;
    int depth;
    int w;
    int i;
    int bits;
    int r;
    int bank;
    unsigned char *fade;
    unsigned char *e;

    depth = 0;
    menus[0] = bar;
    nitems[0] = n;
    menus[1] = menus[2] = menus[3] = 0;
    bg[0] = bg[1] = bg[2] = bg[3] = 0;
    sel[0] = sel[1] = sel[2] = sel[3] = 0;
    pos[0][0] = pos[0][1] = 0;
    size = ((((short *)pointerspr)[2] << 2) + 4) * (((short *)pointerspr)[3] + 1) + 0x11;
    ptr = sub_8CCA8((char *)str_Pointer, size, 0x20);
    *(TreeHdr17 *)ptr = *(TreeHdr17 *)pointerspr;
    ((short *)ptr)[2] = ((short *)pointerspr)[2] + 1;
    ((short *)ptr)[3] = ((short *)pointerspr)[3] + 1;
    mx = oldmx = (menus[0]->x1 + menus[0]->x2) / 2;
    my = oldmy = (menus[0]->y1 + menus[0]->y2) / 2;
    sub_B4BA8();
    sub_91400(ptr, oldmx, oldmy);
    sub_91370(pointerspr, oldmx, oldmy);
    sub_B2E1B(0, 0, 0x280, 0x1E0);
    MouseSetPos(oldmx, oldmy);
    ((void (*)(void))mousepollfn)();
    ClearInputQueue();
    slot = series * 2;
    slot2 = slot == 0x1E ? -1 : slot + 1;
    POHiliteSlot(slot, slot2);
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
        sub_903F0(ptr, oldmx, oldmy);
        if (MenuHitTest(mx, my, menus, depth, nitems, &pos[0][0], &level, &item)) {
            if (menus[level][item].on1) {
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
                    POHiliteSlot(slot, slot2);
                    tree = word_C6D24;
                    FreeMemBlock(ptr);
                    pal[0] = 0x18;
                    pal[1] = 0;
                    pal[2] = 0;
                    pal[3] = 0x2A;
                    pal[4] = 0;
                    pal[5] = 0;
                    pal[6] = 0x3B;
                    pal[7] = 0x12;
                    pal[8] = 0;
                    pal[9] = 0x3B;
                    pal[10] = 0x3B;
                    pal[11] = 0x3B;
                    sub_B4B88(0xFB, 4, pal);
                    r = ((int (*)(void))menus[level][item].on1)();
                    size = ((((short *)pointerspr)[2] << 2) + 4) * (((short *)pointerspr)[3] + 1) + 0x11;
                    ptr = sub_8CCA8((char *)str_Pointer, size, 0x20);
                    *(TreeHdr17 *)ptr = *(TreeHdr17 *)pointerspr;
                    ((short *)ptr)[2]++;
                    ((short *)ptr)[3]++;
                    menus[1] = menus[2] = menus[3] = 0;
                    bg[0] = bg[1] = bg[2] = 0;
                    sel[1] = sel[2] = sel[3] = 0;
                    nitems[1] = nitems[2] = nitems[3] = 0;
                    if (r == 1) {
                        FreeMemBlock(ptr);
                        return r;
                    }
                    if (r == 4) {
                        FreeMemBlock(ptr);
                        return 0;
                    }
                    if (r == 2) {
                        if (!dword_C65AC) {
                            MakePath(path, fileoncd[0x8D] == 1 ? (char *)cddriveptr : 0, (char *)str_Embscup, 0);
                            dword_C65AC = sub_8E83C(path, 0x20);
                        }
                        MakePath(path, fileoncd[0x8E] == 1 ? (char *)cddriveptr : 0, (char *)str_Embpal, 0);
                        bank = sub_8E83C(path, 0);
                        fade = (unsigned char *)sub_B30B4(bank, (char *)str_BangPal) + 0x10;
                        sub_B4BA8();
                        dword_C6D26 = 0;
                        DrawPlayoffTree();
                        DrawMenuBar(bar, n, col1, col2, col3);
                        FadePalStep(0, fade, 0x10);
                        FreeMemBlock(bank);
                    }
                    sub_B4BA8();
                    if (word_C6D24 != tree) {
                        word_C6D24 = tree;
                        DrawPlayoffTree();
                    }
                    POHiliteSlot(slot, slot2);
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
            } else if (menus[level][item].on2) {
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
                DrawMenuItemSel((struct MenuItem *)&menus[depth][sel[depth]], pos[depth][0], pos[depth][1], col1, col2,
                    col3);
                sel[depth] = item;
                DrawMenuItemNorm((struct MenuItem *)&menus[depth][item], pos[depth][0], pos[depth][1], col1, col2,
                    col3);
                depth++;
                menus[depth] = (MenuItem *)menus[level][item].on2;
                nitems[depth] = menus[level][item].pad;
                pos[depth][0] = (depth != 1 ? menus[level][item].x2 : menus[level][item].x1) + pos[depth - 1][0];
                pos[depth][1] = (depth != 1 ? menus[level][item].y1 : menus[level][item].y2) + pos[depth - 1][1];
                w = menus[depth][nitems[depth] - 1].x2 - menus[depth][0].x1 + 1;
                h = menus[depth][nitems[depth] - 1].y2 - menus[depth][0].y1 + 1;
                bg[depth] = sub_8CCA8((char *)str_Menubuff2, w * h + 0x11, 0x20);
                *(TreeHdr17 *)bg[depth] = *(TreeHdr17 *)pointerspr;
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
            if (depth) {
                for (i = depth; i >= 0; i--) {
                    if (bg[i]) {
                        sub_903F0(bg[i], pos[i][0], pos[i][1]);
                        pos[i][0] = 0;
                        pos[i][1] = 0;
                        FreeMemBlock(bg[i]);
                        nitems[i] = (int)(menus[i] = (MenuItem *)(bg[i] = 0));
                    }
                }
                depth = 0;
            }
        }
        sub_B4BA8();
        sub_91400(ptr, mx, my);
        sub_91370(pointerspr, mx, my);
        oldmx = mx;
        oldmy = my;
    }
}
