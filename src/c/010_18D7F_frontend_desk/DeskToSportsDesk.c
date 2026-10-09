/* Front-end desk: menu callbacks. */
#include "nhl95.h"

/* DeskToSportsDesk (1A5B1) - desk menu callback: set both desk exit flags (dword_C66D0 / dword_C66D4) and
   return 5 (go to the sports desk). */
int DeskToSportsDesk(void)
{
    dword_C66D0 = dword_C66D4 = 1;
    return 5;
}
