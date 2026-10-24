/* Scoreboard: play one demo game and restore the exhibition state. */
#define RunDemoGame RunDemoGame_decl
#define LoadRockMusic LoadRockMusic_decl
#define ReloadGameGfx ReloadGameGfx_decl
#define GameLoop GameLoop_decl
#define sub_8F98F sub_8F98F_decl
#define sub_8F13B sub_8F13B_decl
#define TitleScreen TitleScreen_decl
#define RunIntro RunIntro_decl
#define TickDeadlinePassed TickDeadlinePassed_decl
#define TicksSinceLastCall TicksSinceLastCall_decl
#define sub_9087C sub_9087C_decl
#define sub_8F1FE sub_8F1FE_decl
#define sub_912C8 sub_912C8_decl
#define sub_1B0F3 sub_1B0F3_decl
#define sub_1B1C2 sub_1B1C2_decl
#define sub_1AC25 sub_1AC25_decl
#define sub_1B2A7 sub_1B2A7_decl
#define sub_1B8AC sub_1B8AC_decl
#define sub_1B002 sub_1B002_decl
#define sub_1AD16 sub_1AD16_decl
#define sub_1B092 sub_1B092_decl
#define sub_1B09F sub_1B09F_decl
#define sub_1B0AD sub_1B0AD_decl
#define sub_1B0E5 sub_1B0E5_decl
#define sub_1B0D7 sub_1B0D7_decl
#define sub_1B0C9 sub_1B0C9_decl
#define sub_1B0BB sub_1B0BB_decl
#define sub_1B92E sub_1B92E_decl
#define sub_1ACF1 sub_1ACF1_decl
#define sub_1B18B sub_1B18B_decl
#include "nhl95.h"
#undef RunDemoGame
#undef LoadRockMusic
#undef ReloadGameGfx
#undef GameLoop
#undef sub_8F98F
#undef sub_8F13B
#undef TitleScreen
#undef RunIntro
#undef TickDeadlinePassed
#undef TicksSinceLastCall
#undef sub_9087C
#undef sub_8F1FE
#undef sub_912C8
#undef sub_1B0F3
#undef sub_1B1C2
#undef sub_1AC25
#undef sub_1B2A7
#undef sub_1B8AC
#undef sub_1B002
#undef sub_1AD16
#undef sub_1B092
#undef sub_1B09F
#undef sub_1B0AD
#undef sub_1B0E5
#undef sub_1B0D7
#undef sub_1B0C9
#undef sub_1B0BB
#undef sub_1B92E
#undef sub_1ACF1
#undef sub_1B18B

int TitleScreen(void);
void RunIntro(void);
int TickDeadlinePassed(void);
int TicksSinceLastCall(void);
void __cdecl sub_9087C(int frame, int x, int y);       /* graphics library: draw a frame */
void sub_8F1FE(int sample);                            /* sound library: free a sample */
void __cdecl sub_912C8(int art);                       /* graphics library: set the palette from an art block */
int __cdecl sub_1B0F3(int size, int chunk, int flags);  /* cdstream: create a reader */
void __cdecl sub_1B1C2(int stream, char *path);         /* cdstream: open a file */
int sub_1AC25(void);                                    /* cmv_player: create a decoder */
void sub_1B2A7(void);                                   /* cdstream: service the reader */
int __cdecl sub_1B8AC(int stream);                      /* cdstream: next chunk, 0 none yet, -1 at the end */
int sub_1B002(int dec);                                 /* cmv_player: decode a frame */
void sub_1AD16(int dec);
int sub_1B092(int dec);
int sub_1B09F(int dec);
int sub_1B0AD(int dec);
int sub_1B0E5(int dec);
int sub_1B0D7(int dec);
int sub_1B0C9(int dec);
int sub_1B0BB(int dec);
void __cdecl sub_1B92E(int stream, int chunk);          /* cdstream: release a chunk */
void sub_1ACF1(int dec);
void __cdecl sub_1B18B(int stream);
void __STOSB(void *p, int v, int n);
#pragma aux __STOSB "__STOSB" parm [eax] [edx] [ecx];

typedef struct {
    unsigned char hour, minute, second, hsecond;
} DosTime;
void _dos_gettime(DosTime *t);                 /* Watcom CRT _dos_gettime_ */
void srand(unsigned seed);                     /* Watcom CRT srand_ */

int RunDemoGame(void);
void LoadRockMusic(void);
void ReloadGameGfx(void);
void GameLoop(void);
int sub_8F98F(char *path);  /* sound library: load a song */
int sub_8F13B(char *path);  /* sound library: load a digitized sample */

typedef struct ExhRec { unsigned char b[0x75]; } ExhRec;

/* RunDemoGame: save the 75h-byte exhibition record, pick a demo matchup from demoteammode
 (all-stars, a fixed pair, or two random teams), run a one-minute period at 320x200, then
 put the record and the 5-minute period length back. Returns 1 when the game result is 2. */
int RunDemoGame(void)
{
    ExhRec saved;
    int one;
    int team;
    int home;
    int vis;

    ShowLoadingScreen();
    InputRemove();
    PerTimeTab[0] = 0x3C;
    DemoSetupStub();
    demomode = 1;
    seed[0] = (rand() << 16) + rand();
    demoteammode = (demoteammode + 1) % 3;
    saved = *(ExhRec *)exhstate;
    if (demoteammode == 2) {
        *(int *)(exhstate + 0x51) = 0x1B;
        *(int *)(exhstate + 0x55) = 0x1A;
    } else if (demoteammode == 1) {
        team = randomd0(0x11);
        one = *(int *)((char *)dword_C5861 + team * 2);
        one >>= 24;
        *(int *)(exhstate + 0x51) = one;
        one = *(int *)((char *)dword_C5862 + team * 2);
        one >>= 24;
        *(int *)(exhstate + 0x55) = one;
    } else {
        team = rand() % 0x1A;
        *(int *)(exhstate + 0x51) = team;
        team = team + 1;
        *(int *)(exhstate + 0x55) = (team + randomd0(0x19)) % 0x1A;
    }
    one = 0x10;
    *(int *)(exhstate + 0x65) = one;
    gamemode = 0;
    *(int *)(exhstate + 0x69) = one;
    *(int *)(exhstate + 0x6D) = 0;
    *(int *)(exhstate + 0x71) = 1;
    *(int *)(exhstate + 0x5D) = *(int *)(exhstate + 0x51);
    *(int *)(exhstate + 0x5D) = -1;
    *(int *)(exhstate + 0x61) = -2;
    LoadModeState(exhstate);
    *(unsigned char *)&gameopts |= 0xFF;
    if (musicon) ((unsigned char *)&gameopts)[1] |= 1;
    else ((unsigned char *)&gameopts)[1] &= 0xFE;
    ((unsigned char *)&gameopts)[1] |= 2;
    ((unsigned char *)&gameopts)[1] &= 3;
    vis = *(int *)((char *)&VisTeam - 2) >> 16;
    vis = teamabbrevs[vis];
    home = *(int *)((char *)&HomeTeam - 2) >> 16;
    home = teamabbrevs[home];
    PaPreloadClips(home, vis);
    SetupControllers();
    InitGameSummary(0, 0);
    if (HomeTeam >= 0x1A) LoadRink(0x0C);
    else LoadRink(*(int *)((char *)&HomeTeam - 2) >> 16);
    LoadRockMusic();
    ReloadGameGfx();
    FadeOutPalCycle();
    one = 1;
    dword_CC0EC = one;
    SetupDemoGame();
    dword_CC0EC = 0;
    introskipped = 0;
    gameresult = 0;
    SetScreenSize(0x140, 0xC8);
    vis = *(int *)((char *)&VisTeam - 2) >> 16;
    home = *(int *)((char *)&HomeTeam - 2) >> 16;
    LoadTeamPalette(home, vis, gamepal);
    vis = *(int *)((char *)&VisTeam - 2) >> 16;
    home = *(int *)((char *)&HomeTeam - 2) >> 16;
    DrawHudPanel(home, vis, one, one);
    joyq_flush();
    GameLoop();
    SetScreenSize(0x280, 0x1E0);
    PerTimeTab[0] = 0x12C;
    demomode = 0;
    *(ExhRec *)exhstate = saved;
    LoadModeState(exhstate);
    InputInstall();
    return gameresult == 2;
}

typedef struct { char c[17]; } Hdr17;

#pragma pack(1)
typedef struct CreditPage { signed char n; int time; char *bank; char *lines[1]; } CreditPage;
#pragma pack()

/* DRAFT (TitleScreen): 1675 vs 1675, 12 differing under 10.0 GA. The palette brightening reads pal[i] in place
   (the EXE's 3Fh in dh and the sum in bl; a char copy c adds in place and stores 3Fh as an immediate), which
   also gives the EXE's frame size. Left: frame and bmp swap slots (+328h / +32Ch), and the EXE copies the chunk
   into edx right after sub_1B8AC (`mov edx, eax`, as PlayMVI). */
/* TitleScreen (1609F, PC only; ends in RunDemoGame_x): the title screen. Load EASCRN (from the CD when listed):
   its palette brightened (+5, at most 3Fh), the SCRN2 screen and the MSK1 mask (copied into a MASK block of 200 x
   200). Start the title song (music on and none playing) or load the title sample (MT-32 or AdLib), then play
   the TITLE movie through the cdstream reader and the cmv_player decoder over the screen: 'MVIh' sets up the
   decoder (and a draw bitmap the first time), its palette part and the frame delay; 'MVIf' decodes a frame and
   draws it with the mask unless late, the first one saying the NHL intro once (dword_C588A) and starting the
   clock; 'MVIe' counts the end marks (two stop); anything else, or a key or click after 23h frames, stops. Then
   fade out, wait for the song (or stop the sample) and free the mask. Result: the key, -1 at the end of the
   movie, else 0. */
int TitleScreen(void)
{
    signed char pal[0x300];
    char path[0x20];
    int key;
    int chunk;
    int due;
    unsigned char *mask;
    int first;
    unsigned char *m;
    int frame;
    int delay;
    int i;
    unsigned id;
    int bmp;
    int ends;
    int dec;
    int stream;
    int t0;
    int n;
    int bank;

    bmp = 0;
    ClearInputQueue();
    sub_B4BA8();
    sub_B392C(0);
    MakePath(path, fileoncd[0x68] == 1 ? (char *)cddriveptr : 0, (char *)str_Eascrn, 0);
    bank = sub_8E83C(path, 0);
    memcpy(pal, (char *)sub_B30B4(bank, (char *)str_Pal4) + 0x10, 0x300);
    for (i = 0; i < 0x300; i++) {
        if (pal[i] < 0x3B) pal[i] = pal[i] + 5;
        else pal[i] = 0x3F;
    }
    sub_9121C(sub_B30B4(bank, (char *)str_Scrn2));
    m = (unsigned char *)sub_B30B4(bank, (char *)str_Msk1);
    mask = (unsigned char *)sub_8CCA8((char *)str_MASK, 0x9C51, 0x20);
    *(struct { unsigned char b[17]; } *)mask = *(struct { unsigned char b[17]; } *)m;
    *(short *)(mask + 4) = 0xC8;
    *(short *)(mask + 6) = 0xC8;
    memcpy(mask + 0x10, m + 0x10, 0x9C40);
    FreeMemBlock(bank);
    if (musicon && !songdata) {
        MakePath(path, fileoncd[0x1DA] == 1 ? (char *)cddriveptr : 0, (char *)str_Title30, (char *)str_Iff2);
        songdata = sub_8F98F(path);
    } else {
        if (sounddev == 8)
            MakePath(path, fileoncd[0x104] == 1 ? (char *)cddriveptr : 0, (char *)str_Mttitle, (char *)str_KMS);
        else
            MakePath(path, fileoncd[0x104] == 1 ? (char *)cddriveptr : 0, (char *)str_Adtitle, (char *)str_KMS);
        dword_DC33C = sub_8F13B(path);
    }
    MakePath(path, fileoncd[0x24] == 1 ? (char *)cddriveptr : 0, (char *)str_Title, (char *)str_Cmv);
    stream = sub_1B0F3(0x493E0, 0x2000, 0x20);
    sub_1B1C2(stream, path);
    dec = sub_1AC25();
    SetTickDeadline(0x96);
    while (!TickDeadlinePassed()) sub_1B2A7();
    delay = 10;
    pal[2] = pal[1] = pal[0] = 0;
    if (musicon) {
        if (songdata) sub_8FB8E(songdata, musichandle, 3, 0x4C);
        FadePalStep(0, (unsigned char *)pal, 0x10);
        SetTickDeadline(0x5A);
        while (!TickDeadlinePassed()) sub_1B2A7();
    } else {
        PlayDigiSample((void *)dword_DC33C);
        FadePalStep(0, (unsigned char *)pal, 0x10);
    }
    key = 0;
    /* Timer-library entry uses the cdecl calling convention. */
    t0 = ((int (__cdecl *)(void))GetTicks)();
    due = key;
    first = 1;
    n = 0;
    TicksSinceLastCall();
    ends = key;
    do {
        chunk = sub_1B8AC(stream);
        if (chunk == -1) {
            key = chunk;
        } else if (chunk) {
            switch (id = ReadBE32((signed char *)chunk)) {
            case 0x4D564966:
                due += delay;
                n++;
                frame = sub_1B002(dec);
                if (((int (__cdecl *)(void))GetTicks)() - t0 < due) {
                    SetDrawBitmap(bmp);
                    sub_9121C((int)mask);
                    sub_9087C(frame, 0, 0);
                    sub_B4BA8();
                    sub_91284(*(int *)(bmp + 0x2C), 0x21, 0x56);
                }
                if (first == 1 && ends == 0) {
                    if (musicon && dword_C588A) {
                        dword_C588A = 0;
                        PaNhlIntro();
                    }
                    first = 0;
                    t0 = ((int (__cdecl *)(void))GetTicks)();
                }
                break;
            case 0x4D564968:
                sub_1AD16(dec);
                sub_1B092(dec);
                if (!bmp) bmp = sub_B4F8C(sub_1B09F(dec), sub_1B0AD(dec), 0);
                SetDrawBitmap(bmp);
                sub_9121C((int)mask);
                sub_B4BA8();
                sub_91284(*(int *)(bmp + 0x2C), 0x21, 0x56);
                memcpy(pal + sub_1B0C9(dec) * 3, (void *)sub_1B0E5(dec), sub_1B0D7(dec) * 3);
                sub_B4B88(0, 0x100, (unsigned char *)pal);
                delay = 100 / sub_1B0BB(dec);
                break;
            case 0x4D564965:
                ends++;
                break;
            default:
                key = -1;
                break;
            }
            sub_1B92E(stream, chunk);
            sub_1B2A7();
            if (id == 0x4D564966 && (i = ((int (__cdecl *)(void))GetTicks)() - t0) < due) {
                SetTickDeadline(due - i);
                while (!TickDeadlinePassed() && !key) {
                    if (n > 0x23) key = AnyInputPressed();
                }
            }
        } else {
            sub_1B2A7();
        }
        if (!key && n > 0x23) key = AnyInputPressed();
    } while (!key && ends < 2);
    if (bmp) sub_9132C(bmp);
    sub_1ACF1(dec);
    sub_1B18B(stream);
    if (musicon && songdata) sub_8FCDF(musichandle, 3, 0x64);
    FadePalStep(1, (unsigned char *)pal, 0x10);
    if (musicon && songdata) {
        while (!sub_8FC8A(musicslot, 3));
        sub_8D2F0(songdata);
        songdata = 0;
    } else {
        StopDigiSample();
        sub_8F1FE(dword_DC33C);
    }
    FreeMemBlock((int)mask);
    return key;
}

/* The PIONEER2 song is `songdata = song2 = ...`, the later song goes through i, the last fade reads the byte
   into a signed char local c (dec al in place), and the sweep clears the previous white entry with three
   separate stores (a chained zero store holds the white 3Fh in bh, the EXE uses ch). */
/* RunIntro (1672A, PC only; ends in RunDemoGame_x): the intro. Free the speech bank's song (music on), clear the
   screen and the palette, show the Pioneer logos (PIONEER1: BKGD3 on PL1, fading to PL2 one step per 2 ticks with
   the PIONEER2 / 3 / 4 songs when music is on and none plays; then the FLA1-4 frames and PION from PIONEER2, a
   fade to white and back to PIO, a sweep of white entries E0h-EFh), wait for the songs and free them, set up the
   speech slots and the announcer bank and seed rand from the clock. Then the EA screen (EAOPEN, the EASPORTS song)
   and TitleScreen / RunDemoGame in turn until one of them returns nonzero; clear the screen and leave demo mode.
   No result. */
void RunIntro(void)
{
    signed char c;
    signed char tgt[0x300];
    signed char pal[0x300];
    char path[0x20];
    int shapes[5];
    DosTime t;
    int song2;
    int song3;
    int song4;
    int wait;
    int skip;
    int bank;
    int changed;
    int i;
    int bank2;

    skip = 0;
    if (musicon) sub_8D2F0(*(int *)((char *)speechbank + 0x3B60));
    ClearInputQueue();
    sub_B4BA8();
    sub_B392C(0);
    __STOSB(unk_C4E30, 0, 0x300);
    sub_B4B88(0, 0x100, unk_C4E30);
    MakePath(path, fileoncd[0x127] == 1 ? (char *)cddriveptr : 0, (char *)str_Pioneer1, 0);
    bank = sub_8E83C(path, 0);
    memcpy(tgt, (char *)sub_B30B4(bank, (char *)str_Pl2) + 0x10, 0x300);
    memcpy(pal, (char *)sub_B30B4(bank, (char *)str_Pl1) + 0x10, 0x300);
    sub_9121C(sub_B30B4(bank, (char *)str_Bkgd3));
    FreeMemBlock(bank);
    MakePath(path, fileoncd[0x128] == 1 ? (char *)cddriveptr : 0, (char *)str_Pioneer2, 0);
    bank2 = sub_8E83C(path, 0);
    if (musicon && !songdata) {
        MakePath(path, fileoncd[0x12C] == 1 ? (char *)cddriveptr : 0, (char *)str_Pioneer4, (char *)str_Iff2);
        song4 = sub_8F98F(path);
        MakePath(path, fileoncd[0x12B] == 1 ? (char *)cddriveptr : 0, (char *)str_Pioneer3, (char *)str_Iff2);
        song3 = sub_8F98F(path);
        MakePath(path, fileoncd[0x12A] == 1 ? (char *)cddriveptr : 0, (char *)str_Pioneer2, (char *)str_Iff2);
        songdata = song2 = sub_8F98F(path);
        if (songdata) sub_8FB8E(songdata, musichandle, 1, 0x7F);
        SetTickDeadline(0x104);
        WaitTickDeadline();
        wait = 0x50;
    } else {
        wait = 0xC8;
    }
    if (musicon && songdata) sub_8FB8E(songdata, musichandle, 0, 0x64);
    FadePalStep(0, (unsigned char *)pal, 0x5A);
    changed = 1;
    while (changed) {
        changed = 0;
        for (i = 0; i < 0x300; i++) {
            if (pal[i] < tgt[i]) {
                changed = 1;
                pal[i]++;
            } else if (pal[i] > tgt[i]) {
                changed = 1;
                pal[i]--;
            }
        }
        SetTickDeadline(2);
        WaitTickDeadline();
        if (changed) sub_B4B88(0, 0x100, (unsigned char *)pal);
    }
    SetTickDeadline(wait);
    WaitTickDeadline();
    for (i = 1; i < 5; i++) {
        sprintf(path, (char *)str_FlaD, i);
        shapes[i] = sub_B30B4(bank2, path);
    }
    shapes[0] = sub_B30B4(bank2, (char *)str_Pion);
    changed = 1;
    while (changed) {
        changed = 0;
        for (i = 0; i < 0x270; i++) {
            if (pal[i] < tgt[i]) {
                changed = 1;
                pal[i]++;
            }
        }
        SetTickDeadline(5);
        WaitTickDeadline();
        if (changed) sub_B4B88(0, 0x100, (unsigned char *)pal);
    }
    memset(pal, 0x3F, 0x300);
    memcpy(tgt, (char *)sub_B30B4(bank2, (char *)str_Pio) + 0x10, 0x300);
    SetTickDeadline(0x50);
    WaitTickDeadline();
    if (musicon && song3) sub_8FB8E(song3, musichandle, 2, 0x7F);
    for (i = 1; i < 5; i++) sub_913B4(shapes[i]);
    sub_B4B88(0, 0x100, (unsigned char *)pal);
    sub_9121C(shapes[0]);
    FreeMemBlock(bank2);
    changed = 1;
    while (changed) {
        changed = 0;
        for (i = 0; i < 0x300; i++) {
            c = pal[i];
            if (c > tgt[i]) {
                changed = 1;
                pal[i] = c - 1;
            }
        }
        SetTickDeadline(5);
        WaitTickDeadline();
        if (changed) sub_B4B88(0, 0x100, (unsigned char *)pal);
    }
    SetTickDeadline(0x28);
    WaitTickDeadline();
    if (musicon && song4) sub_8FB8E(song4, musichandle, 3, 0x7F);
    for (i = 0xE0; i < 0xF0; i++) {
        if (i > 0xE0) {
            pal[(i - 1) * 3] = 0;
            pal[(i - 1) * 3 + 1] = 0;
            pal[(i - 1) * 3 + 2] = 0;
        }
        pal[i * 3 + 2] = pal[i * 3 + 1] = pal[i * 3] = 0x3F;
        SetTickDeadline(2);
        WaitTickDeadline();
        sub_B4B88(0, 0x100, (unsigned char *)pal);
    }
    SetTickDeadline(0xC8);
    WaitTickDeadline();
    if (musicon) {
        sub_8FCDF(musichandle, 0, 0x64);
        sub_8FCDF(musichandle, 1, 0x64);
        sub_8FCDF(musichandle, 2, 0x64);
        sub_8FCDF(musichandle, 3, 0x64);
    } else if (!skip) {
        WaitClickTimeout(0x78);
    }
    if (musicon) {
        while (!sub_8FC8A(musicslot, 0));
        while (!sub_8FC8A(musicslot, 1));
        while (!sub_8FC8A(musicslot, 2));
        while (!sub_8FC8A(musicslot, 3));
        songdata = 0;
        if (song2) sub_8D2F0(song2);
        if (song3) sub_8D2F0(song3);
        if (song4) sub_8D2F0(song4);
    }
    if (musicon) {
        dword_CCC94 = 0x20;
        InitSpeechSlots(dword_C4CFC);
        dword_CCC94 = 0;
    }
    PaOpenBank();
    FadePalStep(1, (unsigned char *)tgt, 0x10);
    _dos_gettime(&t);
    srand(t.hsecond);
    do {
        MakePath(path, fileoncd[0x67] == 1 ? (char *)cddriveptr : 0, (char *)str_Eaopen, 0);
        bank = sub_8E83C(path, 0);
        memcpy(pal, (char *)sub_B30B4(bank, (char *)str_Pal4) + 0x10, 0x300);
        sub_912C8(sub_B30B4(bank, (char *)str_Scrn2));
        FreeMemBlock(bank);
        if (musicon && !songdata) {
            MakePath(path, fileoncd[0x1DC] == 1 ? (char *)cddriveptr : 0, (char *)str_Easports, (char *)str_Iff2);
            i = sub_8F98F(path);                 /* i reused for the song */
            songdata = i;
            if (songdata) sub_8FB8E(songdata, musichandle, 3, 0x4C);
        }
        FadePalStep(0, (unsigned char *)pal, 0x10);
        SetTickDeadline(0xC8);
        WaitTickDeadline();
        if (musicon && songdata) {
            while (!sub_8FC8A(musicslot, 3));
            sub_8D2F0(songdata);
            songdata = 0;
        }
        FadePalStep(1, (unsigned char *)pal, 0x10);
        sub_B4BA8();
        sub_B392C(0);
    } while (!TitleScreen() && !RunDemoGame());
    sub_B4BA8();
    sub_B392C(0);
    PaOpenBank();
    demomode = dword_CC0EC = 0;
}

/* DRAFT (ShowCredits): 1320 vs 1320, 4 differing under 10.0 GA (two reordered instructions).
   A block-local int height gives the EXE's byte_D42C3 / line-count load order. Left: the first rand() % 8
   loads the divisor into ecx before sar edx, 1Fh; the EXE loads it after. See docs/UNSURE.md. */
/* ShowCredits (16F9A, PC only; ends in RunDemoGame_x): the credits. Keep the text state, load the BACKWIN block
   and the CREDITS bank (from the CD when listed there): its palette (kept for the fade and copied to unk_C4E30)
   and BKGD art, drawn after the palette cycle fades out. Start the credits song when there is music, else the
   ADTITLE and ROCKDITI samples (playing the first), fade the palette in and say goodnight. Then show the 29 pages
   of off_C6399 (from the eighth on in the Kaufmann font): after the first, wait 62h ticks for a click; a page
   other than unk_C638C restores the backdrop and draws its art (a bank named at +5, its SHP0 shape at a random
   spot) and centres its lines (count at +0, strings from +9) from DAh up by half their height, then waits its
   time (+1) for a click. A click ends the credits: restore the backdrop, fade the music and the palette out,
   free the song or the samples, the text state and the block, and clear the screen. No result. */
void ShowCredits(void)
{
    CreditPage *cur;
    int page;
    int bg;
    int stop;
    int wait;
    int sample1;
    int sample2;
    unsigned char pal[0x300];
    char st[0x40];
    char path[0x10];
    int bank;
    int art;
    unsigned char *p;
    int y;
    int i;
    char *s;

    TextGridFree();
    PaOpenBank();
    sub_8E9E8(st);
    sub_8EA18(mainfont);
    SetTextColors(0x7F, 0);
    bg = sub_8CCA8((char *)str_Backwin, 0x19337, 0);
    MakePath(path, fileoncd[0x21D] == 1 ? (char *)cddriveptr : 0, (char *)str_Credits, 0);
    bank = sub_8E83C(path, 0);
    p = (unsigned char *)sub_B30B4(bank, (char *)str_Pal4) + 0x10;
    memcpy(pal, p, 0x300);
    memcpy(unk_C4E30, p, 0x300);
    art = sub_B30B4(bank, (char *)str_Bkgd3);
    *(Hdr17 *)bg = *(Hdr17 *)pointerspr;
    ((short *)bg)[2] = 0x135;
    ((short *)bg)[3] = 0x14E;
    FadeOutPalCycle();
    sub_9061C(art);
    FreeMemBlock(bank);
    sub_91400(bg, 0x14A, 0x3F);
    if (musicon && !songdata) {
        MakePath(path, fileoncd[0x1E1] == 1 ? (char *)cddriveptr : 0, (char *)str_Credits, (char *)str_Iff2);
        wait = sub_8F98F(path);
        songdata = wait;
        if (wait) sub_8FB8E(wait, musichandle, 3, 0x4C);
    } else {
        if (sounddev == 8)
            MakePath(path, fileoncd[0x104] == 1 ? (char *)cddriveptr : 0, (char *)str_Adtitle, (char *)str_KMS);
        else
            MakePath(path, fileoncd[0x104] == 1 ? (char *)cddriveptr : 0, (char *)str_Adtitle, (char *)str_KMS);
        sample1 = sub_8F13B(path);
        MakePath(path, fileoncd[0x161] == 1 ? (char *)cddriveptr : 0, (char *)str_Rockditi, (char *)str_KMS);
        sample2 = sub_8F13B(path);
        PlayDigiSample((void *)sample1);
    }
    FadePalStep(0, pal, 0x10);
    PaGoodnight();
    stop = 0;
    for (page = 0; page < 0x1D; page++) {
        if (page == 7) sub_8EA18(kaufmfont);
        cur = (CreditPage *)off_C6399[page];
        ClearInputQueue();
        if (page != 0) stop = WaitClickTimeout(0x62);
        if (stop) break;
        if (cur == (CreditPage *)unk_C638C) continue;
        if (*cur->bank != 0) {
            MakePath(path, fileoncd[0x21E] == 1 ? (char *)cddriveptr : 0, cur->bank, 0);
            bank = sub_8E83C(path, 0);
            art = sub_B30B4(bank, (char *)str_Shp0);
            sub_903F0(bg, 0x14A, 0x3F);
            sub_91370(art, rand() % 8 + 0x85, rand() % 8 + 0x6A);
            FreeMemBlock(bank);
        } else {
            sub_903F0(bg, 0x14A, 0x3F);
        }
        wait = cur->time;
        {
            int height = byte_D42C3;
            y = 0xDA - (cur->n * height >> 1);
        }
        for (i = 0; i < cur->n; i++) {
            s = cur->lines[i];
            RenderTextLine(0x1EA - (fputchar(s) >> 1), y, s);
            y += byte_D42C3;
        }
        ClearInputQueue();
        if (WaitClickTimeout(wait)) break;
    }
    sub_903F0(bg, 0x14A, 0x3F);
    if (musicon && songdata) sub_8FCDF(musichandle, 3, 0x64);
    SpeechStopQueue();
    FadePalStep(1, pal, 0x10);
    if (musicon && songdata) {
        while (!sub_8FC8A(musicslot, 3));
        sub_8D2F0(songdata);
        songdata = 0;
    } else {
        StopDigiSample();
        sub_8F1FE(sample1);
        sub_8F1FE(sample2);
    }
    sub_8EA00(st);
    FreeMemBlock(bg);
    sub_B4BA8();
    sub_B392C(0);
}
