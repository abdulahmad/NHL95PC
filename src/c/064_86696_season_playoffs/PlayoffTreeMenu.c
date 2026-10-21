/* Season playoffs: the playoff tree screen's menu loop. */
/* DRAFT: 2,820 vs 2,688 bytes, 619 lines (register picks from the pointer block on); see docs/UNSURE.md. */
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
    struct {
        int pos[4][2];
        char path[0x20];
        int sel[4];
        int bg[4];
        MenuItem *menus[4];
        int nitems[4];
        unsigned char pal[12];
        int item;
        int level;
        int my;
        int mx;
        int at;
        int ptr;
        int oldmx;
        int depth;
        int h;
        int w;
        int slot2;
        int slot;
        int tree;
        int oldmy;
    } s;
    int i;
    int bits;
    int r;
    int bank;
    unsigned char *pal;
    unsigned char *e;
    MenuItem *m;

    s.depth = 0;
    s.menus[0] = bar;
    s.nitems[0] = n;
    s.menus[1] = s.menus[2] = s.menus[3] = 0;
    s.bg[0] = s.bg[1] = s.bg[2] = s.bg[3] = 0;
    s.sel[0] = s.sel[1] = s.sel[2] = s.sel[3] = 0;
    s.pos[0][0] = s.pos[0][1] = 0;
    s.ptr = sub_8CCA8((char *)str_Pointer, (((short *)pointerspr)[3] + 1) * (((short *)pointerspr)[2] * 4 + 4) + 0x11,
        0x20);
    *(TreeHdr17 *)s.ptr = *(TreeHdr17 *)pointerspr;
    ((short *)s.ptr)[2] = ((short *)pointerspr)[2] + 1;
    ((short *)s.ptr)[3] = ((short *)pointerspr)[3] + 1;
    s.mx = s.oldmx = (s.menus[0]->x1 + s.menus[0]->x2) / 2;
    s.my = s.oldmy = (s.menus[0]->y1 + s.menus[0]->y2) / 2;
    sub_B4BA8();
    sub_91400(s.ptr, s.oldmx, s.oldmy);
    sub_91370(pointerspr, s.oldmx, s.oldmy);
    sub_B2E1B(0, 0, 0x280, 0x1E0);
    MouseSetPos(s.oldmx, s.oldmy);
    ((void (*)(void))mousepollfn)();
    ClearInputQueue();
    s.slot = series * 2;
    s.slot2 = s.slot == 0x1E ? -1 : s.slot + 1;
    POHiliteSlot(s.slot, s.slot2);
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
        sub_903F0(s.ptr, s.oldmx, s.oldmy);
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
                    POHiliteSlot(s.slot, s.slot2);
                    s.tree = word_C6D24;
                    FreeMemBlock(s.ptr);
                    s.pal[0] = 0x18;
                    s.pal[1] = 0;
                    s.pal[2] = 0;
                    s.pal[3] = 0x2A;
                    s.pal[4] = 0;
                    s.pal[5] = 0;
                    s.pal[6] = 0x3B;
                    s.pal[7] = 0x12;
                    s.pal[8] = 0;
                    s.pal[9] = 0x3B;
                    s.pal[10] = 0x3B;
                    s.pal[11] = 0x3B;
                    sub_B4B88(0xFB, 4, s.pal);
                    r = ((int (*)(void))s.menus[s.level][s.item].on1)();
                    s.ptr = sub_8CCA8((char *)str_Pointer,
                        (((short *)pointerspr)[3] + 1) * (((short *)pointerspr)[2] * 4 + 4) + 0x11, 0x20);
                    *(TreeHdr17 *)s.ptr = *(TreeHdr17 *)pointerspr;
                    ((short *)s.ptr)[2]++;
                    ((short *)s.ptr)[3]++;
                    s.menus[1] = s.menus[2] = s.menus[3] = 0;
                    s.bg[0] = s.bg[1] = s.bg[2] = 0;
                    s.sel[1] = s.sel[2] = s.sel[3] = 0;
                    s.nitems[1] = s.nitems[2] = s.nitems[3] = 0;
                    if (r == 1) {
                        FreeMemBlock(s.ptr);
                        return r;
                    }
                    if (r == 4) {
                        FreeMemBlock(s.ptr);
                        return 0;
                    }
                    if (r == 2) {
                        if (!dword_C65AC) {
                            MakePath(s.path, fileoncd[0x8D] == 1 ? (char *)cddriveptr : 0, (char *)str_Embscup, 0);
                            dword_C65AC = sub_8E83C(s.path, 0x20);
                        }
                        MakePath(s.path, fileoncd[0x8E] == 1 ? (char *)cddriveptr : 0, (char *)str_Embpal, 0);
                        bank = sub_8E83C(s.path, 0);
                        pal = (unsigned char *)sub_B30B4(bank, (char *)str_BangPal) + 0x10;
                        sub_B4BA8();
                        dword_C6D26 = 0;
                        DrawPlayoffTree();
                        DrawMenuBar(bar, n, col1, col2, col3);
                        FadePalStep(0, pal, 0x10);
                        FreeMemBlock(bank);
                    }
                    sub_B4BA8();
                    if (word_C6D24 != s.tree) {
                        word_C6D24 = s.tree;
                        DrawPlayoffTree();
                    }
                    POHiliteSlot(s.slot, s.slot2);
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
                s.bg[s.depth] = sub_8CCA8((char *)str_Menubuff2, s.w * s.h + 0x11, 0x20);
                *(TreeHdr17 *)s.bg[s.depth] = *(TreeHdr17 *)pointerspr;
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
        }
        sub_B4BA8();
        sub_91400(s.ptr, s.mx, s.my);
        sub_91370(pointerspr, s.mx, s.my);
        s.oldmx = s.mx;
        s.oldmy = s.my;
    }
}
