/* Front end: sports desk. */
#include "nhl95.h"

/* DeskScoringSummary (1AA6D) - sports desk scoring summary: save the palette, fade out, show the loading screen
   and the game summary screen in mode 1 (scoring) for the current period. Returns 2. Its tail (DeskSummary_common,
   DeskItem_ret2) is where the other desk items end. */
int DeskScoringSummary(void)
{
    sub_8FFB0(0, 0x100, savepal);
    FadePalStep(1, savepal, 0x10);
    ShowLoadingScreen();
    GameSummaryScreen(1, 1, curperiod, 0);
    return 2;
}

/* DeskTeamScratches (1AAC4) - sports desk team scratches: the same with the game summary screen in mode 4. Returns 2. */
int DeskTeamScratches(void)
{
    sub_8FFB0(0, 0x100, savepal);
    FadePalStep(1, savepal, 0x10);
    ShowLoadingScreen();
    GameSummaryScreen(4, 0, 0, 0);
    return 2;
}

/* DeskHomeGoalie1 (1AB0B) - sports desk goalie menu: home team starts goalie 1 and check that item (1),
   clearing the other two (2). Returns 0. */
int DeskHomeGoalie1(void)
{
    SetTeamGoalie(0, 0);
    *(char *)mi_HomeGoalie1 = 1;
    *(char *)mi_HomeGoalie2 = 2;
    *(char *)mi_HomeGoalieNone = 2;
    return 0;
}

/* DeskHomeGoalie2 (1AB39) - sports desk goalie menu: home team starts goalie 2 and check that item (1),
   clearing the other two (2). Returns 0. */
int DeskHomeGoalie2(void)
{
    SetTeamGoalie(0, 1);
    *(char *)mi_HomeGoalie1 = 2;
    *(char *)mi_HomeGoalie2 = 1;
    *(char *)mi_HomeGoalieNone = 2;
    return 0;
}

/* DeskHomeGoalieNone (1AB62) - sports desk goalie menu: home team pulls its goalie and check that item (1),
   clearing the other two (2). Returns 0. */
int DeskHomeGoalieNone(void)
{
    SetTeamGoalie(0, -1);
    *(char *)mi_HomeGoalie1 = 2;
    *(char *)mi_HomeGoalie2 = 2;
    *(char *)mi_HomeGoalieNone = 1;
    return 0;
}

/* DeskAwayGoalie1 (1AB95) - sports desk goalie menu: away team starts goalie 1 and check that item (1),
   clearing the other two (2). Returns 0. */
int DeskAwayGoalie1(void)
{
    SetTeamGoalie(1, 0);
    *(char *)mi_AwayGoalie1 = 1;
    *(char *)mi_AwayGoalie2 = 2;
    *(char *)mi_AwayGoalieNone = 2;
    return 0;
}

/* DeskAwayGoalie2 (1ABC8) - sports desk goalie menu: away team starts goalie 2 and check that item (1),
   clearing the other two (2). Returns 0. */
int DeskAwayGoalie2(void)
{
    SetTeamGoalie(1, 1);
    *(char *)mi_AwayGoalie1 = 2;
    *(char *)mi_AwayGoalie2 = 1;
    *(char *)mi_AwayGoalieNone = 2;
    return 0;
}

/* DeskAwayGoalieNone (1ABF1) - sports desk goalie menu: away team pulls its goalie and check that item (1),
   clearing the other two (2). Returns 0. */
int DeskAwayGoalieNone(void)
{
    SetTeamGoalie(1, -1);
    *(char *)mi_AwayGoalie1 = 2;
    *(char *)mi_AwayGoalie2 = 2;
    *(char *)mi_AwayGoalieNone = 1;
    return 0;
}
