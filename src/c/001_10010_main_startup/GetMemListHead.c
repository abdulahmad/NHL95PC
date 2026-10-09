/* Main startup: memory lists. */
#include "nhl95.h"

/* GetMemListHead (10010) - head of memory list 1 when which is nonzero, else of memory list 0. */
int GetMemListHead(int which)
{
    if (which) return memlist1[0];
    return memlist0[0];
}
