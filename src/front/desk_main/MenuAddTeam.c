/* Temp files: league desk menu actions (one source block from MenuAddTeam to MenuExportDbs: they share MenuAddTeam_common and MenuRebuildDbs_x). */
#define MenuNewLeague MenuNewLeague_decl
#include "nhl95.h"
#undef MenuNewLeague

/* MenuAddTeam: menu "add team": save the exhibition state, load the league state with the stats source
 menu for leagues (3), add a human team (AddHumanTeam); then back: stats source 0, save the league state, load
 the exhibition state and fade the palette in from a black TEMP palette (768 bytes, FadePalStep 16 steps).
 Returns 2. */
int MenuAddTeam(void)
{
    unsigned char *pal;

    SaveModeState(exhstate);
    LoadModeState(lgstate);
    SetupStatsSourceMenu(3);
    AddHumanTeam();
    SetupStatsSourceMenu(0);
    SaveModeState((unsigned char *)lgstate);
    LoadModeState(exhstate);
    pal = (unsigned char *)sub_8CCA8((char *)str_Temp4, 0x300, 0x20);
    sub_8FFB0(0, 0x100, pal);
    FadePalStep(1, pal, 0x10);
    FreeMemBlock((int)pal);
    return 2;
}

/* MenuRemoveTeam: menu "remove team": the same around RemoveHumanTeam. Returns 2. */
int MenuRemoveTeam(void)
{
    unsigned char *pal;

    SaveModeState(exhstate);
    LoadModeState(lgstate);
    SetupStatsSourceMenu(3);
    RemoveHumanTeam();
    SetupStatsSourceMenu(0);
    SaveModeState((unsigned char *)lgstate);
    LoadModeState(exhstate);
    pal = (unsigned char *)sub_8CCA8((char *)str_Temp4, 0x300, 0x20);
    sub_8FFB0(0, 0x100, pal);
    FadePalStep(1, pal, 0x10);
    FreeMemBlock((int)pal);
    return 2;
}

/* MenuRebuildDbs: menu "rebuild databases": in the league state (exhibition state saved, lgstate loaded)
 rebuild the league databases (RebuildLeagueDbs), then save the league state and reload the exhibition state.
 Returns 0. */
int MenuRebuildDbs(void)
{
    SaveModeState(exhstate);
    LoadModeState(lgstate);
    RebuildLeagueDbs();
    SaveModeState((unsigned char *)lgstate);
    LoadModeState(exhstate);
    return 0;
}


/* MenuMergeUpdateDbs: merge and update the league team databases (MergeUpdateDbs) with the league mode state loaded (exhibition state saved and
 restored around it); on success reload the menu palette (TEMP4, fade in) and return 2, else 0. */
int MenuMergeUpdateDbs(void)
{
    int r;
    int pal;

    SaveModeState(exhstate);
    LoadModeState(lgstate);
    r = MergeUpdateDbs();
    SaveModeState((unsigned char *)lgstate);
    LoadModeState(exhstate);
    if (r) {
        pal = sub_8CCA8((char *)str_Temp4, 0x300, 0x20);
        sub_8FFB0(0, 0x100, (unsigned char *)pal);
        FadePalStep(1, (unsigned char *)pal, 0x10);
        FreeMemBlock(pal);
        return 2;
    }
    return 0;
}


/* MenuMergeLeagueFiles: merge the league files with the league mode state loaded (exhibition state saved and
 restored around it); on success reload the menu palette (TEMP4, fade in) and return 2, else 0. */
int MenuMergeLeagueFiles(void)
{
    int r;
    int pal;

    SaveModeState(exhstate);
    LoadModeState(lgstate);
    r = MergeLeagueFiles();
    SaveModeState((unsigned char *)lgstate);
    LoadModeState(exhstate);
    if (r) {
        pal = sub_8CCA8((char *)str_Temp4, 0x300, 0x20);
        sub_8FFB0(0, 0x100, (unsigned char *)pal);
        FadePalStep(1, (unsigned char *)pal, 0x10);
        FreeMemBlock(pal);
        return 2;
    }
    return 0;
}

/* MenuUpdateTeamDbs: menu "update team databases": UpdateTeamDbs in the league state (as MenuRebuildDbs).
 Returns 0. */
int MenuUpdateTeamDbs(void)
{
    SaveModeState(exhstate);
    LoadModeState(lgstate);
    UpdateTeamDbs();
    SaveModeState((unsigned char *)lgstate);
    LoadModeState(exhstate);
    return 0;
}

/* MenuTradePlayers: menu "trade players": TradePlayers in the league state with the league stats source
 (as MenuAddTeam). Returns 2. */
int MenuTradePlayers(void)
{
    unsigned char *pal;

    SaveModeState(exhstate);
    LoadModeState(lgstate);
    SetupStatsSourceMenu(3);
    TradePlayers();
    SetupStatsSourceMenu(0);
    SaveModeState((unsigned char *)lgstate);
    LoadModeState(exhstate);
    pal = (unsigned char *)sub_8CCA8((char *)str_Temp4, 0x300, 0x20);
    sub_8FFB0(0, 0x100, pal);
    FadePalStep(1, pal, 0x10);
    FreeMemBlock((int)pal);
    return 2;
}


/* MenuNextLeagueGame: menu "next league game": switch to the league mode state, stats source and title, open the
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
    FreeMemBlock(pal);
    return 2;
}


/* MenuLeagueHilights: view the league highlights: save the exhibition mode state, load the league state (game
 mode 0), run ViewHilights, then restore the exhibition state. Returns 2 when the viewer returned 0, else 0. */
int MenuLeagueHilights(void)
{
    SaveModeState(exhstate);
    LoadModeState(lgstate);
    gamemode = 0;
    if (!ViewHilights()) {
        LoadModeState(exhstate);
        return 2;
    }
    LoadModeState(exhstate);
    return 0;
}

/* MenuImportDbs: menu "import databases": ImportDbs in the league state (as MenuRebuildDbs). Returns 0. */
int MenuImportDbs(void)
{
    SaveModeState(exhstate);
    LoadModeState(lgstate);
    ImportDbs();
    SaveModeState((unsigned char *)lgstate);
    LoadModeState(exhstate);
    return 0;
}

/* MenuExportDbs: menu "export databases": ExportDbs in the league state with the league stats source (as
 MenuAddTeam). Returns 2. */
int MenuExportDbs(void)
{
    unsigned char *pal;

    SaveModeState(exhstate);
    LoadModeState(lgstate);
    SetupStatsSourceMenu(3);
    ExportDbs();
    SetupStatsSourceMenu(0);
    SaveModeState((unsigned char *)lgstate);
    LoadModeState(exhstate);
    pal = (unsigned char *)sub_8CCA8((char *)str_Temp4, 0x300, 0x20);
    sub_8FFB0(0, 0x100, pal);
    FadePalStep(1, pal, 0x10);
    FreeMemBlock((int)pal);
    return 2;
}

/* MenuNewLeague: menu "new league". Fill a fresh league state (12 teams, best of 7, the first free
   control), create the league, and point the desk at it when the new file has a name. Fade the
   menu palette back in. Returns 2. */
int MenuNewLeague(void)
{
    int slot;
    unsigned char *pal;

    SaveModeState(exhstate);
    lgstate[0] = 2;
    *(int *)((char *)lgstate + 0x51) = 0x0C;
    *(int *)((char *)lgstate + 0x55) = 0x15;
    *(unsigned short *)((char *)lgstate + 0x59) |= 0x2FF;
    if (musicon)
        ((unsigned char *)lgstate)[0x5A] |= 1;
    else
        ((unsigned char *)lgstate)[0x5A] &= 0xFE;
    ((unsigned char *)lgstate)[0x5A] &= 0x83;
    ((unsigned char *)lgstate)[0x5A] |= 0x78;
    if (ctlavailmask & 2)
        *(int *)((char *)lgstate + 0x65) = 2;
    else if (ctlavailmask & 4)
        *(int *)((char *)lgstate + 0x65) = 4;
    else if (ctlavailmask & 8)
        *(int *)((char *)lgstate + 0x65) = 8;
    else if (ctlavailmask & 1)
        *(int *)((char *)lgstate + 0x65) = 1;
    else
        *(int *)((char *)lgstate + 0x65) = 0x10;
    if (*(int *)((char *)lgstate + 0x65) != 0x10)
        *(int *)((char *)lgstate + 0x5D) = 0x0C;
    else
        *(int *)((char *)lgstate + 0x5D) = -1;
    *(int *)((char *)lgstate + 0x69) = 0x10;
    *(int *)((char *)lgstate + 0x61) = -2;
    *(int *)((char *)lgstate + 0x6D) = 0;
    *(int *)((char *)lgstate + 0x71) = 1;
    LoadModeState(lgstate);
    SetLeagueSetImage(0);
    CreateNewLeague();
    SettingsStub();
    if (((unsigned char *)lgstate)[4]) {
        BuildSavedGameLabels();
        SetupStatsSourceMenu(0);
        *(char **)&menuact_export = (char *)MenuExportDbs;
        *(char **)&menuact_nextlg = (char *)MenuNextLeagueGame;
        *(char **)&menusub_lgmgr = (char *)leaguemgrmenu;
    } else {
        BuildSavedGameLabels();
        SetupStatsSourceMenu(0);
        menuact_export = 0;
        menuact_nextlg = 0;
        menusub_lgmgr = 0;
    }
    LoadModeState(exhstate);
    pal = (unsigned char *)sub_8CCA8((char *)str_Temp4, 0x300, 0x20);
    sub_8FFB0(0, 0x100, pal);
    if (musicon && songdata)
        sub_8FCDF(musichandle, 3, 0x64);
    FadePalStep(1, pal, 0x10);
    FreeMemBlock((int)pal);
    if (musicon && songdata) {
        do
            slot = musicslot;
        while (sub_8FC8A(slot, 3) == 0);
        sub_8D2F0(songdata);
        songdata = 0;
    }
    return 2;
}
