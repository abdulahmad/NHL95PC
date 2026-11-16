/* Scoreboard: draw the in-game panel, clock, period and crests. */
#define DrawHudPanel DrawHudPanel_decl
#define DrawPanelClock DrawPanelClock_decl
#define DrawPanelScore DrawPanelScore_decl
#define VgaBlitKeyedHot sub_B4CD8_decl
#define VgaBlitRemap sub_B4E50_decl
#include "nhl95.h"
#undef DrawHudPanel
#undef DrawPanelClock
#undef DrawPanelScore
#undef VgaBlitKeyedHot
#undef VgaBlitRemap

void DrawPanelClock(void);
void DrawPanelScore(int side, int score);
void __cdecl VgaBlitKeyedHot(int shape, int x, int y);
void __cdecl VgaBlitRemap(int shape, int x, int y);

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
    panelhund = z;
    awpanellines = z;
    hmpanellines = z;
    hudhomeline = *(int *)((char *)&hmtmline - 2) >> 16;
    hudawayline = *(int *)((char *)&awtmline - 2) >> 16;
    awpanelpens = z;
    hmpanelpens = z;
    awlinetimer = z;
    hmlinetimer = z;
    SelectScreenBM();
    MakePath(path, fileoncd[0x16D] == 1 ? (char *)cddriveptr : 0, (char *)str_Scrbrd2, (char *)str_PPV);
    bank = sub_8E8A0(path, 0);
    VgaBlitKeyed(FindShape(bank, (char *)str_Srb3));
    DrawPanelScore(0, *(int *)((char *)&hmscore - 2) >> 16);
    DrawPanelScore(1, *(int *)((char *)&awscore - 2) >> 16);
    SelectScreenBM();
    DrawPanelClock();
    if (period == 0) {
        VgaBlitKeyedHot(FindShape(bank, (char *)hudotname), 0x98, 0x16);
    } else {
        int p;

        p = period % 100;
        VgaBlitKeyedHot(FindShape(bank, (char *)perioddigits[p / 10]), 0x98, 0x16);
        VgaBlitKeyedHot(FindShape(bank, (char *)perioddigits[p % 10]), 0xA0, 0x16);
    }

    FreeMemBlock(bank);
    MakePath(path, fileoncd[0x57] == 1 ? (char *)cddriveptr : 0, (char *)str_Crests4, (char *)str_PPV);
    bank = sub_8E8A0(path, 0);
    homeremap_e43 = 0x67;
    awayremap_e43 = 0x67;
    awayremap_eFF = 0xFF;
    homeremap_eFF = 0xFF;
    SetColorRemap(homeremap);
    reset = home;
    VgaBlitRemap(FindShape(bank, (char *)crestnames[reset]), 4, 4);
    SetColorRemap(awayremap);
    VgaBlitRemap(FindShape(bank, (char *)crestnames[away]), 0x11C, 4);
    homeremap_e43 = 0x43;
    awayremap_e43 = 0x43;
    FreeMemBlock(bank);
    VgaBlitKeyedHot(linesprites[hudhomeline], 0x2A, 0x14);
    VgaBlitKeyedHot(linesprites[hudawayline], 0xFB, 0x14);
}
