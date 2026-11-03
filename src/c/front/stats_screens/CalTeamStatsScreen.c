/* EASN stats: team stats screen from the calendar. */
#define CalTeamStatsScreen CalTeamStatsScreenDecl
#define CalSkaterStatsScreen CalSkaterStatsScreenDecl
#define CalGoalieStatsScreen CalGoalieStatsScreenDecl
#define RunMenu RunMenuDecl
#define CalStandingsMenu CalStandingsMenuDecl
#include "nhl95.h"
#undef CalTeamStatsScreen
#undef CalSkaterStatsScreen
#undef CalGoalieStatsScreen
#undef RunMenu
#undef CalStandingsMenu

void RunMenu(void *bar, int n, int col1, int col2, int col3);
int LeadersScreen(int cat);

/* CalTeamStatsScreen: the calendar's team-stats page. Fade out, free the calendar shapes if memory is
 low, draw TeamStatsScreen, and load embpal3 (from the CD when fileoncd 8Eh says so). Pal8 is faded in
 from the shape. After the menu (CalTeamStatsScreen_common) the calendar shapes are loaded again.
 Returns 0. */
int CalTeamStatsScreen(int cat)
{
    unsigned char buf[0x310];
    char *dir;
    char *name;
    char *ext;
    int z;

    sub_8FFB0(0, 0x100, buf);
    dword_DC738 = 1;
    statscategory = cat;
    statsredrawcb = (int)TeamStatsScreen;
    sub_B4BA8();
    InitMenuRemap(1);
    FadePalStep(1, buf, 0x10);
    FreeCalendarIfLowMem();
    TeamStatsScreen(cat);
    DrawMenuBar(unk_CF78F, 4, 0x40, 0x41, 0x42);
    ext = 0;
    name = (char *)str_embpal3;
    if (fileoncd[0x8E] == 1) dir = (char *)cddriveptr;
    else dir = 0;
    MakePath((char *)buf + 0x300, dir, name, ext);
    statsbgshapes = sub_8E83C((char *)buf + 0x300, 0);
    statspalshape = sub_B30B4(statsbgshapes, (char *)str_Pal8);
    FadePalStep(0, (unsigned char *)statspalshape + 0x10, 0x10);
    FreeMemBlock(statsbgshapes);
    RunMenu(unk_CF78F, 4, 0x40, 0x41, 0x42);
    sub_8FFB0(0, 0x100, buf);
    FadePalStep(1, buf, 0x10);
    dword_DDD2C = -1;
    LoadCalendarShapes();
    z = 0;
    dword_DC738 = z;
    statsredrawcb = z;
    return 0;
}

/* CalSkaterStatsScreen: the calendar's skater page. Same fade and embpal3 load as the team page, with
 LeadersScreen and menu bar unk_CF80F. The menu run and the calendar reload are CalTeamStatsScreen_common.
 Returns 0. */
int CalSkaterStatsScreen(int cat)
{
    unsigned char buf[0x310];
    char *dir;
    char *name;
    char *ext;
    int z;

    sub_8FFB0(0, 0x100, buf);
    dword_DC738 = 1;
    statscategory = cat;
    statsredrawcb = (int)LeadersScreen;
    sub_B4BA8();
    InitMenuRemap(1);
    FadePalStep(1, buf, 0x10);
    FreeCalendarIfLowMem();
    LeadersScreen(cat);
    DrawMenuBar(unk_CF80F, 4, 0x40, 0x41, 0x42);
    ext = 0;
    name = (char *)str_embpal3;
    if (fileoncd[0x8E] == 1) dir = (char *)cddriveptr;
    else dir = 0;
    MakePath((char *)buf + 0x300, dir, name, ext);
    statsbgshapes = sub_8E83C((char *)buf + 0x300, 0);
    statspalshape = sub_B30B4(statsbgshapes, (char *)str_Pal8);
    FadePalStep(0, (unsigned char *)statspalshape + 0x10, 0x10);
    FreeMemBlock(statsbgshapes);
    RunMenu(unk_CF80F, 4, 0x40, 0x41, 0x42);
    sub_8FFB0(0, 0x100, buf);
    FadePalStep(1, buf, 0x10);
    dword_DDD2C = -1;
    LoadCalendarShapes();
    z = 0;
    dword_DC738 = z;
    statsredrawcb = z;
    return 0;
}

/* CalGoalieStatsScreen: the calendar's goalie page. As the skater page, with menu bar unk_CF88F.
 Returns 0. */
int CalGoalieStatsScreen(int cat)
{
    unsigned char buf[0x310];
    char *dir;
    char *name;
    char *ext;
    int z;

    sub_8FFB0(0, 0x100, buf);
    dword_DC738 = 1;
    statscategory = cat;
    statsredrawcb = (int)LeadersScreen;
    sub_B4BA8();
    InitMenuRemap(1);
    FadePalStep(1, buf, 0x10);
    FreeCalendarIfLowMem();
    LeadersScreen(cat);
    DrawMenuBar(unk_CF88F, 4, 0x40, 0x41, 0x42);
    ext = 0;
    name = (char *)str_embpal3;
    if (fileoncd[0x8E] == 1) dir = (char *)cddriveptr;
    else dir = 0;
    MakePath((char *)buf + 0x300, dir, name, ext);
    statsbgshapes = sub_8E83C((char *)buf + 0x300, 0);
    statspalshape = sub_B30B4(statsbgshapes, (char *)str_Pal8);
    FadePalStep(0, (unsigned char *)statspalshape + 0x10, 0x10);
    FreeMemBlock(statsbgshapes);
    RunMenu(unk_CF88F, 4, 0x40, 0x41, 0x42);
    sub_8FFB0(0, 0x100, buf);
    FadePalStep(1, buf, 0x10);
    dword_DDD2C = -1;
    LoadCalendarShapes();
    z = 0;
    dword_DC738 = z;
    statsredrawcb = z;
    return 0;
}

/* CalStandingsMenu (217FE, PC only): the calendar's standings menu, as GameStandingsMenu with the calendar
   files. Keep a copy of playofftree, fade out, reset the stats selection, free the calendar shapes if memory is
   low, load the tstat3 / keys3 / pstat3 / gstat3 buffers, draw the standings (standingscb) with menu bar
   unk_CF54F, fade in embpal3's Pal8 and run the team pick menu. Then follow deskexit until 1 (back): 2 the
   standings again, 3 a team's roster (TeamRosterScreen, menu unk_CF6AF), 4 / 5 a goalie / skater card (menu
   unk_CF74F; 5 sets dword_C6D26). On the way out free and clear the buffers, put playofftree back, fade and
   reload the calendar shapes. The exit is CalTeamStatsScreen's (CalTeamStatsScreen_x). Returns 0. */
int CalStandingsMenu(void)
{
    struct {
        unsigned char pal[0x300];
        int tree[0x1F];
        char path[0x10];
    } s;
    int i;
    int z;

    for (i = 0; i < 0x1F; i++) s.tree[i] = playofftree[i];
    dword_DC738 = 1;
    statsredrawcb = standingscb;
    statsteamsel = 0;
    statscategory = 0;
    statsplayer[2] = 0;
    sub_8FFB0(0, 0x100, s.pal);
    FadePalStep(1, s.pal, 0x10);
    FreeCalendarIfLowMem();
    z = 0;
    dword_C6D26 = z;
    InitMenuRemap(1);
    statsteambuf = sub_8CCA8((char *)str_tstat3, 0x2A4, 0x20);
    statsplayerbuf = (unsigned char *)sub_8CCA8((char *)str_keys3, 0x5B0, 0x20);
    statsskaterbuf = (unsigned char *)sub_8CCA8((char *)str_pstat3, 0x497, 0x20);
    statsgoaliebuf = (unsigned char *)sub_8CCA8((char *)str_gstat3, 0x10E, 0x20);
    ((void (*)(int))standingscb)(0);
    DrawMenuBar(unk_CF54F, 4, 0x40, 0x41, 0x42);
    statscategory = z;
    statsteamsel = z;
    MakePath(s.path, fileoncd[0x8E] == 1 ? (char *)cddriveptr : 0, (char *)str_embpal3, 0);
    statsbgshapes = sub_8E83C(s.path, 0);
    statspalshape = sub_B30B4(statsbgshapes, (char *)str_Pal8);
    FadePalStep(0, (unsigned char *)statspalshape + 0x10, 0x10);
    FreeMemBlock(statsbgshapes);
    ((void (*)(void *, int, int, int, int))RunTeamPickMenu)(unk_CF54F, 4, 0x40, 0x41, 0x42);
    FreeDeskBuffers();
    sub_B4BA8();
    while (deskexit != 1) {
        switch (deskexit) {
        case 2:
            statsredrawcb = standingscb;
            ((void (*)(int))standingscb)(0);
            DrawMenuBar(unk_CF54F, 4, 0x40, 0x41, 0x42);
            ((void (*)(void *, int, int, int, int))RunTeamPickMenu)(unk_CF54F, 4, 0x40, 0x41, 0x42);
            if (statsplayoffs) {
                FreeDeskBuffers();
                sub_B4BA8();
            }
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
            statsredrawcb = (int)GoalieStatsCard;
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
            dword_C6D26 = 1;
            break;
        }
    }
    dword_C6D26 = 0;
    FreeDeskBuffers();
    FreeMemBlock(statsteambuf);
    FreeMemBlock((int)statsgoaliebuf);
    FreeMemBlock((int)statsskaterbuf);
    FreeMemBlock((int)statsplayerbuf);
    z = 0;
    statsplayerbuf = (unsigned char *)z;
    statsteambuf = z;
    statsgoaliebuf = (unsigned char *)z;
    statsskaterbuf = (unsigned char *)z;
    dword_DC738 = z;
    statsredrawcb = z;
    for (i = 0; i < 0x1F; i++) playofftree[i] = s.tree[i];
    sub_8FFB0(0, 0x100, s.pal);
    FadePalStep(1, s.pal, 0x10);
    dword_DDD2C = -1;
    LoadCalendarShapes();
    return 0;
}
