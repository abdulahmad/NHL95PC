/* cflags: -od */
/* League schedule: open the schedule for the stats screens (segment compiled without optimisation). */
#include "nhl95.h"

/* OpenStatsSchedule (29A97) - PC only: load the schedule database of the stats source into *out: the league's
   schedule file (statsleague\<name 6>.DB) or LSSCHED.DB of the last season (sub_8E8A0 loader, 20h). */
void OpenStatsSchedule(void **out)
{
    char path[32];

    if (statsfromleague) MakePath(path, (char *)statsleague, (char *)leaguedbnames[6], (char *)str_extDB);
    else MakePath(path, 0, (char *)str_LSSCHED, (char *)str_extDB);
    *out = sub_8E8A0(path, 0x20);
}
