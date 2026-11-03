/* Frontend labels: the stats source menu. */
/* DRAFT: 1048 vs 1048. Left: the byte registers of the constant 2 in the seven menu-byte blocks (EXE ch / dl /
   ch / dh / al / dh / cl), the 0 for byte_C67A9 (EXE bh). See docs/UNSURE.md. */
#include "nhl95.h"

/* SetupStatsSourceMenu (1D100, PC only): build the stats screen's source menu for src (0 all, 1 exhibition /
 93-94 only, 2 playoffs, 3 league; 0 with a playoff or a league missing picks 2, 3 or 1 from what is loaded,
 postate / lgstate). Points the league / playoff items (off_C6821... the item data and callbacks) at the
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
        off_C6825 = (int)StatsSelLeague;
        off_C6845 = (int)StatsSelLeaguePlayoffs;
        off_C6821 = (int)&mi_LeagueSeason;
        off_C6841 = (int)&mi_LeaguePlayoffs;
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
        off_C6825 = (int)StatsSelPlayoffMode;
        off_C6821 = (int)&mi_PlayoffMode;
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
        off_C6825 = (int)StatsSelLeague;
        off_C6845 = (int)StatsSelLeaguePlayoffs;
        off_C6885 = (int)StatsSelPlayoffMode;
        off_C6821 = (int)&mi_LeagueSeason;
        off_C6841 = (int)&mi_LeaguePlayoffs;
        off_C6881 = (int)&mi_PlayoffMode;
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
        byte_C67A9 = 0;
    } else {
        dword_C67B9[0] = 0xF7;
        byte_C67A9 = 0x2D;
    }
    for (i = 0, y = 0x11; i < n; i++, y += 0x12) {
        dword_C67BD[i * 8] = y;
        dword_C67B9[i * 8] = dword_C67B9[0];
    }
    dword_C679D[n * 8]++;
    dword_CE8EB = n;
    dword_CF00B = n;
    dword_CF4CB = n;
    dword_CF5AB = n;
    dword_CF70B = n;
    dword_CF7CB = n;
    dword_CF84B = n;
    dword_CF8CB = n;
    dword_CFA4B = n;
    dword_C891E = n;
}
