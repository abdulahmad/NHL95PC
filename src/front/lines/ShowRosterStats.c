/* Line editor rosters: the roster stats screen. */
/* DRAFT: 2,097 vs 2,098 bytes, every statement in place; three register picks left (the goalie copy loop's team
   record in eax, EXE edx; the playoff skater record built in eax, EXE ebx; the goalie key record's 34h product
   finished in edi, EXE eax). See docs/UNSURE.md. */
#define ShowRosterStats ShowRosterStats_decl
#include "nhl95.h"
#undef ShowRosterStats

typedef struct { char c[0x34]; } PRec;  /* a key database player record */
typedef struct { char c[0x28]; } PStat;  /* a roster skater stats record */
typedef struct { char c[0x2C]; } GStat;  /* a roster goalie stats record */

/* ShowRosterStats (75BF7, PC only): the stats page of the line editor's team (rosterteamrec[lineedpanel]). Copies
   the key records of its 25 skater and 3 goalie slots (-1 is empty) into statsplayerbuf (34h bytes each, goalies
   from 19h) and their career records into rosterpstat / rostergstat, sorts the shown order with CmpRosterSkaters
   and CmpRosterGoalies, draws the team's EMB background (from the CD when fileoncd says so) and the menu bar, then
   prints "<team> Roster:" and a row per skater (position, number below 100, name, games, goals, assists, points,
   shots, penalty minutes, plus / minus) and per goalie (games, minutes, goals against average, wins, losses, ties
   outside the playoffs, goals and shots against, save percentage), from the season or the playoff block
   (statsplayoffs). c0 to c2 are DrawMenuBar's colours, c0 and c3 the text colours. Result: 0. */
int ShowRosterStats(int c0, int c1, int c2, int c3)
{
    struct {
        char state[0x40];
        char buf[0x28];
        char path[0x20];
    } f;
    int idx;
    int n;
    int m;
    int i;
    int y;
    unsigned char *p;
    unsigned char *k;
    unsigned short *s;
    int bank;
    int art;

    for (i = n = 0; i < 0x19; i++) {  /* i = n = 0: a plain i = 0 drops the jump to the loop test */
        if (((int *)(rosterteamrec[lineedpanel] + 0x4C))[i] != -1) {
            k = KeyDbPtr(((int *)(rosterteamrec[lineedpanel] + 0x4C))[i]);
            ((PRec *)statsplayerbuf)[i] = *(PRec *)k;
            ((PStat *)rosterpstat)[n] = *(PStat *)CareerDbPtr(*(int *)(k + 0x28));
            statsskaterplr[n] = i;
            statsskaterorder[n] = n;
            n++;
        }
    }
    for (i = m = 0; i < 3; i++) {
        if (((int *)(rosterteamrec[lineedpanel] + 0xB0))[i] != -1) {
            k = KeyDbPtr(((int *)(rosterteamrec[lineedpanel] + 0xB0))[i]);
            ((PRec *)statsplayerbuf)[i + 0x19] = *(PRec *)k;
            ((GStat *)rostergstat)[m] = *(GStat *)CareerDbPtr2(*(int *)(k + 0x28));
            statsgoalieplr[m] = i + 0x19;
            statsgoalieorder[m] = m;
            m++;
        }
    }
    qsort(statsskaterorder, n, 4, (int (*)(const void *, const void *))CmpRosterSkaters);
    qsort(statsgoalieorder, m, 4, (int (*)(const void *, const void *))CmpRosterGoalies);
    SetDrawBitmap(fullscrbmp);
    sub_B392C(0);
    sprintf(f.buf, (char *)str_fmtEmb, rosterteamrec[lineedpanel]);
    MakePath(f.path, fileoncd[rosterteam[lineedpanel] + 0x70] == 1 ? (char *)cddriveptr : 0, f.buf, 0);
    bank = sub_8E83C(f.path, 0);
    art = sub_B30B4(bank, (char *)str_Bkgd2);
    sub_B4BC4(0, 0x280, 0x13, 0x1E0);
    sub_913B4(art);
    sub_B4BC4(0, 0x280, 0, 0x1E0);
    FreeMemBlock(bank);
    sub_8E9E8(f.state);
    sub_8EA18(mainfont);
    DrawMenuBar(unk_D075E, 2, c0, c1, c2);
    SetTextColors(c0, c3);
    sprintf(f.buf, (char *)str_SRoster, rosterteamrec[lineedpanel] + 5);
    PrintCenteredText(0x19, f.buf);
    PrintShadowText(0x14, 0x30, (char *)str_Pos2);
    PrintShadowText(0x42, 0x30, (char *)str_No2);
    PrintShadowText(0x60, 0x30, (char *)str_Name2);
    PrintShadowText(0x10E, 0x30, (char *)str_GP8);
    PrintShadowText(0x136, 0x30, (char *)str_G4);
    PrintShadowText(0x15E, 0x30, (char *)str_A4);
    PrintShadowText(0x186, 0x30, (char *)str_PT2);
    PrintShadowText(0x1AE, 0x30, (char *)str_Shots4);
    PrintShadowText(0x1E8, 0x30, (char *)str_PIM4);
    PrintShadowText(0x210, 0x30, (char *)asc_C3164);
    for (i = 0, y = 0x40; i < n; y += 0xD, i++) {
        idx = statsskaterorder[i];
        p = statsplayerbuf + statsskaterplr[idx] * 0x34;
        sprintf(f.buf, (char *)str_C5, ((signed char *)p)[2]);
        PrintShadowText(0x14, y, f.buf);
        if (p[1] < 100) PrintFmt1(0x42, y, (char *)str_fmt2d, p[1]);
        FitPlayerName(f.buf, (char *)p + 3, (char *)p + 0x13, 0xA6);
        PrintShadowText(0x60, y, f.buf);
        s = !statsplayoffs ? (unsigned short *)(rosterpstat + idx * 0x28)
                           : (unsigned short *)(rosterpstat + idx * 0x28 + 0x12);
        PrintFmt1(0x10E, y, (char *)str_fmt2d, s[0]);
        PrintFmt1(0x136, y, (char *)str_fmt3d, s[1]);
        PrintFmt1(0x15E, y, (char *)str_fmt3d, s[2]);
        PrintFmt1(0x186, y, (char *)str_fmt3d, s[3]);
        PrintFmt1(0x1AE, y, (char *)str_fmt4d, s[7]);
        PrintFmt1(0x1E8, y, (char *)str_fmt3d, s[6]);
        PrintFmt1(0x210, y, (char *)str_fmt4d, ((short *)s)[8]);
    }
    y = 0x195;
    PrintShadowText(0x14, y, (char *)str_Pos2);
    PrintShadowText(0x42, y, (char *)str_No2);
    PrintShadowText(0x60, y, (char *)str_Name2);
    PrintShadowText(0x10E, y, (char *)str_GP8);
    PrintShadowText(0x136, y, (char *)str_Min4);
    PrintShadowText(0x15E, y, (char *)str_GAA4);
    PrintShadowText(0x190, y, (char *)str_W6);
    PrintShadowText(0x1AE, y, (char *)str_L8);
    if (!statsplayoffs) PrintShadowText(0x1CC, y, (char *)str_T6);
    PrintShadowText(0x1EA, y, (char *)str_GA3);
    PrintShadowText(0x20E, y, (char *)str_SA3);
    PrintShadowText(0x240, y, (char *)str_PCT2);
    for (i = 0, y += 0x10; i < m; y += 0xD, i++) {
        unsigned short *gs;  /* declared here it stays on the stack and is cached in edi, as in the EXE */

        idx = statsgoalieorder[i];
        p = statsplayerbuf + statsgoalieplr[idx] * 0x34;
        sprintf(f.buf, (char *)str_C5, ((signed char *)p)[2]);
        PrintShadowText(0x14, y, f.buf);
        if (p[1] < 100) PrintFmt1(0x42, y, (char *)str_fmt2d, p[1]);
        FitPlayerName(f.buf, (char *)p + 3, (char *)p + 0x13, 0xA6);
        PrintShadowText(0x60, y, f.buf);
        gs = !statsplayoffs ? (unsigned short *)(rostergstat + idx * 0x2C)
                            : (unsigned short *)(rostergstat + idx * 0x2C + 0x16);
        PrintFmt1(0x10E, y, (char *)str_fmt2d, gs[0]);
        PrintFmt1(0x136, y, (char *)str_fmt4d, gs[6]);
        PrintFmt2(0x15E, y, (char *)str_fmtMinSec, gs[8] / 100, gs[8] % 100);
        PrintFmt1(0x190, y, (char *)str_fmt2d, gs[1]);
        PrintFmt1(0x1AE, y, (char *)str_fmt2d, gs[2]);
        if (!statsplayoffs) PrintFmt1(0x1CC, y, (char *)str_fmt2d, gs[3]);
        PrintFmt1(0x1EA, y, (char *)str_fmt3d, gs[7]);
        PrintFmt1(0x20E, y, (char *)str_fmt4d, gs[9]);
        PrintFmt2(0x240, y, (char *)str_fmtTenths, gs[10] / 10, gs[10] % 10);
    }
    sub_B4BA8();
    sub_9121C(*(int *)(fullscrbmp + 0x2C));
    sub_8EA00(f.state);
    return 0;
}
