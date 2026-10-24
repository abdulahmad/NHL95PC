/* Roster and jersey: the trade screen's menu and mouse loop. */
#define TradeScreenLoop TradeScreenLoop_decl
#define MenuHitTest MenuHitTest_decl
#define DrawTradeScreen DrawTradeScreen_decl
#define TradeHitTest TradeHitTest_decl
#include "nhl95.h"
#undef TradeScreenLoop
#undef MenuHitTest
#undef DrawTradeScreen
#undef TradeHitTest

typedef struct MenuItem {
    int x1, y1, x2, y2;
    char *text;
    int on1, on2;
    int pad;
} MenuItem;

typedef struct { char c[17]; } TrHdr17;
typedef struct { unsigned char c[0x16]; } TrEntry;

int MenuHitTest(int x, int y, MenuItem **menus, int i, int *counts, int *origin, int *hitMenu, int *hitItem);
void DrawTradeScreen(int unused, int art, void *menu, int unused2, int count, unsigned char *cols, int *teams);
int TradeHitTest(int x, int y, int *out, int *slot, int *flag);
int TradeScreenLoop(int art, unsigned char *recs, int *teams, unsigned char *slots, MenuItem *bar, int bank, int font,
    int n);

/* The screen block under the pointer starts 1Ch / 20h up and left of it (the dragged jersey's corner). */
#define PTRX(x) ((x) < 0x1C ? 0 : (x) - 0x1C)
#define PTRY(y) ((y) < 0x20 ? 0 : (y) - 0x20)

/* While a roster row is picked (tradeside, tradecursor) and the pointer is over the middle column below the
   menu bar (and not on an open dropdown), draw the picked player's jersey (his number in his team's colours)
   under the pointer. */
#define DRAGJERSEY()                                                                                              \
    if (my > menus[0]->y2 && mx > 0xBE && mx < 0x1C0 && tradeside != -1 && tradecursor[tradeside] != -1        \
        && (!menus[1] || !MenuHitTest(mx, my, menus, depth, nitems, &pos[0][0], &level, &item))) {             \
        memcpy(unk_D12C8, (unsigned char *)traderemap1[tradeside] + 0x90, 0x30);                                  \
        c1 = jerseyremap[byte_D11BC[teams[tradeside] * 4]];                                                       \
        c2 = byte_D12DE;                                                                                          \
        MakeJerseyShape(jerseyremap, tradejersey[tradeside * 0x268 + tradecursor[tradeside] * 0x16], c1, c2);     \
        sub_B4DD4(jerseyremap);                                                                                   \
        sub_91FE0(art, mx - 0x1C, my - 0x20);                                                                     \
    }

/* DRAFT (first pass from Ghidra): same size (3,943 bytes), 51 differing under 10.0 GA, every stack slot the EXE's
   (the submenu path's position reset as two stores; the submenu path written with depth and `depth++` instead of
   a k copy, as PlayoffTreeMenu, and the new item drawn as menus[depth][sel[depth]] brought the size back). The
   EXE's frame (ebp biased by -72h): picked -9Ah, pos -42h, bg -22h, sel -12h, nitems -2, menus +0Eh, then w, h,
   item, level, my, mx, oldmy, oldmx, flag, i, ptrart, cursor, a cursor * 16h temp, col3, col2, col1, ptr, depth *
   8 and depth * 4 temps, click, depth (+6Eh). The arrays and the address-taken scalars have no register
   conflict, so their slots follow their declaration order through Watcom's size sort (docs/WCC_INTERNALS.md
   "Stack slots"): the order below, found with slotdump's Python copy of the sorts, gives all of them. Left:
   DRAGJERSEY's colour bytes in dh / dl and its jersey index (the EXE adds the doubled cursor offset first, ours
   folds it into `[edx+eax*2]`), the dropdown close loop's bg[i] registers, the cursor load into edi, and the
   event copied to esi as well as ecx, as in DrawShootsField. */
/* TradeScreenLoop (3EF89, PC only): the trade screen's loop, RunMenu's menu engine with the trade screen added.
   Clear the four trade buttons' players (picked, 16h bytes each: position, jersey number, ...), draw the screen
   (DrawTradeScreen), save the screen under the hand pointer (POINTER block, the Pntr2 art's size plus one) and
   follow the mouse: moving redraws the pointer, with the picked roster player's jersey under it over the middle
   column. A click on the menu bar works as in RunMenu; an action gets the team records, the team of the item
   picked in the first dropdown, the teams, the buttons, the art, font, bar and count and the slots, and a result
   of 1 ends the loop (result 0). A click elsewhere goes to TradeHitTest: a roster row (tradeclick 64h and up)
   picks the row of that side (tradecursor, drawn in colour 42h) or drops it on a second click; a trade button
   with a row picked takes that player when he is not on the side's other button (a goalie for a skater clears
   the matching button of the other side), a button clicked alone gives its player back (FindTradeSlot); a
   changed button redraws all four jerseys. The loop ends when an action sets traderesult (TradeDone,
   TradeCancel). art: the screen art; recs: the two team records; teams: the two teams; slots: the roster slot of
   each button's player (FFh: none); bar / n: the menu bar and its item count (also the highest dropdown level
   cleared); bank: the art bank (Pntr2); font: passed to the actions. Result: traderesult when negative, else 0. */
int TradeScreenLoop(int art, unsigned char *recs, int *teams, unsigned char *slots, MenuItem *bar, int bank, int font,
    int n)
{
    int i;
    MenuItem *menus[4];
    int nitems[4];
    int oldmx;
    int pos[4][2];
    TrEntry picked[4];
    int oldmy;
    int mx;
    int my;
    int level;
    int item;
    int h;
    int w;
    int sel[4];
    int bg[4];
    int flag;
    int ptrart;
    int cursor;
    int col3;
    int col2;
    int col1;
    int ptr;
    int click;
    int depth;
    int bits;
    int k;
    int r;
    unsigned char *e;
    unsigned char *p;
    unsigned char c1;
    unsigned char c2;

    depth = 0;
    col1 = 0x40;
    col2 = 0x41;
    col3 = 0x42;
    i = 0;
    do
        picked[i].c[1] = 0xFF;
    while (++i < 4);
    DrawTradeScreen((int)recs, art, bar, font, n, picked[0].c, teams);
    ptrart = sub_B30B4(bank, (char *)str_Pntr2);
    menus[0] = bar;
    nitems[0] = n;
    menus[1] = menus[2] = menus[3] = 0;
    bg[0] = bg[1] = bg[2] = bg[3] = 0;
    sel[0] = sel[1] = sel[2] = sel[3] = 0;
    pos[0][0] = pos[0][1] = 0;
    menuact_gamedress = menuact_gamescratch = 0;
    k = ((((short *)ptrart)[2] << 2) + 4) * (((short *)ptrart)[3] + 1) + 0x11;
    ptr = sub_8CCA8((char *)str_Pointer10, k, 0x20);
    *(TrHdr17 *)ptr = *(TrHdr17 *)ptrart;
    ((short *)ptr)[2] = ((short *)ptrart)[2] + 1;
    ((short *)ptr)[3] = ((short *)ptrart)[3] + 1;
    sub_B2DCA(&i, &oldmx, &oldmy);
    mx = oldmx;
    my = oldmy;
    sub_91400(ptr, PTRX(oldmx), PTRY(oldmy));
    sub_91FE0(pointerspr, oldmx - 3, oldmy);
    ClearInputQueue();
    traderesult = 0;
    do {
        bits = 0;
        do {
            e = GetInputEvent();
            if (e) bits = ((int (*)(unsigned char *, int *, int *))ptrupdatefn)(e, &mx, &my);
        } while (e && !(bits & 2));
        if (!(bits & 2)) {
            if (mx != oldmx || my != oldmy) {
                sub_903F0(ptr, PTRX(oldmx), PTRY(oldmy));
                sub_91400(ptr, PTRX(mx), PTRY(my));
                DRAGJERSEY();
                sub_91FE0(pointerspr, mx - 3, my);
                oldmx = mx;
                oldmy = my;
            }
        } else {
            if (MenuHitTest(mx, my, menus, depth, nitems, &pos[0][0], &level, &item)) {
                if (menus[level][item].on1) {
                    if (item == sel[level]) {
                        sub_903F0(ptr, PTRX(oldmx), PTRY(oldmy));
                        for (i = n; i >= 0; i--) {
                            if (bg[i]) {
                                sub_903F0(bg[i], pos[i][0], pos[i][1]);
                                pos[i][0] = pos[i][1] = 0;
                                FreeMemBlock(bg[i]);
                            }
                        }
                        depth = 0;
                        r = ((int (*)(unsigned char *, int, int *, unsigned char *, int, int, MenuItem *, int,
                            unsigned char *))menus[level][item].on1)(recs, teams[sel[1]], teams,
                            picked[0].c, art, font, bar, n, slots);
                        menus[1] = menus[2] = menus[3] = 0;
                        bg[0] = bg[1] = bg[2] = 0;
                        sel[1] = sel[2] = sel[3] = 0;
                        nitems[1] = nitems[2] = nitems[3] = 0;
                        if (r == 1) {
                            ClearInputQueue();
                            FreeMemBlock(ptr);
                            return 0;
                        }
                        MouseSetPos(oldmx, oldmy);
                        mx = oldmx;
                        my = oldmy;
                        ClearInputQueue();
                    } else {
                        sub_903F0(ptr, PTRX(oldmx), PTRY(oldmy));
                        DrawMenuItemSel((struct MenuItem *)&menus[level][sel[level]], pos[level][0],
                            pos[level][1], col1, col2, col3);
                        sel[level] = item;
                        DrawMenuItemNorm((struct MenuItem *)&menus[level][sel[level]], pos[level][0],
                            pos[level][1], col1, col2, col3);
                    }
                } else if (menus[level][item].on2) {
                    sub_903F0(ptr, PTRX(oldmx), PTRY(oldmy));
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
                    DrawMenuItemSel((struct MenuItem *)&menus[depth][sel[depth]], pos[depth][0], pos[depth][1], col1,
                        col2, col3);
                    sel[depth] = item;
                    DrawMenuItemNorm((struct MenuItem *)&menus[depth][sel[depth]], pos[depth][0], pos[depth][1], col1,
                        col2, col3);
                    depth++;
                    menus[depth] = (MenuItem *)menus[level][item].on2;
                    nitems[depth] = menus[level][item].pad;
                    pos[depth][0] = (depth != 1 ? menus[level][item].x2 : menus[level][item].x1)
                        + pos[depth - 1][0];
                    pos[depth][1] = (depth != 1 ? menus[level][item].y1 : menus[level][item].y2)
                        + pos[depth - 1][1];
                    w = menus[depth][nitems[depth] - 1].x2 - menus[depth][0].x1 + 1;
                    h = menus[depth][nitems[depth] - 1].y2 - menus[depth][0].y1 + 1;
                    bg[depth] = sub_8CCA8((char *)str_Menubuff7, w * 4 * h + 0x11, 0x20);
                    *(TrHdr17 *)bg[depth] = *(TrHdr17 *)pointerspr;
                    ((short *)bg[depth])[2] = w;
                    ((short *)bg[depth])[3] = h;
                    sub_91400(bg[depth], pos[depth][0], pos[depth][1]);
                    DrawMenuDropdown(menus[depth], nitems[depth], pos[depth][0], pos[depth][1],
                        col1, col2, col3);
                    sel[depth] = 0;
                    DrawMenuItemNorm((struct MenuItem *)menus[depth], pos[depth][0], pos[depth][1],
                        col1, col2, col3);
                } else {
                    sub_903F0(ptr, PTRX(oldmx), PTRY(oldmy));
                    DrawMenuItemSel((struct MenuItem *)&menus[level][sel[level]], pos[level][0],
                        pos[level][1], col1, col2, col3);
                    sel[level] = item;
                    DrawMenuItemNorm((struct MenuItem *)&menus[level][sel[level]], pos[level][0],
                        pos[level][1], col1, col2, col3);
                }
            } else {
                sub_903F0(ptr, PTRX(oldmx), PTRY(oldmy));
                if (TradeHitTest(mx, my, tradeclick, &tradeside, &flag)) {
                    for (i = n; i >= 0; i--) {
                        if (bg[i]) {
                            sub_903F0(bg[i], pos[i][0], pos[i][1]);
                            pos[i][0] = pos[i][1] = 0;
                            FreeMemBlock(bg[i]);
                        }
                    }
                    depth = 0;
                    menus[1] = menus[2] = menus[3] = 0;
                    bg[0] = bg[1] = bg[2] = 0;
                    sel[1] = sel[2] = sel[3] = 0;
                    nitems[1] = nitems[2] = nitems[3] = 0;
                    if (tradeclick[tradeside] < 0x64 && (tradecursor[tradeside] != -1 || flag)) {
                        r = 0;
                        click = tradeclick[tradeside];
                        cursor = tradecursor[tradeside];
                        p = slots + click;
                        if (flag) {
                            if (*p != 0xFF) {
                                if (cursor != -1 && *p != cursor) {
                                    sub_8E9C0(0x40, 0x41);
                                    DrawTradeRow(tradeside);
                                }
                                p = slots + click;
                                tradecursor[tradeside] = FindTradeSlot(tradeside, *p);
                                sub_8E9C0(0x42, 0x41);
                                DrawTradeRow(tradeside);
                                *p = 0xFF;
                                picked[click].c[1] = 0xFF;
                                r = -1;
                            } else
                                tradeside = -1;
                        } else {
                            if (click < 2) {
                                if (tradeside == 0 && slots[0] != tradeslot[tradeside * 0x268 + cursor * 0x16]
                                    && slots[1] != tradeslot[tradeside * 0x268 + cursor * 0x16]) {
                                    *p = tradeslot[tradeside * 0x268 + cursor * 0x16];
                                    picked[click] = *(TrEntry *)&traderoster[tradeside * 0x268 + cursor * 0x16];
                                    if ((picked[click].c[0] == 'G' && picked[click + 2].c[0] != 'G')
                                        || (picked[click].c[0] != 'G' && picked[click + 2].c[0] == 'G')) {
                                        slots[click + 2] = 0xFF;
                                        picked[click + 2].c[1] = 0xFF;
                                    }
                                    sub_8E9C0(0x40, 0x41);
                                    DrawTradeRow(tradeside);
                                    tradeside = tradecursor[tradeside] = -1;
                                    r = -1;
                                }
                            } else if (click < 4 && tradeside == 1
                                && slots[2] != tradeslot[tradeside * 0x268 + cursor * 0x16]
                                && tradeslot[tradeside * 0x268 + cursor * 0x16] != slots[3]) {
                                *p = tradeslot[tradeside * 0x268 + cursor * 0x16];
                                picked[click] = *(TrEntry *)&traderoster[tradeside * 0x268 + cursor * 0x16];
                                if ((picked[click].c[0] == 'G' && picked[click - 2].c[0] != 'G')
                                    || (picked[click].c[0] != 'G' && picked[click - 2].c[0] == 'G')) {
                                    slots[click - 2] = 0xFF;
                                    picked[click - 2].c[1] = 0xFF;
                                }
                                sub_8E9C0(0x40, 0x41);
                                DrawTradeRow(tradeside);
                                tradeside = tradecursor[tradeside] = -1;
                                r = -1;
                            }
                        }
                        if (r) {
                            for (i = 0; i < 4; i++) {
                                memcpy(unk_D12C8, (unsigned char *)traderemap1[i >> 1] + 0x90, 0x30);
                                c1 = jerseyremap[byte_D11BC[teams[i >> 1] * 4]];
                                c2 = byte_D12DE;
                                MakeJerseyShape(jerseyremap, picked[i].c[1], c1, c2);
                                sub_B4DD4(jerseyremap);
                                sub_931FC(art, tradebtnx[i * 2], tradebtny[i * 2]);
                            }
                        }
                    } else if (tradeclick[tradeside] >= 0x64) {
                        tradeclick[tradeside] -= 0x64;
                        if (traderoster[tradeside * 0x268 + tradeclick[tradeside] * 0x16]) {
                            if (tradecursor[tradeside] == tradeclick[tradeside]) {
                                sub_8E9C0(0x40, 0x41);
                                DrawTradeRow(tradeside);
                                tradeside = tradecursor[tradeside] = -1;
                            } else {
                                if (tradecursor[tradeside] != -1) {
                                    sub_8E9C0(0x40, 0x41);
                                    DrawTradeRow(tradeside);
                                }
                                tradecursor[tradeside] = tradeclick[tradeside];
                                sub_8E9C0(0x42, 0x41);
                                DrawTradeRow(tradeside);
                            }
                        }
                    }
                }
            }
            if (!traderesult) {
                sub_91400(ptr, PTRX(mx), PTRY(my));
                DRAGJERSEY();
                sub_91FE0(pointerspr, mx - 3, my);
                oldmx = mx;
                oldmy = my;
            }
        }
    } while (!traderesult);
    FreeMemBlock(ptr);
    if (traderesult > 0) traderesult = 0;
    return traderesult;
}
