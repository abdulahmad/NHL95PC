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

/* DRAFT (first pass from Ghidra, tools/ghidra_decomp.py; the menu loop follows MainDeskLoop's draft): 3,461 of
   4,567 bytes (3,422 now), so code is still missing. */
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
    struct {
        unsigned char pal[0x300];
        unsigned char txt[0x40];
        char path[0x18];
        int pos[4][2];
        int bg[4];
        int sel[4];
        int nitems[4];
        MenuItem *menus[4];
        int w;
        int h;
        int item;
        int level;
        int savex;
        int savey;
        int btn;
        int my;
        int mx;
        int speech;
        int oldmy;
        int timeout;
        int autoret;
        int ptr;
        int oldmx;
        int depth;
    } s;
    int i;
    int r;
    int bank;
    unsigned char *src;
    unsigned char *e;
    MenuItem *m;

    s.depth = 0;
    s.autoret = 0;
    s.timeout = 0x5DC;
    SetModeMenuLabels(gamemode);
    SetScreenTitle(mode + 3);
    off_CEF23 = ReplayIsEmpty() ? 0 : (int)DeskGoToReplay;
    sub_B2DCA(&s.btn, &s.savey, &s.savex);
    escrequest = 0;
    joysampling = 0;
    if (mode == 0) {
        sub_1BAF3(700000);
        sub_8FFB0(0, 0x100, s.pal);
        FadePalStep(1, s.pal, 0x10);
    }
    sub_B4BA8();
    sprintf((char *)unk_DC890, (char *)str_Eadesk1d, mode);
    MakePath(s.path, fileoncd[0x64 + mode] == 1 ? (char *)cddriveptr : 0, (char *)unk_DC890, 0);
    bank = sub_8E83C(s.path, 0);
    sub_9061C(sub_B30B4(bank, (char *)str_Desk));
    src = (unsigned char *)sub_B30B4(bank, (char *)str_Pal5);
    for (i = 0; i < 0x300; i++) s.pal[i] = src[0x10 + i];
    FreeMemBlock(bank);
    sub_8E9E8(s.txt);
    sub_8EA18(s1font);
    if (mode == 2) {
        if (schedgameidx > 0x443) PaOpenBank();
        s.menus[0] = (MenuItem *)unk_CEC4F;
        s.nitems[0] = 3;
    } else {
        s.menus[0] = (MenuItem *)unk_CEB8F;
        s.nitems[0] = 6;
    }
    s.menus[3] = s.menus[2] = s.menus[1] = 0;
    s.bg[3] = s.bg[2] = s.bg[1] = s.bg[0] = 0;
    s.sel[3] = s.sel[2] = s.sel[1] = s.sel[0] = 0;
    s.pos[0][1] = s.pos[0][0] = 0;
    s.ptr = sub_8CCA8((char *)str_Pointer2, (((short *)pointerspr)[2] + 1) * (((short *)pointerspr)[3] + 1) + 0x11, 0x20);
    *(Hdr17 *)s.ptr = *(Hdr17 *)pointerspr;
    ((short *)s.ptr)[2] = ((short *)pointerspr)[2] + 1;
    ((short *)s.ptr)[3] = ((short *)pointerspr)[3] + 1;
    DrawMenuBar(s.menus[0], s.nitems[0], 0xFA, 0xF9, 0xF8);
    InputInstall();
    s.mx = s.oldmx = (s.menus[0]->x1 + s.menus[0]->x2) / 2;
    s.my = s.oldmy = (s.menus[0]->y1 + s.menus[0]->y2) / 2;
    sub_91400(s.ptr, s.oldmx, s.oldmy);
    sub_91370(pointerspr, s.oldmx, s.oldmy);
    if (musicon && !songdata) {
        MakePath(s.path, fileoncd[0x21C] == 1 ? (char *)cddriveptr : 0, (char *)str_Pause, (char *)str_Iff3);
        songdata = sub_8F98F(s.path);
        if (songdata && gameopts.music) sub_8FB8E(songdata, musichandle, 3, 0x4C);
    }
    FadePalStep(0, s.pal, 0x10);
    sub_B2E1B(0, 0, 0x280, 0x1E0);
    MouseSetPos(s.oldmx, s.oldmy);
    ((void (*)(void))mousepollfn)();
    ClearInputQueue();
    if (mode == 1 && ctl1team[0] < 0 && ctl2team < 0) s.autoret = 1;
    TicksSinceLastCall();
    if (mode == 2 && schedgameidx > 0x443) {
        PaPlayoffResult(awtmstruct.tmscore < hmtmstruct.tmscore ? HomeTeam : VisTeam, (schedgameidx - 0x444) % 7 + 1,
                        teamconf[HomeTeam] == teamconf[VisTeam] ? (teamconf[HomeTeam] | teamconf[VisTeam]) % 2 + 1 : 3,
                        schedgameidx > 0x497 ? 3 : schedgameidx > 0x47B ? 2 : 1, curperiod > 3 ? -1 : 0, byte_CCCA0);
        byte_CCCA0 = 0;
    }
    s.speech = 0xB4;
    for (;;) {
        if (musicon) {
            if (s.speech > 0) {
                s.speech -= TicksSinceLastCall();
                if (s.speech < 0) s.speech = 0;
            }
            if (s.speech == 0 && mode == 0 && !gameresult && gameopts.speech) {
                s.speech = -1;
                MusicChanReset();
                SayBackMoment();
            }
        }
        if (s.autoret) {
            s.timeout -= TicksSinceLastCall();
            if (s.timeout < 0) {
                if (musicon && songdata) sub_8FCDF(musichandle, 3, 100);
                dword_C66D4 = 1;
                dword_C66D0 = 1;
                ClearInputQueue();
                InputRemove();
                sub_8EA00(s.txt);
                sub_B2E1B(0, 0, 0x280, 0x1E0);
                deferpending = 0;
                scrolly = scrollx = 0;
                MouseSetPos(s.savex, s.savey);
                sub_8FFB0(0, 0x100, s.pal);
                FadePalStep(1, s.pal, 0x10);
                SetScreenTitle(gamemode);
                FreeMemBlock(s.ptr);
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
        s.btn = 0;
        while ((e = GetInputEvent()) != 0) {
            s.btn = ((int (*)(unsigned char *, int *, int *))ptrupdatefn)(e, &s.mx, &s.my);
            if (s.btn & 2) break;
        }
        if (!(s.btn & 2)) {
            if (s.mx == s.oldmx && s.my == s.oldmy) continue;
            sub_B4BA8();
            sub_903F0(s.ptr, s.oldmx, s.oldmy);
            sub_91400(s.ptr, s.mx, s.my);
            sub_91370(pointerspr, s.mx, s.my);
            s.oldmx = s.mx;
            s.oldmy = s.my;
            continue;
        }
        s.autoret = 0;
        if (!MenuHitTest(s.mx, s.my, s.menus, s.depth, s.nitems, &s.pos[0][0], &s.level, &s.item)) {
            sub_903F0(s.ptr, s.oldmx, s.oldmy);
            for (i = s.depth; i > 0; i--) {
                s.sel[i] = 0;
                if (s.bg[i]) {
                    sub_903F0(s.bg[i], s.pos[i][0], s.pos[i][1]);
                    s.pos[i][1] = s.pos[i][0] = 0;
                    FreeMemBlock(s.bg[i]);
                }
            }
            s.depth = 0;
            s.menus[3] = s.menus[2] = s.menus[1] = 0;
            s.bg[3] = s.bg[2] = s.bg[1] = s.bg[0] = 0;
            s.sel[3] = s.sel[2] = s.sel[1] = 0;
            s.nitems[3] = s.nitems[2] = s.nitems[1] = 0;
        } else {
            m = &s.menus[s.level][s.item];
            if (m->on1 && s.item == s.sel[s.level]) {
                sub_903F0(s.ptr, s.oldmx, s.oldmy);
                for (i = s.depth; i > 0; i--) {
                    s.sel[i] = 0;
                    if (s.bg[i]) {
                        sub_903F0(s.bg[i], s.pos[i][0], s.pos[i][1]);
                        s.pos[i][1] = s.pos[i][0] = 0;
                        FreeMemBlock(s.bg[i]);
                    }
                }
                s.depth = 0;
                dword_DC88C = s.mx;
                dword_DC888 = s.my;
                r = ((int (*)(void))m->on1)();
                s.mx = dword_DC88C;
                s.my = dword_DC888;
                s.menus[3] = s.menus[2] = s.menus[1] = 0;
                s.bg[3] = s.bg[2] = s.bg[1] = s.bg[0] = 0;
                s.sel[3] = s.sel[2] = s.sel[1] = 0;
                s.nitems[3] = s.nitems[2] = s.nitems[1] = 0;
                if (r == 1 || r == 5) {
                    ClearInputQueue();
                    InputRemove();
                    sub_8EA00(s.txt);
                    sub_B2E1B(0, 0, 0x280, 0x1E0);
                    deferpending = 0;
                    MouseSetPos(s.savex, s.savey);
                    sub_8FFB0(0, 0x100, s.pal);
                    if (musicon && songdata) sub_8FCDF(musichandle, 3, 100);
                    if (r == 1 && musicon && gameopts.speech) {
                        MusicChanReset();
                        SayNowBack();
                    }
                    FadePalStep(1, s.pal, 0x14);
                    if (r != 1) gameresult = 2;
                    SetScreenTitle(gamemode);
                    if (s.ptr) FreeMemBlock(s.ptr);
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
                    sub_8FFB0(0, 0x100, s.pal);
                    FadePalStep(1, s.pal, 0x10);
                    sub_1BAF3(700000);
                    MakePath(s.path, fileoncd[0x64 + mode] == 1 ? (char *)cddriveptr : 0, (char *)unk_DC890, 0);
                    bank = sub_8E83C(s.path, 0);
                    sub_9061C(sub_B30B4(bank, (char *)str_Desk));
                    src = (unsigned char *)sub_B30B4(bank, (char *)str_Pal5);
                    for (i = 0; i < 0x300; i++) s.pal[i] = src[0x10 + i];
                    FreeMemBlock(bank);
                    DrawMenuBar(s.menus[0], s.nitems[0], 0xFA, 0xF9, 0xF8);
                    FadePalStep(0, s.pal, 0x10);
                }
                MouseSetPos(s.oldmx, s.oldmy);
                ClearInputQueue();
            } else if (m->on1 || m->on2) {
                sub_903F0(s.ptr, s.oldmx, s.oldmy);
                if (s.depth != s.level) {
                    for (i = s.depth; i > s.level; i--) {
                        s.sel[i] = 0;
                        if (s.bg[i]) {
                            sub_903F0(s.bg[i], s.pos[i][0], s.pos[i][1]);
                            s.pos[i][1] = s.pos[i][0] = 0;
                            FreeMemBlock(s.bg[i]);
                            s.bg[i] = 0;
                            s.menus[i] = 0;
                            s.nitems[i] = 0;
                        }
                    }
                    s.depth = s.level;
                }
                i = s.depth;
                DrawMenuItemSel((struct MenuItem *)&s.menus[i][s.sel[i]], s.pos[i][0], s.pos[i][1], 0xFA, 0xF9, 0xF8);
                s.sel[i] = s.item;
                DrawMenuItemNorm((struct MenuItem *)&s.menus[i][s.item], s.pos[i][0], s.pos[i][1], 0xFA, 0xF9, 0xF8);
                if (!m->on1) {
                    s.depth = i + 1;
                    s.menus[s.depth] = (MenuItem *)m->on2;
                    s.nitems[s.depth] = m->pad;
                    s.pos[s.depth][0] = (s.depth == 1 ? m->x1 : m->x2) + s.pos[s.depth - 1][0];
                    s.pos[s.depth][1] = (s.depth == 1 ? m->y2 : m->y1) + s.pos[s.depth - 1][1];
                    i = s.depth;
                    s.w = s.menus[i][s.nitems[i] - 1].x2 - s.menus[i][0].x1 + 1;
                    s.h = s.menus[i][s.nitems[i] - 1].y2 - s.menus[i][0].y1 + 1;
                    s.bg[i] = sub_8CCA8((char *)str_Menubuff3, s.w * s.h + 0x11, 0x20);
                    *(Hdr17 *)s.bg[i] = *(Hdr17 *)pointerspr;
                    ((short *)s.bg[i])[2] = s.w;
                    ((short *)s.bg[i])[3] = s.h;
                    sub_91400(s.bg[i], s.pos[i][0], s.pos[i][1]);
                    DrawMenuDropdown(s.menus[i], s.nitems[i], s.pos[i][0], s.pos[i][1], 0xFA, 0xF9, 0xF8);
                    s.sel[i] = 0;
                    DrawMenuItemNorm((struct MenuItem *)s.menus[i], s.pos[i][0], s.pos[i][1], 0xFA, 0xF9, 0xF8);
                }
            } else {
                sub_903F0(s.ptr, s.oldmx, s.oldmy);
            }
        }
        sub_91400(s.ptr, s.mx, s.my);
        sub_91370(pointerspr, s.mx, s.my);
        s.oldmx = s.mx;
        s.oldmy = s.my;
    }
}
