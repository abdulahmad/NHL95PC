/* EASN stats: team stats screen. */
#define GameTeamStatsScreen GameTeamStatsScreenDecl
#define GameGoalieStatsScreen GameGoalieStatsScreenDecl
#define RunMenu RunMenuDecl
#include "nhl95.h"
#undef GameTeamStatsScreen
#undef GameGoalieStatsScreen
#undef RunMenu

void RunMenu(void *bar, int n, int col1, int col2, int col3);
int LeadersScreen(int cat);

/* GameTeamStatsScreen: the team-stats page. Fade the current palette out, draw TeamStatsScreen and the menu
 bar, load embpal (from the CD when fileoncd 8Eh says so) and copy Pal6 into the palette buffer, fade that in,
 then run the menu (GameTeamStatsScreen_common). Fade back and clear the redraw hook. Returns 2. */
int GameTeamStatsScreen(int cat)
{
    unsigned char buf[0x310];
    char *dir;
    char *name;
    char *ext;

    leaguestatsmode = 1;
    statscategory = cat;
    statsredrawcb = (int)TeamStatsScreen;
    SetPalette(0, 0x100, buf);
    FadePalStep(1, buf, 0x10);
    sub_B4BA8();
    InitMenuRemap(1);
    TeamStatsScreen(cat);
    DrawMenuBar(teamstatsmenubar, 4, 0x40, 0x41, 0x42);
    ext = 0;
    name = (char *)str_embpal;
    if (fileoncd[0x8E] == 1) dir = (char *)cddriveptr;
    else dir = 0;
    MakePath((char *)buf + 0x300, dir, name, ext);
    statsbgshapes = LoadBank((char *)buf + 0x300, 0);
    statspalshape = FindShape(statsbgshapes, (char *)str_Pal6);
    memcpy(buf, (unsigned char *)statspalshape + 0x10, 0x300);
    FreeMemBlock(statsbgshapes);
    FadePalStep(0, buf, 0x10);
    RunMenu(teamstatsmenubar, 4, 0x40, 0x41, 0x42);
    SetPalette(0, 0x100, buf);
    FadePalStep(1, buf, 0x10);
    leaguestatsmode = 0;
    statsredrawcb = 0;
    return 2;
}

/* GameGoalieStatsScreen: the goalie-stats page. Same fade and embpal load as the team page, but no
 sub_B4BA8 after the fade-out, LeadersScreen instead of TeamStatsScreen, and menu bar goaliestatsmenubar.
 The menu run and the fade-back are GameTeamStatsScreen_common. Returns 2. */
int GameGoalieStatsScreen(int cat)
{
    unsigned char buf[0x310];
    char *dir;
    char *name;
    char *ext;

    leaguestatsmode = 1;
    statscategory = cat;
    statsredrawcb = (int)LeadersScreen;
    SetPalette(0, 0x100, buf);
    FadePalStep(1, buf, 0x10);
    InitMenuRemap(1);
    LeadersScreen(cat);
    DrawMenuBar(goaliestatsmenubar, 4, 0x40, 0x41, 0x42);
    ext = 0;
    name = (char *)str_embpal;
    if (fileoncd[0x8E] == 1) dir = (char *)cddriveptr;
    else dir = 0;
    MakePath((char *)buf + 0x300, dir, name, ext);
    statsbgshapes = LoadBank((char *)buf + 0x300, 0);
    statspalshape = FindShape(statsbgshapes, (char *)str_Pal6);
    memcpy(buf, (unsigned char *)statspalshape + 0x10, 0x300);
    FreeMemBlock(statsbgshapes);
    FadePalStep(0, buf, 0x10);
    RunMenu(goaliestatsmenubar, 4, 0x40, 0x41, 0x42);
    SetPalette(0, 0x100, buf);
    FadePalStep(1, buf, 0x10);
    leaguestatsmode = 0;
    statsredrawcb = 0;
    return 2;
}
