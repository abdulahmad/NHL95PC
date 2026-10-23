/* Player stats: the skater stats card. */
/* DRAFT: 7 differing instructions, 2,214 vs 2,211 bytes under Watcom 10.0 GA.
   A byte rating temporary keeps the lookup address in edx. The promotion still uses
   and eax,0FFh after the byte load; the EXE zeroes eax before loading al. */
#define SkaterStatsCard SkaterStatsCard_decl
#include "nhl95.h"
#undef SkaterStatsCard

int open(const char *path, int access, ...);  /* Watcom CRT open_ */
int read(int fh, void *buf, unsigned len);  /* Watcom CRT read_ */
int j___close(int fh);  /* CRT close thunk */

typedef struct { char c[6]; } T6;
typedef struct { char c[13]; } T13;

/* SkaterStatsCard (21CDE, PC only): the skater's stats card. Read the player's season and playoff records (the
   stats file of the league or of the playoffs), ratings (ATT.DB) and team abbreviation (the team file, 4Ch
   bytes per team); draw the team's EMB background, then the player's portrait when there is one (PORTR + the
   portrait code, from the CD when byte_ED909 says so: the photo with its palette, and the bar art PST1, else
   PST2), the title, name, number and position; the season and playoff rows (games, goals, assists, points,
   penalty minutes, plus / minus, power-play and short-handed goals, shots and the shooting percentage in tenths);
   and the ratings: shooting hand, then the 14 ratings (shown as (r + 5) * 5) in two columns. No arguments.
   Result: 0. */
int SkaterStatsCard(void)
{
    struct {
        char name[0x50];
        char text[0x40];
        short season[9];
        short playoff[11];
        char path[0x20];
        unsigned char attr[0x14];
        char abbr[8];
    } s;
    struct {
        int y;
        int mainf;
        int result;
        int kaufm;
        unsigned char *attrp;
        int x;
    } t;
    unsigned char *pl;
    int fh;
    int bank;
    int art;
    short *rec;
    int i;
    int pct;
    int v;
    unsigned char rating;

    t.result = 0;
    pl = statsplayer;
    t.mainf = mainfont;
    t.kaufm = kaufmfont;
    MakePath(s.path, (char *)statsleague, (char *)statsplayerdbs[statsfromleague], 0);
    fh = open(s.path, 0x200);
    lseek(fh, !statsfromleague ? dword_DC85C : dword_DC860, 0);
    read(fh, s.season, 0x28);
    j___close(fh);
    MakePath(s.path, (char *)statsleague, (char *)str_AttDb, 0);
    fh = open(s.path, 0x200);
    lseek(fh, *(int *)(pl + 0x24), 0);
    read(fh, s.attr, 0x14);
    j___close(fh);
    MakePath(s.path, (char *)statsleague, (char *)statsteamdbs[0], 0);
    fh = open(s.path, 0x200);
    lseek(fh, pl[0] * 0x4C, 0);
    read(fh, s.abbr, 5);
    j___close(fh);
    sub_B4BA8();
    sprintf((char *)printfbuf, (char *)str_fmtEmb, s.abbr);
    MakePath(s.path, fileoncd[pl[0] + 0x70] == 1 ? (char *)cddriveptr : 0, (char *)printfbuf, 0);
    statsbgshapes = sub_8E83C(s.path, 0);
    statspalshape = sub_B30B4(statsbgshapes, (char *)str_Bkgd2);
    sub_B4BC4(0, 0x280, 0x13, 0x1E0);
    sub_913B4(statspalshape);
    sub_B4BC4(0, 0x280, 0, 0x1E0);
    FreeMemBlock(statsbgshapes);
    if (pl[0x30]) {
        *(T6 *)s.name = *(T6 *)str_PORTR;
        memcpy(s.name + 5, pl + 0x30, 4);
        bank = (((signed char *)pl)[0x31] - 0x30) * 10;
        v = ((signed char *)pl)[0x32] - 0x30;
        s.name[8] = 0;
        MakePath(s.path, byte_ED909[bank + v] == 1
            ? (char *)cddriveptr : 0, s.name, 0);
        bank = sub_8E83C(s.path, 0);
        memcpy(s.name, pl + 0x30, 4);
        s.name[4] = 0;
        art = sub_B30BB(bank, s.name);
        if (art) {
            s.name[0] = 0x21;
            DrawPhotoWithPal((unsigned char *)sub_B30BB(bank, s.name) + 0x10, art, 0x21, 0x26);
            FreeMemBlock(bank);
            MakePath(s.path, fileoncd[0x13C] == 1 ? (char *)cddriveptr : 0, (char *)str_Pstatbar3, 0);
            statsbgshapes = sub_8E83C(s.path, 0);
            sub_913B4(statspalshape = sub_B30B4(statsbgshapes, (char *)str_Pst1));
        } else {
            FreeMemBlock(bank);
            MakePath(s.path, fileoncd[0x13C] == 1 ? (char *)cddriveptr : 0, (char *)str_Pstatbar3, 0);
            statsbgshapes = sub_8E83C(s.path, 0);
            sub_913B4(statspalshape = sub_B30B4(statsbgshapes, (char *)str_Pst22));
        }
        FreeMemBlock(statsbgshapes);
    } else {
        MakePath(s.path, fileoncd[0x13C] == 1 ? (char *)cddriveptr : 0, (char *)str_Pstatbar3, 0);
        statsbgshapes = sub_8E83C(s.path, 0);
        statspalshape = sub_B30B4(statsbgshapes, (char *)str_Pst22);
        sub_913B4(statspalshape);
        FreeMemBlock(statsbgshapes);
    }
    sub_8E9E8(s.text);
    sub_8EA18(t.kaufm);
    SetTextColors(0x40, 0x43);
    *(T13 *)printfbuf = *(T13 *)str_PlayerStats;
    PrintOutlinedText(0x140 - (fputchar((char *)printfbuf) >> 1), 0x52, (char *)printfbuf);
    TextGridOpen();
    SetTextColors(0x40, 0x43);
    sprintf((char *)printfbuf, (char *)str_SS2, pl + 3, pl + 0x13);
    PrintCenteredText(0x98, (char *)printfbuf);
    sprintf((char *)printfbuf, (char *)str_D2, pl[1]);
    switch (pl[2]) {
    case 'C':
        strcat((char *)printfbuf, (char *)str_Center2);
        break;
    case 'D':
        strcat((char *)printfbuf, (char *)str_Defense);
        break;
    case 'L':
        strcat((char *)printfbuf, (char *)str_LeftWing2);
        break;
    case 'R':
        strcat((char *)printfbuf, (char *)str_RightWing2);
        break;
    }
    PrintCenteredText(0xB2, (char *)printfbuf);
    sub_8EA18(t.mainf);
    t.y = 0xF3;
    PrintShadowText(0x82, (short)t.y, (char *)str_GP2);
    PrintShadowText(0xAA, (short)t.y, (char *)str_G2);
    PrintShadowText(0xD2, (short)t.y, (char *)str_A2);
    PrintShadowText(0xFA, (short)t.y, (char *)str_Pt2);
    PrintShadowText(0x122, (short)t.y, (char *)str_PIM2);
    PrintShadowText(0x14A, (short)t.y, (char *)str_PlusMinus2);
    PrintShadowText(0x186, (short)t.y, (char *)str_PPG2);
    PrintShadowText(0x1AE, (short)t.y, (char *)str_SHG2);
    PrintShadowText(0x1D6, (short)t.y, (char *)str_Shots2);
    PrintShadowText(0x212, (short)t.y, (char *)str_Pct2);
    rec = s.season;
    i = 0;
    t.y = 0x103;
    do {
        PrintShadowText(0x32, (short)t.y, (char *)statslabels[i]);
        PrintFmt1(0x82, (short)t.y, (char *)str_fmt2d, rec[0]);
        PrintFmt1(0xAA, (short)t.y, (char *)str_fmt3d, rec[1]);
        PrintFmt1(0xD2, (short)t.y, (char *)str_fmt3d, rec[2]);
        PrintFmt1(0xFA, (short)t.y, (char *)str_fmt3d, rec[3]);
        PrintFmt1(0x122, (short)t.y, (char *)str_fmt3d, rec[6]);
        PrintFmt1(0x14A, (short)t.y, (char *)str_fmt4d, rec[8]);
        PrintFmt1(0x186, (short)t.y, (char *)str_fmt3d, rec[4]);
        PrintFmt1(0x1AE, (short)t.y, (char *)str_fmt3d, rec[5]);
        PrintFmt1(0x1D6, (short)t.y, (char *)str_fmt5d, rec[7]);
        if (rec[7]) pct = ((unsigned short)rec[1] * 1000 + (unsigned short)rec[7] / 2) / (unsigned short)rec[7];
        else pct = 0;
        PrintFmt2(0x212, (short)t.y, (char *)str_fmtTenths, (short)(pct / 10), (short)(pct % 10));
        rec = s.playoff;
        t.y += 0xD;
    } while (++i < 2);
    t.y = 0x131;
    PrintCenteredText((short)t.y, (char *)str_Ratings2);
    t.attrp = s.attr;
    t.y = 0x143;
    PrintShadowText(0x1E, (short)t.y, (char *)str_Shoots2);
    if (s.attr[0]) PrintShadowText(0x10E, (short)t.y, (char *)str_L2);
    else PrintShadowText(0x10E, (short)t.y, (char *)str_R);
    t.x = 0;
    t.y += 0xD;
    for (i = 0; i < 0xE; i++) {
        if (i == 7) {
            t.x = 0x136;
            t.y -= 0x68;
        }
        PrintShadowText((short)(t.x + 0x1E), (short)t.y, (char *)skaterratingnames[i]);
        rating = t.attrp[((signed char *)off_C6A99)[i + 3]];
        v = (rating + 5) * 5;
        PrintFmt1((short)(t.x + 0x10E), (short)t.y, (char *)str_fmt3d, (short)v);
        t.y += 0xD;
    }
    sub_8EA00(s.text);
    TextGridOff();
    return t.result;
}
