/* EASN stats: skater stats screen. */
#define GameSkaterStatsScreen GameSkaterStatsScreenDecl
#define RunMenu RunMenuDecl
#define GameStandingsMenu GameStandingsMenuDecl
#include "nhl95.h"
#undef GameSkaterStatsScreen
#undef RunMenu
#undef GameStandingsMenu

void RunMenu(void *bar, int n, int col1, int col2, int col3);
int LeadersScreen(int cat);

/* GameSkaterStatsScreen: the skater-stats page. Same fade and embpal load as the team page, with
 LeadersScreen, menu bar unk_CF80F, and the palette buffer recorded in statspal while it is current.
 The zero that clears statspal is reused for the fade-back and the redraw hook. Returns 2. */
int GameSkaterStatsScreen(int cat)
{
    unsigned char buf[0x310];
    int one;
    char *dir;
    char *name;
    char *ext;
    int z;

    one = 1;
    dword_DC738 = one;
    statscategory = cat;
    statsredrawcb = (int)LeadersScreen;
    statspalvalid = one;
    statspal = (int)buf;
    sub_8FFB0(0, 0x100, buf);
    FadePalStep(1, buf, 0x10);
    sub_B4BA8();
    InitMenuRemap(1);
    LeadersScreen(cat);
    DrawMenuBar(unk_CF80F, 4, 0x40, 0x41, 0x42);
    ext = 0;
    name = (char *)str_embpal;
    if (fileoncd[0x8E] == 1) dir = (char *)cddriveptr;
    else dir = 0;
    MakePath((char *)buf + 0x300, dir, name, ext);
    statsbgshapes = sub_8E83C((char *)buf + 0x300, 0);
    statspalshape = sub_B30B4(statsbgshapes, (char *)str_Pal6);
    memcpy(buf, (unsigned char *)statspalshape + 0x10, 0x300);
    FreeMemBlock(statsbgshapes);
    FadePalStep(0, buf, 0x10);
    z = 0;
    statspalvalid = z;
    statspal = z;
    RunMenu(unk_CF80F, 4, 0x40, 0x41, 0x42);
    sub_8FFB0(z, 0x100, buf);
    FadePalStep(1, buf, 0x10);
    dword_DC738 = z;
    statsredrawcb = z;
    return 2;
}

/* GameStandingsMenu (2051A, PC only; the exit is GameSkaterStatsScreen_x): the in-game standings menu. Fade out,
   reset the stats selection (team, category, statsplayer flag byte), load the team / key / skater / goalie stats
   files (tstat, keys, pstat, gstat) into their buffers, draw the standings (standingscb) with menu bar unk_CF54F,
   set the embpal palette and run the team pick menu. Then follow deskexit until 1 (back): 2 the standings again
   (freeing the desk buffers in the playoffs), 3 a team's roster (TeamRosterScreen, player pick menu unk_CF6AF),
   4 / 5 a player's goalie / skater card (menu unk_CF74F; 5 sets dword_C6D26). On the way out fade, free the
   buffers and clear them. No arguments. Result: 2. */
int GameStandingsMenu(void)
{
    unsigned char buf[0x310];
    int one;
    int card;
    int z;

    dword_DC738 = 1;
    statsredrawcb = standingscb;
    statsteamsel = 0;
    statscategory = 0;
    statsplayer[2] = 0;
    sub_8FFB0(0, 0x100, buf);
    FadePalStep(1, buf, 0x10);
    sub_B4BA8();
    sub_B392C(0);
    dword_C6D26 = 0;
    InitMenuRemap(1);
    statsteambuf = sub_8CCA8((char *)str_tstat, 0x2A4, 0x20);
    statsplayerbuf = (unsigned char *)sub_8CCA8((char *)str_keys, 0x5B0, 0x20);
    statsskaterbuf = (unsigned char *)sub_8CCA8((char *)str_pstat, 0x497, 0x20);
    statsgoaliebuf = (unsigned char *)sub_8CCA8((char *)str_gstat, 0x10E, 0x20);
    ((void (*)(int))standingscb)(0);
    DrawMenuBar(unk_CF54F, 4, 0x40, 0x41, 0x42);
    statscategory = 0;
    statsteamsel = 0;
    MakePath((char *)buf + 0x300, fileoncd[0x8E] == 1 ? (char *)cddriveptr : 0, (char *)str_embpal, 0);
    statsbgshapes = sub_8E83C((char *)buf + 0x300, 0);
    statspalshape = sub_B30B4(statsbgshapes, (char *)str_Pal6);
    sub_B4B88(0, 0x100, (unsigned char *)statspalshape + 0x10);
    FreeMemBlock(statsbgshapes);
    ((void (*)(void *, int, int, int, int))RunTeamPickMenu)(unk_CF54F, 4, 0x40, 0x41, 0x42);
    FreeDeskBuffers();
    card = (int)GoalieStatsCard;
    one = 1;
    while (deskexit != 1) {
        switch (deskexit) {
        case 2:
            statsredrawcb = standingscb;
            ((void (*)(int))standingscb)(0);
            DrawMenuBar(unk_CF54F, 4, 0x40, 0x41, 0x42);
            ((void (*)(void *, int, int, int, int))RunTeamPickMenu)(unk_CF54F, 4, 0x40, 0x41, 0x42);
            if (statsplayoffs) FreeDeskBuffers();
            dword_C6D26 = 0;
            break;
        case 3:
            dword_DC734 = 0;
            statsredrawcb = (int)TeamRosterScreen;
            ((void (*)(int))TeamRosterScreen)(statscategory);
            DrawMenuBar(unk_CF6AF, 4, 0x40, 0x41, 0x42);
            ((void (*)(void *, int, int, int, int))RunPlayerPickMenu)(unk_CF6AF, 4, 0x40, 0x41, 0x42);
            break;
        case 4:
            statsredrawcb = card;
            dword_DC6B4 = 0;
            ((void (*)(void *))GoalieStatsCard)(statsplayer);
            DrawMenuBar(unk_CF74F, 2, 0x40, 0x41, 0x42);
            RunMenu(unk_CF74F, 2, 0x40, 0x41, 0x42);
            break;
        case 5:
            statsredrawcb = (int)SkaterStatsCard;
            dword_DC6B4 = 0;
            ((void (*)(void *))SkaterStatsCard)(statsplayer);
            DrawMenuBar(unk_CF74F, 2, 0x40, 0x41, 0x42);
            RunMenu(unk_CF74F, 2, 0x40, 0x41, 0x42);
            dword_C6D26 = one;
            break;
        }
    }
    z = 0;
    dword_C6D26 = z;
    sub_8FFB0(z, 0x100, buf);
    FadePalStep(1, buf, 0x10);
    FreeDeskBuffers();
    FreeMemBlock(statsteambuf);
    FreeMemBlock((int)statsgoaliebuf);
    FreeMemBlock((int)statsskaterbuf);
    FreeMemBlock((int)statsplayerbuf);
    statsplayerbuf = (unsigned char *)z;
    statsteambuf = z;
    statsgoaliebuf = (unsigned char *)z;
    statsskaterbuf = (unsigned char *)z;
    dword_DC738 = z;
    statsredrawcb = z;
    return 2;
}
