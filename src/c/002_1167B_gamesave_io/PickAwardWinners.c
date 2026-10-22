/* Game save I/O: pick the season's award winners. */
/* DrawAwardsSummary, AwardsCeremony and ShowAwardScreens end in its PickAwardWinners_x. Three of the award-9 sums
   read one word into a block int first: that is the EXE's load order. */
/* DRAFT (PickAwardWinners, 10.0 GA): 2 bytes longer, every other instruction the EXE's (the locals declared err, v,
   mine, g, pct, st, pts and the two `mine` sums reordered). Left: the win percentage divisor loads the losses byte
   into eax and adds with `lea esi, [edx+eax]`; the EXE loads it straight into esi (`movzx esi, byte [esp+2Ah]` /
   `add esi, edx`). See docs/UNSURE.md. */
#define PickAwardWinners PickAwardWinners_decl
#define ShowAwardScreens ShowAwardScreens_decl
#define sub_9035C sub_9035C_decl
#include "nhl95.h"
#undef PickAwardWinners
#undef ShowAwardScreens
#undef sub_9035C
int PickAwardWinners(void);
int ShowAwardScreens(void);
int __cdecl sub_9035C(int bank, int n);  /* graphics library: frame n of a bank */
int strnicmp(const char *a, const char *b, unsigned n);  /* Watcom CRT strnicmp_ */
void __STOSB(void *p, int v, int n);  /* Watcom memset helper: the EXE clears the award flags with it */
#pragma aux __STOSB "__STOSB" parm [eax] [edx] [ecx];

typedef struct TeamRec { unsigned char b[0x2E8]; } TeamRec;        /* league team record */
typedef struct KeyRec { unsigned char b[0x34]; } KeyRec;           /* player key record (+2 position letter, +2Ch season record) */
typedef struct SeasonRec {
    unsigned short gp;            /* 00 games */
    unsigned short goals;         /* 02 */
    unsigned short s04;
    unsigned short points;        /* 06 */
    unsigned char p08[8];
    short plusminus;              /* 10 */
    unsigned short s12;           /* 12 */
    unsigned char p14[4];
    unsigned short s18;           /* 18 */
    unsigned char p1A[0xE];
    unsigned short s28, s2A, s2C; /* 28 2A 2C: summed for award 9 */
    unsigned char rookie;         /* 2E */
} SeasonRec;                      /* skater season record, 2Fh bytes */
typedef struct GSeasonRec {
    unsigned short gp;            /* 00 games */
    unsigned short g2;            /* 02 */
    unsigned char p04[8];
    unsigned short g0C;           /* 0C */
    unsigned char p0E[2];
    unsigned short g10;           /* 10 */
    unsigned char p12[2];
    unsigned short g14;           /* 14 */
    unsigned char p16[0x1A];
    unsigned short g30, g32, g34; /* 30 32 34: summed for award 9 */
} GSeasonRec;                     /* goalie season record, 36h bytes */
#define AWST(n) (((unsigned char **)off_C524F)[n])   /* stats record of award n's winner */
#define AWKEY(n) (((KeyRec *)awardwinners)[n])       /* key record of award n's winner */


/* PickAwardWinners (1205D, PC only): pick the season's award winners from the league DBs (team, key and season
   files of curleague; the team names first). Per team: the Presidents' Trophy team (presidentsteam: most points,
   then the better win percentage, then more wins) and the cup team (cupteam: most of team byte 3Bh). Per skater on
   the roster (key indexes at +4Ch) with games: award 0 most goals, 1 most points, 2 most points by a defenceman,
   3 the best +/- (word 10h) of a forward, 6 most points by a rookie (season byte 2Eh, not a goalie), 8 most of
   word 18h (then the fewest of word 12h), ties to fewer games; per goalie (key indexes at +B0h): award 4 most of
   word 2 (then the most of word 14h), 5 with 19h games the lowest word 10h (then the most of word 0Ch). Award 9
   goes to the best sum of words 28h-2Ch (skaters) or 30h-34h (goalies), fewer games on a tie; it keeps the
   winner's record in unk_D98C3 / unk_D9794 and awardtype[9] says which (a goalie winner keeps the last skater's
   key, as in the EXE). Each winner's key record goes to awardwinners[n], the stats to *off_C524F[n]. Returns the
   first error (0 = ok). */
int PickAwardWinners(void)
{
    struct {
        TeamRec team;
        GSeasonRec gseason;
        char pad0[2];
        KeyRec gkey;
        KeyRec key;
        SeasonRec season;
        char pad1;
        char path[0x20];
        unsigned char found[0xB];
        char pad2;
        int cupbest;
        int pctbest;
        int ptsbest;
        int sfh;
        int kfh;
        int tfh;
        int i;
    } f;
    int err;
    int v;
    int mine;
    unsigned short g;
    int pct;
    unsigned char *st;
    int pts;

    f.sfh = f.kfh = f.tfh = -1;
    MakePath(f.path, (char *)&curleague, (char *)leaguedbnames[4], (char *)str_extDB);
    err = ReadTeamNames(f.path, (char *)treeteamnames, 1);
    if (!err) {
        MakePath(f.path, (char *)&curleague, (char *)leaguedbnames[4], (char *)str_extDB);
        err = FileOpenRead(f.path, &f.tfh);
    }
    if (!err) {
        MakePath(f.path, (char *)&curleague, (char *)leaguedbnames[0], (char *)str_extDB);
        err = FileOpenRead(f.path, &f.kfh);
    }
    if (!err) {
        MakePath(f.path, (char *)&curleague, (char *)leaguedbnames[5], (char *)str_extDB);
        err = FileOpenRead(f.path, &f.sfh);
    }
    __STOSB(f.found, 0, sizeof f.found);
    for (f.i = 0; f.i < 0x1A && !err; f.i++) {
        err = ReadTeamRec(f.tfh, &f.team, f.i);
        pts = f.team.b[0x29] * 2 + f.team.b[0x2B];
        if (!f.team.b[0x29] && !f.team.b[0x2A]) pct = 0;
        else pct = f.team.b[0x29] * 100 / (f.team.b[0x29] + f.team.b[0x2A]);
        if (!f.found[7] || pts > f.ptsbest || pts == f.ptsbest && pct > f.pctbest
            || pts == f.ptsbest && pct == f.pctbest && f.team.b[0x29] > presidentsteam[0x29]) {
            *(TeamRec *)presidentsteam = f.team;
            f.ptsbest = pts;
            f.pctbest = pct;
            f.found[7] = 0xFF;
        }
        if (!f.found[0xA] || f.team.b[0x3B] > f.cupbest) {
            *(TeamRec *)cupteam = f.team;
            f.cupbest = f.team.b[0x3B];
            f.found[0xA] = 0xFF;
        }
        for (pts = 0; pts < 0x19 && !err; pts++) {
            v = ((int *)&f.team.b[0x4C])[pts];
            if (v == -1) continue;
            err = ReadKeyRec(f.kfh, &f.key, v);
            if (!err) err = ReadSeasonRec(f.sfh, &f.season, *(int *)&f.key.b[0x2C]);
            if (err || f.season.gp <= 0) continue;
            st = AWST(0);
            if (!f.found[0] || f.season.goals > ((SeasonRec *)st)->goals || f.season.goals == ((SeasonRec *)st)->goals && f.season.gp < ((SeasonRec *)st)->gp) {
                AWKEY(0) = f.key;
                *(SeasonRec *)st = f.season;
                f.found[0] = 0xFF;
            }
            st = AWST(1);
            if (!f.found[1] || f.season.points > ((SeasonRec *)st)->points || f.season.points == ((SeasonRec *)st)->points && f.season.gp < ((SeasonRec *)st)->gp) {
                AWKEY(1) = f.key;
                *(SeasonRec *)st = f.season;
                f.found[1] = 0xFF;
            }
            if (f.key.b[2] == 'D') {
                st = AWST(2);
                if (!f.found[2] || f.season.points > ((SeasonRec *)st)->points || f.season.points == ((SeasonRec *)st)->points && f.season.gp < ((SeasonRec *)st)->gp) {
                    AWKEY(2) = f.key;
                    *(SeasonRec *)st = f.season;
                    f.found[2] = 0xFF;
                }
            }
            if (f.key.b[2] == 'L' || f.key.b[2] == 'R' || f.key.b[2] == 'C') {
                st = AWST(3);
                if (!f.found[3] || f.season.plusminus > ((SeasonRec *)st)->plusminus || f.season.plusminus == ((SeasonRec *)st)->plusminus && f.season.gp < ((SeasonRec *)st)->gp) {
                    AWKEY(3) = f.key;
                    *(SeasonRec *)st = f.season;
                    f.found[3] = 0xFF;
                }
            }
            if (f.key.b[2] != 'G' && f.season.rookie) {
                st = AWST(6);
                if (!f.found[6] || f.season.points > ((SeasonRec *)st)->points || f.season.points == ((SeasonRec *)st)->points && f.season.gp < ((SeasonRec *)st)->gp) {
                    AWKEY(6) = f.key;
                    *(SeasonRec *)st = f.season;
                    f.found[6] = 0xFF;
                }
            }
            st = AWST(8);
            if (!f.found[8] || f.season.s18 > ((SeasonRec *)st)->s18 || f.season.s18 == ((SeasonRec *)st)->s18 && f.season.s12 < ((SeasonRec *)st)->s12) {
                AWKEY(8) = f.key;
                *(SeasonRec *)st = f.season;
                f.found[8] = 0xFF;
            }
            if (awardtype[9] == 1) {
                st = AWST(9);
                v = ((SeasonRec *)st)->s2C + (((SeasonRec *)st)->s28 + ((SeasonRec *)st)->s2A);
            } else {
                st = AWST(9);
                v = ((GSeasonRec *)st)->g34 + (((GSeasonRec *)st)->g30 + ((GSeasonRec *)st)->g32);
            }
            g = ((SeasonRec *)st)->gp;
            {
                int a;

                a = f.season.s28;
                mine = f.season.s2C + (f.season.s2A + a);
            }
            if (!f.found[9] || mine > v || mine == v && g > f.season.gp) {
                AWKEY(9) = f.key;
                *(SeasonRec *)unk_D98C3 = f.season;
                AWST(9) = unk_D98C3;
                awardtype[9] = 1;
                f.found[9] = 0xFF;
            }
        }
        for (pts = 0; pts < 3 && !err; pts++) {
            v = ((int *)&f.team.b[0xB0])[pts];
            if (v == -1) continue;
            err = ReadKeyRec(f.kfh, &f.gkey, v);
            if (!err) err = ReadGoalieSeasonRec(f.sfh, &f.gseason, *(int *)&f.gkey.b[0x2C]);
            if (err || f.gseason.gp <= 0) continue;
            st = AWST(4);
            if (!f.found[4] || f.gseason.g2 > ((GSeasonRec *)st)->g2 || f.gseason.g2 == ((GSeasonRec *)st)->g2 && f.gseason.g14 > ((GSeasonRec *)st)->g14) {
                AWKEY(4) = f.gkey;
                *(GSeasonRec *)st = f.gseason;
                f.found[4] = 0xFF;
            }
            st = AWST(5);
            if (f.gseason.gp >= 0x19
                && (!f.found[5] || f.gseason.g10 < ((GSeasonRec *)st)->g10 || f.gseason.g10 == ((GSeasonRec *)st)->g10 && f.gseason.g0C > ((GSeasonRec *)st)->g0C)) {
                AWKEY(5) = f.gkey;
                *(GSeasonRec *)st = f.gseason;
                f.found[5] = 0xFF;
            }
            if (awardtype[9] == 1) {
                st = AWST(9);
                {
                    int a;

                    a = ((SeasonRec *)st)->s28;
                    v = ((SeasonRec *)st)->s2C + (((SeasonRec *)st)->s2A + a);
                }
            } else {
                st = AWST(9);
                v = ((GSeasonRec *)st)->g30 + ((GSeasonRec *)st)->g32 + ((GSeasonRec *)st)->g34;
            }
            g = ((GSeasonRec *)st)->gp;
            {
                int a;

                a = f.gseason.g30;
                mine = a + f.gseason.g32 + f.gseason.g34;
            }
            if (!f.found[9] || mine > v || mine == v && g > f.gseason.gp) {
                AWKEY(9) = f.key;
                *(GSeasonRec *)unk_D9794 = f.gseason;
                AWST(9) = unk_D9794;
                awardtype[9] = 0;
                f.found[9] = 0xFF;
            }
        }
    }
    FileClose(&f.sfh);
    FileClose(&f.kfh);
    FileClose(&f.tfh);
    return err;
}

typedef struct { char c[25]; } Str25;

/* ShowAwardScreens (12849, PC only; ends in PickAwardWinners_x): show the award screens, one for each of the 11
   awards until a key 3 (WaitClickTimeout) ends them: the award art (awardart, from the CD when listed) in the
   award's text colours, then for a team award (awardtype 2) the Cup or Presidents trophy team, else the winner's
   name and team (Mighty Ducks for ANA; suffix C03C4 for teams 2, 18h, 19h) and two rows (season, playoffs) of the
   winner's goalie (type 0: GP, Min, GAA m:ss, W, L, T, SO in the season row, EN, shots, save percentage) or
   skater stats (type 1: GP, G, A, Pt, PIM, +/-, PPG, SHG, shots, shooting percentage); the award's two title
   lines at the bottom, a palette fade in and out (PALMEM). Result: the last WaitClickTimeout answer. */
int ShowAwardScreens(void)
{
    char buf[0x2C];
    int bank;
    unsigned short *ss;
    unsigned short *gs;
    int k;
    int j;
    int key;
    int x;
    int y;
    unsigned char *w;
    unsigned short *s;
    int pct;
    int pal;

    key = 0;
    ClearInputQueue();
    for (k = key; k < 0xB && key != 3; k++) {
        SetTextColors(dword_C513C[k], 0);
        GetTicks();
        MakePath(buf, fileoncd[dword_C5168[k]] == 1 ? (char *)cddriveptr : 0, (char *)awardart[k], 0);
        bank = sub_8E83C(buf, 0);
        sub_9061C(sub_9035C(bank, 1));
        y = 0x76;
        if (awardtype[k] == 2) {
            strcpy(buf, k == 0xA ? (char *)cupteam : (char *)presidentsteam);
            if (!strnicmp(buf, (char *)str_ANA, 3)) {
                x = 0x1FE - (fputchar((char *)str_MightyDucks) >> 1);
                PrintShadowText(x, y, (char *)str_MightyDucks);
            } else {
                strcpy(buf, k == 0xA ? (char *)cupteam + 5 : (char *)presidentsteam + 5);
                if (!strnicmp(buf, (char *)str_Cal, 3) || !strnicmp(buf, (char *)str_Flo, 3))
                    strcat(buf, (char *)unk_C03C4);
                else
                    strcat(buf, (char *)unk_C03C6);
                x = 0x1FE - (fputchar(buf) >> 1);
                PrintShadowText(x, y, buf);
            }
        } else {
            w = awardwinners + k * 0x34;
            sprintf(buf, (char *)str_SS, w + 3, w + 0x13);
            x = 0x1FE - (fputchar(buf) >> 1);
            PrintShadowText(x, y, buf);
            strcpy(buf, (char *)treeteamnames + awardwinners[k * 0x34] * 21);
            if (!strnicmp(buf, (char *)str_ANA, 3)) {
                *(Str25 *)buf = *(Str25 *)str_MightyDucks;
            } else if (awardwinners[k * 0x34] == 2 || awardwinners[k * 0x34] == 0x18 || awardwinners[k * 0x34] == 0x19) {
                strcat(buf, (char *)unk_C03C4);
            } else {
                strcat(buf, (char *)unk_C03C6);
            }
            x = 0x1FE - (fputchar(buf) >> 1);
            y += byte_D42C3;
            PrintShadowText(x, y, buf);
            x = 0x1A4;
            y += 0x2C;
            if (awardtype[k] == 0) {
                PrintShadowText(x, y, (char *)str_GP);
                PrintShadowText(x, y + byte_D42C3, (char *)str_Min);
                PrintShadowText(x, y + byte_D42C3 * 2, (char *)str_GAA);
                PrintShadowText(x, y + byte_D42C3 * 3, (char *)str_W);
                PrintShadowText(x, y + byte_D42C3 * 4, (char *)str_L);
                PrintShadowText(x, y + byte_D42C3 * 5, (char *)str_T);
                PrintShadowText(x, y + byte_D42C3 * 6, (char *)str_SO);
                PrintShadowText(x, y + byte_D42C3 * 7, (char *)str_EN);
                PrintShadowText(x, y + byte_D42C3 * 8, (char *)str_Shots);
                PrintShadowText(x, y + byte_D42C3 * 9, (char *)str_Pct);
                s = ss = (unsigned short *)off_C524F[k];
                for (j = 0; j < 2; j++) {
                    PrintShadowText((x += 0x50) - 0x1C, y - byte_D42C3, (char *)off_C527B[j]);
                    PrintFmt1(x, y, (char *)str_fmtpd, s[0]);
                    PrintFmt1(x, y + byte_D42C3, (char *)str_fmtpd, s[6]);
                    PrintFmt2(x, y + byte_D42C3 * 2, (char *)str_D02d, s[8] / 100, s[8] % 100);
                    PrintFmt1(x, y + byte_D42C3 * 3, (char *)str_fmtpd, s[1]);
                    PrintFmt1(x, y + byte_D42C3 * 4, (char *)str_fmtpd, s[2]);
                    if (j == 0) PrintFmt1(x, y + byte_D42C3 * 5, (char *)str_fmtpd, s[3]);
                    PrintFmt1(x, y + byte_D42C3 * 6, (char *)str_fmtpd, s[4]);
                    PrintFmt1(x, y + byte_D42C3 * 7, (char *)str_fmtpd, s[5]);
                    PrintFmt1(x, y + byte_D42C3 * 8, (char *)str_fmtpd, s[9]);
                    PrintFmt2(x, y + byte_D42C3 * 9, (char *)str_D01d, s[10] / 10, s[10] % 10);
                    s = (unsigned short *)((char *)ss + 0x16);
                }
            } else if (awardtype[k] == 1) {
                PrintShadowText(x, y, (char *)str_GP);
                PrintShadowText(x, y + byte_D42C3, (char *)str_G);
                PrintShadowText(x, y + byte_D42C3 * 2, (char *)str_A);
                PrintShadowText(x, y + byte_D42C3 * 3, (char *)str_Pt);
                PrintShadowText(x, y + byte_D42C3 * 4, (char *)str_PIM);
                PrintShadowText(x, y + byte_D42C3 * 5, (char *)str_PlusMinus);
                PrintShadowText(x, y + byte_D42C3 * 6, (char *)str_PPG);
                PrintShadowText(x, y + byte_D42C3 * 7, (char *)str_SHG);
                PrintShadowText(x, y + byte_D42C3 * 8, (char *)str_Shots);
                PrintShadowText(x, y + byte_D42C3 * 9, (char *)str_Pct);
                s = gs = (unsigned short *)off_C524F[k];
                for (j = 0; j < 2; j++) {
                    PrintShadowText((x += 0x50) - 0x1C, y - byte_D42C3, (char *)off_C527B[j]);
                    PrintFmt1(x, y, (char *)str_fmtpd, s[0]);
                    PrintFmt1(x, y + byte_D42C3, (char *)str_fmtpd, s[1]);
                    PrintFmt1(x, y + byte_D42C3 * 2, (char *)str_fmtpd, s[2]);
                    PrintFmt1(x, y + byte_D42C3 * 3, (char *)str_fmtpd, s[3]);
                    PrintFmt1(x, y + byte_D42C3 * 4, (char *)str_fmtpd, s[6]);
                    PrintFmt1(x, y + byte_D42C3 * 5, (char *)str_fmtpd, ((short *)s)[8]);
                    PrintFmt1(x, y + byte_D42C3 * 6, (char *)str_fmtpd, s[4]);
                    PrintFmt1(x, y + byte_D42C3 * 7, (char *)str_fmtpd, s[5]);
                    PrintFmt1(x, y + byte_D42C3 * 8, (char *)str_fmtpd, s[7]);
                    if (s[7]) pct = (s[1] * 1000 + s[7] / 2) / s[7];
                    else pct = 0;
                    PrintFmt2(x, y + byte_D42C3 * 9, (char *)str_D01d, pct / 10, pct % 10);
                    s = (unsigned short *)((char *)gs + 0x12);
                }
            }
        }
        y = 0x1BA;
        if (awardtitles[k * 2 + 1]) {
            x = 0x1FE - (fputchar((char *)awardtitles[k * 2 + 1]) >> 1);
            PrintShadowText(x, y, (char *)awardtitles[k * 2 + 1]);
            y = 0x1BA - byte_D42C3;
        }
        x = 0x1FE - (fputchar((char *)awardtitles[k * 2]) >> 1);
        PrintShadowText(x, y, (char *)awardtitles[k * 2]);
        FadePalStep(0, (unsigned char *)sub_B30B4(bank, (char *)str_Pal3) + 0x10, 0x10);
        FreeMemBlock(bank);
        key = WaitClickTimeout(0x2710);
        pal = sub_8CCA8((char *)str_Palmem, 0x300, 0);
        sub_8FFB0(0, 0x100, (unsigned char *)pal);
        FadePalStep(1, (unsigned char *)pal, 0x10);
        FreeMemBlock(pal);
    }
    return key;
}
