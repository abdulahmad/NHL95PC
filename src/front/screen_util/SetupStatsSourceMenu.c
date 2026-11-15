/* Frontend labels: the stats source menu. */
/* DRAFT: 1048 vs 1048. Left: the byte registers of the constant 2 in the seven menu-byte blocks (EXE ch / dl /
   ch / dh / al / dh / cl), the 0 for str_Dashes (EXE bh). See docs/UNSURE.md. */
#include "nhl95.h"

/* SetupStatsSourceMenu (1D100, PC only): build the stats screen's source menu for src (0 all, 1 exhibition /
 93-94 only, 2 playoffs, 3 league; 0 with a playoff or a league missing picks 2, 3 or 1 from what is loaded,
 postate / lgstate). Points the league / playoff items (menutext_statsleague... the item data and callbacks) at the
 sources that exist, and when the checked item (1) is not one of them falls back to the first that is: check it,
 clear the others (2), set statsfromleague / statsplayoffs (a change of playoffs clears statsteamsel) and copy
 that source's name to statsleague. Then lays out the n items (2, 4, 5 or 7; x C5h / title byte 0 for the
 playoff-only menu, else F7h / 2Dh; y from 11h in steps of 12h) and stores n in the ten menus' counts. */
void SetupStatsSourceMenu(int src)
{
    int n;
    int i;
    int y;

    if (src == 0 && (!*((char *)postate + 4) || !*((char *)lgstate + 4))) {
        if (*((char *)postate + 4)) src = 2;
        else if (*((char *)lgstate + 4)) src = 3;
        else src = 1;
    }
    switch (src) {
    case 3:
        menuact_statsleague = (int)StatsSelLeague;
        menuact_statslgplayoffs = (int)StatsSelLeaguePlayoffs;
        menutext_statsleague = (int)&mi_LeagueSeason;
        menutext_statslgplayoffs = (int)&mi_LeaguePlayoffs;
        if (mi_PlayoffMode == 1 || mi_LeagueSeason == 1) {
            mi_LeagueSeason = 1;
            mi_9394Season = mi_9394Playoffs = mi_LeaguePlayoffs = mi_PlayoffMode = 2;
            statsfromleague = 1;
            if (statsplayoffs) statsteamsel = 0;
            statsplayoffs = 0;
            strncpy((char *)statsleague, (char *)lgstate + 4, 0x1F);
        } else if (mi_LeaguePlayoffs == 1) {
            mi_9394Season = mi_9394Playoffs = mi_LeagueSeason = mi_PlayoffMode = 2;
            statsfromleague = 1;
            if (!statsplayoffs) statsteamsel = 0;
            statsplayoffs = 1;
            strncpy((char *)statsleague, (char *)lgstate + 4, 0x1F);
        }
        n = 5;
        break;
    case 2:
        menuact_statsleague = (int)StatsSelPlayoffMode;
        menutext_statsleague = (int)&mi_PlayoffMode;
        if (mi_LeagueSeason == 1 || mi_LeaguePlayoffs == 1 || mi_PlayoffMode == 1) {
            mi_PlayoffMode = 1;
            mi_9394Season = mi_9394Playoffs = mi_LeagueSeason = mi_LeaguePlayoffs = 2;
            statsfromleague = 1;
            if (!statsplayoffs) statsteamsel = 0;
            statsplayoffs = 1;
            strncpy((char *)statsleague, (char *)postate + 4, 0x1F);
        }
        n = 4;
        break;
    case 1:
        if (mi_9394Season == 2 && mi_9394Playoffs == 2) {
            mi_9394Season = 1;
            mi_9394Playoffs = mi_LeagueSeason = mi_LeaguePlayoffs = mi_PlayoffMode = 2;
            statsfromleague = 0;
            if (statsplayoffs) statsteamsel = 0;
            statsplayoffs = 0;
            strncpy((char *)statsleague, (char *)exhstate + 4, 0x1F);
        }
        n = 2;
        break;
    case 0:
        menuact_statsleague = (int)StatsSelLeague;
        menuact_statslgplayoffs = (int)StatsSelLeaguePlayoffs;
        menuact_statsplayoff = (int)StatsSelPlayoffMode;
        menutext_statsleague = (int)&mi_LeagueSeason;
        menutext_statslgplayoffs = (int)&mi_LeaguePlayoffs;
        menutext_statsplayoff = (int)&mi_PlayoffMode;
        if (mi_LeagueSeason == 1) {
            mi_9394Season = mi_9394Playoffs = mi_LeaguePlayoffs = mi_PlayoffMode = 2;
            statsfromleague = 1;
            if (statsplayoffs) statsteamsel = 0;
            statsplayoffs = 0;
            strncpy((char *)statsleague, (char *)lgstate + 4, 0x1F);
        } else if (mi_LeaguePlayoffs == 1) {
            mi_9394Season = mi_9394Playoffs = mi_LeagueSeason = mi_PlayoffMode = 2;
            statsfromleague = 1;
            if (!statsplayoffs) statsteamsel = 0;
            statsplayoffs = 1;
            strncpy((char *)statsleague, (char *)lgstate + 4, 0x1F);
        } else if (mi_PlayoffMode == 1) {
            mi_9394Season = mi_9394Playoffs = mi_LeagueSeason = mi_LeaguePlayoffs = 2;
            statsfromleague = 1;
            if (!statsplayoffs) statsteamsel = 0;
            statsplayoffs = 1;
            strncpy((char *)statsleague, (char *)postate + 4, 0x1F);
        }
        n = 7;
        break;
    }
    if (n == 4) {
        dword_C67B9[0] = 0xC5;
        str_Dashes = 0;
    } else {
        dword_C67B9[0] = 0xF7;
        str_Dashes = 0x2D;
    }
    for (i = 0, y = 0x11; i < n; i++, y += 0x12) {
        dword_C67BD[i * 8] = y;
        dword_C67B9[i * 8] = dword_C67B9[0];
    }
    dword_C679D[n * 8]++;
    dword_CE8EB = n;
    dword_CF00B = n;
    dword_CF4CB = n;
    standingsmenubar_srccnt = n;
    rostermenubar_srccnt = n;
    teamstatsmenubar_srccnt = n;
    skaterstatsmenubar_srccnt = n;
    goaliestatsmenubar_srccnt = n;
    dword_CFA4B = n;
    dword_C891E = n;
}
