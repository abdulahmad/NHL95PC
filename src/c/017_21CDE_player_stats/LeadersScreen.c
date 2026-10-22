/* Player stats: the league leaders screen. */
#define LeadersScreen LeadersScreen_decl
#define PrintShadowText PrintShadowText_decl
#define PrintFmt1 PrintFmt1_decl
#define PrintFmt2 PrintFmt2_decl
#include "nhl95.h"
#undef LeadersScreen
#undef PrintShadowText
#undef PrintFmt1
#undef PrintFmt2

typedef struct { char c[0x34]; } PRec;  /* a key database player record */
typedef struct { char c[0x2F]; } SStat;  /* a skater stats record */
typedef struct { char c[0x36]; } GStat;  /* a goalie stats record */

int LeadersScreen(int cat);
void PrintShadowText(short x, short y, char *s);  /* 175E2 */
void PrintFmt1(short x, short y, char *fmt, short a);  /* 176AE */
void PrintFmt2(short x, short y, char *fmt, short a, short b);  /* 176DB */
int open(const char *path, int access, ...);  /* Watcom CRT open_ */
int read(int fh, void *buf, unsigned len);  /* Watcom CRT read_ */
int j___close(int fh);  /* CRT close thunk */

#define W(p, o) (*(unsigned short *)((char *)(p) + (o)))
#define CMP(i, j) ((int (*)(int *, int *))leadersortfns[cat])(i, j)

/* DRAFT (first pass from Ghidra, tools/ghidra_decomp.py): the column switch (LeadersScreen_coljt) and the
   insertion are not shaped yet; 3,561 of 3,782 bytes. */
/* LeadersScreen (25B24, PC only): the league leaders of category cat (0-7 skaters: points, goals, assists, power
   play goals, short-handed goals, penalty minutes, plus / minus, shooting percentage; 8-10 goalies: goals against
   average, wins, save percentage) for the stats screens' league (statsleague; season or league stats,
   statsfromleague; season or playoff blocks, statsplayoffs). For the averages and percentages the teams' games
   played come from the team database first: a goalie needs 30% and a skater 80% of his team's games. Every
   player of a team (team byte under 1Ah) with games is read from the key and player databases and kept among the
   20 best by the category's comparator (leadersortfns, an index list sorted with qsort). Then the stats
   background and bar, the title (MakeStatsTitle with leadertitles[cat]) and a row per leader: rank, number,
   name, team and the category's columns (headers off_C6C40, five per category), or "stats unavailable". cat: the
   category. Result 0. */
int LeadersScreen(int cat)
{
    int teamgp[0x1A];
    char title[0x50];
    int order[0x15];
    unsigned char trec[0x4C];
    unsigned char txt[0x40];
    GStat gs;
    PRec key;
    SStat ss;
    char path[0x20];
    int n;
    int kfh;
    int pfh;
    int fh;
    int i;
    int j;
    int y;
    int recsz;
    int gp;
    int g;
    int kf;
    int mf;
    unsigned short *sp;
    unsigned short *gsp;

    n = 0;
    statsplayerbuf = (unsigned char *)sub_8CCA8((char *)str_Keys, 0x444, 0x20);
    if (cat < 8) statsskaterbuf = (unsigned char *)sub_8CCA8((char *)str_Pstat, 0x3DB, 0x20);
    else statsgoaliebuf = (unsigned char *)sub_8CCA8((char *)str_Gstat, 0x46E, 0x20);
    if (cat == 7) statssortkeys = (int *)sub_8CCA8((char *)str_Addsort2, 0x54, 0x20);
    if (cat == 8 || cat == 10 || cat == 5 || cat == 7) {
        MakePath(path, (char *)&statsleague, (char *)statsteamdbs[statsfromleague], 0);
        fh = open(path, 0x200);
        recsz = statsfromleague ? 0x2E8 : 0x4C;
        for (i = 0; i < 0x1A; i++) {
            lseek(fh, i * recsz, 0);
            read(fh, trec, 0x4C);
            teamgp[i] = statsplayoffs ? trec[0x3A] : trec[0x28];
        }
        j___close(fh);
    }
    MakePath(path, (char *)&statsleague, (char *)str_KeyDb2, 0);
    kfh = open(path, 0x200);
    MakePath(path, (char *)&statsleague, (char *)statsplayerdbs[statsfromleague], 0);
    pfh = open(path, 0x200);
    while (read(kfh, &key, 0x34) == 0x34) {
        if (key.c[0] >= 0x1A) continue;
        if (key.c[2] == 'G') {
            if (cat < 8) continue;
            lseek(pfh, statsfromleague ? *(int *)(key.c + 0x2C) : *(int *)(key.c + 0x28), 0);
            read(pfh, &gs, 0x36);
            gp = statsplayoffs ? W(&gs, 0x16) : W(&gs, 0);
            if (!gp) continue;
            if (cat == 8 || cat == 10) {
                if (!teamgp[(unsigned char)key.c[0]] || gp * 100 / teamgp[(unsigned char)key.c[0]] < 0x1E) continue;
            } else if (cat == 9) {
                if (!(statsplayoffs ? W(&gs, 0x18) : W(&gs, 2))) continue;
            }
            ((GStat *)statsgoaliebuf)[n] = gs;
            if (n > 0x13 && CMP(&n, &order[n]) >= 0) continue;
            if (n < 0x14) {
                ((PRec *)statsplayerbuf)[n] = key;
                order[n + 1] = n;
                n++;
            } else {
                j = order[n];
                ((PRec *)statsplayerbuf)[j] = key;
                ((GStat *)statsgoaliebuf)[j] = gs;
            }
        } else {
            if (cat > 7) continue;
            lseek(pfh, statsfromleague ? *(int *)(key.c + 0x2C) : *(int *)(key.c + 0x28), 0);
            read(pfh, &ss, 0x2F);
            gp = statsplayoffs ? W(&ss, 0x12) : W(&ss, 0);
            if (!gp) continue;
            if ((cat == 5 || cat == 7) &&
                (!teamgp[(unsigned char)key.c[0]] || gp * 100 / teamgp[(unsigned char)key.c[0]] < 0x50)) continue;
            ((SStat *)statsskaterbuf)[n] = ss;
            if (cat == 7) {
                g = statsplayoffs ? W(&ss, 0x20) : W(&ss, 0xE);
                statssortkeys[n] = g ? ((statsplayoffs ? W(&ss, 0x14) : W(&ss, 2)) * 1000 + g / 2) / g : 0;
            }
            if (n > 0x13 && CMP(&n, &order[n]) >= 0) continue;
            if (n < 0x14) {
                ((PRec *)statsplayerbuf)[n] = key;
                order[n + 1] = n;
                n++;
            } else {
                j = order[n];
                ((PRec *)statsplayerbuf)[j] = key;
                ((SStat *)statsskaterbuf)[j] = ss;
                if (cat == 7) statssortkeys[j] = statssortkeys[n];
            }
        }
        qsort(&order[1], n, 4, (int (*)(const void *, const void *))leadersortfns[cat]);
    }
    j___close(kfh);
    j___close(pfh);
    mf = mainfont;
    kf = kaufmfont;
    sub_B4BA8();
    MakePath(path, fileoncd[0x8C] == 1 ? (char *)cddriveptr : 0, (char *)statsbgnames[statsplayoffs], 0);
    statsbgshapes = sub_8E83C(path, 0);
    statspalshape = sub_B30B4(statsbgshapes, (char *)str_Bkgd2);
    sub_B4BC4(0, 0x280, 0x13, 0x1E0);
    sub_913B4(statspalshape);
    sub_B4BC4(0, 0x280, 0, 0x1E0);
    FreeMemBlock(statsbgshapes);
    MakePath(path, fileoncd[0x13C] == 1 ? (char *)cddriveptr : 0, (char *)str_Pstatbar7, 0);
    statsbgshapes = sub_8E83C(path, 0);
    statspalshape = sub_B30B4(statsbgshapes, (char *)str_Pst26);
    sub_91370(statspalshape, 0, 0x1C);
    FreeMemBlock(statsbgshapes);
    sub_8E9E8(txt);
    sub_8EA18(kf);
    TextGridOpen();
    SetTextColors(0x40, 0x43);
    MakeStatsTitle(title, (char *)leadertitles[cat]);
    PrintOutlinedText(300 - (fputchar(title) >> 1), 0x31, title);
    sub_8EA18(mf);
    if (n == 0) {
        sub_8EA18(kf);
        PrintCenteredText(0xEB, (char *)str_StatsUnavailable2);
        sub_8EA18(mf);
    } else {
        y = 0x5C;
        PrintShadowText(0xA, y, (char *)str_POS);
        PrintShadowText(0x32, y, (char *)str_NO);
        PrintShadowText(0x50, y, (char *)str_PLAYER2);
        PrintShadowText(0xFA, y, (char *)str_TEAM);
        PrintShadowText(0x172, y, (char *)str_GP6);
        PrintShadowText(0x19A, y, (char *)off_C6C40[cat * 5]);
        PrintShadowText(0x1CC, y, (char *)off_C6C40[cat * 5 + 1]);
        PrintShadowText(0x1F4, y, (char *)off_C6C40[cat * 5 + 2]);
        if (cat != 9 || statsplayoffs != 1) PrintShadowText(0x21C, y, (char *)off_C6C40[cat * 5 + 3]);
        PrintShadowText(0x24E, y, (char *)off_C6C40[cat * 5 + 4]);
        y += 0x10;
        for (i = 0; i < n; i++) {
            j = order[i + 1];
            key = ((PRec *)statsplayerbuf)[j];
            sprintf((char *)printfbuf, (char *)str_C2, key.c[2]);
            PrintShadowText(0xA, y, (char *)printfbuf);
            if ((unsigned char)key.c[1] < 100) PrintFmt1(0x32, y, (char *)str_fmt2d, (unsigned char)key.c[1]);
            FitPlayerName((char *)printfbuf, key.c + 3, key.c + 0x13, 0xA0);
            PrintShadowText(0x50, y, (char *)printfbuf);
            MakePath(path, (char *)&statsleague, (char *)statsteamdbs[0], 0);
            fh = open(path, 0x200);
            lseek(fh, (unsigned char)key.c[0] * 0x4C, 0);
            read(fh, trec, 0x4C);
            j___close(fh);
            PrintShadowText(0xFA, y, (char *)trec + 0x1A);
            if (cat < 8) {
                sp = (unsigned short *)(statsskaterbuf + j * 0x2F + (statsplayoffs ? 0x12 : 0));
                PrintFmt1(0x172, y, (char *)str_fmt2d, sp[0]);
                PrintFmt1(0x19A, y, (char *)str_fmt3d, sp[1]);
                PrintFmt1(0x1CC, y, (char *)str_fmt3d, sp[2]);
                PrintFmt1(0x1F4, y, (char *)str_fmt3d, sp[3]);
                switch (cat) {
                case 3: PrintFmt1(0x21C, y, (char *)str_fmt2d, sp[4]); break;
                case 4: PrintFmt1(0x21C, y, (char *)str_fmt3d, sp[5]); break;
                case 5: PrintFmt1(0x21C, y, (char *)str_fmt4d, sp[8]); break;
                case 6: PrintFmt1(0x21C, y, (char *)str_fmt3d, sp[6]); break;
                case 7:
                    PrintFmt1(0x21C, y, (char *)str_fmt5d, sp[7]);
                    PrintFmt2(0x24E, y, (char *)str_fmtTenths, statssortkeys[j] / 10, statssortkeys[j] % 10);
                    break;
                }
            } else {
                gsp = (unsigned short *)(statsgoaliebuf + j * 0x36 + (statsplayoffs ? 0x16 : 0));
                PrintFmt1(0x172, y, (char *)str_fmt2d, gsp[0]);
                PrintFmt1(0x19A, y, (char *)str_fmt4d, *(unsigned short *)((char *)gsp + 0xC));
                switch (cat) {
                case 8:
                    PrintFmt1(0x1CC, y, (char *)str_fmt3d, gsp[7]);
                    PrintFmt2(0x1F4, y, (char *)str_fmtMinSec, gsp[8] / 100, gsp[8] % 100);
                    break;
                case 9:
                    PrintFmt1(0x1CC, y, (char *)str_fmt2d, gsp[1]);
                    PrintFmt1(0x1F4, y, (char *)str_fmt2d, gsp[2]);
                    if (!statsplayoffs) PrintFmt1(0x21C, y, (char *)str_fmt2d, gsp[3]);
                    break;
                case 10:
                    PrintFmt1(0x1CC, y, (char *)str_fmt3d, gsp[7]);
                    PrintFmt1(0x1F4, y, (char *)str_fmt4d, gsp[9]);
                    if (gsp[10] > 999) PrintFmt2(0x21C, y, (char *)str_fmtPct, gsp[10] / 1000, gsp[10] % 1000);
                    else PrintFmt1(0x21C, y, (char *)str_fmtPct0, gsp[10] % 1000);
                    break;
                }
            }
            y += 0xD;
        }
    }
    TextGridOff();
    sub_8EA00(txt);
    if (cat == 7) FreeMemBlock((int)statssortkeys);
    FreeMemBlock((int)(cat < 8 ? statsskaterbuf : statsgoaliebuf));
    FreeMemBlock((int)statsplayerbuf);
    return 0;
}
