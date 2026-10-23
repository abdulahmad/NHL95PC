/* Settings: locker room screen; DrawLockerRoom follows it (it ends in LockerStub, this file's epilogue),
   and LockerRoomLoop (draft) ends there too. */
#define LockerRoomScreen LockerRoomScreen_decl
#define LockerRoomLoop LockerRoomLoop_decl
#define sub_912C8 sub_912C8_decl
#define sub_8F98F sub_8F98F_decl
#include "nhl95.h"
#undef LockerRoomScreen
#undef LockerRoomLoop
#undef sub_912C8
#undef sub_8F98F

typedef struct { char c[17]; } Hdr17;

int LockerRoomLoop(void);
void __cdecl sub_912C8(int art);  /* graphics library: set the palette from an art block */
int sub_8F98F(char *path);  /* sound library: load a song */

#define LR ((Rect4 *)lockerrects)

/* LockerRoomScreen: fade the music and the palette, save the text state, load the locker-room
 backdrops, draw the room and run it. Exhibition (gamemode 0) returns 2; any other mode returns
 the loop result. */
int LockerRoomScreen(void)
{
    unsigned char buf[0x340];
    int picked;
    int r;

    if (musicon && songdata)
        sub_8FCDF(musichandle, 3, 0x64);
    sub_8FFB0(0, 0x100, buf);
    FadePalStep(1, buf, 0x10);
    if (musicon && songdata) {
        int slot;

        do
            slot = musicslot;
        while (sub_8FC8A(slot, 3) == 0);
        sub_8D2F0(songdata);
        songdata = 0;
    }
    ShowLoadingScreen();
    sub_8E9E8(buf + 0x300);
    homebckspr = sub_8CCA8((char *)str_HomeBck, 0x1B811, 0x20);
    visbckspr = sub_8CCA8((char *)str_VisBck, 0x1A6F9, 0x20);
    *(Hdr17 *)homebckspr = *(Hdr17 *)pointerspr;
    *(Hdr17 *)visbckspr = *(Hdr17 *)pointerspr;
    ((short *)homebckspr)[2] = 0x140;
    ((short *)visbckspr)[2] = 0x138;
    ((short *)homebckspr)[3] = 0x160;
    ((short *)visbckspr)[3] = 0x15B;
    homenamebckspr = sub_8CCA8((char *)str_HomeNameBck, 0xA07, 0x20);
    visnamebckspr = sub_8CCA8((char *)str_VisNameBck, 0xA07, 0x20);
    *(Hdr17 *)homenamebckspr = *(Hdr17 *)pointerspr;
    *(Hdr17 *)visnamebckspr = *(Hdr17 *)pointerspr;
    ((short *)homenamebckspr)[2] = 0xAA;
    ((short *)visnamebckspr)[2] = 0xAA;
    ((short *)homenamebckspr)[3] = 0xF;
    ((short *)visnamebckspr)[3] = 0xF;
    titlebckspr = sub_8CCA8((char *)str_TitleBck, 0x35C7, 0x20);
    *(Hdr17 *)titlebckspr = *(Hdr17 *)pointerspr;
    ((short *)titlebckspr)[2] = 0x226;
    ((short *)titlebckspr)[3] = 0x19;
    DrawLockerRoom();
    picked = LockerRoomLoop();
    FreeMemBlock(titlebckspr);
    FreeMemBlock(homenamebckspr);
    FreeMemBlock(visnamebckspr);
    FreeMemBlock(homebckspr);
    FreeMemBlock(visbckspr);
    sub_8EA00(buf + 0x300);
    if (gamemode == 0)
        r = 2;
    else
        r = picked;
    return r;
}

/* DrawLockerRoom (80AA4, PC only; ends in LockerStub): draw the locker room. Load LOCKROOM (from the CD when
   listed): its palette entries 0-167h brightened (+5, at most 3Fh, the rest as they are), the palette cycle faded
   out, the ROOM art; the frame panels (DrawPanel3D) and the background plates saved (sub_91400). Both teams'
   jersey banks (JERSH / JERSV + the team file name; palette entries 240h-2FFh home, 180h-23Fh visitors,
   brightened) and their art (00002). The four neighbour plates are cleared and labelled with the teams before and
   after each side (28 teams in exhibition, where an all-star team equal to the other side is skipped; else 26),
   the city names with "vs", the Accept / Cancel buttons, the "Home Team" / "Visiting Team" captions and the title
   (the division flags of a league game, else "Exhibition Game") in the Kaufman font. Start the jersey song (music
   on, none playing, and gameopts bit 6 to play it), fade the palette in and set the colour remap (identity with
   fifteen changed entries). No arguments, no result. */
void DrawLockerRoom(void)
{
    signed char pal[0x300];
    char path[0x40];
    char name[0x10];
    int i;
    int bank;
    signed char *src;
    char *s;
    int x;
    int y;
    int cx;
    int cy;

    sub_B4BA8();
    MakePath(path, fileoncd[0xE9] == 1 ? (char *)cddriveptr : 0, (char *)str_Lockroom, 0);
    bank = sub_8E83C(path, 0);
    src = (signed char *)sub_B30B4(bank, (char *)str_P01) + 0x10;
    for (i = 0; i < 0x180; i++) {
        if (i < 0x168) {
            if (src[i] < 0x3B) pal[i] = src[i] + 5;
            else pal[i] = 0x3F;
        } else {
            pal[i] = src[i];
        }
    }
    FadeOutPalCycle();
    sub_912C8(sub_B30B4(bank, (char *)str_Room));
    FreeMemBlock(bank);
    DrawPanel3D(0, 0x1A7, 0x27F, 0x1E0, 1);
    for (i = 2; i < 8; i++) DrawPanel3D(LR[i].l, LR[i].t, LR[i].r, LR[i].b, 0);
    sub_91400(titlebckspr, 0x2D, 0x11);
    sub_91400(homebckspr, 0xA, 0x45);
    sub_91400(visbckspr, 0x146, 0x4A);
    sub_91400(homenamebckspr, 0x85, 0x2C);
    sub_91400(visnamebckspr, 0x152, 0x2C);
    sprintf(name, (char *)str_JERSH, off_D21C0[dword_D20E0[HomeTeam]]);
    i = HomeTeam * 2 + 0xA3;
    MakePath(path, fileoncd[i] == 1 ? (char *)cddriveptr : 0, name, 0);
    bank = sub_8E83C(path, 0);
    src = (signed char *)sub_B30B4(bank, (char *)str_P01) + 0x10;
    for (i = 0x240; i < 0x300; i++) {
        if (src[i] < 0x3B) pal[i] = src[i] + 5;
        else pal[i] = 0x3F;
    }
    sub_912C8(sub_B30B4(bank, (char *)str_00002));
    FreeMemBlock(bank);
    sprintf(name, (char *)str_JERSV, off_D21C0[dword_D20E0[VisTeam]]);
    i = VisTeam * 2 + 0xA4;
    MakePath(path, fileoncd[i] == 1 ? (char *)cddriveptr : 0, name, 0);
    bank = sub_8E83C(path, 0);
    src = (signed char *)sub_B30B4(bank, (char *)str_P01) + 0x10;
    for (i = 0x180; i < 0x240; i++) {
        if (src[i] < 0x3B) pal[i] = src[i] + 5;
        else pal[i] = 0x3F;
    }
    sub_912C8(sub_B30B4(bank, (char *)str_00002));
    FreeMemBlock(bank);
    SetTextColors(0x77, 0x62);
    for (i = 2; i < 6; i++) sub_90D20(LR[i].l + 1, LR[i].t + 1, LR[i].r - LR[i].l - 1, LR[i].b - LR[i].t - 1, 0x70);
    sub_8EA18(mainfont);
    sub_8E9C0(0x77, 0xFF);
    if (gamemode == 0) {
        i = (dword_D20E0[HomeTeam] + 0x1B) % 0x1C;
        if (i >= 0x1A && i == dword_D20E0[VisTeam]) i = (i + 0x1B) % 0x1C;
    } else {
        i = (dword_D20E0[HomeTeam] + 0x19) % 0x1A;
        if (i == dword_D20E0[VisTeam]) i = (i + 0x19) % 0x1A;
    }
    s = (char *)off_D21C0[i];
    y = LR[2].t + 3;
    x = LR[2].l + LR[2].r >> 1;
    PrintShadowText(x - (fputchar(s) >> 1) + 2, y, s);
    if (gamemode == 0) {
        i = (dword_D20E0[HomeTeam] + 1) % 0x1C;
        if (i >= 0x1A && i == dword_D20E0[VisTeam]) i = (i + 1) % 0x1C;
    } else {
        i = (dword_D20E0[HomeTeam] + 1) % 0x1A;
        if (i == dword_D20E0[VisTeam]) i = (HomeTeam + 1) % 0x1A;
    }
    s = (char *)off_D21C0[i];
    y = LR[3].t + 3;
    x = LR[3].l + LR[3].r >> 1;
    PrintShadowText(x - (fputchar(s) >> 1) + 2, y, s);
    if (gamemode == 0) {
        i = (dword_D20E0[VisTeam] + 0x1B) % 0x1C;
        if (i >= 0x1A && i == dword_D20E0[HomeTeam]) i = (i + 0x1B) % 0x1C;
    } else {
        i = (dword_D20E0[VisTeam] + 0x19) % 0x1A;
        if (i == dword_D20E0[HomeTeam]) i = (i + 0x19) % 0x1A;
    }
    s = (char *)off_D21C0[i];
    y = LR[4].t + 3;
    x = LR[4].l + LR[4].r >> 1;
    PrintShadowText(x - (fputchar(s) >> 1) + 2, y, s);
    if (gamemode == 0) {
        i = (dword_D20E0[VisTeam] + 1) % 0x1C;
        if (i >= 0x1A && i == dword_D20E0[HomeTeam]) i = (i + 1) % 0x1C;
    } else {
        i = (dword_D20E0[VisTeam] + 1) % 0x1A;
        if (i == dword_D20E0[HomeTeam]) i = (i + 1) % 0x1A;
    }
    s = (char *)off_D21C0[i];
    y = LR[5].t + 3;
    x = LR[5].l + LR[5].r >> 1;
    PrintShadowText(x - (fputchar(s) >> 1) + 2, y, s);
    i = 0x12D - fputchar((char *)teamcitynames[HomeTeam]);
    PrintOutlinedText(i, 0x2C, (char *)teamcitynames[HomeTeam]);
    PrintOutlinedText(0x13A, 0x2C, (char *)str_Vs);
    PrintOutlinedText(0x154, 0x2C, (char *)teamcitynames[VisTeam]);
    PrintShadowText(dword_D22DC + 0x12, dword_D22E0 + 3, (char *)str_Accept);
    PrintShadowText(dword_D22EC + 0x12, dword_D22F0 + 3, (char *)str_Cancel2);
    cy = LR[2].b + 5;
    cx = LR[2].l + LR[3].r >> 1;
    PrintShadowText(cx - (fputchar((char *)str_HomeTeam) >> 1) + 2, cy, (char *)str_HomeTeam);
    cy = LR[4].b + 5;
    cx = LR[4].l + LR[5].r >> 1;
    PrintShadowText(cx - (fputchar((char *)str_VisitingTeam) >> 1) + 2, cy, (char *)str_VisitingTeam);
    sub_8EA18(kaufmfont);
    if (gamemode == 1) {
        i = teamdivflags[VisTeam] | teamdivflags[HomeTeam];
        s = (char *)off_D2230[dword_D223C[i]];
        PrintOutlinedText((0x280 - fputchar(s)) / 2, 0x12, s);
    } else {
        PrintOutlinedText((0x280 - fputchar((char *)str_ExhibitionGame)) / 2, 0x12, (char *)str_ExhibitionGame);
    }
    sub_8EA18(mainfont);
    if (musicon && !songdata) {
        MakePath(path, fileoncd[0x1DD] == 1 ? (char *)cddriveptr : 0, (char *)str_Jersey, (char *)str_Iff11);
        songdata = sub_8F98F(path);
        if (songdata && gameopts.music) sub_8FB8E(songdata, musichandle, 3, 0x4C);
    }
    FadePalStep(0, (unsigned char *)pal, 0x10);
    for (i = 0; i < 0x100; i++) byte_DC9D8[i] = i;
    byte_DC9E8 = 0x2C;
    byte_DC9E9 = 1;
    byte_DC9DF = 0x2F;
    byte_DC9EB = 0x32;
    byte_DC9EC = 0x3A;
    byte_DCA29 = 0x6D;
    byte_DCA28 = 0x6E;
    byte_DCA21 = 0x19;
    byte_DC9EE = 0x51;
    byte_DCA38 = 0x18;
    byte_DC9DD = 0x7F;
    byte_DCAD3 = 0x7C;
    byte_DCAD4 = 0x7D;
    byte_DCAD5 = 0x7E;
    (&byte_DCAD5)[1] = 0x7F;
    sub_B4DD4(byte_DC9D8);
}

/* LockerRoomLoop (81C4E, PC only; ends in LockerStub): the locker room. Start from the home and visiting teams'
   locker indexes (dword_D20E0), draw the mouse pointer (sub_91FE0) over a saved POINTER block and follow it.
   A click (event bit 2) on a box (LockerHitTest): 0 / 3 and 2 step the home team forward and back, 1 / 5 and 4
   the visitors (28 teams in exhibition mode, where the two extra teams may not meet themselves, else 26 and the
   teams must differ); each step redraws that side's jersey (DrawLockerJersey with both teams' division flags)
   and puts the mouse back. 6 (OK) sets HomeTeam / VisTeam (dword_D2150), in exhibition mode writes both
   abbreviations into the matchup string, points the controllers at their sides' teams and writes the mode state;
   7 (Cancel) and event bit 4 leave without that. Leaving fades the music and the palette, frees the block and
   waits for the song to stop. Result: 0 after OK, else 3.
   DRAFT (10.0 GA): same size, one register left: case 4's dword_D2150[vis] goes into eax where the EXE uses ebx
   (case 0 / 3 gets ebx as in the EXE). The home steps' second try is written with hm (hm == vis there, and Watcom
   uses vis's register for it); with vis, Watcom hoists (vis + 1Bh) % 1Ch and (vis + 19h) % 1Ah, which the visitor
   steps share, above the jump table. See docs/UNSURE.md. */
int LockerRoomLoop(void)
{
    char *p;
    int vis;
    int bm;
    int ox;
    int oy;
    int x;
    int y;
    int btn;
    int hit;
    unsigned char buf[0x300];
    int hm;
    int n;
    unsigned char *ev;

    hm = dword_D20E0[HomeTeam];
    vis = dword_D20E0[VisTeam];
    sub_B2DCA(&btn, &ox, &oy);
    x = ox;
    y = oy;
    sub_B4BA8();
    n = (((short *)pointerspr)[2] + 1) * (((short *)pointerspr)[3] + 1) + 0x11;
    bm = sub_8CCA8((char *)str_Pointer20, n, 0x20);
    *(Hdr17 *)bm = *(Hdr17 *)pointerspr;
    ((short *)bm)[2] = ((short *)pointerspr)[2] + 1;
    ((short *)bm)[3] = ((short *)pointerspr)[3] + 1;
    sub_91400(bm, x - 4, y);
    sub_91FE0(pointerspr, x - 4, y);
    ClearInputQueue();
    for (;;) {
        btn = 0;
        for (;;) {
            ev = GetInputEvent();
            if (ev == 0) break;
            btn = ((int (*)(unsigned char *, int *, int *))ptrupdatefn)(ev, &x, &y);
            if (btn & 6) break;
        }
        if (!(btn & 2) && !(btn & 4)) {
            if (x != ox || y != oy) {
                sub_903F0(bm, ox - 4, oy);
                sub_91400(bm, x - 4, y);
                sub_91FE0(pointerspr, x - 4, y);
                ox = x;
                oy = y;
            }
        } else if (btn & 2) {
            sub_903F0(bm, ox - 4, oy);
            if (LockerHitTest(x, y, &hit)) {
                switch (hit) {
                case 2:
                    if (gamemode == 0) {
                        hm = (hm + 0x1B) % 0x1C;
                        if (hm >= 0x1A && hm == vis) hm = (hm + 0x1B) % 0x1C;
                    } else {
                        hm = (hm + 0x19) % 0x1A;
                        if (hm == vis) hm = (hm + 0x19) % 0x1A;
                    }
                    DrawLockerJersey(0, hm, teamdivflags[dword_D2150[vis]] | teamdivflags[dword_D2150[hm]], hm, vis);
                    ClearInputQueue();
                    MouseSetPos(x, y);
                    break;
                case 0:
                case 3:
                    if (gamemode == 0) {
                        hm = (hm + 1) % 0x1C;
                        if (hm >= 0x1A && hm == vis) hm = (hm + 1) % 0x1C;
                    } else {
                        hm = (hm + 1) % 0x1A;
                        if (hm == vis) hm = (hm + 1) % 0x1A;
                    }
                    DrawLockerJersey(0, hm, teamdivflags[dword_D2150[vis]] | teamdivflags[dword_D2150[hm]], hm, vis);
                    ClearInputQueue();
                    MouseSetPos(x, y);
                    break;
                case 4:
                    if (gamemode == 0) {
                        vis = (vis + 0x1B) % 0x1C;
                        if (vis >= 0x1A && hm == vis) vis = (vis + 0x1B) % 0x1C;
                    } else {
                        vis = (vis + 0x19) % 0x1A;
                        if (hm == vis) vis = (vis + 0x19) % 0x1A;
                    }
                    DrawLockerJersey(1, vis, teamdivflags[dword_D2150[vis]] | teamdivflags[dword_D2150[hm]], hm, vis);
                    ClearInputQueue();
                    MouseSetPos(x, y);
                    break;
                case 1:
                case 5:
                    if (gamemode == 0) {
                        vis = (vis + 1) % 0x1C;
                        if (vis >= 0x1A && hm == vis) vis = (vis + 1) % 0x1C;
                    } else {
                        vis = (vis + 1) % 0x1A;
                        if (hm == vis) vis = (vis + 1) % 0x1A;
                    }
                    DrawLockerJersey(1, vis, teamdivflags[dword_D2150[vis]] | teamdivflags[dword_D2150[hm]], hm, vis);
                    ClearInputQueue();
                    MouseSetPos(x, y);
                    break;
                case 6:
                    HomeTeam = dword_D2150[hm];
                    VisTeam = dword_D2150[vis];
                    if (gamemode == 0) {
                        p = (char *)off_D21C0[hm];
                        if (p[2] != 0) {
                            strncpy((char *)str_LAAtMTL + 7, p, 3);
                        } else {
                            strncpy((char *)str_LAAtMTL + 7, p, 2);
                            str_LAAtMTL[9] = ' ';
                        }
                        p = (char *)off_D21C0[vis];
                        if (p[2] != 0) {
                            strncpy((char *)str_LAAtMTL, p, 3);
                        } else {
                            strncpy((char *)str_LAAtMTL, p, 2);
                            str_LAAtMTL[2] = ' ';
                        }
                    }
                    if (ctl1team[0] >= 0) ctl1team[0] = ctl1side[0] == 0 ? (int)HomeTeam : (int)VisTeam;
                    if (ctl2team >= 0) ctl2team = ctl2side == 0 ? (int)HomeTeam : (int)VisTeam;
                    WriteCurModeState();
                    if (musicon && songdata) sub_8FCDF(musichandle, 3, 0x64);
                    sub_8FFB0(0, 0x100, buf);
                    FadePalStep(1, buf, 0x10);
                    FreeMemBlock(bm);
                    if (musicon && songdata) {
                        while (!sub_8FC8A(musicslot, 3));
                        sub_8D2F0(songdata);
                        songdata = 0;
                    }
                    return 0;
                case 7:
                    if (musicon && songdata) sub_8FCDF(musichandle, 3, 0x64);
                    sub_8FFB0(0, 0x100, buf);
                    FadePalStep(1, buf, 0x10);
                    FreeMemBlock(bm);
                    if (musicon && songdata) {
                        while (!sub_8FC8A(musicslot, 3));
                        sub_8D2F0(songdata);
                        songdata = 0;
                    }
                    return 3;
                }
            }
            sub_91400(bm, x - 4, y);
            sub_91FE0(pointerspr, x - 4, y);
            ox = x;
            oy = y;
        } else {
            if (musicon && songdata) sub_8FCDF(musichandle, 3, 0x64);
            sub_8FFB0(0, 0x100, buf);
            FadePalStep(1, buf, 0x10);
            FreeMemBlock(bm);
            if (musicon && songdata) {
                while (!sub_8FC8A(musicslot, 3));
                sub_8D2F0(songdata);
                songdata = 0;
            }
            return 3;
        }
    }
}
