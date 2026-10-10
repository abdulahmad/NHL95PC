/* Line editor / rosters: goalie sorting. */
#include "nhl95.h"

/* CmpRosterGoalies (75A37) - CmpGAA for the roster screen: goalie records in rostergstat (2Ch bytes each, playoffs at
   +16h); no minutes (word +0Ch) last, then lower +10h, more minutes, more +0, fewer +0Eh, more +2, fewer +4, more +14h. */
int CmpRosterGoalies(int *a, int *b)
{
    unsigned short *p;
    unsigned short *q;

    p = !statsplayoffs ? (unsigned short *)(rostergstat + *a * 0x2C)
                       : (unsigned short *)(rostergstat + *a * 0x2C + 0x16);
    q = !statsplayoffs ? (unsigned short *)(rostergstat + *b * 0x2C)
                       : (unsigned short *)(rostergstat + *b * 0x2C + 0x16);
    if ((q[6] == 0) ^ (p[6] == 0)) return q[6] - p[6];
    if (q[8] != p[8]) return p[8] - q[8];
    if (q[6] != p[6]) return q[6] - p[6];
    if (q[0] != p[0]) return q[0] - p[0];
    if (q[7] != p[7]) return p[7] - q[7];
    if (q[1] != p[1]) return q[1] - p[1];
    if (q[2] != p[2]) return p[2] - q[2];
    return q[10] - p[10];
}

/* MenuRegSeasonStats (75BAA) - PC only: menu handler: roster stats screen (ShowRosterStats with shapes / strings
   C0h-C3h) for the regular season (statsplayoffs = 0). Returns 0. */
int MenuRegSeasonStats(void)
{
    statsplayoffs = 0;
    ShowRosterStats(0xC0, 0xC1, 0xC2, 0xC3);
    return 0;
}

/* MenuPlayoffStats (75BDE) - PC only: as MenuRegSeasonStats for the playoffs (statsplayoffs = 1; shares its
   tail). Returns 0. */
int MenuPlayoffStats(void)
{
    statsplayoffs = 1;
    ShowRosterStats(0xC0, 0xC1, 0xC2, 0xC3);
    return 0;
}
