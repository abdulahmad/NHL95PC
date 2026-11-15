/* Settings: locker room screen; DrawLockerRoom follows it (it ends in LockerStub, this file's epilogue),
   and LockerRoomLoop ends there too. */
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
    SetPalette(0, 0x100, buf);
    FadePalStep(1, buf, 0x10);
    if (musicon && songdata) {
        int slot;

        do
            slot = musicslot;
        while (SndQuery(slot, 3) == 0);
        sub_8D2F0(songdata);
        songdata = 0;
    }
    ShowLoadingScreen();
    TextSaveState(buf + 0x300);
    homebckspr = AllocMemBlock((char *)str_HomeBck, 0x1B811, 0x20);
    visbckspr = AllocMemBlock((char *)str_VisBck, 0x1A6F9, 0x20);
    *(Hdr17 *)homebckspr = *(Hdr17 *)pointerspr;
    *(Hdr17 *)visbckspr = *(Hdr17 *)pointerspr;
    ((short *)homebckspr)[2] = 0x140;
    ((short *)visbckspr)[2] = 0x138;
    ((short *)homebckspr)[3] = 0x160;
    ((short *)visbckspr)[3] = 0x15B;
    homenamebckspr = AllocMemBlock((char *)str_HomeNameBck, 0xA07, 0x20);
    visnamebckspr = AllocMemBlock((char *)str_VisNameBck, 0xA07, 0x20);
    *(Hdr17 *)homenamebckspr = *(Hdr17 *)pointerspr;
    *(Hdr17 *)visnamebckspr = *(Hdr17 *)pointerspr;
    ((short *)homenamebckspr)[2] = 0xAA;
    ((short *)visnamebckspr)[2] = 0xAA;
    ((short *)homenamebckspr)[3] = 0xF;
    ((short *)visnamebckspr)[3] = 0xF;
    titlebckspr = AllocMemBlock((char *)str_TitleBck, 0x35C7, 0x20);
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
    TextRestoreState(buf + 0x300);
    if (gamemode == 0)
        r = 2;
    else
        r = picked;
    return r;
}

/* DrawLockerRoom (80AA4, PC only; ends in LockerStub): draw the locker room. Load LOCKROOM (from the CD when
   listed): its palette entries 0-167h brightened (+5, at most 3Fh, the rest as they are), the palette cycle faded
   out, the ROOM art; the frame panels (DrawPanel3D) and the background plates saved (GrabBlock). Both teams'
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
    bank = LoadBank(path, 0);
    src = (signed char *)FindShape(bank, (char *)str_P01) + 0x10;
    for (i = 0; i < 0x180; i++) {
        if (i < 0x168) {
            if (src[i] < 0x3B) pal[i] = src[i] + 5;
            else pal[i] = 0x3F;
        } else {
            pal[i] = src[i];
        }
    }
    FadeOutPalCycle();
    sub_912C8(FindShape(bank, (char *)str_Room));
    FreeMemBlock(bank);
    DrawPanel3D(0, 0x1A7, 0x27F, 0x1E0, 1);
    for (i = 2; i < 8; i++) DrawPanel3D(LR[i].l, LR[i].t, LR[i].r, LR[i].b, 0);
    GrabBlock(titlebckspr, 0x2D, 0x11);
    GrabBlock(homebckspr, 0xA, 0x45);
    GrabBlock(visbckspr, 0x146, 0x4A);
    GrabBlock(homenamebckspr, 0x85, 0x2C);
    GrabBlock(visnamebckspr, 0x152, 0x2C);
    sprintf(name, (char *)str_JERSH, jerseyabbrevs[lockerindex[HomeTeam]]);
    i = HomeTeam * 2 + 0xA3;
    MakePath(path, fileoncd[i] == 1 ? (char *)cddriveptr : 0, name, 0);
    bank = LoadBank(path, 0);
    src = (signed char *)FindShape(bank, (char *)str_P01) + 0x10;
    for (i = 0x240; i < 0x300; i++) {
        if (src[i] < 0x3B) pal[i] = src[i] + 5;
        else pal[i] = 0x3F;
    }
    sub_912C8(FindShape(bank, (char *)str_00002));
    FreeMemBlock(bank);
    sprintf(name, (char *)str_JERSV, jerseyabbrevs[lockerindex[VisTeam]]);
    i = VisTeam * 2 + 0xA4;
    MakePath(path, fileoncd[i] == 1 ? (char *)cddriveptr : 0, name, 0);
    bank = LoadBank(path, 0);
    src = (signed char *)FindShape(bank, (char *)str_P01) + 0x10;
    for (i = 0x180; i < 0x240; i++) {
        if (src[i] < 0x3B) pal[i] = src[i] + 5;
        else pal[i] = 0x3F;
    }
    sub_912C8(FindShape(bank, (char *)str_00002));
    FreeMemBlock(bank);
    SetTextColors(0x77, 0x62);
    for (i = 2; i < 6; i++) FillRect(LR[i].l + 1, LR[i].t + 1, LR[i].r - LR[i].l - 1, LR[i].b - LR[i].t - 1, 0x70);
    TextSetFont(mainfont);
    TextSetColors(0x77, 0xFF);
    if (gamemode == 0) {
        i = (lockerindex[HomeTeam] + 0x1B) % 0x1C;
        if (i >= 0x1A && i == lockerindex[VisTeam]) i = (i + 0x1B) % 0x1C;
    } else {
        i = (lockerindex[HomeTeam] + 0x19) % 0x1A;
        if (i == lockerindex[VisTeam]) i = (i + 0x19) % 0x1A;
    }
    s = (char *)jerseyabbrevs[i];
    y = LR[2].t + 3;
    x = LR[2].l + LR[2].r >> 1;
    PrintShadowText(x - (fputchar(s) >> 1) + 2, y, s);
    if (gamemode == 0) {
        i = (lockerindex[HomeTeam] + 1) % 0x1C;
        if (i >= 0x1A && i == lockerindex[VisTeam]) i = (i + 1) % 0x1C;
    } else {
        i = (lockerindex[HomeTeam] + 1) % 0x1A;
        if (i == lockerindex[VisTeam]) i = (HomeTeam + 1) % 0x1A;
    }
    s = (char *)jerseyabbrevs[i];
    y = LR[3].t + 3;
    x = LR[3].l + LR[3].r >> 1;
    PrintShadowText(x - (fputchar(s) >> 1) + 2, y, s);
    if (gamemode == 0) {
        i = (lockerindex[VisTeam] + 0x1B) % 0x1C;
        if (i >= 0x1A && i == lockerindex[HomeTeam]) i = (i + 0x1B) % 0x1C;
    } else {
        i = (lockerindex[VisTeam] + 0x19) % 0x1A;
        if (i == lockerindex[HomeTeam]) i = (i + 0x19) % 0x1A;
    }
    s = (char *)jerseyabbrevs[i];
    y = LR[4].t + 3;
    x = LR[4].l + LR[4].r >> 1;
    PrintShadowText(x - (fputchar(s) >> 1) + 2, y, s);
    if (gamemode == 0) {
        i = (lockerindex[VisTeam] + 1) % 0x1C;
        if (i >= 0x1A && i == lockerindex[HomeTeam]) i = (i + 1) % 0x1C;
    } else {
        i = (lockerindex[VisTeam] + 1) % 0x1A;
        if (i == lockerindex[HomeTeam]) i = (i + 1) % 0x1A;
    }
    s = (char *)jerseyabbrevs[i];
    y = LR[5].t + 3;
    x = LR[5].l + LR[5].r >> 1;
    PrintShadowText(x - (fputchar(s) >> 1) + 2, y, s);
    i = 0x12D - fputchar((char *)teamcitynames[HomeTeam]);
    PrintOutlinedText(i, 0x2C, (char *)teamcitynames[HomeTeam]);
    PrintOutlinedText(0x13A, 0x2C, (char *)str_Vs);
    PrintOutlinedText(0x154, 0x2C, (char *)teamcitynames[VisTeam]);
    PrintShadowText(lockeracceptx + 0x12, lockeraccepty + 3, (char *)str_Accept);
    PrintShadowText(lockercancelx + 0x12, lockercancely + 3, (char *)str_Cancel2);
    cy = LR[2].b + 5;
    cx = LR[2].l + LR[3].r >> 1;
    PrintShadowText(cx - (fputchar((char *)str_HomeTeam) >> 1) + 2, cy, (char *)str_HomeTeam);
    cy = LR[4].b + 5;
    cx = LR[4].l + LR[5].r >> 1;
    PrintShadowText(cx - (fputchar((char *)str_VisitingTeam) >> 1) + 2, cy, (char *)str_VisitingTeam);
    TextSetFont(kaufmfont);
    if (gamemode == 1) {
        i = teamdivflags[VisTeam] | teamdivflags[HomeTeam];
        s = (char *)poroundnames[poroundnameidx[i]];
        PrintOutlinedText((0x280 - fputchar(s)) / 2, 0x12, s);
    } else {
        PrintOutlinedText((0x280 - fputchar((char *)str_ExhibitionGame)) / 2, 0x12, (char *)str_ExhibitionGame);
    }
    TextSetFont(mainfont);
    if (musicon && !songdata) {
        MakePath(path, fileoncd[0x1DD] == 1 ? (char *)cddriveptr : 0, (char *)str_Jersey, (char *)str_Iff11);
        songdata = sub_8F98F(path);
        if (songdata && gameopts.music) sub_8FB8E(songdata, musichandle, 3, 0x4C);
    }
    FadePalStep(0, (unsigned char *)pal, 0x10);
    for (i = 0; i < 0x100; i++) homeremap[i] = i;
    homeremap_e10 = 0x2C;
    homeremap_e11 = 1;
    homeremap_e07 = 0x2F;
    homeremap_e13 = 0x32;
    homeremap_e14 = 0x3A;
    homeremap_e51 = 0x6D;
    homeremap_e50 = 0x6E;
    homeremap_e49 = 0x19;
    homeremap_e16 = 0x51;
    homeremap_e60 = 0x18;
    homeremap_e05 = 0x7F;
    homeremap_eFB = 0x7C;
    homeremap_eFC = 0x7D;
    homeremap_eFD = 0x7E;
    (&homeremap_eFD)[1] = 0x7F;
    SetColorRemap(homeremap);
}

/* LockerRoomLoop (81C4E, PC only; ends in LockerStub): the locker room. Start from the home and visiting teams'
   locker indexes (lockerindex), draw the mouse pointer (sub_91FE0) over a saved POINTER block and follow it.
   A click (event bit 2) on a box (LockerHitTest): 0 / 3 and 2 step the home team forward and back, 1 / 5 and 4
   the visitors (28 teams in exhibition mode, where the two extra teams may not meet themselves, else 26 and the
   teams must differ); each step redraws that side's jersey (DrawLockerJersey with both teams' division flags)
   and puts the mouse back. 6 (OK) sets HomeTeam / VisTeam (lockerteams), in exhibition mode writes both
   abbreviations into the matchup string, points the controllers at their sides' teams and writes the mode state;
   7 (Cancel) and event bit 4 leave without that. Leaving fades the music and the palette, frees the block and
   waits for the song to stop. Result: 0 after OK, else 3.
   Matched (10.0 GA): the controller teams as if / else with a store each (the EXE converts each side's short
   in its own arm and cross-jumps the shared `sar` / store; the plain ternary converts once after the join) and
   hm, vis declared first (that order gives case 4's team index the EXE's tie order, ebx). The home steps'
   second try is written with hm (hm == vis there, and Watcom uses vis's register for it); with vis, Watcom
   hoists (vis + 1Bh) % 1Ch and (vis + 19h) % 1Ah, which the visitor steps share, above the jump table. */
int LockerRoomLoop(void)
{
    int hm;
    int vis;
    char *p;
    int bm;
    int ox;
    int oy;
    int x;
    int y;
    int btn;
    int hit;
    unsigned char buf[0x300];
    int n;
    unsigned char *ev;

    hm = lockerindex[HomeTeam];
    vis = lockerindex[VisTeam];
    MouseRead(&btn, &ox, &oy);
    x = ox;
    y = oy;
    sub_B4BA8();
    n = (((short *)pointerspr)[2] + 1) * (((short *)pointerspr)[3] + 1) + 0x11;
    bm = AllocMemBlock((char *)str_Pointer20, n, 0x20);
    *(Hdr17 *)bm = *(Hdr17 *)pointerspr;
    ((short *)bm)[2] = ((short *)pointerspr)[2] + 1;
    ((short *)bm)[3] = ((short *)pointerspr)[3] + 1;
    GrabBlock(bm, x - 4, y);
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
                PutBlock(bm, ox - 4, oy);
                GrabBlock(bm, x - 4, y);
                sub_91FE0(pointerspr, x - 4, y);
                ox = x;
                oy = y;
            }
        } else if (btn & 2) {
            PutBlock(bm, ox - 4, oy);
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
                    DrawLockerJersey(0, hm, teamdivflags[lockerteams[vis]] | teamdivflags[lockerteams[hm]], hm, vis);
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
                    DrawLockerJersey(0, hm, teamdivflags[lockerteams[vis]] | teamdivflags[lockerteams[hm]], hm, vis);
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
                    DrawLockerJersey(1, vis, teamdivflags[lockerteams[vis]] | teamdivflags[lockerteams[hm]], hm, vis);
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
                    DrawLockerJersey(1, vis, teamdivflags[lockerteams[vis]] | teamdivflags[lockerteams[hm]], hm, vis);
                    ClearInputQueue();
                    MouseSetPos(x, y);
                    break;
                case 6:
                    HomeTeam = lockerteams[hm];
                    VisTeam = lockerteams[vis];
                    if (gamemode == 0) {
                        p = (char *)jerseyabbrevs[hm];
                        if (p[2] != 0) {
                            strncpy((char *)str_LAAtMTL + 7, p, 3);
                        } else {
                            strncpy((char *)str_LAAtMTL + 7, p, 2);
                            str_LAAtMTL[9] = ' ';
                        }
                        p = (char *)jerseyabbrevs[vis];
                        if (p[2] != 0) {
                            strncpy((char *)str_LAAtMTL, p, 3);
                        } else {
                            strncpy((char *)str_LAAtMTL, p, 2);
                            str_LAAtMTL[2] = ' ';
                        }
                    }
                    if (ctl1team[0] >= 0) {
                        if (ctl1side[0] == 0) ctl1team[0] = HomeTeam;
                        else ctl1team[0] = VisTeam;
                    }
                    if (ctl2team >= 0) {
                        if (ctl2side == 0) ctl2team = HomeTeam;
                        else ctl2team = VisTeam;
                    }
                    WriteCurModeState();
                    if (musicon && songdata) sub_8FCDF(musichandle, 3, 0x64);
                    SetPalette(0, 0x100, buf);
                    FadePalStep(1, buf, 0x10);
                    FreeMemBlock(bm);
                    if (musicon && songdata) {
                        while (!SndQuery(musicslot, 3));
                        sub_8D2F0(songdata);
                        songdata = 0;
                    }
                    return 0;
                case 7:
                    if (musicon && songdata) sub_8FCDF(musichandle, 3, 0x64);
                    SetPalette(0, 0x100, buf);
                    FadePalStep(1, buf, 0x10);
                    FreeMemBlock(bm);
                    if (musicon && songdata) {
                        while (!SndQuery(musicslot, 3));
                        sub_8D2F0(songdata);
                        songdata = 0;
                    }
                    return 3;
                }
            }
            GrabBlock(bm, x - 4, y);
            sub_91FE0(pointerspr, x - 4, y);
            ox = x;
            oy = y;
        } else {
            if (musicon && songdata) sub_8FCDF(musichandle, 3, 0x64);
            SetPalette(0, 0x100, buf);
            FadePalStep(1, buf, 0x10);
            FreeMemBlock(bm);
            if (musicon && songdata) {
                while (!SndQuery(musicslot, 3));
                sub_8D2F0(songdata);
                songdata = 0;
            }
            return 3;
        }
    }
}
