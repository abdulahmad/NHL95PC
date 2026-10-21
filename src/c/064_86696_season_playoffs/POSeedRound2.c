/* Season playoffs: creating the playoffs, and seeding the second round from the first-round winners. */
#define POSeedRound2 POSeedRound2_decl
#define SeriesWinner SeriesWinner_decl
#define POSetSeriesTeams POSetSeriesTeams_decl
#define CreatePlayoffs CreatePlayoffs_decl
#define POSeedTeams POSeedTeams_decl
#define LockerRoomScreen LockerRoomScreen_decl
#define savenamedefault savenamedefault_decl
#define POAfterGame POAfterGame_decl
#define PostGameToTeamDb PostGameToTeamDb_decl
#define POSeedConfFinals POSeedConfFinals_decl
#define POSeedFinal POSeedFinal_decl
#define POHandleElimination POHandleElimination_decl
#define PlayoffTreeMenu PlayoffTreeMenu_decl
#define PreGameScreen PreGameScreen_decl
#define sub_910B0 sub_910B0_decl
#define DrawPlayoffTree DrawPlayoffTree_decl
#define CountSeriesWins CountSeriesWins_decl
#include "nhl95.h"
#undef POSeedRound2
#undef SeriesWinner
#undef POSetSeriesTeams
#undef CreatePlayoffs
#undef POSeedTeams
#undef LockerRoomScreen
#undef savenamedefault
#undef POAfterGame
#undef PostGameToTeamDb
#undef POSeedConfFinals
#undef POSeedFinal
#undef POHandleElimination
#undef PlayoffTreeMenu
#undef PreGameScreen
#undef sub_910B0
#undef DrawPlayoffTree
#undef CountSeriesWins

typedef struct { char c[13]; } PlayoffName;
typedef struct { char c[34]; } TreeStr34;
typedef struct { char c[19]; } TreeStr19;
typedef struct { char c[3]; } TreeStr3;

int CreatePlayoffs(void);
void POSeedTeams(int *seeds);
int LockerRoomScreen(void);
int mkdir(const char *path);  /* Watcom CRT mkdir_ */
int POAfterGame(unsigned char *p);
void PostGameToTeamDb(char *dir, char *ext, int team, int side, int game, char *dir2);  /* 3626D */
void POSeedConfFinals(unsigned char *p);
void POSeedFinal(unsigned char *p);
void POHandleElimination(int mode, unsigned char *po);
int PlayoffTreeMenu(void *bar, int n, int col1, int col2, int col3, int sel);
int PreGameScreen(int home, int vis);
void __cdecl sub_910B0(int a);  /* graphics library */
void DrawPlayoffTree(void);
void CountSeriesWins(int *tree, int *wins, int mode);  /* 27C34 */
extern PlayoffName savenamedefault;  /* 86616: "." and zeros, the default name */

/* DRAFT: 2,037 bytes as in the EXE, 34 differing lines (register picks, the bank store, the epilogue);
   see docs/UNSURE.md. */
/* CreatePlayoffs (86696, PC only; ends in POSeedRound2_x): start a new playoff. Keep and set the dialog colours,
   keep the exhibition mode state, fade the palette out and draw the EMBSCUP background (dword_C65AC when loaded),
   fade the EMBPAL palette in and ask for the playoff name (up to 8 characters, colour 3 white meanwhile). With a
   name: set the playoff mode state (postate: 12 and 21 for two counts, the option word, the first controller in
   ctlavailmask order 2, 4, 8, 1 else 10h), add .PO, offer to replace an existing playoff of that name (no: give
   up), make it the current league (curleague, the database paths) and its directory, ask which database, check
   GAMESET and the disk space, then show the locker room (3 gives up and removes the directory). Then redraw the
   background, seed the teams (POSeedTeams), copy the seven databases, make the schedule (POCreateSchedule), write
   the mode state, rebuild the saved game labels and stats menu and point the menu actions at the playoff screens.
   On an error say so and remove the directory. At the end fade the TEMP2 palette in, restore the exhibition mode
   state and the dialog colours. No arguments; result 2. */
int CreatePlayoffs(void)
{
    struct {
        int seeds[16];
        char ft[0x2C];
        char path[0x20];
        PlayoffName name;
        char pad[3];
        int btn;
        int y;
        int x;
        int bank2;
        int fill;
        int lite;
        int bg;
        int shade;
        int fg;
        unsigned char rgb[4];
        unsigned char orgb[4];
    } s;
    int p;
    int pal;
    int bank;
    int r;
    int i;

    s.name = savenamedefault;
    s.fill = boxfillcolor;
    s.lite = boxlitecolor;
    s.shade = boxshadecolor;
    s.fg = dlgtextfg;
    s.bg = dlgtextbg;
    boxfillcolor = 0x41;
    boxlitecolor = 0x40;
    boxshadecolor = 0x42;
    dlgtextfg = 0x40;
    dlgtextbg = 0x43;
    SaveModeState(exhstate);
    pal = p = sub_8CCA8((char *)str_Palette, 0x300, 0x20);
    sub_8FFB0(0, 0x100, (unsigned char *)p);
    FadePalStep(1, (unsigned char *)p, 0x10);
    sub_B4BA8();
    if (!dword_C65AC) {
        MakePath(s.path, fileoncd[0x8D] == 1 ? (char *)cddriveptr : 0, (char *)str_Embscup, 0);
        p = sub_8E83C(s.path, 0);
        sub_B4BC4(0, 0x280, 0, 0x1E0);
        sub_913B4(sub_B30B4(p, (char *)str_Bkgd));
        FreeMemBlock(p);
    } else {
        sub_9121C(sub_B30B4(dword_C65AC, (char *)str_Bkgd));
    }
    MakePath(s.path, fileoncd[0x8E] == 1 ? (char *)cddriveptr : 0, (char *)str_Embpal, 0);
    bank = sub_8E83C(s.path, 0);
    FadePalStep(0, (unsigned char *)sub_B30B4(bank, (char *)str_BangPal) + 0x10, 0x10);
    sub_8E9C0(0x40, 0x41);
    SetDialogColors(0x41, 0x40, 0x42, 0x40, 0x43);
    s.rgb[0] = s.rgb[1] = s.rgb[2] = 0x3F;
    sub_8FFB0(3, 1, s.orgb);
    sub_B4B88(3, 1, s.rgb);
    r = TextInputDialog((char *)str_PleaseEnterNewPlay, s.name.c, 8, 0x36, 0, 0, 0, 0, 5);
    sub_B4B88(3, 1, s.orgb);
    sub_B2DCA(&s.btn, &s.x, &s.y);
    if (r == 0x1B || !s.name.c[0]) goto cancel;
    postate[0] = 1;
    *(int *)((char *)postate + 0x51) = 0xC;
    *(int *)((char *)postate + 0x55) = 0x15;
    *(unsigned short *)((char *)postate + 0x59) &= 0x8000;
    *(unsigned short *)((char *)postate + 0x59) |= 0x79FF;
    if (ctlavailmask & 2) *(int *)((char *)postate + 0x65) = 2;
    else if (ctlavailmask & 4) *(int *)((char *)postate + 0x65) = 4;
    else if (ctlavailmask & 8) *(int *)((char *)postate + 0x65) = 8;
    else if (ctlavailmask & 1) *(int *)((char *)postate + 0x65) = 1;
    else *(int *)((char *)postate + 0x65) = 0x10;
    if (*(int *)((char *)postate + 0x65) != 0x10) *(int *)((char *)postate + 0x5D) = 0xC;
    else *(int *)((char *)postate + 0x5D) = -1;
    *(int *)((char *)postate + 0x69) = 0x10;
    *(int *)((char *)postate + 0x61) = -2;
    *(int *)((char *)postate + 0x6D) = r = 0;
    *(int *)((char *)postate + 0x71) = 1;
    LoadModeState(postate);
    strcat(s.name.c, (char *)str_PO);
    if (!unknown_libname_1(s.name.c, 0x10, s.ft)) {
        if ((r = !MessageBox(-1, -1, (char *)msg_POExists, 2, (int)btn_LeagueExists, 2, (int)&s.x, (int)&s.y, -1)) != 0)
            goto cancel;
        DeleteDir(s.name.c);
    }
    goto named;
cancel:
    FreeMemBlock(bank);
    FreeMemBlock(pal);
    r = 1;
named:
    if (!r) {
        strcpy((char *)&curleague, s.name.c);
        strcpy((char *)&leaguedbfmt, s.name.c);
        strcat((char *)&leaguedbfmt, (char *)str_fmtSlashDb);
        strcpy((char *)&leaguedbfmt2, (char *)&leaguedbfmt);
        if (mkdir(s.name.c)) {
            MessageBox(-1, -1, (char *)msg_POSetupError, 4, 0, 0, (int)&s.x, (int)&s.y, 0x190);
            r = 1;
        }
        if (!r) {
            if ((r = AskDatabaseChoice()) >= 0) {
                GetLeagueDBSizes(0, (int *)unk_D2864, (char *)dbextension);
                MakePath(s.path, (char *)&curleague, (char *)str_GameSet, 0);
                if (FileExists(s.path)) dword_D2884 = 0;
                if ((r = DiskSpaceShort(0, (int *)unk_D2864)) != 0) {
                    sprintf((char *)msg_PODiskSpace_arg, (char *)str_4dKbytesOfFree, r);
                    MessageBox(-1, -1, (char *)msg_PODiskSpace, 3, 0, 0, (int)&s.x, (int)&s.y, 0x258);
                    r = 1;
                }
            }
            if (!r && LockerRoomScreen() != 3) {
                sub_8FFB0(0, 0x100, (unsigned char *)pal);
                FadePalStep(1, (unsigned char *)pal, 0x10);
                if (!dword_C65AC) {
                    MakePath(s.path, fileoncd[0x8D] == 1 ? (char *)cddriveptr : 0, (char *)str_Embscup, 0);
                    s.bank2 = sub_8E83C(s.path, 0);
                    sub_9121C(sub_B30B4(s.bank2, (char *)str_Bkgd));
                    FreeMemBlock(s.bank2);
                } else {
                    sub_9121C(sub_B30B4(dword_C65AC, (char *)str_Bkgd));
                }
                FadePalStep(0, (unsigned char *)sub_B30B4(bank, (char *)str_BangPal) + 0x10, 0x10);
                FreeMemBlock(bank);
                FreeMemBlock(pal);
                POSeedTeams(s.seeds);
                MessageBox(-1, -1, (char *)msg_POSettingUp, 2, 0, 0, (int)&s.x, (int)&s.y, 0);
                for (i = 0; i < 7; i++) {
                    if (CopyFile((char *)leaguedbnames[i], (char *)dbextension, (char *)str_extDB, (char *)&str_dot,
                            (char *)&curleague)) {
                        SetTickDeadline(0x190);
                        DeleteDir(s.name.c);
                        r = 1;
                        WaitTickDeadline();
                        break;
                    }
                }
                if (!r) {
                    if (POCreateSchedule(s.seeds, s.name.c)) {
                        SetTickDeadline(0x190);
                        MessageBox(-1, -1, (char *)msg_POSetupError, 4, 0, 0, (int)&s.x, (int)&s.y, 0);
                        DeleteDir(s.name.c);
                        WaitTickDeadline();
                        RestoreDialogBg();
                    }
                    WriteModeState(postate);
                    BuildSavedGameLabels();
                    SetupStatsSourceMenu(0);
                    menuact_nextpo = (int)PlayoffModeLoop;
                    menuact_posettings = (int)EditPlayoffSettings;
                    menuact_pohilights = (int)ViewPlayoffHilights;
                    seriesgameno = r = 0;
                }
                RestoreDialogBg();
            } else {
                rmdir(s.name.c);
                FreeMemBlock(bank);
                FreeMemBlock(pal);
            }
        }
    }
    pal = sub_8CCA8((char *)str_Temp2, 0x300, 0x20);
    sub_8FFB0(0, 0x100, (unsigned char *)pal);
    FadePalStep(1, (unsigned char *)pal, 0x10);
    FreeMemBlock(pal);
    LoadModeState(exhstate);
    boxfillcolor = s.fill;
    boxlitecolor = s.lite;
    boxshadecolor = s.shade;
    dlgtextfg = s.fg;
    dlgtextbg = s.bg;
    return 2;
}

int SeriesWinner(unsigned char *s, unsigned games);
#pragma aux SeriesWinner parm [eax] [edx] value [eax] modify [eax edx];
void POSetSeriesTeams(unsigned char *s, int a, int b);
#pragma aux POSetSeriesTeams parm [eax] [edx] [ebx] modify [eax edx ebx];

void __STOSD(void *p, int v, int n);
#pragma aux __STOSD "__STOSD" parm [eax] [edx] [ecx] modify [eax edx ecx];

/* DRAFT: 736 vs 720 (best of 5). The frame, the eight-score scan, both date fills and
 __STOSD match. Each SeriesWinner result is copied with mov edx, eax before the home byte
 is loaded, so the byte lands in eax and the compare is swapped (16 bytes, eight calls).
 Do not retry: named unsigned chars for the scan (al/ah/dh/dl instead of ah/dl/dh/al),
 one int for both the day remainder and the home byte (spills, sub esp, 34h), or
 assigning the home byte to k, the filter counter that lives in edx.
 */
/* POSeedRound2: walk back from the last first-round game while all eight series
 still have an empty score, then date the two second-round series (14 games each,
 every other day, rolling the month at 30). The four winners on each side fill
 the next series; a winner that is the home team is kept in the low slots and
 the other winner in the high slots, and only team numbers below 26 are passed
 on. POSeedRound2_x30 is the add esp. */
void POSeedRound2(unsigned char *p)
{
    struct {
        int slot[8];
        int out[4];
    } s;
    unsigned char *g;
    unsigned char *ser;
    int i;
    int k;
    int div;
    int rem;

    g = p + 0x19BC;
    i = 0;
    do {
        if (g[4] != 0xFF || g[0x2E] != 0xFF || g[0x58] != 0xFF || g[0x82] != 0xFF
            || g[0xAC] != 0xFF || g[0xD6] != 0xFF || g[0x100] != 0xFF || g[0x12A] != 0xFF)
            break;
        i++;
        g -= 6;
    } while (i < 6);
    s.out[0] = g[0];
    s.out[1] = g[1] + 3;
    ser = p + 0x1AE8;
    for (i = 0; i < 0xE;) {
        div = 7;
        ser[0] = s.out[0];
        rem = i % div;
        rem += rem;
        rem += s.out[1];
        ser[1] = rem;
        if (ser[1] > 0x1E) {
            ser[0]++;
            ser[1] -= 0x1E;
        }
        i++;
        ser += 6;
    }
    s.out[1]--;
    ser = p + 0x1B3C;
    i = 0;
    div = 7;
    do {
        ser[0] = s.out[0];
        rem = i % div;
        rem += rem;
        rem += s.out[1];
        ser[1] = rem;
        if (ser[1] > 0x1E) {
            ser[0]++;
            ser[1] -= 0x1E;
        }
        i++;
        ser += 6;
    } while (i < 0xE);
    __STOSD(s.slot, -1, 8);
    ser = p + 0x1998;
    s.out[0] = SeriesWinner(ser, *(int *)(p + 0x50));
    k = ser[2];
    if (s.out[0] == k) s.slot[0] = k;
    else s.slot[7] = s.out[0];
    ser += 0x2A;
    s.out[1] = SeriesWinner(ser, *(int *)(p + 0x54));
    k = ser[2];
    if (s.out[1] == k) s.slot[1] = k;
    else s.slot[6] = s.out[1];
    ser += 0x2A;
    s.out[2] = SeriesWinner(ser, *(int *)(p + 0x58));
    k = ser[2];
    if (s.out[2] == k) s.slot[2] = k;
    else s.slot[5] = s.out[2];
    ser += 0x2A;
    s.out[3] = SeriesWinner(ser, *(int *)(p + 0x5C));
    k = ser[2];
    if (s.out[3] == k) s.slot[3] = k;
    else s.slot[4] = s.out[3];
    i = 0;
    k = 0;
    for (; i < 8; i++) {
        if (s.slot[i] >= 0 && s.slot[i] < 0x1A)
            s.out[k++] = s.slot[i];
    }
    ser = p + 0x1AE8;
    POSetSeriesTeams(ser, s.out[0], s.out[3]);
    POSetSeriesTeams(ser + 0x2A, s.out[1], s.out[2]);
    __STOSD(s.slot, -1, 8);
    ser = p + 0x1A40;
    s.out[0] = SeriesWinner(ser, *(int *)(p + 0x60));
    k = ser[2];
    if (s.out[0] == k) s.slot[0] = k;
    else s.slot[7] = s.out[0];
    ser += 0x2A;
    s.out[1] = SeriesWinner(ser, *(int *)(p + 0x64));
    k = ser[2];
    if (s.out[1] == k) s.slot[1] = k;
    else s.slot[6] = s.out[1];
    ser += 0x2A;
    s.out[2] = SeriesWinner(ser, *(int *)(p + 0x68));
    k = ser[2];
    if (s.out[2] == k) s.slot[2] = k;
    else s.slot[5] = s.out[2];
    ser += 0x2A;
    s.out[3] = SeriesWinner(ser, *(int *)(p + 0x6C));
    k = ser[2];
    if (s.out[3] == k) s.slot[3] = k;
    else s.slot[4] = s.out[3];
    i = 0;
    k = 0;
    for (; i < 8; i++) {
        if (s.slot[i] >= 0 && s.slot[i] < 0x1A)
            s.out[k++] = s.slot[i];
    }
    ser = p + 0x1B3C;
    POSetSeriesTeams(ser, s.out[0], s.out[3]);
    POSetSeriesTeams(ser + 0x2A, s.out[1], s.out[2]);
}

/* DRAFT: 2,668 vs 2,678 bytes, 100 differing lines (register picks after SeriesWinner and in the controller
   side code); see docs/UNSURE.md. */
/* POAfterGame (8873C, PC only; ends in POSeedRound2_x): after a playoff game. Post both teams' game to their team
   databases (game 444h + the game index), store the score in the game record, load the season, career and key
   databases and simulate the other series of the round up to this game (POSimSeriesTo). When the series is decided
   (SeriesWinner): set the round's series length options, simulate the rest of the round (POSimSeries) and mark the
   games a shorter series no longer needs (FFh) in every series of the round, seed the next round (POSeedRound2,
   POSeedConfFinals, POSeedFinal), refresh the tree slots (playofftree, FFh shown as 1Ah) and the champion, move on
   to the winner's next series (the cup final ends the playoff: game 69h, SaveScheduleDB) and write the mode state.
   Otherwise move to the next game and build the series score line ("tied" or the leader's abbreviation). Write the
   season database back and free the three. Then set the next game's teams and the controller sides: one human
   side out of the playoff ends it (result 1); with two humans, the loser's name goes into the "team out" message,
   its controller drops out (result 2). p: the playoff schedule. Result: 0, 1 when the playoff is over for the
   player, 2 when one of two players is out. */
int POAfterGame(unsigned char *p)
{
    struct {
        char path[0x40];
        int homewon;
        int ret;
        int away;
        int home;
        int aw;
        int hw;
    } f;
    int idx;
    unsigned char *s;
    unsigned char *g;
    int w;
    int gn;
    int j;
    int k;
    int m;
    int n;

    f.ret = 0;
    idx = *(int *)(p + 0x40);
    PostGameToTeamDb((char *)&curleague, (char *)str_Db, HomeTeam, 0, idx + 0x444, (char *)&curleague);
    PostGameToTeamDb((char *)&curleague, (char *)str_Db, VisTeam, 1, idx + 0x444, (char *)&curleague);
    s = p + (idx + 0x444) * 6;
    gn = idx % 7 + 1;
    idx /= 7;
    s[4] = hmscore[0];
    s[5] = awscore;
    MakePath(f.path, (char *)&curleague, (char *)leaguedbnames[5], (char *)str_extDB);
    seasondb = (unsigned char *)sub_8E8A0(f.path, 0x20);
    seasondb_size = sub_92DE0(f.path);
    MakePath(f.path, (char *)&curleague, (char *)leaguedbnames[1], (char *)str_extDB);
    careerdb = (unsigned char *)sub_8E8A0(f.path, 0x20);
    careerdb_size = sub_92DE0(f.path);
    MakePath(f.path, (char *)&curleague, (char *)leaguedbnames[0], (char *)str_extDB);
    keydb = (unsigned char *)sub_8E8A0(f.path, 0x20);
    keydb_size = sub_92DE0(f.path);
    if (idx < 8) {
        for (w = 0; w < 8; w++)
            if (w != idx) POSimSeriesTo(p, w, gn);
    } else if (idx < 0xC) {
        for (w = 8; w < 0xC; w++)
            if (w != idx) POSimSeriesTo(p, w, gn);
    } else if (idx < 0xE) {
        for (w = 0xC; w < 0xE; w++)
            if (w != idx) POSimSeriesTo(p, w, gn);
    }
    g = p + (idx * 7 + 0x444) * 6;
    w = SeriesWinner(g, gameopts.optbits12);
    if (w >= 0) {
        f.homewon = w == HomeTeam;
        if (idx < 8) {
            *(int *)(p + 0x50) = *(int *)(p + 0x54) = *(int *)(p + 0x58) = *(int *)(p + 0x5C) =
                *(int *)(p + 0x60) = *(int *)(p + 0x64) = *(int *)(p + 0x68) = *(int *)(p + 0x6C) = gameopts.optbits12;
            s = p + 0x1998;
            for (j = 0; j < 8; j++, s += 0x2A) {
                if (j != idx) POSimSeries(s, gameopts.optbits12);
                for (k = 0; k < 7 && s[k * 6 + 4] != 0xFF; k++);
                for (m = gameopts.optbits12 / 2 + 1, k -= m; m < 4; m++) {
                    n = k + m;
                    s[n * 6] = s[n * 6 + 1] = s[n * 6 + 2] = s[n * 6 + 3] = s[n * 6 + 4] = s[n * 6 + 5] = 0xFF;
                }
            }
            POSeedRound2(p);
        } else if (idx < 0xC) {
            *(int *)(p + 0x70) = *(int *)(p + 0x74) = *(int *)(p + 0x78) = *(int *)(p + 0x7C) = gameopts.optbits12;
            s = p + 0x1AE8;
            for (j = 8; j < 0xC; j++, s += 0x2A) {
                if (j != idx) POSimSeries(s, gameopts.optbits12);
                for (k = 0; k < 7 && s[k * 6 + 4] != 0xFF; k++);
                for (m = gameopts.optbits12 / 2 + 1, k -= m; m < 4; m++) {
                    n = k + m;
                    s[n * 6] = s[n * 6 + 1] = s[n * 6 + 2] = s[n * 6 + 3] = s[n * 6 + 4] = s[n * 6 + 5] = 0xFF;
                }
            }
            POSeedConfFinals(p);
        } else if (idx < 0xE) {
            *(int *)(p + 0x80) = *(int *)(p + 0x84) = gameopts.optbits12;
            s = p + 0x1B90;
            for (j = 0xC; j < 0xE; j++, s += 0x2A) {
                if (j != idx) POSimSeries(s, gameopts.optbits12);
                for (k = 0; k < 7 && s[k * 6 + 4] != 0xFF; k++);
                for (m = gameopts.optbits12 / 2 + 1, k -= m; m < 4; m++) {
                    n = k + m;
                    s[n * 6] = s[n * 6 + 1] = s[n * 6 + 2] = s[n * 6 + 3] = s[n * 6 + 4] = s[n * 6 + 5] = 0xFF;
                }
            }
            POSeedFinal(p);
        } else {
            *(int *)(p + 0x88) = gameopts.optbits12;
            s = p + 0x1BE4;
            for (k = 0; k < 7 && s[k * 6 + 4] != 0xFF; k++);
            for (m = gameopts.optbits12 / 2 + 1, k -= m; m < 4; m++) {
                n = k + m;
                s[n * 6] = s[n * 6 + 1] = s[n * 6 + 2] = s[n * 6 + 3] = s[n * 6 + 4] = s[n * 6 + 5] = 0xFF;
            }
        }
        s = p + 0x1AE8;
        for (j = 0x10; j < 0x1E; j += 2, s += 0x2A) {
            playofftree[j] = s[2];
            playofftree_p1[j] = s[3];
            if (playofftree[j] == 0xFF) playofftree[j] = 0x1A;
            if (playofftree_p1[j] == 0xFF) playofftree_p1[j] = 0x1A;
        }
        s = p + 0x1BE4;
        pochampion = SeriesWinner(s, *(int *)(p + 0x88));
        if (pochampion == -1) pochampion = 0x1A;
        switch (idx) {
        case 0: case 1: case 2: case 3:
            if (p[0x1AEA] == w || p[0x1AEB] == w) {
                idx = 8;
                s = p + 0x1AE8;
            } else {
                idx = 9;
                s = p + 0x1B12;
            }
            break;
        case 4: case 5: case 6: case 7:
            if (p[0x1B3E] == w || p[0x1B3F] == w) {
                idx = 0xA;
                s = p + 0x1B3C;
            } else {
                idx = 0xB;
                s = p + 0x1B66;
            }
            break;
        case 8: case 9:
            idx = 0xC;
            s = p + 0x1B90;
            break;
        case 0xA: case 0xB:
            idx = 0xD;
            s = p + 0x1BBA;
            break;
        case 0xC: case 0xD:
            idx = 0xE;
            s = p + 0x1BE4;
            break;
        case 0xE:
            idx = 0xF;
            off_CF983 = 0;
            *(int *)(p + 0x40) = 0x69;
            SaveScheduleDB((char *)p);
            break;
        }
        *(int *)(p + 0x40) = idx * 7;
        WriteModeState(postate);
    } else {
        f.aw = f.hw = 0;
        s = p + (++*(int *)(p + 0x40) + 0x444) * 6;
        POSeriesScore(g, &f.hw, &f.aw, &f.home, &f.away);
        if (f.hw == f.aw)
            sprintf((char *)unk_ED7BC, (char *)dword_D288C, (char *)str_Tied, f.hw, f.aw);
        else if (f.hw > f.aw)
            sprintf((char *)unk_ED7BC, (char *)dword_D288C, (char *)teamabbrevs[f.home], f.hw, f.aw);
        else
            sprintf((char *)unk_ED7BC, (char *)dword_D288C, (char *)teamabbrevs[f.away], f.aw, f.hw);
        strcpy((char *)unk_DDCFB, (char *)unk_ED7BC);
    }
    MakePath(f.path, (char *)&curleague, (char *)leaguedbnames[5], (char *)str_extDB);
    sub_932D0(f.path, seasondb, seasondb_size);
    if (seasondb) FreeMemBlock((int)seasondb);
    if (careerdb) FreeMemBlock((int)careerdb);
    if (keydb) FreeMemBlock((int)keydb);
    keydb_size = careerdb_size = seasondb_size = (int)(keydb = careerdb = seasondb = 0);
    if (idx < 0xF) {
        if (w >= 0) {
            if (ctl1side[0] == ctl2side || (ctl2team < 0) ^ (ctl1team[0] < 0)) n = 1;
            else if (ctl1team[0] >= 0 || ctl2team >= 0) n = 2;
            else n = 0;
            if (n == 1) {
                if (w != ctl1team[0] && w != ctl2team) {
                    *(int *)(p + 0x40) = 0x69;
                    off_CF983 = 0;
                    SaveScheduleDB((char *)p);
                    return 1;
                }
            } else if (n == 2) {
                strcpy((char *)msg_POTeamOut_arg, (char *)hmteamrec + f.homewon * 0x2E8 + 5);
                strcpy((char *)msg_POTeamOut_arg2, (char *)hmteamrec + (f.homewon == 0) * 0x2E8 + 5);
                if (w != ctl1team[0]) ctl1team[0] = (ctl1side[0] == 0) - 2;
                else ctl2team = (ctl2side == 0) - 2;
                f.ret = 2;
            }
            *(int *)(p + 0x44) = idx;
            HomeTeam = s[2];
            VisTeam = s[3];
            if (w == ctl1team[0] && ctl1team[0] == ctl2team) {
                if (s[2] == ctl1team[0]) {
                    ctl2side = 0;
                    ctl1side[0] = 0;
                } else {
                    ctl1side[0] = ctl2side = 1;
                }
            } else if (w == ctl1team[0]) {
                if (s[2] == w) {
                    ctl1side[0] = 0;
                    ctl2team = -2;
                    ctl2side = 1;
                } else {
                    ctl1side[0] = 1;
                    ctl2team = -1;
                    ctl2side = 0;
                }
            } else if (w == ctl2team) {
                if (s[2] == ctl2team) {
                    ctl2side = 0;
                    ctl1team[0] = -2;
                    ctl1side[0] = 1;
                } else {
                    ctl2side = 1;
                    ctl1team[0] = -1;
                    ctl1side[0] = 0;
                }
            }
        } else {
            HomeTeam = s[2];
            VisTeam = s[3];
            if (ctl1team[0] == -1) ctl1side[0] = 0;
            else if (ctl1team[0] != -2 && HomeTeam == ctl1team[0]) ctl1side[0] = 0;
            else ctl1side[0] = 1;
            if (ctl2team == -1) ctl2side = 0;
            else if (ctl2team != -2 && HomeTeam == ctl2team) ctl2side = 0;
            else ctl2side = 1;
        }
    }
    return f.ret;
}

/* PlayoffModeLoop (89268, PC only; ends in POSeedRound2_x30): the playoff mode screen. Switch to the playoff mode
   state and stats menu; with a saved game in progress (GAMESAV, *fh open) and the disk space for a game, resume it:
   the next game index (schedgameidx), the music faded out and stopped, the game played with the game stats
   callbacks, then the saved game removed (postate and gameopts bit 15 cleared) and the result posted (POAfterGame)
   when it ended. Then refresh the tree slots and champion, the 26 city names (and "TBA") for the tree, the EMBSCUP
   background and the music, handle an elimination (POHandleElimination) and run the tree menu
   (PlayoffTreeMenu with the human series). Each pass of the menu plays the next game: fade out, check the disk
   space, write the state, open or start GAMESAV (a new game shows the pregame screen; bit 2 of its result skips
   the game), play it, post the result, redraw and handle an elimination. On leaving: free the schedule and
   background, fade out, back to the exhibition mode state. fh: the saved game file handle (-1 for none). Result:
   2. */
int PlayoffModeLoop(int *fh)
{
    struct {
        char path[0x20];
        int sched;
        int stopped;
        int r;
        int pg;
    } f;
    unsigned char *g;
    int pal;
    int i;
    int k;
    int r;

    f.sched = f.stopped = f.r = 0;
    SaveModeState(exhstate);
    LoadModeState(postate);
    SetupStatsSourceMenu(2);
    SetScreenTitle(1);
    if (*fh < 0) {
        MakePath(f.path, (char *)&curleague, (char *)str_GameSav, 0);
        if (FileOpenRead(f.path, fh)) *fh = -1;
    }
    SetDialogColors(0xF9, 0xFA, 0xF8, 0xFA, 0);
    if (*fh >= 0 && !CheckGameDiskSpace()) {
        LoadScheduleDB(&f.sched);
        f.sched += 2;
        schedgameidx = *(int *)(f.sched + 0x40) + 0x444;
        FreeMemBlock(f.sched - 2);
        f.sched = 0;
        if (musicon && songdata) sub_8FCDF(musichandle, 3, 0x64);
        pal = sub_8CCA8((char *)str_Palette, 0x300, 0x20);
        sub_8FFB0(0, 0x100, (unsigned char *)pal);
        FadePalStep(1, (unsigned char *)pal, 0x10);
        FreeMemBlock(pal);
        if (musicon && songdata) {
            while (!sub_8FC8A(musicslot, 3));
            sub_8D2F0(songdata);
            songdata = 0;
            f.stopped = 1;
        }
        ShowLoadingScreen();
        SetSideControls();
        SetupControllers();
        teamstatscb = (int)GameTeamStatsScreen;
        skaterstatscb = (int)GameSkaterStatsScreen;
        goaliestatscb = (int)GameGoalieStatsScreen;
        standingscb = (int)GameStandingsScreen;
        standingsmenucb = (int)GameStandingsMenu;
        PlayGame(fh);
        teamstatscb = (int)EasnTeamStatsScreen;
        skaterstatscb = (int)EasnSkaterStatsScreen;
        goaliestatscb = (int)EasnGoalieStatsScreen;
        standingscb = (int)EasnStandingsScreen;
        standingsmenucb = (int)EasnStandingsMenu;
        scrpitch = 0x50;
        if (!f.sched) {
            LoadScheduleDB(&f.sched);
            f.sched += 2;
        }
        if (gameresult == 1) {
            MakePath(f.path, (char *)&curleague, (char *)str_GameSav, 0);
            if (!FileOpenRead(f.path, fh)) {
                j_unlink(f.path);
                ((unsigned char *)postate)[0x5A] &= 0x7F;
                ((unsigned char *)&gameopts)[1] &= 0x7F;
            }
            f.r = POAfterGame((unsigned char *)f.sched);
            SaveScheduleDB((char *)f.sched);
        }
        pal = sub_8CCA8((char *)str_Palette, 0x300, 0x20);
        sub_8FFB0(0, 0x100, (unsigned char *)pal);
        FadePalStep(1, (unsigned char *)pal, 0x10);
        FreeMemBlock(pal);
        InputInstall();
    }
    if (*fh >= 0) FileClose(fh);
    if (!f.sched) {
        LoadScheduleDB(&f.sched);
        f.sched += 2;
    }
    g = (unsigned char *)f.sched + 0x1998;
    for (i = 0; i < 0x1E; i += 2, g += 0x2A) {
        playofftree[i] = g[2];
        playofftree_p1[i] = g[3];
        if (playofftree[i] == 0xFF) playofftree[i] = 0x1A;
        if (playofftree_p1[i] == 0xFF) playofftree_p1[i] = 0x1A;
    }
    g = (unsigned char *)f.sched + 0x1BE4;
    pochampion = SeriesWinner(g, *(int *)(f.sched + 0x88));
    if (pochampion == -1) pochampion = 0x1A;
    for (i = 0; i < 0x1A; i++) strcpy((char *)treeteamnames + i * 21, (char *)teamcitynames[i]);
    strcpy((char *)treeteamnames + 0x222, (char *)unk_C3A66);
    if (!dword_C65AC) {
        MakePath(f.path, fileoncd[0x8D] == 1 ? (char *)cddriveptr : 0, (char *)str_Embscup, 0);
        dword_C65AC = sub_8E83C(f.path, 0x20);
    }
    if (!f.stopped && musicon) sub_8FCDF(musichandle, 3, 0x64);
    pal = sub_8CCA8((char *)str_Palette, 0x300, 0x20);
    sub_8FFB0(0, 0x100, (unsigned char *)pal);
    FadePalStep(1, (unsigned char *)pal, 0x10);
    FreeMemBlock(pal);
    if (!f.stopped && musicon) {
        while (!sub_8FC8A(musicslot, 3));
        if (songdata) sub_8D2F0(songdata);
        songdata = 0;
    }
    POHandleElimination(f.r, (unsigned char *)f.sched);
    SaveScheduleDB((char *)f.sched);
    k = *(int *)(f.sched + 0x40);
    g = (unsigned char *)f.sched + (k + 0x444) * 6;
    seriesgameno = k % 7;
    if (k / 7 < 0xF) off_CF983 = (int)MenuPlayNextGame;
    else off_CF983 = 0;
    dword_C6D26 = 0;
    DrawMenuBar(unk_CF90F, 3, 0x40, 0x41, 0x42);
    r = PlayoffTreeMenu(unk_CF90F, 3, 0x40, 0x41, 0x42, *(int *)(f.sched + 0x44));
    while (!r) {
        if (dword_C65AC) {
            FreeMemBlock(dword_C65AC);
            dword_C65AC = 0;
        }
        pal = sub_8CCA8((char *)str_Palette, 0x300, 0x20);
        sub_8FFB0(0, 0x100, (unsigned char *)pal);
        FadePalStep(1, (unsigned char *)pal, 0x10);
        SetDialogColors(0x41, 0x40, 0x42, 0x40, 0x43);
        sub_910B0(0);
        sub_B4B88(0, 0x100, (unsigned char *)pal);
        if (!CheckGameDiskSpace()) {
            FadePalStep(1, (unsigned char *)pal, 1);
            FreeMemBlock(pal);
            SetupControllers();
            WriteModeState(postate);
            SaveScheduleDB((char *)f.sched);
            schedgameidx = *(int *)(f.sched + 0x40) + 0x444;
            SetSideControls();
            MakePath(f.path, (char *)&curleague, (char *)str_GameSav, 0);
            if (FileOpenRead(f.path, fh)) {
                *fh = -1;
                InitGameSummary(g[0], g[1]);
                f.pg = PreGameScreen(HomeTeam, VisTeam);
                InputRemove();
            } else {
                f.pg = 0;
                ShowLoadingScreen();
            }
            FreeMemBlock(f.sched - 2);
            f.sched = 0;
            if (!(f.pg & 4)) {
                teamstatscb = (int)GameTeamStatsScreen;
                skaterstatscb = (int)GameSkaterStatsScreen;
                goaliestatscb = (int)GameGoalieStatsScreen;
                standingscb = (int)GameStandingsScreen;
                standingsmenucb = (int)GameStandingsMenu;
                PlayGame(fh);
                teamstatscb = (int)EasnTeamStatsScreen;
                skaterstatscb = (int)EasnSkaterStatsScreen;
                goaliestatscb = (int)EasnGoalieStatsScreen;
                standingscb = (int)EasnStandingsScreen;
                standingsmenucb = (int)EasnStandingsMenu;
            }
            scrpitch = 0x50;
        } else {
            FadePalStep(1, (unsigned char *)pal, 1);
            FreeMemBlock(pal);
            f.pg = 4;
        }
        if (!f.sched) {
            LoadScheduleDB(&f.sched);
            f.sched += 2;
        }
        if (gameresult == 1 && !(f.pg & 4)) {
            f.r = POAfterGame((unsigned char *)f.sched);
            SaveScheduleDB((char *)f.sched);
        } else {
            f.r = 0;
        }
        g = (unsigned char *)f.sched + (*(int *)(f.sched + 0x40) + 0x444) * 6;
        if (!dword_C65AC) {
            MakePath(f.path, fileoncd[0x8D] == 1 ? (char *)cddriveptr : 0, (char *)str_Embscup, 0);
            dword_C65AC = sub_8E83C(f.path, 0x20);
        }
        pal = sub_8CCA8((char *)str_Palette, 0x300, 0x20);
        sub_8FFB0(0, 0x100, (unsigned char *)pal);
        FadePalStep(1, (unsigned char *)pal, 0x10);
        FreeMemBlock(pal);
        dword_C6D26 = 0;
        DrawMenuBar(unk_CF90F, 3, 0x40, 0x41, 0x42);
        InputInstall();
        POHandleElimination(f.r, (unsigned char *)f.sched);
        SaveScheduleDB((char *)f.sched);
        seriesgameno = *(int *)(f.sched + 0x40) % 7;
        r = PlayoffTreeMenu(unk_CF90F, 3, 0x40, 0x41, 0x42, *(int *)(f.sched + 0x44));
    }
    FreeMemBlock(f.sched - 2);
    if (dword_C65AC) {
        FreeMemBlock(dword_C65AC);
        dword_C65AC = 0;
    }
    pal = sub_8CCA8((char *)str_Palette, 0x300, 0x20);
    sub_8FFB0(0, 0x100, (unsigned char *)pal);
    FadePalStep(1, (unsigned char *)pal, 0x10);
    FreeMemBlock(pal);
    SetupStatsSourceMenu(0);
    WriteModeState(postate);
    LoadModeState(exhstate);
    return 2;
}

#define TX(i) (((int *)treecolx)[i])

/* DRAFT: 4,616 vs 4,617 bytes; only the first seed loop differs (i and the playofftree read swap eax / edx);
   see docs/UNSURE.md. */
/* DrawPlayoffTree (8A652, PC only; ends in POSeedRound2_x): draw the playoff tree. The BKGD2 background (rows 13h
   down), the BangPal palette when dword_C6D26 asks for it, the series wins (CountSeriesWins). Before the first
   round is seeded say so ("Playoffs have not been...", Kaufman font, centred). Otherwise the PSTATBAR2 bars, the
   SCUPARRW arrows bank, the title and the two conference captions; then number the first-round teams (seeds in
   dword_C6DBA) and draw each round from the top: the West first round (8 lines in two columns), the West second
   round, the West final, the cup final, the East final, the East second round (mirrored) and the East first round,
   each team as seed letter, city and wins, its wins lit (44h West, C4h East) when it reached the next round, with
   the arrows between rounds once every team of the next round is known. No arguments, no result. */
void DrawPlayoffTree(void)
{
    struct {
        int wins[0x1E];
        char state[0x40];
        char buf[0x20];
        char path[0x10];
    } f;
    int midl;
    int arrows;
    short y;
    int mf;
    int kf;
    int bank;
    int art;
    short i;
    short x;
    short slot;

    midl = 0;
    mf = mainfont;
    kf = kaufmfont;
    sub_B4BC4(0, 0x280, 0x13, 0x1E0);
    sub_913B4(sub_B30B4(dword_C65AC, (char *)str_Bkgd2));
    sub_B4BC4(0, 0x280, 0, 0x1E0);
    if (dword_C6D26 == 1) {
        MakePath(f.path, fileoncd[0x8E] == 1 ? (char *)cddriveptr : 0, (char *)str_Embpal, 0);
        bank = sub_8E83C(f.path, 0);
        sub_B4B88(0, 0x100, (unsigned char *)sub_B30B4(bank, (char *)str_BangPal) + 0x10);
        FreeMemBlock(bank);
        dword_C6D26 = 0;
    }
    CountSeriesWins(playofftree, f.wins, 1);
    SetTextColors(0x40, 0x43);
    if (playofftree[treecolslots[0]] > 0x19) {
        sub_8EA18(kf);
        *(TreeStr34 *)f.buf = *(TreeStr34 *)str_PlayoffsHaveNotBeen;
        PrintOutlinedText(0x140 - (fputchar(f.buf) >> 1), 0xF0, f.buf);
        sub_8EA18(mf);
        return;
    }
    MakePath(f.path, fileoncd[0x13C] == 1 ? (char *)cddriveptr : 0, (char *)str_Pstatbar2, 0);
    bank = sub_8E83C(f.path, 0);
    art = sub_B30B4(bank, (char *)str_Rst1);
    sub_91370(art, 0, 0x1A);
    art = sub_B30B4(bank, (char *)str_Rst2);
    sub_91370(art, 0xF, 0x192);
    FreeMemBlock(bank);
    MakePath(f.path, fileoncd[0x16E] == 1 ? (char *)cddriveptr : 0, (char *)str_Scuparrw, 0);
    arrows = sub_8E83C(f.path, 0);
    TextGridOpen();
    sub_8E9E8(f.state);
    sub_8EA18(mf);
    SetTextColors(0x40, 0x43);
    strcpy(f.buf, (char *)str_POTitle);
    PrintCenteredText(0x16, f.buf);
    sub_8EA18(kf);
    *(TreeStr19 *)f.buf = *(TreeStr19 *)str_WesternConference;
    PrintOutlinedText(0x140 - (fputchar(f.buf) >> 1), 0x2F, f.buf);
    *(TreeStr19 *)f.buf = *(TreeStr19 *)str_EasternConference;
    PrintOutlinedText(0x140 - (fputchar(f.buf) >> 1), 0x1A7, f.buf);
    sub_8EA18(mf);
    for (i = 0; i < 8; i++) {
        if (i < 4) slot = treecolslots[i * 2];
        else slot = treecolslots[7 - (i * 2 - 8)];
        dword_C6DBA[playofftree[slot]] = i;
        if (i < 4) slot = treecol_Er1[i * 2];
        else slot = treecol_Er1[7 - (i * 2 - 8)];
        dword_C6DBA[playofftree[slot]] = i;
    }
    y = 0x48;
    for (i = 0; i < 8; i++) {
        if (i < 4) {
            x = i;
            slot = treecolslots[i * 2];
        } else {
            x = 7 - i;
            slot = treecolslots[7 - (i * 2 - 8)];
        }
        SetTextColors(0x40, 0x43);
        sprintf(f.buf, (char *)str_fmtcsp, dword_C6DBA[playofftree[slot]] + 0x91);
        strcat(f.buf, (char *)treeteamnames + playofftree[slot] * 21);
        PrintShadowText(TX(x), y, f.buf);
        x = TX(x) + 0x6A;
        if (playofftree[treecol_Wr2[0]] == playofftree[slot] || playofftree[treecol_Wr2[1]] == playofftree[slot]
            || playofftree[treecol_Wr2[2]] == playofftree[slot] || playofftree[treecol_Wr2[3]] == playofftree[slot])
            SetTextColors(0x44, 0x43);
        else
            SetTextColors(0x40, 0x43);
        sprintf(f.buf, (char *)str_D, f.wins[slot]);
        PrintShadowText(x, y, f.buf);
        if (i == 3) y += 0x10;
    }
    y += 0x3F;
    if (playofftree[treecol_Wr2[0]] < 0x1A && playofftree[treecol_Wr2[1]] < 0x1A && playofftree[treecol_Wr2[2]] < 0x1A
        && playofftree[treecol_Wr2[3]] < 0x1A) {
        sub_913B4(sub_B30B4(arrows, (char *)str_Aup1));
        for (i = 0; i < 4; i++) {
            if (i < 2) {
                x = i + 4;
                slot = treecol_Wr2[i * 2];
            } else {
                x = 7 - i;
                slot = treecol_Wr2[3 - (i * 2 - 4)];
            }
            SetTextColors(0x40, 0x43);
            sprintf(f.buf, (char *)str_fmtcsp, dword_C6DBA[playofftree[slot]] + 0x91);
            strcat(f.buf, (char *)treeteamnames + playofftree[slot] * 21);
            PrintShadowText(TX(x), y, f.buf);
            x = TX(x) + 0x6A;
            if (playofftree[treecolslots[0x10]] == playofftree[slot] || playofftree[treecolslots[0x11]] == playofftree[slot])
                SetTextColors(0x44, 0x43);
            else
                SetTextColors(0x40, 0x43);
            sprintf(f.buf, (char *)str_D, f.wins[slot]);
            PrintShadowText(x, y, f.buf);
            if (i == 1) y += 0x10;
        }
        y += 0x3D;
        if (playofftree[treecolslots[0x10]] < 0x1A && playofftree[treecolslots[0x11]] < 0x1A) {
            sub_913B4(sub_B30B4(arrows, (char *)str_Aup2));
            slot = treecolslots[0x10];
            SetTextColors(0x40, 0x43);
            sprintf(f.buf, (char *)str_fmtcsp, dword_C6DBA[playofftree[slot]] + 0x91);
            strcat(f.buf, (char *)treeteamnames + playofftree[slot] * 21);
            PrintShadowText(0x48, y - 1, f.buf);
            if (playofftree[treecolslots[0x18]] == playofftree[slot] || playofftree[treecolslots[0x28]] == playofftree[slot])
                SetTextColors(0x44, 0x43);
            else
                SetTextColors(0x40, 0x43);
            sprintf(f.buf, (char *)str_D, f.wins[slot]);
            PrintShadowText(0xB2, y - 1, f.buf);
            slot = treecolslots[0x11];
            y += 0x10;
            SetTextColors(0x40, 0x43);
            sprintf(f.buf, (char *)str_fmtcsp, dword_C6DBA[playofftree[slot]] + 0x91);
            strcat(f.buf, (char *)treeteamnames + playofftree[slot] * 21);
            PrintShadowText(0x48, y - 1, f.buf);
            if (playofftree[treecolslots[0x18]] == playofftree[slot] || playofftree[treecolslots[0x28]] == playofftree[slot])
                SetTextColors(0x44, 0x43);
            else
                SetTextColors(0x40, 0x43);
            sprintf(f.buf, (char *)str_D, f.wins[slot]);
            PrintShadowText(0xB2, y - 1, f.buf);
            y -= 0x10;
        }
    } else {
        y += 0x4D;
    }
    if (playofftree[treecolslots[0x18]] < 0x1A) {
        sub_913B4(sub_B30B4(arrows, (char *)str_Aup3));
        midl = 1;
        sub_913B4(sub_B30B4(arrows, (char *)str_Midl));
        SetTextColors(0x40, 0x43);
        *(TreeStr3 *)f.buf = *(TreeStr3 *)unk_C3AF8;
        slot = treecolslots[0x18];
        strcat(f.buf, (char *)treeteamnames + playofftree[treecolslots[0x18]] * 21);
        PrintShadowText(0x102, y - 4, f.buf);
        sprintf(f.buf, (char *)str_D, f.wins[slot]);
        if (playofftree[treecolslots[0x20]] == playofftree[slot]) {
            if (teamconf[slot] == 3) SetTextColors(0x44, 0x43);
            else SetTextColors(0xC4, 0x43);
        } else {
            SetTextColors(0x40, 0x43);
        }
        PrintShadowText(0x16C, y - 4, f.buf);
    }
    if (playofftree[treecolslots[0x28]] < 0x1A) {
        sub_913B4(sub_B30B4(arrows, (char *)str_Adn3));
        if (!midl) sub_913B4(sub_B30B4(arrows, (char *)str_Midl));
        y += 0x10;
        SetTextColors(0x40, 0x43);
        *(TreeStr3 *)f.buf = *(TreeStr3 *)unk_C3AF8;
        slot = treecolslots[0x28];
        strcat(f.buf, (char *)treeteamnames + playofftree[treecolslots[0x28]] * 21);
        PrintShadowText(0x102, y - 4, f.buf);
        sprintf(f.buf, (char *)str_D, f.wins[slot]);
        if (playofftree[treecolslots[0x20]] == playofftree[slot]) {
            if (teamconf[slot] == 3) SetTextColors(0x44, 0x43);
            else SetTextColors(0xC4, 0x43);
        } else {
            SetTextColors(0x40, 0x43);
        }
        PrintShadowText(0x16C, y - 4, f.buf);
        y -= 0x10;
    }
    if (playofftree[treecolslots[0x30]] < 0x1A && playofftree[treecolslots[0x31]] < 0x1A) {
        slot = treecolslots[0x30];
        SetTextColors(0x40, 0x43);
        sprintf(f.buf, (char *)str_fmtcsp, dword_C6DBA[playofftree[slot]] + 0x91);
        strcat(f.buf, (char *)treeteamnames + playofftree[slot] * 21);
        PrintShadowText(0x1C6, y - 1, f.buf);
        if (playofftree[treecolslots[0x18]] == playofftree[slot] || playofftree[treecolslots[0x28]] == playofftree[slot])
            SetTextColors(0xC4, 0x43);
        else
            SetTextColors(0x40, 0x43);
        sprintf(f.buf, (char *)str_D, f.wins[slot]);
        PrintShadowText(0x230, y - 1, f.buf);
        slot = treecolslots[0x31];
        y += 0x10;
        SetTextColors(0x40, 0x43);
        sprintf(f.buf, (char *)str_fmtcsp, dword_C6DBA[playofftree[slot]] + 0x91);
        strcat(f.buf, (char *)treeteamnames + playofftree[slot] * 21);
        PrintShadowText(0x1C6, y - 1, f.buf);
        if (playofftree[treecolslots[0x18]] == playofftree[slot] || playofftree[treecolslots[0x28]] == playofftree[slot])
            SetTextColors(0xC4, 0x43);
        else
            SetTextColors(0x40, 0x43);
        sprintf(f.buf, (char *)str_D, f.wins[slot]);
        PrintShadowText(0x230, y - 1, f.buf);
        y += 0x3D;
        sub_913B4(sub_B30B4(arrows, (char *)str_Adn2));
    } else {
        y += 0x4D;
    }
    if (playofftree[treecol_Er2[0]] < 0x1A && playofftree[treecol_Er2[1]] < 0x1A && playofftree[treecol_Er2[2]] < 0x1A
        && playofftree[treecol_Er2[3]] < 0x1A) {
        for (i = 0; i < 4; i++) {
            if (i < 2) x = i;
            else x = 3 - i;
            if (i < 2) slot = treecol_Er2[i * 2];
            else slot = treecol_Er2[3 - (i * 2 - 4)];
            SetTextColors(0x40, 0x43);
            sprintf(f.buf, (char *)str_fmtcsp, dword_C6DBA[playofftree[slot]] + 0x91);
            strcat(f.buf, (char *)treeteamnames + playofftree[slot] * 21);
            PrintShadowText(0x280 - (TX(5 - x) + 0x64), y, f.buf);
            x = 0x286 - TX(5 - x);
            if (playofftree[treecolslots[0x30]] == playofftree[slot] || playofftree[treecolslots[0x31]] == playofftree[slot])
                SetTextColors(0xC4, 0x43);
            else
                SetTextColors(0x40, 0x43);
            sprintf(f.buf, (char *)str_D, f.wins[slot]);
            PrintShadowText(x, y, f.buf);
            if (i == 1) y += 0x10;
        }
        y += 0x3D;
        sub_913B4(sub_B30B4(arrows, (char *)str_Adn1));
    } else {
        y += 0x4D;
    }
    for (i = 0; i < 8; i++) {
        if (i < 4) {
            x = i;
            slot = treecol_Er1[i * 2];
        } else {
            x = 7 - i;
            slot = treecol_Er1[7 - (i * 2 - 8)];
        }
        SetTextColors(0x40, 0x43);
        sprintf(f.buf, (char *)str_fmtcsp, dword_C6DBA[playofftree[slot]] + 0x91);
        strcat(f.buf, (char *)treeteamnames + playofftree[slot] * 21);
        PrintShadowText(TX(x), y, f.buf);
        x = TX(x) + 0x6A;
        if (playofftree[treecol_Er2[0]] == playofftree[slot] || playofftree[treecol_Er2[1]] == playofftree[slot]
            || playofftree[treecol_Er2[2]] == playofftree[slot] || playofftree[treecol_Er2[3]] == playofftree[slot])
            SetTextColors(0xC4, 0x43);
        else
            SetTextColors(0x40, 0x43);
        sprintf(f.buf, (char *)str_D, f.wins[slot]);
        PrintShadowText(x, y, f.buf);
        if (i == 3) y += 0x10;
    }
    TextGridOff();
    FreeMemBlock(arrows);
    sub_8EA00(f.state);
}
