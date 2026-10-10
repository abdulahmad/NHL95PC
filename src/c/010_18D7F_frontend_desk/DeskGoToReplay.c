/* Front end: sports desk menu items (one block: the replay, lines and stats items end in DeskScoringSummary's
   tail DeskItem_ret2, and Watcom only produces those forward jumps with the whole group in one file). */
#include "nhl95.h"

/* DeskGoToReplay (1A817) - sports desk instant replay: load the home team's rink (entry 12 for team 26 and up)
   and the player photos, save the palette and fade out, back to the 320x200 screen, InstantReplay(0), restore the
   s1 font, then flag a redraw (dword_C66D0 / dword_C66D4). Returns 2. */
int DeskGoToReplay(void)
{
    LoadRink(HomeTeam >= 26 ? 12 : HomeTeam);
    LoadPlayerPhotos();
    sub_8FFB0(0, 0x100, savepal);
    FadePalette(1, savepal, 0x10);
    SetScreenSize(0x140, 0xC8);
    InstantReplay(0);
    sub_8EA18(s1font);
    dword_C66D0 = dword_C66D4 = 1;
    return 2;
}

/* DeskHomeLines (1A8AA) - sports desk home lines: save the palette, fade out, GameLineEditor for the home team
   (hmlinetab), then save and fade again. Returns 2. */
int DeskHomeLines(void)
{
    sub_8FFB0(0, 0x100, savepal);
    FadePalStep(1, savepal, 0x10);
    GameLineEditor(0, hmlinetab, unk_CF2EF, 2);
    sub_8FFB0(0, 0x100, savepal);
    FadePalStep(1, savepal, 0x10);
    return 2;
}

/* DeskVisitorLines (1A922) - as DeskHomeLines for the visitors (awlinetab). Returns 2. */
int DeskVisitorLines(void)
{
    sub_8FFB0(0, 0x100, savepal);
    FadePalStep(1, savepal, 0x10);
    GameLineEditor(1, awlinetab, unk_CF2EF, 2);
    sub_8FFB0(0, 0x100, savepal);
    FadePalStep(1, savepal, 0x10);
    return 2;
}

/* DeskGameStats (1A96D) - sports desk game stats: save the palette, fade out, GameStatsScreen. Returns 2. */
int DeskGameStats(void)
{
    sub_8FFB0(0, 0x100, savepal);
    FadePalStep(1, savepal, 0x10);
    GameStatsScreen();
    return 2;
}

/* DeskPenaltySummary (1A9AC) - sports desk penalty summary: save the palette, fade the music down and the screen
   out, wait for the music slot to stop and free the song, then show the loading screen and the game summary
   screen in mode 2 (penalties) for the current period. Returns 2. */
int DeskPenaltySummary(void)
{
    sub_8FFB0(0, 0x100, savepal);
    if (musicon && songdata) sub_8FCDF(musichandle, 3, 0x64);
    FadePalStep(1, savepal, 0x10);
    if (musicon && songdata) {
        while (!sub_8FC8A(*(int *)((char *)&musicslot - 3) >> 24, 3));
        sub_8D2F0(songdata);
        songdata = 0;
    }
    ShowLoadingScreen();
    GameSummaryScreen(2, 1, curperiod, 0);
    return 2;
}

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
