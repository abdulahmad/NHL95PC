/* Front-end desk: menu callbacks. */
#include "nhl95.h"

/* DeskToSportsDesk: desk menu callback: set both desk exit flags (DeskRedrawAll DeskRedrawFlag) and
 return 5 (go to the sports desk). */
int DeskToSportsDesk(void)
{
    DeskRedrawAll = DeskRedrawFlag = 1;
    return 5;
}
