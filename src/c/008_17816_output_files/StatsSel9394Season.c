/* Output files: stats source menu. */
#include "nhl95.h"

/* StatsSel9394Season (17A00) - stats menu: switch the source to the 93-94 season (from league or playoff stats): check
   that item (1) and clear the others (2), copy the exhibition league name to statsleague; in the league screens
   (dword_DC738) fade in the stats palette and redraw the current category (statsredrawcb), then fade out. */
void StatsSel9394Season(void)
{
    if (!statsfromleague && !statsplayoffs) return;
    mi_9394Season = 1;
    mi_9394Playoffs = mi_LeagueSeason = mi_LeaguePlayoffs = mi_PlayoffMode = 2;
    statsfromleague = 0;
    if (statsplayoffs) statsteamsel = 0;
    statsplayoffs = 0;
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
