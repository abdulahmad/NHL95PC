/* Arena logos: tonight's game, the line-ups before a game. */
/* DRAFT: 3043 vs 3032 bytes, 140 differing lines of 780, first pass; see docs/UNSURE.md. */
#define TonightsGameScreen TonightsGameScreen_decl
#define sub_8F98F sub_8F98F_decl
#define sub_8FB8E sub_8FB8E_decl
#define sub_913D0 sub_913D0_decl
#include "nhl95.h"
#undef TonightsGameScreen
#undef sub_8F98F
#undef sub_8FB8E
#undef sub_913D0

typedef struct { char c[17]; } ArtHdr17;

int TonightsGameScreen(int home, int away);
int sub_8F98F(char *path);
void sub_8FB8E(int song, int handle, int a, int b);
void __cdecl sub_913D0(int art, int x, int y);  /* graphics library: draw art (another mode than sub_91370) */

/* TonightsGameScreen (2ABDF, PC only): tonight's game. Copy the two teams' crests (CTLOGO) into LOGOHOME and
   LOGOAWAY blocks, load the CTBKGD background and palette, the CTTITLE1 gadget art and the INDUS030 font, read
   both teams' 28 player records from the league database (GIPK) and start the TONIGHTS song. Then, for the home
   team and the away team, show three pages over the team's crest: the forward lines (four lines of three, with
   the PA line-up call for the home team), the defence pairs (three of two) and the goalies and extras (eight
   rows, INJURED beside the injured ones), each faded in once and held until a click or 1000 ticks. Clicks 2 and
   3 end it early. Fade out the song and the screen, show the loading screen unless the last click was 3 or more,
   and free everything. No arguments. Result: the last WaitClickTimeout answer. */
int TonightsGameScreen(int home, int away)
{
    char name[0x54];
    char state[0x40];
    int gad[13];
    char path[0x10];
    int logos[2];
    unsigned char *linetab[2];
    int fh;
    int crest;
    int bkbank;
    int font;
    int titlebank;
    int logobank;
    int bkgd;
    int faded;
    unsigned char *pal;
    char *gipk;
    int n;
    int side;
    int p;
    int err;
    int key;
    int i;
    int y;
    int k;

    fh = -1;
    ClearInputQueue();
    err = 0;
    sub_B4BA8();
    sub_B392C(0);
    MakePath(path, fileoncd[0x59] == 1 ? (char *)cddriveptr : 0, (char *)str_Ctlogo, 0);
    logobank = sub_8E83C(path, 0);
    crest = sub_B30B4(logobank, (char *)crestnames[HomeTeam]);
    n = *(short *)(crest + 4) * *(short *)(crest + 6) + 0x11;
    logos[0] = sub_8CCA8((char *)str_Logohome, n, 0x20);
    *(ArtHdr17 *)logos[0] = *(ArtHdr17 *)crest;
    sub_903F0(crest, 0, 0);
    sub_91400(logos[0], 0, 0);
    crest = sub_B30B4(logobank, (char *)crestnames[VisTeam]);
    n = *(short *)(crest + 4) * *(short *)(crest + 6) + 0x11;
    logos[1] = sub_8CCA8((char *)str_Logoaway, n, 0x20);
    *(ArtHdr17 *)logos[1] = *(ArtHdr17 *)crest;
    sub_903F0(crest, 0, 0);
    sub_91400(logos[1], 0, 0);
    FreeMemBlock(logobank);
    MakePath(path, fileoncd[0x58] == 1 ? (char *)cddriveptr : 0, (char *)str_Ctbkgd, 0);
    bkbank = sub_8E83C(path, 0);
    bkgd = sub_B30B4(bkbank, (char *)str_Bkgd4);
    pal = (unsigned char *)sub_B30B4(bkbank, (char *)str_Pal12) + 0x10;
    MakePath(path, fileoncd[0x5A] == 1 ? (char *)cddriveptr : 0, (char *)str_Cttitle1, 0);
    titlebank = sub_8E83C(path, 0);
    gad[0] = sub_B30B4(titlebank, (char *)str_Def);
    gad[1] = sub_B30B4(titlebank, (char *)str_Fowa);
    gad[7] = sub_B30B4(titlebank, (char *)str_Scra);
    gad[9] = sub_B30B4(titlebank, (char *)str_Tlu);
    gad[10] = sub_B30B4(titlebank, (char *)str_Top);
    sub_8E9E8(state);
    MakePath(name, fileoncd[0x21A] == 1 ? (char *)cddriveptr : 0, (char *)str_Indus030, (char *)str_VFN);
    font = sub_8E8A0(name, 0x20);
    sub_8EA18(font);
    SetTextColors(0x40, 0);
    if (!err) {
        MakePath(name, (char *)&curleague, (char *)leaguedbnames[0], (char *)str_extDB);
        err = FileOpenRead(name, &fh);
    }
    if (!err) {
        gipk = (char *)sub_8CCA8((char *)str_GIPK, 0xB60, 0x20);
        for (n = 0; n < 2 && !err; n++) {
            for (i = 0; i < 0x1C && !err; i++) {
                k = ((int (*)[0xBA])dword_DBC7C)[n][i];
                if (k != -1) err = ReadKeyRec(fh, gipk + (n * 0x1C + i) * 0x34, k);
            }
        }
    }
    FileClose(&fh);
    linetab[0] = hmlinetab;
    linetab[1] = awlinetab;
    err = 0;
    faded = 0;
    key = 0;
    if (musicon && !songdata) {
        MakePath(path, fileoncd[0x1DF] == 1 ? (char *)cddriveptr : 0, (char *)str_Tonights, (char *)str_Iff5);
        songdata = sub_8F98F(path);
        if (songdata && gameopts.music) sub_8FB8E(songdata, musichandle, 3, 0x4C);
    }
    for (side = 0; side < 2 && key < 2 && !err; side++) {
        int out;

        sub_B4BA8();
        if (side) {
            sub_B4BC4(0x80, 0x280, 0x8C, 0x1E0);
            sub_9061C(bkgd);
            sub_B4BC4(0, 0x80, 0, 0x8C);
            sub_9061C(bkgd);
            sub_B4BC4(0, 0x80, 0, 0x1E0);
        } else {
            sub_B4BC4(0, 0x280, 0, 0x1E0);
            sub_9061C(bkgd);
        }
        DrawGadgetByType(8, 0, (int)pal, gad, 0, (int)&out);
        sub_B4BC4(0, 0x280, 0, 0x1E0);
        sub_913D0(logos[side], 0x3D, 0x50);
        SetTextColors(0x40, 0);
        sub_B4BC4(0, 0x280, 0, 0x154);
        y = byte_D42C3 + 0xA6;
        for (n = 0; n < 4 && !err; n++) {
            for (i = 0; i < 3 && !err; i++) {
                p = linetab[side][n * 3 + i];
                if (!err) {
                    FitPlayerName(name, 0, gipk + (side * 0x1C + p) * 0x34 + 0x13, 0xC8);
                    PrintShadowText(i * 0x96 + 0x91 + (0x96 - fputchar(name)) / 2, y, name);
                }
            }
            y += byte_D42C3 + 0xE;
        }
        if (!faded) {
            FadePalStep(0, pal, 0x10);
            if (!side) PaLineups();
            faded = -1;
        }
        key = WaitClickTimeout(0x3E8);
        if (key < 2) {
            sub_B4BA8();
            sub_B4BC4(0x80, 0x280, 0x8C, 0x1E0);
            sub_9061C(bkgd);
            sub_B4BC4(0, 0x80, 0x8C, 0x1E0);
            DrawGadgetByType(0x10, 0, (int)pal, gad, 0, (int)&out);
            sub_913D0(logos[side], 0x3D, 0x50);
            sub_B4BC4(0, 0x280, 0, 0x1E0);
            y = byte_D42C3 + 0xA6;
            for (n = 0; n < 3 && !err; n++) {
                for (i = 0; i < 2 && !err; i++) {
                    p = linetab[side][n * 2 + i + 0xC];
                    if (!err) {
                        FitPlayerName(name, 0, gipk + (side * 0x1C + p) * 0x34 + 0x13, 0xC8);
                        PrintShadowText(i * 0xF0 + 0x91 + (0xF0 - fputchar(name)) / 2, y, name);
                    }
                }
                y += byte_D42C3 + 0xE;
            }
            if (!faded) {
                FadePalStep(0, pal, 0x10);
                faded = -1;
            }
            key = WaitClickTimeout(0x3E8);
        }
        if (key < 2) {
            sub_B4BA8();
            sub_B4BC4(0x80, 0x280, 0x8C, 0x1E0);
            sub_9061C(bkgd);
            sub_B4BC4(0, 0x80, 0x8C, 0x1E0);
            DrawGadgetByType(4, 0, (int)pal, gad, 0, (int)&out);
            sub_913D0(logos[side], 0x3D, 0x50);
            sub_B4BC4(0, 0x280, 0, 0x1E0);
            y = byte_D42C3 + 0x7E;
            for (n = 0; n < 8 && !err; n++) {
                p = linetab[side][n + 0x28];
                if (p < 0x64) {
                    if (!err) {
                        FitPlayerName(name, 0, gipk + (side * 0x1C + p) * 0x34 + 0x13, 0xC8);
                        PrintShadowText(0xB4, y, name);
                        if (hmroster[side * 0x444 + p * 0x27] == 1) PrintShadowText(0x226, y, (char *)str_Injured);
                    }
                    y += byte_D42C3 + 0xE;
                }
            }
            if (!faded) {
                FadePalStep(0, pal, 0x10);
                faded = -1;
            }
            key = WaitClickTimeout(0x3E8);
        }
    }
    FreeMemBlock((int)gipk);
    if (musicon && songdata) sub_8FCDF(musichandle, 3, 0x64);
    FadePalStep(1, pal, 0x10);
    sub_B4BA8();
    sub_B392C(0);
    if (musicon && songdata) {
        while (!sub_8FC8A(musicslot, 3));
        sub_8D2F0(songdata);
        songdata = 0;
    }
    if (key < 3) ShowLoadingScreen();
    sub_8EA00(state);
    FreeMemBlock(font);
    FreeMemBlock(titlebank);
    FreeMemBlock(bkbank);
    FreeMemBlock(logos[0]);
    FreeMemBlock(logos[1]);
    return key;
}
