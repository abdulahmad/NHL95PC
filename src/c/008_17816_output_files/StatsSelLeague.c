/* Output files: stats source menu. */
#include "nhl95.h"

/* StatsSelLeague (17BE7) - stats menu: switch the source to the league season (unless already there): check that
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
