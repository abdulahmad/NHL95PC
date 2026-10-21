/* Settings locker room: draw the locker room screen. */
/* DRAFT: first pass; see docs/UNSURE.md. It ends in LockerStub, so its match belongs in LockerRoomScreen.c (a file
   whose only marked block is its own function, so the draft stays here). */
#define sub_912C8 sub_912C8_decl
#define sub_8F98F sub_8F98F_decl
#include "nhl95.h"
#undef sub_912C8
#undef sub_8F98F

void __cdecl sub_912C8(int art);  /* graphics library: set the palette from an art block */
int sub_8F98F(char *path);  /* sound library: load a song */

#define LR ((Rect4 *)lockerrects)

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
    x = LR[3].r + LR[3].l >> 1;
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
    x = LR[4].r + LR[4].l >> 1;
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
    x = LR[5].r + LR[5].l >> 1;
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
