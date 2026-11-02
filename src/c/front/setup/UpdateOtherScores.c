/* Game setup: other-game simulation and the end-of-game team stats screen. */
#define sub_913D0 sub_913D0_decl
#define sub_8F13B sub_8F13B_decl
#define sub_8F1FE sub_8F1FE_decl
#define sub_8F98F sub_8F98F_decl
#define sub_8FB8E sub_8FB8E_decl
#include "nhl95.h"
#undef sub_913D0
#undef sub_8F13B
#undef sub_8F1FE
#undef sub_8F98F
#undef sub_8FB8E

void __cdecl sub_913D0(int shape, int x, int y);
void *sub_8F13B(char *path);
void sub_8F1FE(void *smp);
int sub_8F98F(char *path);
void sub_8FB8E(int song, int handle, int a, int b);

#define TS(off) (*(short *)((char *)&hmtmstruct + t + (off)))

/* UpdateOtherScores - advance the six other games to the home team's period (period plus the difference of the
   start lags, teamstartlag, of the home team and the game's first team): for each period reached a game below the
   3rd scores 0-2 goals per team; at period 4 (overtime) a tied game goes on (4) and a team wins with a 30% chance
   each (5, one goal more), otherwise it is over (6); period 5 ends an overtime game. */
void UpdateOtherScores(int period)
{
    int i;
    int last;
    int p;

    for (i = 0; i < 6; i++) {
        last = teamstartlag[*(int *)((char *)&HomeTeam - 2) >> 16] - teamstartlag[othergames[i * 2]];
        last += period;
        if (last < otherperiod[i]) continue;
        for (p = otherperiod[i]; p <= last; p++) {
            if (p == 4) {
                if (otherscores[i * 2] == otherscoresb[i * 2]) {
                    otherperiod[i] = p;
                    if ((rand() & 0x7FFF) % 100 > 70) {
                        otherperiod[i] = 5;
                        otherscores[i * 2]++;
                    } else if ((rand() & 0x7FFF) % 100 > 70) {
                        otherperiod[i] = 5;
                        otherscoresb[i * 2]++;
                    }
                } else {
                    otherperiod[i] = 6;
                }
            } else if (p == 5 && otherperiod[i] == 4) {
                otherperiod[i] = 5;
            } else if (otherperiod[i] < 3 && p != otherperiod[i]) {
                otherperiod[i] = p;
                otherscores[i * 2] += (rand() & 0x7FFF) % 3;
                otherscoresb[i * 2] += (rand() & 0x7FFF) % 3;
            }
        }
    }
}

/* GameStatsScreen (2F5EE, PC only; ends in UpdateOtherScores_x): the team stats screen after a game. Black out
   the palette, draw the CTBKGD3 background and the CTTITLE3 columns, then the 12 row labels (gamestatlabels) and
   for both teams the crest, the name and the column of game stats from the team structures (score, shots, power
   plays, times as m:ss, passes and the completion percentage), centred on the column. Play the LEAGUETM song (or
   the summary sample), fade in, wait up to 2000 ticks for a click and fade out. No arguments, no result. */
void GameStatsScreen(void)
{
    struct {
        unsigned char pal[0x300];
        char text[0x40];
        char buf[0x14];
        int teams[2];
    } s;
    int shape;
    int logos;
    int cx;
    int y;
    int col;
    void *smp;
    int i;
    int t;
    int bank;
    char *name;
    int slot;
    int x;
    int m;
    int width;

    s.teams[0] = HomeTeam;
    s.teams[1] = VisTeam;
    ClearInputQueue();
    sub_B4BA8();
    sub_B392C(0);
    s.buf[2] = s.buf[1] = s.buf[0] = 0;
    for (i = 0; i < 0x100; i++) sub_B4B88(i, 1, s.buf);
    MakePath(s.buf, fileoncd[0x58] == 1 ? (char *)cddriveptr : 0, (char *)str_Ctbkgd3, 0);
    bank = sub_8E83C(s.buf, 0);
    memcpy(s.pal, (unsigned char *)sub_B30B4(bank, (char *)str_Pal14) + 0x10, 0x300);
    sub_913B4(sub_B30B4(bank, (char *)str_Bkgd6));
    FreeMemBlock(bank);
    MakePath(s.buf, fileoncd[0x5C] == 1 ? (char *)cddriveptr : 0, (char *)str_Cttitle32, 0);
    bank = sub_8E83C(s.buf, 0);
    sub_913B4(sub_B30B4(bank, (char *)str_Colm2));
    sub_913B4(sub_B30B4(bank, (char *)str_Gsta));
    FreeMemBlock(bank);
    MakePath(s.buf, fileoncd[0x59] == 1 ? (char *)cddriveptr : 0, (char *)str_Ctlogo3, 0);
    logos = sub_8E83C(s.buf, 0);
    sub_8E9E8(s.text);
    sub_8EA18(kaufmfont);
    SetTextColors(0x40, 0);
    y = 0xB0;
    for (i = 0; i < 0xC; i++) {
        x = (0x26C - fputchar((char *)gamestatlabels[i])) / 2;
        PrintShadowText(x, y, (char *)gamestatlabels[i]);
        y += 0x18;
    }
    for (i = 0; i < 2; i++) {
        shape = sub_B30B4(logos, (char *)crestnames[s.teams[i]]);
        sub_913D0(shape, i ? 0x212 : 0x40, 0x4E);
        col = i * 455;
        name = (char *)hmteamrec + i * 0x2E8 + 0x1A;
        width = fputchar(name) >> 1;
        cx = col + 0x49;
        PrintShadowText(cx - width, 0x8A, name);
        t = i << 8;
        sprintf(s.buf, (char *)str_D7, TS(0x10));
        PrintClampedText(cx - (fputchar(s.buf) >> 1), 0xB0, s.buf);
        sprintf(s.buf, (char *)str_D7, TS(0));
        PrintClampedText(cx - (fputchar(s.buf) >> 1), 0xC8, s.buf);
        sprintf(s.buf, (char *)str_D7, TS(0x18));
        PrintClampedText(cx - (fputchar(s.buf) >> 1), 0xE0, s.buf);
        sprintf(s.buf, (char *)str_DD, TS(2), TS(4));
        PrintClampedText(cx - (fputchar(s.buf) >> 1), 0xF8, s.buf);
        x = TS(8);
        m = x / 60;
        sprintf(s.buf, (char *)str_D02d2, m, x % 60);
        PrintClampedText(cx - (fputchar(s.buf) >> 1), 0x110, s.buf);
        sprintf(s.buf, (char *)str_D7, TS(6));
        PrintClampedText(cx - (fputchar(s.buf) >> 1), 0x128, s.buf);
        sprintf(s.buf, (char *)str_DD, TS(0xA), TS(0xC));
        PrintClampedText(cx - (fputchar(s.buf) >> 1), 0x140, s.buf);
        sprintf(s.buf, (char *)str_D7, TS(0x12));
        PrintClampedText(cx - (fputchar(s.buf) >> 1), 0x158, s.buf);
        sprintf(s.buf, (char *)str_D7, TS(0x14));
        PrintClampedText(cx - (fputchar(s.buf) >> 1), 0x170, s.buf);
        sprintf(s.buf, (char *)str_D7, TS(0x24));
        PrintClampedText(cx - (fputchar(s.buf) >> 1), 0x188, s.buf);
        x = TS(0xE);
        m = x / 60;
        sprintf(s.buf, (char *)str_D02d2, m, x % 60);
        PrintClampedText(cx - (fputchar(s.buf) >> 1), 0x1A0, s.buf);
        m = 0;
        y = 0x1B8;
        if (TS(0x26)) m = TS(0x28) * 100 / TS(0x26);
        sprintf(s.buf, (char *)str_DDD, *(short *)((char *)&hmtmstruct + (i << 8) + 0x28),
            *(short *)((char *)&hmtmstruct + (i << 8) + 0x26), m);
        PrintClampedText(i * 455 + 0x49 - (fputchar(s.buf) >> 1), y, s.buf);
    }
    if (musicon) {
        if (songdata) {
            sub_8FCDF(musichandle, 3, 0x28);
            SetTickDeadline(0x28);
            WaitTickDeadline();
            sub_8D2F0(songdata);
            songdata = 0;
        }
        MusicChanCmd3();
        MakePath(s.buf, fileoncd[0x1E0] == 1 ? (char *)cddriveptr : 0, (char *)str_Leaguetm, (char *)str_Iff7);
        songdata = sub_8F98F(s.buf);
        if (songdata && gameopts.music) sub_8FB8E(songdata, musichandle, 3, 0x7F);
    } else {
        if (sounddev == 8)
            MakePath(s.buf, fileoncd[0x102] == 1 ? (char *)cddriveptr : 0, (char *)str_Mtsum2, 0);
        else
            MakePath(s.buf, fileoncd[0x21] == 1 ? (char *)cddriveptr : 0, (char *)str_Adsum2, 0);
        dword_CCC94 = 0x20;
        smp = sub_8F13B(s.buf);
        dword_CCC94 = 0;
        PlayDigiSample(smp);
    }
    FadePalStep(0, s.pal, 0x10);
    WaitClickTimeout(2000);
    if (musicon && songdata) sub_8FCDF(musichandle, 3, 0x64);
    FadePalStep(1, s.pal, 0x10);
    if (musicon) {
        if (songdata) {
            do
                slot = musicslot;
            while (sub_8FC8A(slot, 3) == 0);
            sub_8D2F0(songdata);
            songdata = 0;
        }
    } else {
        StopDigiSample();
        sub_8F1FE(smp);
    }
    sub_8EA00(s.text);
    FreeMemBlock(logos);
}
