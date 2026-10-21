/* Player stats: a team's roster stats screen. */
/* DRAFT: 3,169 vs 3,170 bytes, 37 differing lines of 781: the stack slots of the spilled scalars (the EXE: kfh,
   pfh, n, fh, kf, mf, gs, idx, m, y upward from 3E8h; this order gives kfh, pfh, idx, gs, kf, fh, mf, m, n, y) and
   one register pick (the skater record copy builds the source in esi from the base, C from the product). See
   docs/UNSURE.md. */
#define TeamRosterScreen TeamRosterScreen_decl
#define PrintShadowText PrintShadowText_decl
#define PrintFmt1 PrintFmt1_decl
#define PrintFmt2 PrintFmt2_decl
#include "nhl95.h"
#undef TeamRosterScreen
#undef PrintShadowText
#undef PrintFmt1
#undef PrintFmt2

typedef struct { char c[0x34]; } PRec;  /* a key database player record */
typedef struct { char c[0x2F]; } SStat;  /* a skater stats record */
typedef struct { char c[0x36]; } GStat;  /* a goalie stats record */

int TeamRosterScreen(int team);
void PrintShadowText(short x, short y, char *s);  /* 175E2 */
void PrintFmt1(short x, short y, char *fmt, short a);  /* 176AE */
void PrintFmt2(short x, short y, char *fmt, short a, short b);  /* 176DB */
int open(const char *path, int access, ...);  /* Watcom CRT open_ */
int read(int fh, void *buf, unsigned len);  /* Watcom CRT read_ */
int j___close(int fh);  /* CRT close thunk */

/* TeamRosterScreen (244E2, PC only): the roster stats of a team of the stats screens' league (statsleague). Reads
   the team's record (2E8h bytes) from its team database, then for its 25 skater and 3 goalie slots (-1 is empty)
   the key record (into statsplayerbuf, goalies from 19h) and the season or league stats record (statsfromleague)
   into statsskaterbuf / statsgoaliebuf, sorts the shown order by points and by goals against average, draws the
   team's EMB background and the PSTATBAR6 bar, the team name (MIGHTY DUCKS OF ANAHEIM for team 18h) with the
   TRAD or REGI crest beside it, and a row per skater (position, number below 100, name, games, goals, assists,
   points, shots, penalty minutes, plus / minus) and per goalie (games, minutes, goals against average, wins,
   losses, ties outside the playoffs, goals and shots against, save percentage), from the season or the playoff
   block (statsplayoffs). Leaves the counts in statsnumskaters / statsnumgoalies. team: the team. Result: 0. */
int TeamRosterScreen(int team)
{
    unsigned char rec[0x2E8];
    char state[0x40];
    unsigned char gstat[0x36];
    unsigned char prec[0x34];
    unsigned char sstat[0x2F];
    char path[0x20];
    int kfh;
    int pfh;
    int n;
    int fh;
    int kf;
    int mf;
    unsigned short *gs;
    int idx;
    int m;
    int y;
    int i;
    unsigned short *s;

    mf = mainfont;
    kf = kaufmfont;
    MakePath(path, (char *)statsleague, (char *)statsteamdbs[1], 0);
    fh = open(path, 0x200);
    lseek(fh, team * 0x2E8, 0);
    read(fh, rec, 0x2E8);
    MakePath(path, (char *)statsleague, (char *)str_KeyDb, 0);
    kfh = open(path, 0x200);
    MakePath(path, (char *)statsleague, (char *)statsplayerdbs[statsfromleague], 0);
    pfh = open(path, 0x200);
    for (i = n = 0; i < 0x19; i++) {
        if (((int *)(rec + 0x4C))[i] != -1) {
            lseek(kfh, ((int *)(rec + 0x4C))[i], 0);
            read(kfh, prec, 0x34);
            ((PRec *)statsplayerbuf)[i] = *(PRec *)prec;
            lseek(pfh, !statsfromleague ? *(int *)(prec + 0x28) : *(int *)(prec + 0x2C), 0);
            read(pfh, sstat, 0x2F);
            ((SStat *)statsskaterbuf)[n] = *(SStat *)sstat;
            statsskaterplr[n] = i;
            statsskaterorder[n] = n;
            n++;
        }
    }
    for (i = m = 0; i < 3; i++) {
        if (((int *)(rec + 0xB0))[i] != -1) {
            lseek(kfh, ((int *)(rec + 0xB0))[i], 0);
            read(kfh, prec, 0x34);
            ((PRec *)statsplayerbuf)[i + 0x19] = *(PRec *)prec;
            lseek(pfh, !statsfromleague ? *(int *)(prec + 0x28) : *(int *)(prec + 0x2C), 0);
            read(pfh, gstat, 0x36);
            ((GStat *)statsgoaliebuf)[m] = *(GStat *)gstat;
            statsgoalieplr[m] = i + 0x19;
            statsgoalieorder[m] = m;
            m++;
        }
    }
    j___close(fh);
    j___close(kfh);
    j___close(pfh);
    qsort(statsskaterorder, n, 4, (int (*)(const void *, const void *))CmpPoints);
    qsort(statsgoalieorder, m, 4, (int (*)(const void *, const void *))CmpGAA);
    sub_B4BA8();
    sprintf((char *)printfbuf, (char *)str_fmtEmb, rec);
    MakePath(path, fileoncd[team + 0x70] == 1 ? (char *)cddriveptr : 0, (char *)printfbuf, 0);
    statsbgshapes = sub_8E83C(path, 0);
    statspalshape = sub_B30B4(statsbgshapes, (char *)str_Bkgd2);
    sub_B4BC4(0, 0x280, 0x13, 0x1E0);
    sub_913B4(statspalshape);
    sub_B4BC4(0, 0x280, 0, 0x1E0);
    FreeMemBlock(statsbgshapes);
    MakePath(path, fileoncd[0x13C] == 1 ? (char *)cddriveptr : 0, (char *)str_Pstatbar6, 0);
    statsbgshapes = sub_8E83C(path, 0);
    statspalshape = sub_B30B4(statsbgshapes, (char *)str_Pst25);
    sub_91370(statspalshape, 0, 6);
    sub_8E9E8(state);
    sub_8EA18(mf);
    TextGridOpen();
    if (dword_DC734) SetTextColors(0xC0, 0xC3);
    else SetTextColors(0x40, 0x43);
    sub_8EA18(kf);
    SetTextColors(0x40, 0x43);
    y = 0x1B;
    if (team != 0x18) {
        sprintf((char *)printfbuf, (char *)str_S, rec + 5);
        PrintOutlinedText(0x12C - (fputchar((char *)printfbuf) >> 1), y, (char *)printfbuf);
        if (team == 2 || team == 0x18 || team == 0x19)
            statspalshape = sub_B30B4(statsbgshapes, (char *)str_Trad);
        else
            statspalshape = sub_B30B4(statsbgshapes, (char *)str_Regi);
        sub_91370(statspalshape, (fputchar((char *)printfbuf) >> 1) + 0x12C, y + 6);
    } else {
        sprintf((char *)printfbuf, (char *)str_MightyDucksOfAnaheim2);
        PrintOutlinedText(0x12C - (fputchar((char *)printfbuf) >> 1), y, (char *)printfbuf);
        statspalshape = sub_B30B4(statsbgshapes, (char *)str_Trad);
        sub_91370(statspalshape, 0x12A, y);
    }
    FreeMemBlock(statsbgshapes);
    sub_8EA18(mf);
    SetTextColors(0x40, 0x43);
    y = 0x30;
    PrintShadowText(0x14, y, (char *)str_Pos);
    PrintShadowText(0x42, y, (char *)str_No);
    PrintShadowText(0x60, y, (char *)str_Name);
    PrintShadowText(0x10E, y, (char *)str_GP5);
    PrintShadowText(0x136, y, (char *)str_G3);
    PrintShadowText(0x15E, y, (char *)str_A3);
    PrintShadowText(0x186, y, (char *)str_PT);
    PrintShadowText(0x1AE, y, (char *)str_Shots3);
    PrintShadowText(0x1E8, y, (char *)str_PIM3);
    PrintShadowText(0x210, y, (char *)str_PlusMinus3);
    for (i = 0, y = 0x40; i < n; y += 0xD, i++) {
        idx = statsskaterorder[i];
        *(PRec *)prec = ((PRec *)statsplayerbuf)[statsskaterplr[idx]];
        sprintf((char *)printfbuf, (char *)str_C, ((signed char *)prec)[2]);
        PrintShadowText(0x14, y, (char *)printfbuf);
        if (prec[1] < 100) PrintFmt1(0x42, y, (char *)str_fmt2d, prec[1]);
        FitPlayerName((char *)printfbuf, (char *)prec + 3, (char *)prec + 0x13, 0xA6);
        PrintShadowText(0x60, y, (char *)printfbuf);
        s = !statsplayoffs ? (unsigned short *)(statsskaterbuf + idx * 0x2F)
                           : (unsigned short *)(statsskaterbuf + idx * 0x2F + 0x12);
        PrintFmt1(0x10E, y, (char *)str_fmt2d, s[0]);
        PrintFmt1(0x136, y, (char *)str_fmt3d, s[1]);
        PrintFmt1(0x15E, y, (char *)str_fmt3d, s[2]);
        PrintFmt1(0x186, y, (char *)str_fmt3d, s[3]);
        PrintFmt1(0x1AE, y, (char *)str_fmt5d, s[7]);
        PrintFmt1(0x1E8, y, (char *)str_fmt3d, s[6]);
        PrintFmt1(0x210, y, (char *)str_fmt4d, s[8]);
    }
    y = 0x195;
    PrintShadowText(0x14, y, (char *)str_Pos);
    PrintShadowText(0x42, y, (char *)str_No);
    PrintShadowText(0x60, y, (char *)str_Name);
    PrintShadowText(0x10E, y, (char *)str_GP5);
    PrintShadowText(0x136, y, (char *)str_Min3);
    PrintShadowText(0x15E, y, (char *)str_GAA3);
    PrintShadowText(0x190, y, (char *)str_W3);
    PrintShadowText(0x1AE, y, (char *)str_L5);
    if (!statsplayoffs) PrintShadowText(0x1CC, y, (char *)str_T3);
    PrintShadowText(0x1EA, y, (char *)str_GA);
    PrintShadowText(0x20E, y, (char *)str_SA2);
    PrintShadowText(0x240, y, (char *)str_PCT);
    for (i = 0, y += 0x10; i < m; y += 0xD, i++) {
        idx = statsgoalieorder[i];
        *(PRec *)prec = ((PRec *)statsplayerbuf)[statsgoalieplr[idx]];
        sprintf((char *)printfbuf, (char *)str_C, ((signed char *)prec)[2]);
        PrintShadowText(0x14, y, (char *)printfbuf);
        if (prec[1] < 100) PrintFmt1(0x42, y, (char *)str_fmt2d, prec[1]);
        FitPlayerName((char *)printfbuf, (char *)prec + 3, (char *)prec + 0x13, 0xA6);
        PrintShadowText(0x60, y, (char *)printfbuf);
        gs = !statsplayoffs ? (unsigned short *)(statsgoaliebuf + idx * 0x36)
                            : (unsigned short *)(statsgoaliebuf + idx * 0x36 + 0x16);
        PrintFmt1(0x10E, y, (char *)str_fmt2d, gs[0]);
        PrintFmt1(0x136, y, (char *)str_fmt4d, gs[6]);
        PrintFmt2(0x15E, y, (char *)str_fmtMinSec, gs[8] / 100, gs[8] % 100);
        PrintFmt1(0x190, y, (char *)str_fmt2d, gs[1]);
        PrintFmt1(0x1AE, y, (char *)str_fmt2d, gs[2]);
        if (!statsplayoffs) PrintFmt1(0x1CC, y, (char *)str_fmt2d, gs[3]);
        PrintFmt1(0x1EA, y, (char *)str_fmt3d, gs[7]);
        PrintFmt1(0x20E, y, (char *)str_fmt4d, gs[9]);
        if (gs[10] < 1000)
            PrintFmt1(0x240, y, (char *)str_fmtPct0, gs[10] % 1000);
        else
            PrintFmt2(0x240, y, (char *)str_fmtPct, gs[10] / 1000, gs[10] % 1000);
    }
    TextGridOff();
    sub_8EA00(state);
    statsnumskaters = n;
    statsnumgoalies = m;
    return 0;
}
