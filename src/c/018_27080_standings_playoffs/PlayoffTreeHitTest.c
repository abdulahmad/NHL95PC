/* cflags: -od */
/* Standings / playoffs: playoff tree entry points (segment compiled without optimisation). */
#include "nhl95.h"

/* PlayoffTreeHitTest (29681) - PC only: playoff tree mouse hit test stub (five arguments, one on the stack):
   always 0. */
int PlayoffTreeHitTest(int a, int b, int c, int d, int e)
{
    int hit;

    hit = 0;
    return hit;
}

/* ShowPlayoffTree (296BA) - PC only: the playoff tree of the current league (LoadLeagueTree) or of playoff mode
   (LoadPlayoffModeTree). Returns 0. */
int ShowPlayoffTree(int a, int b)
{
    if (statsfromleague == 0) LoadPlayoffModeTree(a, b);
    else LoadLeagueTree(a, b);
    return 0;
}
