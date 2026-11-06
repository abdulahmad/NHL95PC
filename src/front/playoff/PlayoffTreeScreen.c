/* cflags: -od */
/* Standings playoffs: the EASN playoff tree screen. */

#define PrintShadowText PrintShadowText_decl
#define CountSeriesWins CountSeriesWins_decl
#include "nhl95.h"
#undef PrintShadowText
#undef CountSeriesWins

typedef struct { short a; short b; } Pair;
typedef struct { char c[34]; } TreeStr34b;
typedef struct { char c[19]; } TreeStr19b;
typedef struct { char c[3]; } TreeStr3b;

void PrintShadowText(short x, short y, char *s);  /* 175E2 */
void CountSeriesWins(int *teams, int *out, int mode);  /* 27C34 */

/* PlayoffTreeScreen (27F9C, PC only): the stats desk's playoff tree, the -od twin of DrawPlayoffTree. Set the
   desk's exit action (none before the playoffs start), draw the stats background (BKGD2 from the stats bank or the
   loaded EMBSCUP bank) and, when dword_C6D26 asks, set the PAL palette (or keep it in statspal); count the series
   wins (CountSeriesWins, schedule mode 0). Before the playoffs say so; otherwise draw the PSTATBAR8 bars, the title
   and conference captions and the tree from the top as DrawPlayoffTree does (seed letter, city, wins; winners lit
   44h / C4h; the SCUPARRW2 arrows between rounds). No arguments, no result. */
void PlayoffTreeScreen(void)
{
    short unused1;
    short slot;
    short unused2;
    short unused3;
    short i;
    short x;
    short unused4;
    short unused5;
    short x2;
    int unused6;
    int mf;
    int unused7;
    int y;
    int midl;
    int kf;
    char path[0x20];
    char state[0x40];
    char buf[0x54];
    char unused8[0x60];
    int wins[0x1E];

    midl = 0;
    mf = mainfont;
    kf = kaufmfont;
    if (playofftree[0] == 0x1A) off_CF6A3 = 0;
    else off_CF6A3 = (int)DeskSetExit3b;
    sub_B4BA8();
    if (dword_C65AC == 0) {
        MakePath(path, fileoncd[0x8D] == 1 ? (char *)cddriveptr : 0, (char *)statsbgnames[statsplayoffs], 0);
        statsbgshapes = sub_8E83C(path, 0);
        statspalshape = sub_B30B4(statsbgshapes, (char *)str_Bkgd2);
        sub_B4BC4(0, 0x280, 0x13, 0x1E0);
        sub_913B4(statspalshape);
        sub_B4BC4(0, 0x280, 0, 0x1E0);
        FreeMemBlock(statsbgshapes);
    } else {
        statspalshape = sub_B30B4(dword_C65AC, (char *)str_Bkgd2);
        sub_B4BC4(0, 0x280, 0x13, 0x1E0);
        sub_913B4(statspalshape);
        sub_B4BC4(0, 0x280, 0, 0x1E0);
    }
    if (dword_C6D26 == 1) {
        MakePath(path, fileoncd[0x8E] == 1 ? (char *)cddriveptr : 0, (char *)str_Embpal2, 0);
        statsbgshapes = sub_8E83C(path, 0);
        statspalshape = sub_B30B4(statsbgshapes, (char *)str_Pal9);
        if (statspalvalid == 1) memcpy((void *)statspal, (void *)(statspalshape + 0x10), 0x300);
        else sub_B4B88(0, 0x100, (unsigned char *)statspalshape + 0x10);
        FreeMemBlock(statsbgshapes);
        dword_C6D26 = 0;
    }
    CountSeriesWins(playofftree, wins, 0);
    SetTextColors(0x40, 0x43);
    if (playofftree[treecolslots[0]] > 0x19) {
        sub_8EA18(kf);
        *(TreeStr34b *)buf = *(TreeStr34b *)str_PlayoffsHaveNotBeen2;
        PrintOutlinedText(0x140 - (fputchar(buf) >> 1), 0xF0, buf);
        sub_8EA18(mf);
        return;
    }
    MakePath(path, fileoncd[0x13C] == 1 ? (char *)cddriveptr : 0, (char *)str_Pstatbar8, 0);
    statsbgshapes = sub_8E83C(path, 0);
    statspalshape = sub_B30B4(statsbgshapes, (char *)str_Rst12);
    sub_91370(statspalshape, 0, 0x1A);
    statspalshape = sub_B30B4(statsbgshapes, (char *)str_Rst22);
    sub_91370(statspalshape, 0xF, 0x192);
    FreeMemBlock(statsbgshapes);
    MakePath(path, fileoncd[0x16E] == 1 ? (char *)cddriveptr : 0, (char *)str_Scuparrw2, 0);
    statsbgshapes = sub_8E83C(path, 0);
    TextGridOpen();
    sub_8E9E8(state);
    sub_8EA18(mf);
    MakeStatsTitle(buf, (char *)str_Standings);
    PrintCenteredText(0x16, buf);
    sub_8EA18(kf);
    *(TreeStr19b *)buf = *(TreeStr19b *)str_WesternConference2;
    PrintOutlinedText(0x140 - (fputchar(buf) >> 1), 0x2F, buf);
    *(TreeStr19b *)buf = *(TreeStr19b *)str_EasternConference2;
    PrintOutlinedText(0x140 - (fputchar(buf) >> 1), 0x1A7, buf);
    sub_8EA18(mf);
    for (i = 0; i < 8; i++) {
        if (i < 4) {
            x = i;
            slot = treecolslots[i * 2];
        } else {
            x = 7 - i;
            slot = treecolslots[7 - (i * 2 - 8)];
        }
        dword_C6DBA[playofftree[slot]] = i;
        if (i < 4) {
            x = i;
            slot = treecol_Er1[i * 2];
        } else {
            x = 7 - i;
            slot = treecol_Er1[7 - (i * 2 - 8)];
        }
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
        sprintf(buf, (char *)str_C3, dword_C6DBA[playofftree[slot]] + 0x91);
        strcat(buf, (char *)treeteamnames + playofftree[slot] * 21);
        PrintShadowText(((Pair *)treecolx)[x].a, y, buf);
        x2 = ((Pair *)treecolx)[x].a + 0x6A;
        if (playofftree[treecol_Wr2[0]] == playofftree[slot] || playofftree[treecol_Wr2[1]] == playofftree[slot]
            || playofftree[treecol_Wr2[2]] == playofftree[slot] || playofftree[treecol_Wr2[3]] == playofftree[slot])
            SetTextColors(0x44, 0x43);
        else
            SetTextColors(0x40, 0x43);
        sprintf(buf, (char *)str_D3, wins[slot]);
        PrintShadowText(x2, y, buf);
        if (i == 3) y += 0x10;
    }
    y += 0x3F;
    if (playofftree[treecol_Wr2[0]] < 0x1A && playofftree[treecol_Wr2[1]] < 0x1A && playofftree[treecol_Wr2[2]] < 0x1A
        && playofftree[treecol_Wr2[3]] < 0x1A) {
        statspalshape = sub_B30B4(statsbgshapes, (char *)str_Aup12);
        sub_913B4(statspalshape);
        for (i = 0; i < 4; i++) {
            if (i < 2) {
                x = i + 4;
                slot = treecol_Wr2[i * 2];
            } else {
                x = 7 - i;
                slot = treecol_Wr2[3 - (i * 2 - 4)];
            }
            SetTextColors(0x40, 0x43);
            sprintf(buf, (char *)str_C3, dword_C6DBA[playofftree[slot]] + 0x91);
            strcat(buf, (char *)treeteamnames + playofftree[slot] * 21);
            PrintShadowText(((Pair *)treecolx)[x].a, y, buf);
            x2 = ((Pair *)treecolx)[x].a + 0x6A;
            if (playofftree[treecolslots[0x10]] == playofftree[slot] || playofftree[treecolslots[0x11]] == playofftree[slot])
                SetTextColors(0x44, 0x43);
            else
                SetTextColors(0x40, 0x43);
            sprintf(buf, (char *)str_D3, wins[slot]);
            PrintShadowText(x2, y, buf);
            if (i == 1) y += 0x10;
        }
        y += 0x3D;
        if (playofftree[treecolslots[0x10]] < 0x1A && playofftree[treecolslots[0x11]] < 0x1A) {
            statspalshape = sub_B30B4(statsbgshapes, (char *)str_Aup22);
            sub_913B4(statspalshape);
            slot = treecolslots[0x10];
            SetTextColors(0x40, 0x43);
            sprintf(buf, (char *)str_C3, dword_C6DBA[playofftree[slot]] + 0x91);
            strcat(buf, (char *)treeteamnames + playofftree[slot] * 21);
            PrintShadowText(0x48, y - 1, buf);
            if (playofftree[treecolslots[0x18]] == playofftree[slot] || playofftree[treecolslots[0x28]] == playofftree[slot])
                SetTextColors(0x44, 0x43);
            else
                SetTextColors(0x40, 0x43);
            sprintf(buf, (char *)str_D3, wins[slot]);
            PrintShadowText(0xB2, y - 1, buf);
            y += 0x10;
            slot = treecolslots[0x11];
            SetTextColors(0x40, 0x43);
            sprintf(buf, (char *)str_C3, dword_C6DBA[playofftree[slot]] + 0x91);
            strcat(buf, (char *)treeteamnames + playofftree[slot] * 21);
            PrintShadowText(0x48, y - 1, buf);
            if (playofftree[treecolslots[0x18]] == playofftree[slot] || playofftree[treecolslots[0x28]] == playofftree[slot])
                SetTextColors(0x44, 0x43);
            else
                SetTextColors(0x40, 0x43);
            sprintf(buf, (char *)str_D3, wins[slot]);
            PrintShadowText(0xB2, y - 1, buf);
            y -= 0x10;
        }
    } else {
        y += 0x4D;
    }
    if (playofftree[treecolslots[0x18]] < 0x1A) {
        statspalshape = sub_B30B4(statsbgshapes, (char *)str_Aup32);
        sub_913B4(statspalshape);
        midl = 1;
        statspalshape = sub_B30B4(statsbgshapes, (char *)str_Midl2);
        sub_913B4(statspalshape);
        SetTextColors(0x40, 0x43);
        *(TreeStr3b *)buf = *(TreeStr3b *)str_TwoSpaces;
        slot = treecolslots[0x18];
        strcat(buf, (char *)treeteamnames + playofftree[slot] * 21);
        PrintShadowText(0x102, y - 4, buf);
        sprintf(buf, (char *)str_D3, wins[slot]);
        if (playofftree[treecolslots[0x20]] == playofftree[slot]) {
            if (teamconf[slot] == 3) SetTextColors(0x44, 0x43);
            else SetTextColors(0xC4, 0x43);
        } else {
            SetTextColors(0x40, 0x43);
        }
        PrintShadowText(0x16C, y - 4, buf);
    }
    if (playofftree[treecolslots[0x28]] < 0x1A) {
        statspalshape = sub_B30B4(statsbgshapes, (char *)str_Adn32);
        sub_913B4(statspalshape);
        if (midl == 0) {
            statspalshape = sub_B30B4(statsbgshapes, (char *)str_Midl2);
            sub_913B4(statspalshape);
        }
        y += 0x10;
        SetTextColors(0x40, 0x43);
        *(TreeStr3b *)buf = *(TreeStr3b *)str_TwoSpaces;
        slot = treecolslots[0x28];
        strcat(buf, (char *)treeteamnames + playofftree[slot] * 21);
        PrintShadowText(0x102, y - 4, buf);
        sprintf(buf, (char *)str_D3, wins[slot]);
        if (playofftree[treecolslots[0x20]] == playofftree[slot]) {
            if (teamconf[slot] == 3) SetTextColors(0x44, 0x43);
            else SetTextColors(0xC4, 0x43);
        } else {
            SetTextColors(0x40, 0x43);
        }
        PrintShadowText(0x16C, y - 4, buf);
        y -= 0x10;
    }
    if (playofftree[treecolslots[0x30]] < 0x1A && playofftree[treecolslots[0x31]] < 0x1A) {
        slot = treecolslots[0x30];
        SetTextColors(0x40, 0x43);
        sprintf(buf, (char *)str_C3, dword_C6DBA[playofftree[slot]] + 0x91);
        strcat(buf, (char *)treeteamnames + playofftree[slot] * 21);
        PrintShadowText(0x1C6, y - 1, buf);
        if (playofftree[treecolslots[0x18]] == playofftree[slot] || playofftree[treecolslots[0x28]] == playofftree[slot])
            SetTextColors(0xC4, 0x43);
        else
            SetTextColors(0x40, 0x43);
        sprintf(buf, (char *)str_D3, wins[slot]);
        PrintShadowText(0x230, y - 1, buf);
        y += 0x10;
        slot = treecolslots[0x31];
        SetTextColors(0x40, 0x43);
        sprintf(buf, (char *)str_C3, dword_C6DBA[playofftree[slot]] + 0x91);
        strcat(buf, (char *)treeteamnames + playofftree[slot] * 21);
        PrintShadowText(0x1C6, y - 1, buf);
        if (playofftree[treecolslots[0x18]] == playofftree[slot] || playofftree[treecolslots[0x28]] == playofftree[slot])
            SetTextColors(0xC4, 0x43);
        else
            SetTextColors(0x40, 0x43);
        sprintf(buf, (char *)str_D3, wins[slot]);
        PrintShadowText(0x230, y - 1, buf);
        y += 0x3D;
        statspalshape = sub_B30B4(statsbgshapes, (char *)str_Adn22);
        sub_913B4(statspalshape);
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
            sprintf(buf, (char *)str_C3, dword_C6DBA[playofftree[slot]] + 0x91);
            strcat(buf, (char *)treeteamnames + playofftree[slot] * 21);
            PrintShadowText(0x280 - (((Pair *)treecolx)[5 - x].a + 0x64), y, buf);
            x2 = 0x286 - ((Pair *)treecolx)[5 - x].a;
            if (playofftree[treecolslots[0x30]] == playofftree[slot] || playofftree[treecolslots[0x31]] == playofftree[slot])
                SetTextColors(0xC4, 0x43);
            else
                SetTextColors(0x40, 0x43);
            sprintf(buf, (char *)str_D3, wins[slot]);
            PrintShadowText(x2, y, buf);
            if (i == 1) y += 0x10;
        }
        y += 0x3D;
        statspalshape = sub_B30B4(statsbgshapes, (char *)str_Adn12);
        sub_913B4(statspalshape);
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
        sprintf(buf, (char *)str_C3, dword_C6DBA[playofftree[slot]] + 0x91);
        strcat(buf, (char *)treeteamnames + playofftree[slot] * 21);
        PrintShadowText(((Pair *)treecolx)[x].a, y, buf);
        x2 = ((Pair *)treecolx)[x].a + 0x6A;
        if (playofftree[treecol_Er2[0]] == playofftree[slot] || playofftree[treecol_Er2[1]] == playofftree[slot]
            || playofftree[treecol_Er2[2]] == playofftree[slot] || playofftree[treecol_Er2[3]] == playofftree[slot])
            SetTextColors(0xC4, 0x43);
        else
            SetTextColors(0x40, 0x43);
        sprintf(buf, (char *)str_D3, wins[slot]);
        PrintShadowText(x2, y, buf);
        if (i == 3) y += 0x10;
    }
    TextGridOff();
    FreeMemBlock(statsbgshapes);
    sub_8EA00(state);
}
