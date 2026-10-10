/* Temp files: league desk menu actions (one source block from MenuAddTeam to MenuExportDbs: they share MenuAddTeam_common and MenuRebuildDbs_x). */
#include "nhl95.h"

/* MenuAddTeam (3322A) - menu "add team": save the exhibition state, load the league state with the stats source
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
    jctime((int)pal);
    return 2;
}

/* MenuRemoveTeam (332C0) - menu "remove team": the same around RemoveHumanTeam. Returns 2. */
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
    jctime((int)pal);
    return 2;
}

/* MenuLeagueSettings (332F6) - menu "league settings": in the league state, ask the master password
   (CheckMasterPassword; the dialog only when it is right); after a season (byte_DE268) fade the menu palette in
   first and return 2, else 0. DRAFT: not checked (stays asm); its exit is in the main desk. */
int MenuLeagueSettings(void)
{
    int ok;
    int r;
    unsigned char *pal;

    ok = 0;
    r = 0;
    SaveModeState(exhstate);
    LoadModeState(lgstate);
    if (!((int (*)(void))CheckMasterPassword)()) ok = -1;
    if (byte_DE268) {
        pal = (unsigned char *)sub_8CCA8((char *)str_Temp4, 0x300, 0x20);
        sub_8FFB0(0, 0x100, pal);
        FadePalStep(1, pal, 0x10);
        jctime((int)pal);
        r = 2;
    }
    if (ok) LeagueSettingsDlg();
    SaveModeState((unsigned char *)lgstate);
    LoadModeState(exhstate);
    return r;
}


/* MenuRebuildDbs (3339D) - menu "rebuild databases": in the league state (exhibition state saved, lgstate loaded)
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


/* MenuMergeUpdateDbs (333D7) - merge and update the league team databases (MergeUpdateDbs) with the league mode state loaded (exhibition state saved and
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
        jctime(pal);
        return 2;
    }
    return 0;
}


/* MenuMergeLeagueFiles (33469) - merge the league files with the league mode state loaded (exhibition state saved and
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
        jctime(pal);
        return 2;
    }
    return 0;
}

/* MenuUpdateTeamDbs (334FB) - menu "update team databases": UpdateTeamDbs in the league state (as MenuRebuildDbs).
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

/* MenuTradePlayers (33523) - menu "trade players": TradePlayers in the league state with the league stats source
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
    jctime((int)pal);
    return 2;
}


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


/* MenuLeagueHilights (3366F) - view the league highlights: save the exhibition mode state, load the league state (game
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

/* MenuImportDbs (336BE) - menu "import databases": ImportDbs in the league state (as MenuRebuildDbs). Returns 0. */
int MenuImportDbs(void)
{
    SaveModeState(exhstate);
    LoadModeState(lgstate);
    ImportDbs();
    SaveModeState((unsigned char *)lgstate);
    LoadModeState(exhstate);
    return 0;
}

/* MenuExportDbs (336E6) - menu "export databases": ExportDbs in the league state with the league stats source (as
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
    jctime((int)pal);
    return 2;
}
