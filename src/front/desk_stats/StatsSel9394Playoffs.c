/* Output files: stats source menu (one source block: the league playoff-mode selections end in StatsSel9394Playoffs' common tail). */
#include "nhl95.h"

/* StatsSel9394Playoffs: stats menu: switch the source to the 93-94 playoffs (from league or season stats):
 check that item (1) and clear the others (2), copy the exhibition league name to statsleague; in the league
 screens (dword_DC738) fade in the stats palette and redraw the current category (statsredrawcb), then fade out. */
void StatsSel9394Playoffs(void)
{
    if (!statsfromleague && statsplayoffs == 1) return;
    mi_9394Playoffs = 1;
    mi_9394Season = mi_LeagueSeason = mi_LeaguePlayoffs = mi_PlayoffMode = 2;
    statsfromleague = 0;
    if (!statsplayoffs) statsteamsel = 0;
    statsplayoffs = 1;
    strncpy((char *)statsleague, (char *)exhstate + 4, 0x1F);
    if (!dword_DC738) return;
    sub_8FFB0(0, 0x100, unk_DC340);
    FadePalStep(1, unk_DC340, 0x10);
    statspalvalid = 1;
    statspal = (int)unk_DC340;
    dword_DC6B4 = -1;
    ((void (*)(int))statsredrawcb)(statscategory);
    statspalvalid = 0;
    statspal = 0;
    FadePalStep(0, unk_DC340, 0x10);
}


/* StatsSelLeague: stats menu: switch the source to the league season (unless already there): check that
 item (1) and clear the others (2), copy the league name to statsleague (from lgstate); in the league screens
 (dword_DC738) fade in the stats palette and redraw the current category (statsredrawcb), then fade out. */
void StatsSelLeague(void)
{
    if (statsfromleague == 1 && !statsplayoffs) return;
    mi_LeagueSeason = 1;
    mi_9394Season = mi_9394Playoffs = mi_LeaguePlayoffs = mi_PlayoffMode = 2;
    statsfromleague = 1;
    if (statsplayoffs) statsteamsel = 0;
    statsplayoffs = 0;
    strncpy((char *)statsleague, (char *)lgstate + 4, 0x1F);
    if (!dword_DC738) return;
    sub_8FFB0(0, 0x100, unk_DC340);
    FadePalStep(1, unk_DC340, 0x10);
    statspalvalid = 1;
    statspal = (int)unk_DC340;
    dword_DC6B4 = -1;
    ((void (*)(int))statsredrawcb)(statscategory);
    statspalvalid = 0;
    statspal = 0;
    FadePalStep(0, unk_DC340, 0x10);
}

/* StatsSelLeaguePlayoffs: stats menu: switch the source to the league playoffs (unless already showing
 this league's playoffs): as StatsSel9394Playoffs with the league name from lgstate. */
void StatsSelLeaguePlayoffs(void)
{
    if (statsfromleague == 1 && statsfromleague == statsplayoffs && !strcmp((char *)statsleague, (char *)lgstate + 4)) return;
    mi_LeaguePlayoffs = 1;
    mi_9394Season = mi_9394Playoffs = mi_LeagueSeason = mi_PlayoffMode = 2;
    statsfromleague = 1;
    if (!statsplayoffs) statsteamsel = 0;
    statsplayoffs = 1;
    strncpy((char *)statsleague, (char *)lgstate + 4, 0x1F);
    if (!dword_DC738) return;
    sub_8FFB0(0, 0x100, unk_DC340);
    FadePalStep(1, unk_DC340, 0x10);
    statspalvalid = 1;
    statspal = (int)unk_DC340;
    dword_DC6B4 = -1;
    ((void (*)(int))statsredrawcb)(statscategory);
    statspalvalid = 0;
    statspal = 0;
    FadePalStep(0, unk_DC340, 0x10);
}

/* StatsSelPlayoffMode: stats menu: switch the source to the playoff mode's playoffs (postate), as
 StatsSelLeaguePlayoffs. */
void StatsSelPlayoffMode(void)
{
    if (statsfromleague == 1 && statsfromleague == statsplayoffs && !strcmp((char *)statsleague, (char *)postate + 4)) return;
    mi_PlayoffMode = 1;
    mi_9394Season = mi_9394Playoffs = mi_LeagueSeason = mi_LeaguePlayoffs = 2;
    statsfromleague = 1;
    if (!statsplayoffs) statsteamsel = 0;
    statsplayoffs = 1;
    strncpy((char *)statsleague, (char *)postate + 4, 0x1F);
    if (!dword_DC738) return;
    sub_8FFB0(0, 0x100, unk_DC340);
    FadePalStep(1, unk_DC340, 0x10);
    statspalvalid = 1;
    statspal = (int)unk_DC340;
    dword_DC6B4 = -1;
    ((void (*)(int))statsredrawcb)(statscategory);
    statspalvalid = 0;
    statspal = 0;
    FadePalStep(0, unk_DC340, 0x10);
}

/* FreeDeskBuffers (18D33, PC only; segment 009, the same source file: it ends in StatsSel_x): free the two stats
   desk buffers dword_C65AC and dword_C65A8 (FreeMemBlock) when they are allocated and clear them. No arguments.
   Result: 0. */
int FreeDeskBuffers(void)
{
    if (dword_C65AC) {
        FreeMemBlock(dword_C65AC);
        dword_C65AC = 0;
    }
    if (dword_C65A8) {
        FreeMemBlock(dword_C65A8);
        dword_C65A8 = 0;
    }
    return 0;
}
