/* Roster and jersey: trade statistics page. */
#define TradeShowStats TradeShowStats_decl
#define RunMenu RunMenu_decl
#define TeamRosterScreen TeamRosterScreen_decl
#define DrawTradeScreen DrawTradeScreen_decl
#include "nhl95.h"
#undef TradeShowStats
#undef RunMenu
#undef TeamRosterScreen
#undef DrawTradeScreen

void RunMenu(void *bar, int n, int col1, int col2, int col3);
void TeamRosterScreen(int cat);
void DrawTradeScreen(int list, int s0, int s2, int s1, int s3, int b3, int b2);

/* TradeShowStats: fade out, load the roster stat screens for cat, show the trade menu, then fade
 back and redraw the trade screen. list and the other arguments are the trade screen's own.
 The last stack argument is unused. */
void TradeShowStats(int list, unsigned char cat, int b2, int b3,
                    int s0, int s1, int s2, int s3, int s4)
{
    char path[16];
    char *dir;
    char *name;
    char *ext;
    int pal;
    int bank;
    int shape;
    int c;
    int z;

    sub_B4BA8();
    pal = sub_8CCA8((char *)str_Temp6, 0x300, 0x20);
    sub_8FFB0(0, 0x100, (unsigned char *)pal);
    FadePalStep(1, (unsigned char *)pal, 0x10);
    sub_B392C(0);
    dword_DC738 = 1;
    statsredrawcb = (int)TeamRosterScreen;
    statscategory = cat;
    statsteambuf = sub_8CCA8((char *)str_Tstat, 0x2A4, 0x20);
    statsplayerbuf = (unsigned char *)sub_8CCA8((char *)str_Keys2, 0x5B0, 0x20);
    statsskaterbuf = (unsigned char *)sub_8CCA8((char *)str_Pstat2, 0x497, 0x20);
    statsgoaliebuf = (unsigned char *)sub_8CCA8((char *)str_Gstat2, 0x10E, 0x20);
    ext = 0;
    name = (char *)str_Embpal3;
    if (fileoncd[0x8E] == 1)
        dir = (char *)cddriveptr;
    else
        dir = 0;
    MakePath(path, dir, name, ext);
    bank = sub_8E83C(path, 0);
    shape = sub_B30B4(bank, (char *)str_Pal21);
    memcpy((unsigned char *)pal, (char *)shape + 0x10, 0x300);
    FreeMemBlock(bank);
    InitMenuRemap(1);
    TeamRosterScreen(cat);
    DrawMenuBar(unk_C88E2, 2, 0x40, 0x41, 0x42);
    FadePalStep(0, (unsigned char *)pal, 0x10);
    RunMenu(unk_C88E2, 2, 0x40, 0x41, 0x42);
    c = 0;
    dword_DC738 = c;
    statsredrawcb = c;
    FreeMemBlock(statsteambuf);
    FreeMemBlock((int)statsgoaliebuf);
    FreeMemBlock((int)statsskaterbuf);
    FreeMemBlock((int)statsplayerbuf);
    z = 0;
    statsplayerbuf = (unsigned char *)z;
    statsteambuf = z;
    statsgoaliebuf = (unsigned char *)z;
    statsskaterbuf = (unsigned char *)z;
    sub_B4BA8();
    FadePalStep(1, (unsigned char *)pal, 0x10);
    sub_B392C(z);
    FreeMemBlock(pal);
    DrawTradeScreen(list, s0, s2, s1, s3, b3, b2);
}
