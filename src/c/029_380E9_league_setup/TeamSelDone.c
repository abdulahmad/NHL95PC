/* Menu / dialog callbacks. */
#include "nhl95.h"

/* TeamSelDone (38B25) - team selection done: teamselresult = 1. */
void TeamSelDone(void)
{
    teamselresult = 1;
}
