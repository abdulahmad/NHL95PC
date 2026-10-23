/* Player stats: the team stats pages. */
/* DRAFT: 3,714 vs 3,733 bytes, 132 differing; see docs/UNSURE.md. */
#define TeamStatsScreen TeamStatsScreen_decl
#define PrintShadowText PrintShadowText_decl
#define PrintFmt1 PrintFmt1_decl
#define PrintFmt2 PrintFmt2_decl
#include "nhl95.h"
#undef TeamStatsScreen
#undef PrintShadowText
#undef PrintFmt1
#undef PrintFmt2

typedef struct { char c[0x4C]; } TRec;  /* a team stats record */

int TeamStatsScreen(int page);
void PrintShadowText(short x, short y, char *s);  /* 175E2 */
void PrintFmt1(short x, short y, char *fmt, short a);  /* 176AE */
void PrintFmt2(short x, short y, char *fmt, short a, short b);  /* 176DB */
int open(const char *path, int access, ...);  /* Watcom CRT open_ */
int read(int fh, void *buf, unsigned len);  /* Watcom CRT read_ */
int j___close(int fh);  /* CRT close thunk */
int strnicmp(const char *a, const char *b, unsigned n);  /* Watcom CRT strnicmp_ */

/* TeamStatsScreen (235BE, PC only): one page of team stats (page 0 scoring, 1 defence, 2 penalty killing, 3 power
   play, 4 penalties, 5 the conference standings). Reads the teams' records (all 26, or in the playoffs the 16
   teams of the first-round series from the stats schedule) into statsteamrecs, works out the page's sort key
   (penalty killing and power play percentages and penalty minutes per game in tenths, the standings points) into
   statssortkeys, sorts by teamsortfns[page] (the standings page instead splits the teams by conference and moves
   the other division's leader to second place; the exhibition stats use the fixed conference lists), then draws
   the page: a row per team that has played (rank, name, games and the page's columns), or "stats unavailable".
   page: the page. Result: 0. */
int TeamStatsScreen(int page)
{
    struct {
        int west[14];
        int east[14];
        int teams[0x1A];
        int order[0x1A];
        char title[0x54];
        unsigned char rec[0x4C];
        char state[0x40];
        char path[0x20];
    } f;
    unsigned char *sched;
    int x;
    int koff;
    int recsize;
    int fh;
    int n;
    int rank;
    int y;
    int t;
    int i;
    int w;
    int e;
    unsigned char *s;
    unsigned char *p;
    int mf;
    int kf;

    statsteamrecs = (unsigned char *)sub_8CCA8((char *)str_Teams, 0x7B8, 0x20);
    if (page > 1) statssortkeys = (int *)sub_8CCA8((char *)str_Addsort, 0x68, 0x20);
    MakePath(f.path, (char *)statsleague, (char *)statsteamdbs[statsfromleague], 0);
    fh = open(f.path, 0x200);
    recsize = statsfromleague == 0 ? 0x4C : 0x2E8;
    if (!statsplayoffs) {
        for (i = 0; i < 0x1A; i++) f.teams[i] = i;
        n = 0x1A;
    } else {
        OpenStatsSchedule((void **)&sched);
        sched += 2;
        p = sched + 0x1998;
        for (i = 0; i < 8; i++, p += 0x2A) {
            f.teams[i * 2] = p[2];
            f.teams[i * 2 + 1] = p[3];
        }
        if (f.teams[0] == 0xFF) n = 0;
        else n = 0x10;
        FreeMemBlock((int)(sched - 2));
    }
    if (n) {
        for (i = 0; i < n; i++) {
            f.order[i] = i;
            lseek(fh, recsize * f.teams[i], 0);
            read(fh, f.rec, 0x4C);
            ((TRec *)statsteamrecs)[i] = *(TRec *)f.rec;
            s = !statsplayoffs ? f.rec + 0x28 : f.rec + 0x3A;
            switch (page) {
            case 5:
                statssortkeys[i] = f.rec[0x27];
                break;
            case 2:
                if (((unsigned short *)s)[6] > ((unsigned short *)s)[7]) ((unsigned short *)s)[7] = ((unsigned short *)s)[6];
                t = ((unsigned short *)s)[7];
                statssortkeys[i] = t ? 1000 - (((unsigned short *)s)[6] * 1000 + t / 2) / t : 0;
                break;
            case 3:
                if (((unsigned short *)s)[4] > ((unsigned short *)s)[5]) ((unsigned short *)s)[5] = ((unsigned short *)s)[4];
                t = ((unsigned short *)s)[5];
                statssortkeys[i] = t ? (((unsigned short *)s)[4] * 1000 + t / 2) / t : 0;
                break;
            case 4:
                t = s[0];
                statssortkeys[i] = t ? (((unsigned short *)s)[8] * 10 + t / 2) / t : 0;
                break;
            }
        }
        if (page != 5)
            qsort(f.order, n, 4, (int (*)(const void *, const void *))teamsortfns[page]);
        else if (!statsplayoffs) {
            if (!statsfromleague) {
                n = 0xE;
                for (i = 0; i < 0xE; i++) {
                    f.west[i] = westconfteams[i];
                    f.east[i] = eastconfteams[i];
                }
            } else {
                qsort(f.order, n, 4, (int (*)(const void *, const void *))teamsortfns[page]);
                for (i = e = w = 0; i < n; i++) {
                    if (teamconf[f.teams[f.order[i]]] == 3) f.west[w++] = f.order[i];
                    else f.east[e++] = f.order[i];
                }
                if ((teamdivflags[f.west[0]] | teamdivflags[f.west[1]]) != 3) {
                    for (i = 2; i < 0xC; i++)
                        if ((teamdivflags[f.west[0]] | teamdivflags[f.west[i]]) == 3) break;
                    w = f.west[i];
                    for (; i >= 2; i--) f.west[i] = f.west[i - 1];
                    f.west[1] = w;
                }
                if ((teamdivflags[f.east[0]] | teamdivflags[f.east[1]]) != 0xC) {
                    for (i = 2; i < 0xC; i++)
                        if ((teamdivflags[f.east[0]] | teamdivflags[f.east[i]]) == 0xC) break;
                    e = f.east[i];
                    for (; i >= 2; i--) f.east[i] = f.east[i - 1];
                    f.east[1] = e;
                }
                n = 0xE;
            }
        } else {
            qsort(f.order, n, 4, (int (*)(const void *, const void *))teamsortfns[page]);
            for (i = e = w = 0; i < 0x10; i++) {
                if (teamconf[f.teams[f.order[i]]] == 3) f.west[w++] = f.order[i];
                else f.east[e++] = f.order[i];
            }
            n = 8;
        }
    }
    j___close(fh);
    mf = mainfont;
    kf = kaufmfont;
    sub_B4BA8();
    if (!statsplayoffs)
        MakePath(f.path, fileoncd[0x8C] == 1 ? (char *)cddriveptr : 0, (char *)statsbgnames[statsplayoffs], 0);
    else
        MakePath(f.path, fileoncd[0x8D] == 1 ? (char *)cddriveptr : 0, (char *)statsbgnames[statsplayoffs], 0);
    statsbgshapes = sub_8E83C(f.path, 0);
    statspalshape = sub_B30B4(statsbgshapes, (char *)str_Bkgd2);
    sub_B4BC4(0, 0x280, 0x13, 0x1E0);
    sub_913B4(statspalshape);
    sub_B4BC4(0, 0x280, 0, 0x1E0);
    FreeMemBlock(statsbgshapes);
    MakePath(f.path, fileoncd[0x13C] == 1 ? (char *)cddriveptr : 0, (char *)str_Pstatbar5, 0);
    statsbgshapes = sub_8E83C(f.path, 0);
    statspalshape = sub_B30B4(statsbgshapes, (char *)str_Pst24);
    sub_91370(statspalshape, 0, 0x1C);
    FreeMemBlock(statsbgshapes);
    sub_8E9E8(f.state);
    sub_8EA18(kf);
    TextGridOpen();
    SetTextColors(0x40, 0x43);
    MakeStatsTitle(f.title, (char *)teamstattitles[page]);
    PrintOutlinedText(0x12C - (fputchar(f.title) >> 1), 0x31, f.title);
    if (!n) {
        sub_8EA18(kf);
        PrintCenteredText(0xEB, (char *)str_StatsUnavailable);
        sub_8EA18(mf);
    } else {
        sub_8EA18(mf);
        y = 0x5C;
        if (page == 5) {
            PrintShadowText(0xA0 - (fputchar((char *)westconfname) >> 1), y, (char *)westconfname);
            PrintShadowText(0x1E0 - (fputchar((char *)eastconfname) >> 1), y, (char *)eastconfname);
            y = 0x73;
            PrintShadowText(0xEC, y, (char *)str_GP4);
            PrintShadowText(0x21C, y, (char *)str_GP4);
            PrintShadowText(0x114, y, (char *)((int (*)[4])teamcolhdrs)[page][statsplayoffs != 0]);
            PrintShadowText(0x244, y, (char *)((int (*)[4])teamcolhdrs)[page][statsplayoffs != 0]);
        } else {
            PrintShadowText(0x154, y, (char *)str_GP4);
            PrintShadowText(0x186, y, (char *)((int (*)[4])teamcolhdrs)[page][0]);
            PrintShadowText(0x1B8, y, (char *)((int (*)[4])teamcolhdrs)[page][1]);
            if (!statsplayoffs || page != 1 && page != 0) PrintShadowText(0x1EA, y, (char *)((int (*)[4])teamcolhdrs)[page][2]);
            PrintShadowText(0x21C, y, (char *)((int (*)[4])teamcolhdrs)[page][3]);
        }
        rank = 1;
        y += 0x10;
        if (page == 5) {
            for (i = 0; i < n; i++) {
                x = 0;
                if (i < 0xC) {
                    t = f.west[i];
                    *(TRec *)f.rec = ((TRec *)statsteamrecs)[t];
                    s = !statsplayoffs ? f.rec + 0x28 : f.rec + 0x3A;
                    if (!statsfromleague && !s[0]) continue;
                    PrintFmt1(x + 0x1E, y, (char *)str_fmt2d, rank);
                    PrintShadowText(x + 0x3C, y, !strnicmp((char *)f.rec, (char *)str_ANA2, 3) ? (char *)str_MightyDucksOfAnaheim : (char *)f.rec + 5);
                    PrintFmt1(x + 0xEC, y, (char *)str_fmt2d, s[0]);
                    if (!statsplayoffs) PrintFmt1(x + 0x114, y, (char *)str_fmt3d, s[1] * 2 + s[3]);
                    else PrintFmt1(x + 0x114, y, (char *)str_fmt2d, s[1]);
                }
                x = 0x140;
                t = f.east[i];
                *(TRec *)f.rec = ((TRec *)statsteamrecs)[t];
                s = !statsplayoffs ? f.rec + 0x28 : f.rec + 0x3A;
                if (!statsfromleague && !s[0]) continue;
                PrintFmt1(x + 0x1E, y, (char *)str_fmt2d, rank);
                PrintShadowText(x + 0x3C, y, !strnicmp((char *)f.rec, (char *)str_ANA2, 3) ? (char *)str_MightyDucksOfAnaheim : (char *)f.rec + 5);
                PrintFmt1(x + 0xDC, y, (char *)str_fmt2d, s[0]);
                if (!statsplayoffs) PrintFmt1(x + 0x104, y, (char *)str_fmt3d, s[1] * 2 + s[3]);
                else PrintFmt1(x + 0x104, y, (char *)str_fmt2d, s[1]);
                if (++rank == 9 && !statsplayoffs) {
                    y += 0xD;
                    PrintShadowText(0x1E, y, (char *)str_Dashes39);
                    PrintShadowText(0x15E, y, (char *)str_Dashes36);
                }
                y += 0xD;
            }
        } else {
            for (i = 0; i < n; i++) {
                t = f.order[i];
                *(TRec *)f.rec = ((TRec *)statsteamrecs)[t];
                s = !statsplayoffs ? f.rec + 0x28 : f.rec + 0x3A;
                if (!statsfromleague && !s[0]) continue;
                PrintFmt1(0x50, y, (char *)str_fmt2d, rank++);
                PrintShadowText(0x6E, y, !strnicmp((char *)f.rec, (char *)str_ANA2, 3) ? (char *)str_MightyDucksOfAnaheim : (char *)f.rec + 5);
                PrintFmt1(0x154, y, (char *)str_fmt2d, s[0]);
                koff = t * 4;
                switch (page) {
                case 0:
                    PrintFmt1(0x186, y, (char *)str_fmt2d, s[1]);
                    PrintFmt1(0x1B8, y, (char *)str_fmt2d, s[2]);
                    if (!statsplayoffs) PrintFmt1(0x1EA, y, (char *)str_fmt2d, s[3]);
                    PrintFmt1(0x21C, y, (char *)str_fmt3d, ((short *)s)[2]);
                    break;
                case 1:
                    PrintFmt1(0x186, y, (char *)str_fmt2d, s[1]);
                    PrintFmt1(0x1B8, y, (char *)str_fmt2d, s[2]);
                    if (!statsplayoffs) PrintFmt1(0x1EA, y, (char *)str_fmt2d, s[3]);
                    PrintFmt1(0x21C, y, (char *)str_fmt3d, ((short *)s)[3]);
                    break;
                case 2:
                    PrintFmt1(0x186, y, (char *)str_fmt3d, ((short *)s)[7]);
                    PrintFmt1(0x1B8, y, (char *)str_fmt4d, ((short *)s)[6]);
                    PrintFmt2(0x1EA, y, (char *)str_fmtTenths, *(int *)(koff + (int)statssortkeys) / 10, *(int *)(koff + (int)statssortkeys) % 10);
                    break;
                case 3:
                    PrintFmt1(0x186, y, (char *)str_fmt3d, ((short *)s)[5]);
                    PrintFmt1(0x1B8, y, (char *)str_fmt3d, ((short *)s)[4]);
                    PrintFmt2(0x1EA, y, (char *)str_fmtTenths, *(int *)(koff + (int)statssortkeys) / 10, *(int *)(koff + (int)statssortkeys) % 10);
                    break;
                case 4:
                    PrintFmt1(0x186, y, (char *)str_fmt3d, ((short *)s)[8]);
                    PrintFmt2(0x1B8, y, (char *)str_fmtTenths, *(int *)(koff + (int)statssortkeys) / 10, *(int *)(koff + (int)statssortkeys) % 10);
                    break;
                }
                y += 0xD;
            }
        }
    }
    TextGridOff();
    sub_8EA00(f.state);
    if (page > 1) FreeMemBlock((int)statssortkeys);
    FreeMemBlock((int)statsteamrecs);
    return 0;
}
