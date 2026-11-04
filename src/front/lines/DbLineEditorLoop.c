/* Line editor rosters: the database line editor loop. */
#define DbLineEditorLoop DbLineEditorLoop_decl
#define MenuHitTest MenuHitTest_decl
#include "nhl95.h"
#undef DbLineEditorLoop
#undef MenuHitTest

typedef struct MenuItem {
    int x1, y1, x2, y2;
    char *text;
    int on1, on2;
    int pad;
} MenuItem;

typedef struct { char c[17]; } LeHdr17;

/* A line table (30h bytes, the layout of the team's line block): the 28h slots by group, then the 8 extra
   (scratched) slots. */
typedef union LineSet {
    unsigned char slot[0x30];
    struct {
        unsigned char fwd[12];    /* forward lines 1-4, 3 each */
        unsigned char def[6];     /* defence pairs 1-3 */
        unsigned char pp[10];     /* power play units 1-2, 5 each */
        unsigned char pk[8];      /* penalty kill units 1-2, 4 each */
        unsigned char gl[2];      /* goaltenders */
        unsigned char ex[2];      /* extra attackers */
        unsigned char scr[8];     /* extra slots */
    } g;
} LineSet;

/* A line editor menu action (MenuShowPlayerStats, DressPlayer, ScratchPlayer, MenuLineEdCancel ...). */
typedef int (*LineEdAction)(unsigned char *nums, unsigned char *lines, unsigned char side, int *sel, int art,
                            int zero, MenuItem *buttons, int n, int *mx, int *my);

/* The offset of row r of the team's roster list (27 bytes per player, 2F4h per team). */
#define RREC(r) (team * 0x2F4 + (r) * 27)

int MenuHitTest(int x, int y, MenuItem **menus, int i, int *counts, int *origin, int *hitMenu, int *hitItem);
int DbLineEditorLoop(unsigned char *lines, int art, unsigned char team, int zero, MenuItem *buttons, int n,
                     int bank);

/* DRAFT under 10.0 GA: 5,678 bytes as the EXE, 64 differing instructions (7 aligned, two of them the false
   two-fixup stores of the menu actions). The explicit menu-item offset restores the EXE's frame size and bias,
   the jersey numbers are an if / else of two stores as in GameLineEditorLoop, and the declaration order
   (tools/wccre/declsearch.py) puts every local in the EXE's slot. Left: the EXE computes level * 4 before the
   itemoffset store (C after it). */
/* DbLineEditorLoop (73A18, PC only): the database line editor (DbLineEditor's loop; GameLineEditorLoop is its
   copy for the game roster). Copy the jersey numbers of the 28h line slots of lines (the players found in team's
   roster list by FindRosterSlot; 100 for an empty slot) and put the dressed players of the 8 extra slots back to
   scratched (status 3 -> 2). The dress and scratch menu items are off until a player is picked. Load the palette
   (PAL25, the team crest colours from EMBPAL and the LELOGO colours), the jersey colours (the team's rosterteam
   colours), draw the jerseys and fade in. Then follow the mouse: a click on the menu bar works as in RunMenu (an
   action, the second click on the selected item, gets the jersey table, lines, team, the picked row, art, buttons
   and n, and the pointer position; a result of 1 fades out and leaves); a click on a roster row picks that
   player (dressed, on the ice or scratched; the old row is printed in its plain colour, the new one
   highlighted); a click on a line slot with a player picked puts him there when his position fits (C / L / R on
   the forward lines, D on the defence pairs, a skater on the special teams and extra attackers, a goalie in the
   nets), taking him out of the other slots of that line; an empty slot is drawn as a plain jersey. A click on a
   slot or row also closes the dropdowns. While a player is picked his jersey follows the pointer over the
   slots. lines: the team's line block (30h bytes); art: the jersey art; team: the roster side; zero: not used;
   buttons, n: the menu bar; bank: the line editor bank (Pntr3 pointer). Result: 0. */
/* Locals: blk is the pointer art, then the loaded banks; slot a roster slot (FindRosterSlot); k the slot within a
   line; j the remap index of a plain jersey; pick the picked roster row (-1 none), hit the item LineEdHitTest
   found. */
int DbLineEditorLoop(unsigned char *lines, int art, unsigned char team, int zero, MenuItem *buttons, int n,
                     int bank)
{
    int i;
    unsigned char c2;
    int sel[4];
    int col1;
    unsigned char *pal;
    LineSet nums;
    int itemoffset;
    int my;
    int bg[4];
    unsigned char c1;
    int level;
    char path[0x20];
    int hit;
    int col2;
    int h;
    int pick;
    int nitems[4];
    int blk;
    int col3;
    int ptr;
    int mx;
    int pos[4][2];
    MenuItem *menus[4];
    char buf[0x20];
    int depth;
    int w;
    int oldmx;
    int oldmy;
    int bits;
    int r;
    int k;
    int j;
    unsigned char slot;
    unsigned char *e;
    MenuItem *m;
    int item;

    depth = 0;
    hit = pick = -1;
    col1 = 0xC0;
    col2 = 0xC1;
    col3 = 0xC2;
    blk = sub_B30B4(bank, (char *)str_Pntr3);
    menus[0] = buttons;
    nitems[0] = n;
    menus[1] = menus[2] = menus[3] = 0;
    bg[0] = bg[1] = bg[2] = bg[3] = 0;
    sel[0] = sel[1] = sel[2] = sel[3] = 0;
    pos[0][0] = pos[0][1] = 0;
    menuact_dbscratch = menuact_dbdress = 0;
    r = (((short *)blk)[2] + 1) * (((short *)blk)[3] + 1) + 0x11;
    ptr = sub_8CCA8((char *)str_Pointer13, r, 0x20);
    *(LeHdr17 *)ptr = *(LeHdr17 *)blk;
    ((short *)ptr)[2] = ((short *)blk)[2] + 1;
    ((short *)ptr)[3] = ((short *)blk)[3] + 1;
    mx = oldmx = (menus[0]->x1 + menus[0]->x2) / 2;
    my = oldmy = (menus[0]->y1 + menus[0]->y2) / 2;
    /* the slots' jersey numbers */
    for (i = 0; i < 0x28; i++) {
        if (lines[i] != 100) {
            slot = FindRosterSlot(lines[i], team);
            nums.slot[i] = rosterjersey[RREC(slot)];
        } else nums.slot[i] = 100;
    }
    /* the extra slots' dressed players are scratched again */
    for (i = 0; i < 8; i++) {
        slot = FindRosterSlot(lines[0x28 + i], team);
        if (lines[0x28 + i] != 100 && rosterstat[RREC(slot)] == 3)
            rosterstat[RREC(slot)] = 2;
    }
    pal = (unsigned char *)sub_8CCA8((char *)str_Pal25, 0x300, 0x20);
    MakePath(path, fileoncd[0x8E] == 1 ? (char *)cddriveptr : 0, (char *)str_Embpal4, 0);
    blk = sub_8E83C(path, 0);
    memcpy(pal, (unsigned char *)sub_B30B4(blk, (char *)str_Pal26) + 0x10, 0x300);
    FreeMemBlock(blk);
    LoadJerseyColours(team, bank, pal);
    c1 = byte_D11BC[rosterteam[team] * 4];
    c1 = jerseyremap[c1];
    c2 = byte_D12DE;
    DrawLineJerseys(nums.slot, art, team);
    MakePath(path, fileoncd[0x21B] == 1 ? (char *)cddriveptr : 0, (char *)str_Lelogo, 0);
    blk = sub_8E83C(path, 0);
    memcpy(pal + 0x25E, (unsigned char *)sub_B30B4(blk, (char *)str_Pal26) + 0x26E, 0x93);
    FreeMemBlock(blk);
    FadePalStep(0, pal, 0x10);
    sub_91400(editptrspr, oldmx < 0x1C ? 0 : oldmx - 0x1C, oldmy < 0x20 ? 0 : oldmy - 0x20);
    sub_91400(ptr, oldmx < 0x1C ? 0 : oldmx - 0x1C, oldmy < 0x20 ? 0 : oldmy - 0x20);
    sub_91FE0(pointerspr, oldmx - 3, oldmy);
    sub_B2E1B(0, 0, 0x280, 0x1E0);
    MouseSetPos(oldmx, oldmy);
    sub_B2DCA(&i, &i, &i);
    ClearInputQueue();
    for (;;) {
        bits = 0;
        while ((e = GetInputEvent()) != 0) {
            bits = ((int (*)(unsigned char *, int *, int *))ptrupdatefn)(e, &mx, &my);
            if (bits & 2) break;
        }
        if (!(bits & 2)) {
            if (oldmx != mx || oldmy != my) {
                /* moved: the saved block and the picked player's jersey follow the pointer */
                sub_903F0(ptr, oldmx < 0x1C ? 0 : oldmx - 0x1C, oldmy < 0x20 ? 0 : oldmy - 0x20);
                sub_91400(ptr, mx < 0x1C ? 0 : mx - 0x1C, my < 0x20 ? 0 : my - 0x20);
                if (my > menus[0]->y2 && mx < 500 && pick != -1
                    && (!menus[1] || !MenuHitTest(mx, my, menus, depth, nitems, &pos[0][0], &level, &item))
                    && rosterstat[RREC(pick)] != 2) {
                    MakeJerseyShape(jerseyremap, rosterjersey[RREC(pick)], c1, c2);
                    sub_B4DD4(jerseyremap);
                    sub_91FE0(art, mx - 0x1C, my - 0x20);
                }
                sub_91FE0(pointerspr, mx - 3, my);
                oldmx = mx;
                oldmy = my;
            }
            continue;
        }
        if (MenuHitTest(mx, my, menus, depth, nitems, &pos[0][0], &level, &item)) {
            itemoffset = item * sizeof(MenuItem);
            m = (MenuItem *)((char *)menus[level] + itemoffset);
            if ((*(int *)((char *)menus[level] + itemoffset + 0x14))) {
                if (item == sel[level]) {
                    /* the second click on the selected item: close the dropdowns and run the action */
                    sub_903F0(ptr, oldmx < 0x1C ? 0 : oldmx - 0x1C, oldmy < 0x20 ? 0 : oldmy - 0x20);
                    for (i = 3; i >= 0; i--) {
                        if (bg[i]) {
                            sub_903F0(bg[i], pos[i][0], pos[i][1]);
                            pos[i][0] = pos[i][1] = 0;
                            FreeMemBlock(bg[i]);
                        }
                    }
                    depth = 0;
                    r = ((LineEdAction)menus[level][item].on1)(nums.slot, lines, team, &pick, art, 0, buttons, n,
                                                               &mx, &my);
                    menus[1] = menus[2] = menus[3] = 0;
                    bg[0] = bg[1] = bg[2] = 0;
                    sel[1] = sel[2] = sel[3] = 0;
                    nitems[1] = nitems[2] = nitems[3] = 0;
                    if (r == 1) {
                        ClearInputQueue();
                        FreeMemBlock(ptr);
                        FadePalStep(1, pal, 0x10);
                        FreeMemBlock((int)pal);
                        return 0;
                    }
                    ClearInputQueue();
                } else {
                    /* another item of the same menu: move the selection */
                    sub_903F0(ptr, oldmx < 0x1C ? 0 : oldmx - 0x1C, oldmy < 0x20 ? 0 : oldmy - 0x20);
                    DrawMenuItemSel((struct MenuItem *)&menus[level][sel[level]], pos[level][0], pos[level][1],
                        col1, col2, col3);
                    sel[level] = item;
                    DrawMenuItemNorm((struct MenuItem *)&menus[level][sel[level]], pos[level][0], pos[level][1],
                        col1, col2, col3);
                }
            } else if ((*(int *)((char *)menus[level] + itemoffset + 0x18))) {
                /* an item with a submenu: close the deeper dropdowns, select it and open its dropdown */
                sub_903F0(ptr, oldmx < 0x1C ? 0 : oldmx - 0x1C, oldmy < 0x20 ? 0 : oldmy - 0x20);
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
                DrawMenuItemSel((struct MenuItem *)&menus[depth][sel[depth]], pos[depth][0], pos[depth][1], col1,
                    col2, col3);
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
                bg[depth] = sub_8CCA8((char *)str_Menubuff8, w * 4 * h + 0x11, 0x20);
                *(LeHdr17 *)bg[depth] = *(LeHdr17 *)pointerspr;
                ((short *)bg[depth])[2] = w;
                ((short *)bg[depth])[3] = h;
                sub_91400(bg[depth], pos[depth][0], pos[depth][1]);
                DrawMenuDropdown(menus[depth], nitems[depth], pos[depth][0], pos[depth][1], col1, col2, col3);
                sel[depth] = 0;
                DrawMenuItemNorm((struct MenuItem *)menus[depth], pos[depth][0], pos[depth][1], col1, col2, col3);
            } else {
                /* an item without action or submenu: select it */
                sub_903F0(ptr, oldmx < 0x1C ? 0 : oldmx - 0x1C, oldmy < 0x20 ? 0 : oldmy - 0x20);
                DrawMenuItemSel((struct MenuItem *)&menus[level][sel[level]], pos[level][0], pos[level][1], col1,
                    col2, col3);
                sel[level] = item;
                DrawMenuItemNorm((struct MenuItem *)&menus[level][sel[level]], pos[level][0], pos[level][1], col1,
                    col2, col3);
            }
        } else {
            /* a click on a slot or a roster row closes the menus first */
            sub_903F0(ptr, oldmx < 0x1C ? 0 : oldmx - 0x1C, oldmy < 0x20 ? 0 : oldmy - 0x20);
            if (LineEdHitTest(mx, my, &hit)) {
                for (i = 3; i >= 0; i--) {
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
                if (hit < 100 && pick != -1 && rosterstat[RREC(pick)] != 2) {
                    /* a line slot: put the picked player there when his position fits */
                    sub_8E9C0(0xC0, 0xC1);
                    if (hit < 0xC) {
                        if (rosterlist[RREC(pick)] == 'C' || rosterlist[RREC(pick)] == 'L'
                            || rosterlist[RREC(pick)] == 'R') {
                            i = hit / 3;
                            for (k = 0; k < 3; k++)
                                if (nums.g.fwd[i * 3 + k] == rosterjersey[RREC(pick)])
                                    nums.g.fwd[i * 3 + k] = 100;
                            k = hit % 3;
                            nums.g.fwd[k + i * 3] = rosterjersey[RREC(pick)];
                            for (k = 0; k < 3; k++) {
                                if (nums.g.fwd[i * 3 + k] <= 99) {
                                    MakeJerseyShape(jerseyremap, nums.g.fwd[i * 3 + k], c1, c2);
                                } else {
                                    for (j = 0; j < 0x90; j++) jerseyremap[j] = c2;
                                    for (j = 0xC0; j < 0xF0; j++) jerseyremap[j] = c2;
                                }
                                sub_B4DD4(jerseyremap);
                                sub_931FC(art, lineslotx[(i * 3 + k) * 2], linesloty[(i * 3 + k) * 2]);
                            }
                        }
                    } else if (hit < 0x12) {
                        if (rosterlist[RREC(pick)] == 'D') {
                            i = (hit - 0xC) / 2;
                            for (k = 0; k < 2; k++)
                                if (nums.g.def[i * 2 + k] == rosterjersey[RREC(pick)])
                                    nums.g.def[i * 2 + k] = 100;
                            k = (hit - 0xC) % 2;
                            nums.g.def[k + i * 2] = rosterjersey[RREC(pick)];
                            for (k = 0; k < 2; k++) {
                                if (nums.g.def[i * 2 + k] <= 99) {
                                    MakeJerseyShape(jerseyremap, nums.g.def[i * 2 + k], c1, c2);
                                } else {
                                    for (j = 0; j < 0x90; j++) jerseyremap[j] = c2;
                                    for (j = 0xC0; j < 0xF0; j++) jerseyremap[j] = c2;
                                }
                                sub_B4DD4(jerseyremap);
                                sub_931FC(art, dword_D1398[(i * 2 + k) * 2], dword_D139C[(i * 2 + k) * 2]);
                            }
                        }
                    } else if (hit < 0x1C) {
                        if (rosterlist[RREC(pick)] != 'G') {
                            i = (hit - 0x12) / 5;
                            for (k = 0; k < 5; k++)
                                if (nums.g.pp[i * 5 + k] == rosterjersey[RREC(pick)])
                                    nums.g.pp[i * 5 + k] = 100;
                            k = (hit - 0x12) % 5;
                            nums.g.pp[k + i * 5] = rosterjersey[RREC(pick)];
                            for (k = 0; k < 5; k++) {
                                if (nums.g.pp[i * 5 + k] <= 99) {
                                    MakeJerseyShape(jerseyremap, nums.g.pp[i * 5 + k], c1, c2);
                                } else {
                                    for (j = 0; j < 0x90; j++) jerseyremap[j] = c2;
                                    for (j = 0xC0; j < 0xF0; j++) jerseyremap[j] = c2;
                                }
                                sub_B4DD4(jerseyremap);
                                sub_931FC(art, dword_D13C8[(i * 5 + k) * 2], dword_D13CC[(i * 5 + k) * 2]);
                            }
                        }
                    } else if (hit < 0x24) {
                        if (rosterlist[RREC(pick)] != 'G') {
                            i = (hit - 0x1C) / 4;
                            for (k = 0; k < 4; k++)
                                if (nums.g.pk[i * 4 + k] == rosterjersey[RREC(pick)])
                                    nums.g.pk[i * 4 + k] = 100;
                            k = (hit - 0x1C) % 4;
                            nums.g.pk[k + i * 4] = rosterjersey[RREC(pick)];
                            for (k = 0; k < 4; k++) {
                                if (nums.g.pk[i * 4 + k] <= 99) {
                                    MakeJerseyShape(jerseyremap, nums.g.pk[i * 4 + k], c1, c2);
                                } else {
                                    for (j = 0; j < 0x90; j++) jerseyremap[j] = c2;
                                    for (j = 0xC0; j < 0xF0; j++) jerseyremap[j] = c2;
                                }
                                sub_B4DD4(jerseyremap);
                                sub_931FC(art, dword_D1418[(i * 4 + k) * 2], dword_D141C[(i * 4 + k) * 2]);
                            }
                        }
                    } else if (hit < 0x26) {
                        if (rosterlist[RREC(pick)] == 'G') {
                            for (k = 0; k < 2; k++)
                                if (nums.g.gl[k] == rosterjersey[RREC(pick)]) nums.g.gl[k] = 100;
                            k = hit - 0x24;
                            nums.g.gl[k] = rosterjersey[RREC(pick)];
                            for (k = 0; k < 2; k++) {
                                if (nums.g.gl[k] <= 99) {
                                    MakeJerseyShape(jerseyremap, nums.g.gl[k], c1, c2);
                                } else {
                                    for (j = 0; j < 0x90; j++) jerseyremap[j] = c2;
                                    for (j = 0xC0; j < 0xF0; j++) jerseyremap[j] = c2;
                                }
                                sub_B4DD4(jerseyremap);
                                sub_931FC(art, dword_D1458[k * 2], dword_D145C[k * 2]);
                            }
                        }
                    } else {
                        if (rosterlist[RREC(pick)] != 'G') {
                            for (k = 0; k < 2; k++)
                                if (nums.g.ex[k] == rosterjersey[RREC(pick)]) nums.g.ex[k] = 100;
                            k = hit - 0x26;
                            nums.g.ex[k] = rosterjersey[RREC(pick)];
                            for (k = 0; k < 2; k++) {
                                if (nums.g.ex[k] <= 99) {
                                    MakeJerseyShape(jerseyremap, nums.g.ex[k], c1, c2);
                                } else {
                                    for (j = 0; j < 0x90; j++) jerseyremap[j] = c2;
                                    for (j = 0xC0; j < 0xF0; j++) jerseyremap[j] = c2;
                                }
                                sub_B4DD4(jerseyremap);
                                sub_931FC(art, dword_D1468[k * 2], dword_D146C[k * 2]);
                            }
                        }
                    }
                } else if (hit >= 100) {
                    /* a roster row: pick a dressed, playing or scratched player */
                    hit -= 100;
                    if (rosterstat[RREC(hit)]
                        && (rosterstat[RREC(hit)] == 4 || rosterstat[RREC(hit)] == 3 || rosterstat[RREC(hit)] == 2)) {
                        if (pick != -1) {
                            if (rosterstat[RREC(pick)] == 2) sub_8E9C0(0xFC, 0xC1);
                            else sub_8E9C0(0xC3, 0xC1);
                            sprintf(buf, (char *)str_C2dS2, rosterlist[RREC(pick)],
                                rosterjersey[RREC(pick)], rosterlist + team * 0x2F4 + pick * 27 + 8);
                            PrintLineEdStatus(0x1FA, pick * 13 + 0x16, buf);
                        }
                        pick = hit;
                        menuact_dbdress = (int)DressPlayer;
                        menuact_dbscratch = (int)ScratchPlayer;
                        if (rosterstat[RREC(hit)] == 2) sub_8E9C0(0xFD, 0xC1);
                        else sub_8E9C0(0xC0, 0xC1);
                        sprintf(buf, (char *)str_C2dS2, rosterlist[RREC(pick)],
                            rosterjersey[RREC(pick)], rosterlist + team * 0x2F4 + pick * 27 + 8);
                        PrintLineEdStatus(0x1FA, pick * 13 + 0x16, buf);
                    }
                }
            }
        }
        sub_91400(ptr, mx < 0x1C ? 0 : mx - 0x1C, my < 0x20 ? 0 : my - 0x20);
        if (my > menus[0]->y2 && mx < 500 && pick != -1
            && (!menus[1] || !MenuHitTest(mx, my, menus, depth, nitems, &pos[0][0], &level, &item))
            && rosterstat[RREC(pick)] != 2) {
            MakeJerseyShape(jerseyremap, rosterjersey[RREC(pick)], c1, c2);
            sub_B4DD4(jerseyremap);
            sub_91FE0(art, mx - 0x1C, my - 0x20);
        }
        sub_91FE0(pointerspr, mx - 3, my);
        oldmx = mx;
        oldmy = my;
    }
}
