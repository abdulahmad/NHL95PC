/* Front-end desk: the sports desk (pause, intermission and post-game menus). */
#define MenuHitTest MenuHitTest_decl
#define sub_8F98F sub_8F98F_decl
#define sub_8FB8E sub_8FB8E_decl
#define TicksSinceLastCall TicksSinceLastCall_decl
#include "nhl95.h"
#undef MenuHitTest
#undef sub_8F98F
#undef sub_8FB8E
#undef TicksSinceLastCall

typedef struct MenuItem {
    int x1, y1, x2, y2;
    char *text;
    int on1, on2;
    int pad;
} MenuItem;

typedef struct Hdr17 { char c[17]; } Hdr17;

int MenuHitTest(int x, int y, MenuItem **menus, int i, int *counts, int *origin, int *hitMenu, int *hitItem);
int sub_8F98F(char *path);  /* music library: load a song (register arguments) */
void sub_8FB8E(int song, int handle, int chan, int vol);  /* music library: play a song (register arguments) */
int __cdecl TicksSinceLastCall(void);  /* timer library: ticks since the last call */

/* DRAFT under 10.0 GA: 192 differing instructions, 4,512 of 4,567 bytes. The frame is the retail 404h:
   the menu-item offset is computed in place, and m is formed only in the submenu path after the drawing calls.
   A click on an item with an action runs it when it is the selected one and otherwise moves the selection; an
   item with a submenu opens it: two separate arms, each closing the deeper dropdowns itself, as in the EXE (the
   submenu arm's last DrawMenuItemNorm cross-jumps into the selection arm's). Zero chains store the higher
   indices first, as in the EXE, and the playoff comparisons use its >= bounds. sub_B2DCA returns the buttons
   and the pointer x and y, which MouseSetPos gets back in that order. A hit (MenuHitTest) is the if arm and a
   miss the else arm, so the miss block sits at the end of the function as in the EXE; the dropdown ternaries
   test depth != 1. The declaration order of the arrays and scalars comes from real-compile sweeps,
   tools/slot_solver.py and tools/wccre/declsearch.py (--conflicts). Left: stack slots (oldmy, autoret,
   timeout, speech, ptr), register picks, the overtime / conference argument shapes, r kept in a register (the EXE keeps
   it on the stack), and the miss arm's tail: the EXE keeps its own sub_91400 call and pushes and joins the
   no-click path only at sub_91370 (55 bytes), where C cross-jumps the whole tail. The retail speech timer
   compares the routine address. */
/* SportsDesk (1935D, PC only): the sports desk of a game (mode 0: paused in the game, 1: intermission, 2: after
   the game): the menu labels and title of the mode, the replay item only when a replay is recorded; fade in the
   EADESK<mode> art and palette, the pause music (when music is on and none plays), and the desk menu bar (six
   items, three after the game, when a playoff game also opens the playoff speech bank and announces the result:
   the winner, game number, conference, round, overtime and final, PaPlayoffResult). Then the cascading menus run
   with the mouse pointer as in MainDeskLoop: a click on an open item with an action calls it (the pointer position
   passed in dword_DC88C / dword_DC888), an item with a submenu opens it. Result 1 of an action goes back to the
   game, 5 ends it (gameresult 2), 2 redraws the desk. In the intermission with no human controller the desk goes
   back to the game by itself after 1500 ticks, and paused in a game with speech on the announcer says he is back
   in a moment after 180 ticks. Going back restores the text state, the mouse, the screen title and the music and
   reloads the game (DeskReloadGame). mode: 0, 1 or 2. No result. */
void SportsDesk(int mode)
{
    MenuItem *menus[4];
    unsigned char txt[0x40];
    char path[0x20];
    int bg[4];
    int ptrsize;
    int nitems[4];
    int btn;
    unsigned char pal[0x300];
    int savex;
    int conf;
    int timeout;
    int oldmx;
    int depth;
    int speech;
    int savey;
    int oldmy;
    int level;
    int item;
    int mx;
    int pos[4][2];
    int ptr;
    int w;
    int sel[4];
    int r;
    int my;
    int bank;
    unsigned char *src;
    int i;
    unsigned char *e;
    MenuItem *m;
    int winner;
    int ot;
    int h;
    int autoret;
    int rnd;

    depth = 0;
    autoret = 0;
    timeout = 0x5DC;
    SetModeMenuLabels(gamemode);
    SetScreenTitle(mode + 3);
    if (ReplayIsEmpty()) off_CEF23 = 0;
    else off_CEF23 = (int)DeskGoToReplay;
    sub_B2DCA(&btn, &savex, &savey);
    escrequest = 0;
    joysampling = 0;
    if (mode == 0) {
        sub_1BAF3(700000);
        sub_8FFB0(0, 0x100, pal);
        FadePalStep(1, pal, 0x10);
    }
    sub_B4BA8();
    sprintf((char *)unk_DC890, (char *)str_Eadesk1d, mode);
    MakePath(path, fileoncd[0x64 + mode] == 1 ? (char *)cddriveptr : 0, (char *)unk_DC890, 0);
    bank = sub_8E83C(path, 0);
    sub_9061C(sub_B30B4(bank, (char *)str_Desk));
    src = (unsigned char *)sub_B30B4(bank, (char *)str_Pal5) + 0x10;
    for (i = 0; i < 0x300; i++) pal[i] = src[i];
    FreeMemBlock(bank);
    sub_8E9E8(txt);
    sub_8EA18(s1font);
    if (mode == 2) {
        if (schedgameidx >= 0x444) PaOpenBank();
        menus[0] = (MenuItem *)unk_CEC4F;
        nitems[0] = 3;
    } else {
        menus[0] = (MenuItem *)unk_CEB8F;
        nitems[0] = 6;
    }
    menus[1] = menus[2] = menus[3] = 0;
    bg[0] = bg[1] = bg[2] = bg[3] = 0;
    sel[0] = sel[1] = sel[2] = sel[3] = 0;
    pos[0][0] = pos[0][1] = 0;
    ptrsize = (((short *)pointerspr)[2] + 1) * (((short *)pointerspr)[3] + 1) + 0x11;
    ptr = sub_8CCA8((char *)str_Pointer2, ptrsize, 0x20);
    *(Hdr17 *)ptr = *(Hdr17 *)pointerspr;
    ((short *)ptr)[2] = ((short *)pointerspr)[2] + 1;
    ((short *)ptr)[3] = ((short *)pointerspr)[3] + 1;
    DrawMenuBar(menus[0], nitems[0], 0xFA, 0xF9, 0xF8);
    InputInstall();
    mx = oldmx = (menus[0]->x1 + menus[0]->x2) / 2;
    my = oldmy = (menus[0]->y1 + menus[0]->y2) / 2;
    sub_91400(ptr, oldmx, oldmy);
    sub_91370(pointerspr, oldmx, oldmy);
    if (musicon && !songdata) {
        MakePath(path, fileoncd[0x21C] == 1 ? (char *)cddriveptr : 0, (char *)str_Pause, (char *)str_Iff3);
        songdata = sub_8F98F(path);
        if (songdata && gameopts.music) sub_8FB8E(songdata, musichandle, 3, 0x4C);
    }
    FadePalStep(0, pal, 0x10);
    sub_B2E1B(0, 0, 0x280, 0x1E0);
    MouseSetPos(oldmx, oldmy);
    ((void (*)(void))mousepollfn)();
    ClearInputQueue();
    if (mode == 1 && ctl1team[0] < 0 && ctl2team < 0) autoret = 1;
    TicksSinceLastCall();
    if (mode == 2 && schedgameidx >= 0x444) {
        if (hmtmstruct.tmscore > awtmstruct.tmscore) winner = HomeTeam;
        else winner = VisTeam;
        ot = curperiod > 3 ? -1 : 0;
        if (teamconf[HomeTeam] != teamconf[VisTeam]) conf = 3;
        else conf = (teamconf[HomeTeam] | teamconf[VisTeam]) % 2 + 1;
        rnd = 1;
        if (schedgameidx >= 0x47C) rnd = 2;
        if (schedgameidx >= 0x498) rnd = 3;
        PaPlayoffResult(winner, (schedgameidx - 0x444) % 7 + 1, conf, rnd, ot, byte_CCCA0);
        byte_CCCA0 = 0;
    }
    speech = 0xB4;
    for (;;) {
        if (musicon) {
            /* Retail 19B0A compares the timer with the routine address. */
            if ((unsigned)speech > (unsigned)TicksSinceLastCall) speech -= TicksSinceLastCall();
            else if (speech > 0) speech = 0;
            if (speech == 0 && mode == 0 && !gameresult && gameopts.speech) {
                speech = -1;
                MusicChanReset();
                SayBackMoment();
            }
        }
        if (autoret) {
            timeout -= TicksSinceLastCall();
            if (timeout < 0) {
                if (musicon && songdata) sub_8FCDF(musichandle, 3, 100);
                dword_C66D4 = 1;
                dword_C66D0 = 1;
                ClearInputQueue();
                InputRemove();
                sub_8EA00(txt);
                sub_B2E1B(0, 0, 0x280, 0x1E0);
                deferpending = 0;
                scrolly = 0;
                scrollx = 0;
                MouseSetPos(savex, savey);
                sub_8FFB0(0, 0x100, pal);
                FadePalStep(1, pal, 0x10);
                SetScreenTitle(gamemode);
                FreeMemBlock(ptr);
                if (musicon && songdata) {
                    while (!sub_8FC8A(musicslot, 3));
                    sub_8D2F0(songdata);
                    songdata = 0;
                }
                DeskReloadGame();
                if (musicon && !gameresult && gameopts.speech) {
                    MusicChanReset();
                    FreeBackMoment();
                }
                return;
            }
        }
        btn = 0;
        while ((e = GetInputEvent()) != 0) {
            btn = ((int (*)(unsigned char *, int *, int *))ptrupdatefn)(e, &mx, &my);
            if (btn & 2) break;
        }
        if (!(btn & 2)) {
            if (mx == oldmx && my == oldmy) continue;
            autoret = 0;
            sub_903F0(ptr, oldmx, oldmy);
            sub_91400(ptr, mx, my);
            sub_91370(pointerspr, mx, my);
            oldmx = mx;
            oldmy = my;
            continue;
        }
        autoret = 0;
        if (MenuHitTest(mx, my, menus, depth, nitems, &pos[0][0], &level, &item)) {
            if ((*(int *)((char *)menus[level] + (item * sizeof(MenuItem)) + 0x14))) {
                if (item == sel[level]) {
                    sub_903F0(ptr, oldmx, oldmy);
                    for (i = depth; i > 0; i--) {
                        sel[i] = 0;
                        if (bg[i]) {
                            sub_903F0(bg[i], pos[i][0], pos[i][1]);
                            pos[i][0] = pos[i][1] = 0;
                            FreeMemBlock(bg[i]);
                        }
                    }
                    depth = 0;
                    dword_DC88C = mx;
                    dword_DC888 = my;
                    r = ((int (*)(void))(*(int *)((char *)menus[level] + (item * sizeof(MenuItem)) + 0x14)))();
                    mx = dword_DC88C;
                    my = dword_DC888;
                    menus[1] = menus[2] = menus[3] = 0;
                    bg[0] = bg[1] = bg[2] = bg[3] = 0;
                    sel[1] = sel[2] = sel[3] = 0;
                    nitems[1] = nitems[2] = nitems[3] = 0;
                    if (r == 1 || r == 5) {
                        ClearInputQueue();
                        InputRemove();
                        sub_8EA00(txt);
                        sub_B2E1B(0, 0, 0x280, 0x1E0);
                        deferpending = 0;
                        MouseSetPos(savex, savey);
                        sub_8FFB0(0, 0x100, pal);
                        if (musicon && songdata) sub_8FCDF(musichandle, 3, 100);
                        if (r == 1 && musicon && gameopts.speech) {
                            MusicChanReset();
                            SayNowBack();
                        }
                        FadePalStep(1, pal, 0x14);
                        if (r != 1) gameresult = 2;
                        SetScreenTitle(gamemode);
                        if (ptr) FreeMemBlock(ptr);
                        if (musicon && songdata) {
                            while (!sub_8FC8A(musicslot, 3));
                            sub_8D2F0(songdata);
                            songdata = 0;
                        }
                        if (r == 1) DeskReloadGame();
                        if (r == 1 && musicon && gameopts.speech) {
                            while (SpeechBusy());
                            FreeNowBack();
                        }
                        return;
                    }
                    if (r == 2) {
                        sub_8FFB0(0, 0x100, pal);
                        FadePalStep(1, pal, 0x10);
                        sub_1BAF3(700000);
                        MakePath(path, fileoncd[0x64 + mode] == 1 ? (char *)cddriveptr : 0, (char *)unk_DC890, 0);
                        bank = sub_8E83C(path, 0);
                        sub_9061C(sub_B30B4(bank, (char *)str_Desk));
                        src = (unsigned char *)sub_B30B4(bank, (char *)str_Pal5) + 0x10;
                        for (i = 0; i < 0x300; i++) pal[i] = src[i];
                        FreeMemBlock(bank);
                        DrawMenuBar(menus[0], nitems[0], 0xFA, 0xF9, 0xF8);
                        FadePalStep(0, pal, 0x10);
                    }
                    MouseSetPos(oldmx, oldmy);
                    ClearInputQueue();
                } else {
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
                    DrawMenuItemSel((struct MenuItem *)&menus[level][sel[level]], pos[level][0], pos[level][1], 0xFA, 0xF9,
                        0xF8);
                    sel[level] = item;
                    DrawMenuItemNorm((struct MenuItem *)&menus[level][item], pos[level][0], pos[level][1], 0xFA, 0xF9, 0xF8);
                }
            } else if ((*(int *)((char *)menus[level] + (item * sizeof(MenuItem)) + 0x18))) {
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
                DrawMenuItemSel((struct MenuItem *)&menus[i][sel[i]], pos[i][0], pos[i][1], 0xFA, 0xF9, 0xF8);
                sel[i] = item;
                DrawMenuItemNorm((struct MenuItem *)&menus[i][item], pos[i][0], pos[i][1], 0xFA, 0xF9, 0xF8);
                depth = i + 1;
                menus[depth] = (MenuItem *)(*(int *)((char *)menus[level] + (item * sizeof(MenuItem)) + 0x18));
                m = &menus[level][item];
                nitems[depth] = m->pad;
                pos[depth][0] = (depth != 1 ? m->x2 : m->x1) + pos[depth - 1][0];
                pos[depth][1] = (depth != 1 ? menus[level][item].y1 : menus[level][item].y2) + pos[depth - 1][1];
                i = depth;
                w = menus[i][nitems[i] - 1].x2 - menus[i][0].x1 + 1;
                h = menus[i][nitems[i] - 1].y2 - menus[i][0].y1 + 1;
                bg[i] = sub_8CCA8((char *)str_Menubuff3, w * h + 0x11, 0x20);
                *(Hdr17 *)bg[i] = *(Hdr17 *)pointerspr;
                ((short *)bg[i])[2] = w;
                ((short *)bg[i])[3] = h;
                sub_91400(bg[i], pos[i][0], pos[i][1]);
                DrawMenuDropdown(menus[i], nitems[i], pos[i][0], pos[i][1], 0xFA, 0xF9, 0xF8);
                sel[i] = 0;
                DrawMenuItemNorm((struct MenuItem *)menus[i], pos[i][0], pos[i][1], 0xFA, 0xF9, 0xF8);
            } else {
                sub_903F0(ptr, oldmx, oldmy);
            }
        } else {
            sub_903F0(ptr, oldmx, oldmy);
            for (i = depth; i > 0; i--) {
                sel[i] = 0;
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
        }
        sub_91400(ptr, mx, my);
        sub_91370(pointerspr, mx, my);
        oldmx = mx;
        oldmy = my;
    }
}
