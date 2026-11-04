/* cflags: -od */
/* Standings playoffs: the conference standings screen. */
#define StandingsScreen StandingsScreen_decl
#define PrintShadowText PrintShadowText_decl
#define PrintFmt1 PrintFmt1_decl
#define PrintFmt2 PrintFmt2_decl
#define CmpConfStandings CmpConfStandings_decl
#define stand_tmpl1 stand_tmpl1_decl
#define stand_tmpl2 stand_tmpl2_decl
#include "nhl95.h"
#undef StandingsScreen
#undef PrintShadowText
#undef PrintFmt1
#undef PrintFmt2
#undef CmpConfStandings
#undef stand_tmpl1
#undef stand_tmpl2

typedef struct Stand {
    char name[13];
    unsigned char div;
    unsigned char gp;
    unsigned char w;
    unsigned char l;
    unsigned char t;
    short gf;
    short ga;
    unsigned short pts;
    unsigned short pct;
} Stand;

typedef struct { char c[10]; } StandTmpl;

extern StandTmpl stand_tmpl1;  /* 269EA */
extern StandTmpl stand_tmpl2;  /* 269F4 */
int StandingsScreen(Stand *teams, int *order);
void PrintShadowText(short x, short y, char *s);  /* 175E2 */
void PrintFmt1(short x, short y, char *fmt, short a);  /* 176AE */
void PrintFmt2(short x, short y, char *fmt, short a, short b);  /* 176DB */
int CmpConfStandings(const void *a, const void *b);  /* 269FE */
int open(const char *path, int access, ...);  /* Watcom CRT open_ */
int read(int fh, void *buf, unsigned len);  /* Watcom CRT read_ */
int j___close(int fh);  /* CRT close thunk */

/* StandingsScreen (27080, PC only): the standings by conference. Read the 26 teams' records (4Ch bytes each, or
   2E8h from the league file) into teams (1Ah bytes each: name, division, games, wins, losses, ties, goals for and
   against, points as wins * 2 + ties, percentage in thousandths of the possible points), sort order by
   CmpConfStandings, then draw the background (BKGD2 from the stats bank, the PSTATBAR8 bar), the title and the
   two conference captions, and each division's header row (GP W L T GF GA P Pct) and teams at the division's
   divx / divy (league teams without games are skipped in exhibition stats). teams: the 26 standings rows; order:
   their order. Result: 0. */
int StandingsScreen(Stand *teams, int *order)
{
    int unused1;
    int mf;
    int kf;
    int fh;
    int unused2;
    int i;
    Stand *p;
    int x;
    int y;
    int div;
    Stand *q;
    int recsize;
    StandTmpl tmpl2;
    StandTmpl tmpl1;
    char path[0x20];
    unsigned char rec[0x34];
    char state[0x40];
    char title[0x54];
    unsigned char big[0x2E8];

    tmpl1 = stand_tmpl1;
    tmpl2 = stand_tmpl2;
    off_CF6A3 = (int)DeskSetExit3b;
    mf = mainfont;
    kf = kaufmfont;
    MakePath(path, (char *)statsleague, (char *)statsteamdbs[statsfromleague], 0);
    fh = open(path, 0x200);
    recsize = statsfromleague == 0 ? 0x4C : 0x2E8;
    q = (Stand *)(rec + 0x1A);
    for (i = 0; i < 0x1A; i++) {
        lseek(fh, recsize * i, 0);
        read(fh, rec, 0x34);
        q->pts = q->w * 2 + q->t;
        if (q->gp) q->pct = (q->pts * 1000 + q->gp) / (q->gp * 2);
        else q->pct = 0;
        p = teams + i;
        *p = *q;
        order[i] = i;
    }
    j___close(fh);
    qsort(order, 0x1A, 4, CmpConfStandings);
    sub_B4BA8();
    MakePath(path, fileoncd[0x8C] == 1 ? (char *)cddriveptr : 0, (char *)statsbgnames[statsplayoffs], 0);
    statsbgshapes = sub_8E83C(path, 0);
    statspalshape = sub_B30B4(statsbgshapes, (char *)str_Bkgd2);
    sub_B4BC4(0, 0x280, 0x13, 0x1E0);
    sub_913B4(statspalshape);
    sub_B4BC4(0, 0x280, 0, 0x1E0);
    FreeMemBlock(statsbgshapes);
    MakePath(path, fileoncd[0x13C] == 1 ? (char *)cddriveptr : 0, (char *)str_Pstatbar8, 0);
    statsbgshapes = sub_8E83C(path, 0);
    statspalshape = sub_B30B4(statsbgshapes, (char *)str_Pst27);
    sub_91370(statspalshape, 0, 0x1C);
    FreeMemBlock(statsbgshapes);
    TextGridOpen();
    sub_8E9E8(state);
    sub_8EA18(kf);
    SetTextColors(0x40, 0x43);
    y = 0x31;
    MakeStatsTitle(title, (char *)str_Standings);
    PrintOutlinedText(0x12C - (fputchar(title) >> 1), y, title);
    y = 0x50;
    PrintShadowText(0xA0 - (fputchar((char *)str_Western) >> 1), y, (char *)str_Western);
    PrintShadowText(0xA0 - (fputchar((char *)str_Conference) >> 1), y + 0x10, (char *)str_Conference);
    PrintShadowText(0x1E0 - (fputchar((char *)str_Eastern) >> 1), y, (char *)str_Eastern);
    PrintShadowText(0x1E0 - (fputchar((char *)str_Conference) >> 1), y + 0x10, (char *)str_Conference);
    sub_8EA18(mf);
    SetTextColors(0x40, 0x43);
    y += 0x57;
    div = -1;
    for (i = 0; i < 0x1A; i++) {
        p = teams + order[i];
        if (p->div != div) {
            div = p->div % 4;
            x = divx[div];
            y = divy[div];
            PrintShadowText(x, y, (char *)divisionnames[div]);
            y += 0x12;
            PrintShadowText(x, y, (char *)str_Team);
            PrintShadowText(x + 0x64, y, (char *)str_GP7);
            PrintShadowText(x + 0x78, y, (char *)str_W4);
            PrintShadowText(x + 0x8C, y, (char *)str_L6);
            PrintShadowText(x + 0xA0, y, (char *)str_T4);
            PrintShadowText(x + 0xB4, y, (char *)str_GF);
            PrintShadowText(x + 0xD2, y, (char *)str_GA2);
            PrintShadowText(x + 0xF0, y, (char *)str_P);
            PrintShadowText(x + 0x10E, y, (char *)str_Pct4);
            y += 0x13;
        }
        if (!(statsfromleague || p->gp)) continue;
        *q = *p;
        PrintShadowText(x, y, q->name);
        PrintFmt1(x + 0x64, y, (char *)str_fmt2d, q->gp);
        PrintFmt1(x + 0x78, y, (char *)str_fmt2d, q->w);
        PrintFmt1(x + 0x8C, y, (char *)str_fmt2d, q->l);
        PrintFmt1(x + 0xA0, y, (char *)str_fmt2d, q->t);
        PrintFmt1(x + 0xB4, y, (char *)str_fmt3d, q->gf);
        PrintFmt1(x + 0xD2, y, (char *)str_fmt3d, q->ga);
        PrintFmt1(x + 0xF0, y, (char *)str_fmt3d, q->pts);
        if (q->pct < 1000)
            PrintFmt1(x + 0x10E, y, (char *)str_fmtPct0, q->pct % 1000);
        else
            PrintFmt2(x + 0x10E, y, (char *)str_fmtPct, q->pct / 1000, q->pct % 1000);
        y += 0xD;
    }
    TextGridOff();
    sub_8EA00(state);
    return 0;
}
