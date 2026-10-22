/* Line editor rosters: the in-game line editor loop. */
#define GameLineEditorLoop GameLineEditorLoop_decl
#define MenuHitTest MenuHitTest_decl
#include "nhl95.h"
#undef GameLineEditorLoop
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

/* A line editor menu action (MenuShowPlayerStats, GameDressPlayer, MenuLineEdCancel ...). */
typedef int (*LineEdAction)(unsigned char *nums, unsigned char *lines, unsigned char side, int *sel, int art,
                            int zero, MenuItem *buttons, int n, int *mx, int *my);

/* The roster status of game roster row r (the team's roster, 27h bytes per player, 444h per team). */
#define GSTAT(r) hmroster[team * 0x444 + gmrosterslot[(r) * 22] * 39]

int MenuHitTest(int x, int y, MenuItem **menus, int i, int *counts, int *origin, int *hitMenu, int *hitItem);
int GameLineEditorLoop(unsigned char *lines, int art, unsigned char team, int zero, MenuItem *buttons, int n,
                       int bank);

/* DRAFT (first pass from Ghidra): 5,243 of 5,242 bytes, 384 differing lines (permute.py count; 49 with the
   frame offsets masked). The code follows the EXE block for block; the frame is 4 bytes short (the EXE spills
   item * 20h for the on1 test to ebp+4Ah, C keeps it in ecx), so the arrays sit 4 bytes higher, path and nitems
   swap places and the lower scalars take other slots. Left: register picks in the menu branches, and the goalie
   and extra attacker stores (the EXE computes hit - 24h / 26h into esi; `k = hit - 0x24; gl[k]` matches them but
   moves registers elsewhere: 412). */
/* GameLineEditorLoop (76AF5, PC only): the in-game line editor (GameLineEditor's loop; DbLineEditorLoop on the
   game roster). Copy the jersey numbers of the 28h line slots of lines (100 for an empty slot) and, before the
   game (curperiod < 0), put the dressed players of the 8 extra slots back to scratched (status 3 -> 2). The menu
   items that use the lines (save / use these lines, save default lines) are off while a slot is empty, the dress
   and scratch items until a player is picked. Load the palette (PAL27, the team crest colours from EMBPAL and the
   LELOGO colours), the jersey colours, draw the jerseys and fade in. Then follow the mouse: a click on the menu
   bar works as in RunMenu (an action, the second click on the selected item, gets the jersey table, lines, team,
   the picked row, art, buttons and n, and the pointer position; a result of 1 leaves); a click on a roster row
   picks that player (dressed or on the ice, or scratched before the game; the old row is printed in its plain
   colour, the new one highlighted); a click on a line slot with a player picked puts him there when his position
   fits (C / L / R on the forward lines, D on the defence pairs, a skater on the special teams and extra
   attackers, a goalie in the nets), taking him out of the other slots of that line. While a player is picked his
   jersey follows the pointer over the slots. lines: the team's line block (30h bytes); art: the jersey art; team:
   0 home, else away; zero: not used; buttons, n: the menu bar; bank: the line editor bank (Pntr4 pointer).
   Result: 0. */
/* Locals: blk is the pointer art, then the loaded banks; r the pointer buffer size, then the action result; k the
   slot within a line; pick the picked roster row (-1 none), hit the item LineEdHitTest found. */
int GameLineEditorLoop(unsigned char *lines, int art, unsigned char team, int zero, MenuItem *buttons, int n,
                       int bank)
{
    LineSet nums;
    int pos[4][2];
    char buf[0x20];
    char path[0x10];
    int bg[4];
    int nitems[4];
    int sel[4];
    MenuItem *menus[4];
    int hit;
    int pick;
    int item;
    int level;
    int my;
    int mx;
    int i;
    int blk;
    int h;
    int w;
    unsigned char *pal;
    int col1;
    int col3;
    int col2;
    int ptr;
    int depth;
    unsigned char c2;
    unsigned char c1;
    int oldmx;
    int oldmy;
    int bits;
    int r;
    int k;
    unsigned char *e;
    MenuItem *m;

    depth = 0;
    hit = pick = -1;
    col1 = 0xC0;
    col2 = 0xC1;
    col3 = 0xC2;
    blk = sub_B30B4(bank, (char *)str_Pntr4);
    menus[0] = buttons;
    nitems[0] = n;
    menus[1] = menus[2] = menus[3] = 0;
    bg[0] = bg[1] = bg[2] = bg[3] = 0;
    sel[0] = sel[1] = sel[2] = sel[3] = 0;
    pos[0][0] = pos[0][1] = 0;
    menuact_gamedress = menuact_gamescratch = 0;
    r = (((short *)blk)[2] + 1) * (((short *)blk)[3] + 1) + 0x11;
    ptr = sub_8CCA8((char *)str_Pointer14, r, 0x20);
    *(LeHdr17 *)ptr = *(LeHdr17 *)blk;
    ((short *)ptr)[2] = ((short *)blk)[2] + 1;
    ((short *)ptr)[3] = ((short *)blk)[3] + 1;
    mx = oldmx = (menus[0]->x1 + menus[0]->x2) / 2;
    my = oldmy = (menus[0]->y1 + menus[0]->y2) / 2;
    /* the line menu items only with every slot filled */
    menuact_savelines = (int)MenuSaveTheseLines;
    menuact_uselines = (int)MenuUseTheseLines;
    menuact_uselines2 = (int)MenuUseTheseLines;
    menuact_savedeflines = (int)MenuSaveDefaultLines;
    menuact_savedeflines2 = (int)MenuSaveDefaultLines;
    for (i = 0; i < 0x28; i++) {
        if (lines[i] == 100) {
            menuact_savelines = 0;
            menuact_uselines = 0;
            menuact_uselines2 = 0;
            menuact_savedeflines = 0;
            menuact_savedeflines2 = 0;
            break;
        }
    }
    /* the slots' jersey numbers */
    for (i = 0; i < 0x28; i++) {
        if (lines[i] != 100) nums.slot[i] = hmrosterjersey[team * 0x444 + lines[i] * 39];
        else nums.slot[i] = 100;
    }
    /* before the game the extra slots' dressed players are scratched again */
    if (curperiod < 0) {
        for (i = 0; i < 8; i++) {
            if (lines[0x28 + i] != 100 && hmroster[team * 0x444 + lines[0x28 + i] * 39] == 3)
                hmroster[team * 0x444 + lines[0x28 + i] * 39] = 2;
        }
    }
    pal = (unsigned char *)sub_8CCA8((char *)str_Pal27, 0x300, 0x20);
    MakePath(path, fileoncd[0x8E] == 1 ? (char *)cddriveptr : 0, (char *)str_Embpal5, 0);
    blk = sub_8E83C(path, 0);
    memcpy(pal, (unsigned char *)sub_B30B4(blk, (char *)str_Pal28) + 0x10, 0x300);
    FreeMemBlock(blk);
    LoadJerseyColours(team, bank, pal);
    c1 = byte_D11BC[(team ? VisTeam : HomeTeam) * 4];
    c1 = jerseyremap[c1];
    c2 = byte_D12DE;
    DrawGameLineJerseys(nums.slot, art, team);
    MakePath(path, fileoncd[0x21B] == 1 ? (char *)cddriveptr : 0, (char *)str_Lelogo2, 0);
    blk = sub_8E83C(path, 0);
    memcpy(pal + 0x25E, (unsigned char *)sub_B30B4(blk, (char *)str_Pal28) + 0x26E, 0x93);
    FreeMemBlock(blk);
    FadePalStep(0, pal, 0x10);
    FreeMemBlock((int)pal);
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
                    && GSTAT(pick) != 2) {
                    MakeJerseyShape(jerseyremap, gmrosterjersey[pick * 22], c1, c2);
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
            m = &menus[level][item];
            if (m->on1) {
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
                        return 0;
                    }
                    ClearInputQueue();
                } else {
                    /* another item of the same menu: move the selection */
                    sub_903F0(ptr, oldmx < 0x1C ? 0 : oldmx - 0x1C, oldmy < 0x20 ? 0 : oldmy - 0x20);
                    DrawMenuItemSel((struct MenuItem *)&menus[level][sel[level]], pos[level][0], pos[level][1],
                        col1, col2, col3);
                    sel[level] = item;
                    DrawMenuItemNorm((struct MenuItem *)&menus[level][item], pos[level][0], pos[level][1], col1,
                        col2, col3);
                }
            } else if (m->on2) {
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
                bg[depth] = sub_8CCA8((char *)str_Menubuff9, w * h + 0x11, 0x20);
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
            /* a click outside the menus closes them; then the slots and the roster rows */
            sub_903F0(ptr, oldmx < 0x1C ? 0 : oldmx - 0x1C, oldmy < 0x20 ? 0 : oldmy - 0x20);
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
            if (LineEdHitTest(mx, my, &hit)) {
                if (hit < 100 && pick != -1 && GSTAT(pick) != 2) {
                    /* a line slot: put the picked player there when his position fits */
                    sub_8E9C0(0xC0, 0xC1);
                    if (hit < 0xC) {
                        if (gmroster[pick * 22] == 'C' || gmroster[pick * 22] == 'L' || gmroster[pick * 22] == 'R') {
                            i = hit / 3;
                            for (k = 0; k < 3; k++)
                                if (nums.g.fwd[i * 3 + k] == gmrosterjersey[pick * 22]) nums.g.fwd[i * 3 + k] = 100;
                            k = hit % 3;
                            nums.g.fwd[k + i * 3] = gmrosterjersey[pick * 22];
                            for (k = 0; k < 3; k++) {
                                MakeJerseyShape(jerseyremap, nums.g.fwd[i * 3 + k], c1, c2);
                                sub_B4DD4(jerseyremap);
                                sub_931FC(art, lineslotx[(i * 3 + k) * 2], linesloty[(i * 3 + k) * 2]);
                            }
                        }
                    } else if (hit < 0x12) {
                        if (gmroster[pick * 22] == 'D') {
                            i = (hit - 0xC) / 2;
                            for (k = 0; k < 2; k++)
                                if (nums.g.def[i * 2 + k] == gmrosterjersey[pick * 22]) nums.g.def[i * 2 + k] = 100;
                            k = (hit - 0xC) % 2;
                            nums.g.def[k + i * 2] = gmrosterjersey[pick * 22];
                            for (k = 0; k < 2; k++) {
                                MakeJerseyShape(jerseyremap, nums.g.def[i * 2 + k], c1, c2);
                                sub_B4DD4(jerseyremap);
                                sub_931FC(art, dword_D1398[(i * 2 + k) * 2], dword_D139C[(i * 2 + k) * 2]);
                            }
                        }
                    } else if (hit < 0x1C) {
                        if (gmroster[pick * 22] != 'G') {
                            i = (hit - 0x12) / 5;
                            for (k = 0; k < 5; k++)
                                if (nums.g.pp[i * 5 + k] == gmrosterjersey[pick * 22]) nums.g.pp[i * 5 + k] = 100;
                            k = (hit - 0x12) % 5;
                            nums.g.pp[k + i * 5] = gmrosterjersey[pick * 22];
                            for (k = 0; k < 5; k++) {
                                MakeJerseyShape(jerseyremap, nums.g.pp[i * 5 + k], c1, c2);
                                sub_B4DD4(jerseyremap);
                                sub_931FC(art, dword_D13C8[(i * 5 + k) * 2], dword_D13CC[(i * 5 + k) * 2]);
                            }
                        }
                    } else if (hit < 0x24) {
                        if (gmroster[pick * 22] != 'G') {
                            i = (hit - 0x1C) / 4;
                            for (k = 0; k < 4; k++)
                                if (nums.g.pk[i * 4 + k] == gmrosterjersey[pick * 22]) nums.g.pk[i * 4 + k] = 100;
                            k = (hit - 0x1C) % 4;
                            nums.g.pk[k + i * 4] = gmrosterjersey[pick * 22];
                            for (k = 0; k < 4; k++) {
                                MakeJerseyShape(jerseyremap, nums.g.pk[i * 4 + k], c1, c2);
                                sub_B4DD4(jerseyremap);
                                sub_931FC(art, dword_D1418[(i * 4 + k) * 2], dword_D141C[(i * 4 + k) * 2]);
                            }
                        }
                    } else if (hit < 0x26) {
                        if (gmroster[pick * 22] == 'G') {
                            for (k = 0; k < 2; k++)
                                if (nums.g.gl[k] == gmrosterjersey[pick * 22]) nums.g.gl[k] = 100;
                            nums.g.gl[hit - 0x24] = gmrosterjersey[pick * 22];
                            for (k = 0; k < 2; k++) {
                                MakeJerseyShape(jerseyremap, nums.g.gl[k], c1, c2);
                                sub_B4DD4(jerseyremap);
                                sub_931FC(art, dword_D1458[k * 2], dword_D145C[k * 2]);
                            }
                        }
                    } else {
                        if (gmroster[pick * 22] != 'G') {
                            for (k = 0; k < 2; k++)
                                if (nums.g.ex[k] == gmrosterjersey[pick * 22]) nums.g.ex[k] = 100;
                            nums.g.ex[hit - 0x26] = gmrosterjersey[pick * 22];
                            for (k = 0; k < 2; k++) {
                                MakeJerseyShape(jerseyremap, nums.g.ex[k], c1, c2);
                                sub_B4DD4(jerseyremap);
                                sub_931FC(art, dword_D1468[k * 2], dword_D146C[k * 2]);
                            }
                        }
                    }
                    menuact_savelines = (int)MenuSaveTheseLines;
                    menuact_uselines = (int)MenuUseTheseLines;
                    menuact_uselines2 = (int)MenuUseTheseLines;
                    menuact_savedeflines = (int)MenuSaveDefaultLines;
                    menuact_savedeflines2 = (int)MenuSaveDefaultLines;
                    for (i = 0; i < 0x28; i++) {
                        if (nums.slot[i] == 100) {
                            menuact_savelines = 0;
                            menuact_uselines = 0;
                            menuact_uselines2 = 0;
                            menuact_savedeflines = 0;
                            menuact_savedeflines2 = 0;
                            break;
                        }
                    }
                } else if (hit >= 100) {
                    /* a roster row: pick a dressed player (scratched ones too before the game) */
                    hit -= 100;
                    if (GSTAT(hit) && (GSTAT(hit) == 4 || GSTAT(hit) == 3 || (GSTAT(hit) == 2 && curperiod < 0))) {
                        if (pick != -1) {
                            if (GSTAT(pick) == 2) sub_8E9C0(0xFC, 0xC1);
                            else sub_8E9C0(0xC3, 0xC1);
                            sprintf(buf, (char *)str_C2dS3, gmroster[pick * 22], gmrosterjersey[pick * 22],
                                gmroster + pick * 22 + 3);
                            PrintLineEdStatus(0x1FA, pick * 13 + 0x16, buf);
                        }
                        pick = hit;
                        menuact_gamedress = (int)GameDressPlayer;
                        menuact_gamescratch = (int)GameScratchPlayer;
                        if (GSTAT(hit) == 2) sub_8E9C0(0xFD, 0xC1);
                        else sub_8E9C0(0xC0, 0xC1);
                        sprintf(buf, (char *)str_C2dS3, gmroster[pick * 22], gmrosterjersey[pick * 22],
                            gmroster + pick * 22 + 3);
                        PrintLineEdStatus(0x1FA, pick * 13 + 0x16, buf);
                    }
                }
            }
        }
        sub_91400(ptr, mx < 0x1C ? 0 : mx - 0x1C, my < 0x20 ? 0 : my - 0x20);
        if (my > menus[0]->y2 && mx < 500 && pick != -1
            && (!menus[1] || !MenuHitTest(mx, my, menus, depth, nitems, &pos[0][0], &level, &item))
            && GSTAT(pick) != 2) {
            MakeJerseyShape(jerseyremap, gmrosterjersey[pick * 22], c1, c2);
            sub_B4DD4(jerseyremap);
            sub_91FE0(art, mx - 0x1C, my - 0x20);
        }
        sub_91FE0(pointerspr, mx - 3, my);
        oldmx = mx;
        oldmy = my;
    }
}
