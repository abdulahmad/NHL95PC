/* Player stats: the goalie stats card. */
#define GoalieStatsCard GoalieStatsCard_decl
#include "nhl95.h"
#undef GoalieStatsCard

int open(const char *path, int access, ...);  /* Watcom CRT open_ */
int read(int fh, void *buf, unsigned len);  /* Watcom CRT read_ */
int j___close(int fh);  /* CRT close thunk */

typedef struct { char c[6]; } T6;
typedef struct { char c[13]; } T13;

/* GoalieStatsCard (22581, PC only): the goalie's stats card, as SkaterStatsCard with the goalie columns: games,
   minutes (shown as m:ss from hundredths), goals against average, wins, losses, ties, shutouts, empty-net goals,
   shots against and the save percentage (".nnn", or "1.nnn" from 1000), then the glove hand and the 10 goalie
   ratings in two columns. No arguments, no result. */
void GoalieStatsCard(void)
{
    struct {
        char name[0x50];
        char text[0x40];
        short season[11];
        short playoff[17];
        char path[0x20];
        unsigned char attr[0x10];
        char abbr[8];
    } s;
    int y;
    int mainf;
    int kaufm;
    unsigned char *attrp;
    unsigned char *pl;
    int fh;
    int bank;
    int art;
    short *rec;
    int i;
    int x;
    int v;
    unsigned m;

    pl = statsplayer;
    mainf = mainfont;
    kaufm = kaufmfont;
    MakePath(s.path, (char *)statsleague, (char *)statsplayerdbs[statsfromleague], 0);
    fh = open(s.path, 0x200);
    lseek(fh, !statsfromleague ? dword_DC85C : dword_DC860, 0);
    read(fh, s.season, 0x36);
    j___close(fh);
    MakePath(s.path, (char *)statsleague, (char *)str_AttDb, 0);
    fh = open(s.path, 0x200);
    lseek(fh, *(int *)(pl + 0x24), 0);
    read(fh, s.attr, 0x10);
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
        *(T6 *)s.name = *(T6 *)str_PORTR2;
        memcpy(s.name + 5, pl + 0x30, 4);
        v = (((signed char *)pl)[0x31] - 0x30) * 10 + (((signed char *)pl)[0x32] - 0x30);
        s.name[8] = 0;
        MakePath(s.path, byte_ED909[v] == 1 ? (char *)cddriveptr : 0, s.name, 0);
        bank = sub_8E83C(s.path, 0);
        memcpy(s.name, pl + 0x30, 4);
        s.name[4] = 0;
        art = sub_B30BB(bank, s.name);
        if (art) {
            s.name[0] = 0x21;
            DrawPhotoWithPal((unsigned char *)sub_B30BB(bank, s.name) + 0x10, art, 0x21, 0x26);
            FreeMemBlock(bank);
            MakePath(s.path, fileoncd[0x13C] == 1 ? (char *)cddriveptr : 0, (char *)str_Pstatbar4, 0);
            statsbgshapes = sub_8E83C(s.path, 0);
            statspalshape = sub_B30B4(statsbgshapes, (char *)str_Pst12);
            sub_913B4(statspalshape);
        } else {
            FreeMemBlock(bank);
            MakePath(s.path, fileoncd[0x13C] == 1 ? (char *)cddriveptr : 0, (char *)str_Pstatbar4, 0);
            statsbgshapes = sub_8E83C(s.path, 0);
            statspalshape = sub_B30B4(statsbgshapes, (char *)str_Pst23);
            sub_913B4(statspalshape);
        }
        FreeMemBlock(statsbgshapes);
    } else {
        MakePath(s.path, fileoncd[0x13C] == 1 ? (char *)cddriveptr : 0, (char *)str_Pstatbar4, 0);
        statsbgshapes = sub_8E83C(s.path, 0);
        statspalshape = sub_B30B4(statsbgshapes, (char *)str_Pst23);
        sub_913B4(statspalshape);
        FreeMemBlock(statsbgshapes);
    }
    TextGridOpen();
    sub_8E9E8(s.text);
    sub_8EA18(kaufm);
    SetTextColors(0x40, 0x43);
    *(T13 *)printfbuf = *(T13 *)str_PlayerStats2;
    PrintOutlinedText(0x140 - (fputchar((char *)printfbuf) >> 1), 0x52, (char *)printfbuf);
    SetTextColors(0x40, 0x43);
    sprintf((char *)printfbuf, (char *)str_SS3, pl + 3, pl + 0x13);
    PrintCenteredText(0x98, (char *)printfbuf);
    sprintf((char *)printfbuf, (char *)str_DGoalie, pl[1]);
    PrintCenteredText(0xB2, (char *)printfbuf);
    sub_8EA18(mainf);
    y = 0xF3;
    PrintShadowText(0x82, (short)y, (char *)str_GP3);
    PrintShadowText(0xAA, (short)y, (char *)str_Min2);
    PrintShadowText(0xD2, (short)y, (char *)str_GAA2);
    PrintShadowText(0x10E, (short)y, (char *)str_W2);
    PrintShadowText(0x136, (short)y, (char *)str_L4);
    PrintShadowText(0x15E, (short)y, (char *)str_T2);
    PrintShadowText(0x186, (short)y, (char *)str_SO2);
    PrintShadowText(0x1AE, (short)y, (char *)str_EN2);
    PrintShadowText(0x1D6, (short)y, (char *)str_SA);
    PrintShadowText(0x212, (short)y, (char *)str_Pct3);
    rec = s.season;
    i = 0;
    y = 0x103;
    do {
        PrintShadowText(0x32, (short)y, (char *)statslabels[i]);
        PrintFmt1(0x82, (short)y, (char *)str_fmt2d, rec[0]);
        PrintFmt1(0xAA, (short)y, (char *)str_fmt4d, rec[6]);
        PrintFmt2(0xD2, (short)y, (char *)str_fmtMinSec, (short)((unsigned short)rec[8] / 100),
            (short)((unsigned short)rec[8] % 100));
        PrintFmt1(0x10E, (short)y, (char *)str_fmt2d, rec[1]);
        PrintFmt1(0x136, (short)y, (char *)str_fmt2d, rec[2]);
        PrintFmt1(0x15E, (short)y, (char *)str_fmt2d, rec[3]);
        PrintFmt1(0x186, (short)y, (char *)str_fmt2d, rec[4]);
        PrintFmt1(0x1AE, (short)y, (char *)str_fmt2d, rec[5]);
        PrintFmt1(0x1D6, (short)y, (char *)str_fmt5d, rec[9]);
        if ((unsigned short)rec[10] < 1000) {
            PrintFmt1(0x212, (short)y, (char *)str_fmtPct0, (short)((unsigned short)rec[10] % 1000));
        } else {
            m = (unsigned short)rec[10];
            PrintFmt2(0x212, (short)y, (char *)str_fmtPct, (short)((int)m / 1000), (short)((int)m % 1000));
        }
        rec = s.playoff;
        y += 0xD;
    } while (++i < 2);
    y = 0x131;
    PrintCenteredText((short)y, (char *)str_Ratings3);
    attrp = s.attr;
    y = 0x143;
    PrintShadowText(0x14, (short)y, (char *)str_GloveHand2);
    if (s.attr[0]) PrintShadowText(0x104, (short)y, (char *)str_L3);
    else PrintShadowText(0x104, (short)y, (char *)str_R2);
    x = 0;
    y += 0xD;
    for (i = 0; i < 0xA; i++) {
        if (i == 5) {
            x += 0x140;
            y -= (i + 1) * 0xD;
        }
        PrintShadowText((short)(x + 0x14), (short)y, (char *)goalieratingnames[i]);
        v = (attrp[((signed char *)off_C6AD1)[i + 3]] + 5) * 5;
        PrintFmt1((short)(x + 0x104), (short)y, (char *)str_fmt3d, (short)v);
        y += 0xD;
    }
    sub_8EA00(s.text);
    TextGridOff();
}
