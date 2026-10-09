/* Menu / dialog callbacks. */
#include "nhl95.h"

/* TeamSelCancel (38B3A) - team selection cancelled: teamselresult = -1. */
void TeamSelCancel(void)
{
    teamselresult = -1;
}
