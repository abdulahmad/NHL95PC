/* Scoreboard: draw the in-game panel, clock, period and crests. */
#define DrawHudPanel DrawHudPanel_decl
#define DrawPanelClock DrawPanelClock_decl
#define DrawPanelScore DrawPanelScore_decl
#define sub_B4CD8 sub_B4CD8_decl
#define sub_B4E50 sub_B4E50_decl
#include "nhl95.h"
#undef DrawHudPanel
#undef DrawPanelClock
#undef DrawPanelScore
#undef sub_B4CD8
#undef sub_B4E50

void DrawPanelClock(void);
void DrawPanelScore(int side, int score);
void __cdecl sub_B4CD8(int shape, int x, int y);
void __cdecl sub_B4E50(int shape, int x, int y);

/* DrawHudPanel: reset the hud clock from the period length when asked, clear the panel
 counters, then draw the scoreboard art, both scores, the clock, the period digits, the
 two crests and the line markers. home and away select the crest names. */
void DrawHudPanel(int home, int away, int period, int reset)
{
    char path[16];
    int bank;
    int z;

    if (reset) {
        hudclockmin = hudclocksec = GetPeriodTime();
        hudclockmin /= 60;
        hudclocksec %= 60;
        hudclockhund = 0;
    }
    z = 0;
    dword_C583C = z;
    dword_C5848 = z;
    dword_C5844 = z;
    hudhomeline = *(int *)((char *)&hmtmline - 2) >> 16;
    hudawayline = *(int *)((char *)&awtmline - 2) >> 16;
    dword_C5858 = z;
    dword_C5854 = z;
    dword_C5860 = z;
    dword_C585C = z;
    SelectScreenBM();
    MakePath(path, fileoncd[0x16D] == 1 ? (char *)cddriveptr : 0, (char *)str_Scrbrd2, (char *)str_PPV);
    bank = sub_8E8A0(path, 0);
    sub_B4CF2(sub_B30B4(bank, (char *)str_Srb3));
    DrawPanelScore(0, *(int *)((char *)&hmscore - 2) >> 16);
    DrawPanelScore(1, *(int *)((char *)&awscore - 2) >> 16);
    SelectScreenBM();
    DrawPanelClock();
    if (period == 0) {
        sub_B4CD8(sub_B30B4(bank, (char *)off_C57C8), 0x98, 0x16);
    } else {
        int p;

        p = period % 100;
        sub_B4CD8(sub_B30B4(bank, (char *)perioddigits[p / 10]), 0x98, 0x16);
        sub_B4CD8(sub_B30B4(bank, (char *)perioddigits[p % 10]), 0xA0, 0x16);
    }

    FreeMemBlock(bank);
    MakePath(path, fileoncd[0x57] == 1 ? (char *)cddriveptr : 0, (char *)str_Crests4, (char *)str_PPV);
    bank = sub_8E8A0(path, 0);
    byte_DCA1B = 0x67;
    byte_DC91B = 0x67;
    byte_DC9D7 = 0xFF;
    byte_DCAD7 = 0xFF;
    sub_B4DD4(byte_DC9D8);
    reset = home;
    sub_B4E50(sub_B30B4(bank, (char *)crestnames[reset]), 4, 4);
    sub_B4DD4(byte_DC8D8);
    sub_B4E50(sub_B30B4(bank, (char *)crestnames[away]), 0x11C, 4);
    byte_DCA1B = 0x43;
    byte_DC91B = 0x43;
    FreeMemBlock(bank);
    sub_B4CD8(linesprites[hudhomeline], 0x2A, 0x14);
    sub_B4CD8(linesprites[hudawayline], 0xFB, 0x14);
}
