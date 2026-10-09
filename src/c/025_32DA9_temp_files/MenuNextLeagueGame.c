/* Temp files: league game menu. */
#include "nhl95.h"

/* MenuNextLeagueGame (33559) - menu "next league game": switch to the league mode state, stats source and title, open the
   league's saved game file (curleague + the str_GameSav4 suffix) when fh is not open yet (-1 on
   failure), play the game, then restore the EASN stats callbacks, the exhibition mode state and the TEMP4
   palette (fade in). Returns 2. */
int MenuNextLeagueGame(int *fh)
{
    char path[32];
    int pal;

    SaveModeState(exhstate);
    LoadModeState(lgstate);
    SetupStatsSourceMenu(3);
    SetLeagueSetImage(1);
    SetScreenTitle(2);
    if (*fh < 0) {
        strcpy(path, (char *)&curleague);
        strcat(path, (char *)str_GameSav4);
        if (FileOpenRead(path, fh)) *fh = -1;
    }
    PlayLeagueGame(fh);
    teamstatscb = (int)EasnTeamStatsScreen;
    skaterstatscb = (int)EasnSkaterStatsScreen;
    goaliestatscb = (int)EasnGoalieStatsScreen;
    standingscb = (int)EasnStandingsScreen;
    standingsmenucb = (int)EasnStandingsMenu;
    SetupStatsSourceMenu(0);
    SaveModeState((unsigned char *)lgstate);
    LoadModeState(exhstate);
    pal = sub_8CCA8((char *)str_Temp4, 0x300, 0x20);
    sub_8FFB0(0, 0x100, (unsigned char *)pal);
    FadePalStep(1, (unsigned char *)pal, 0x10);
    jctime(pal);
    return 2;
}
