/* Output files: desk menu callbacks 2 and 3. */
#include "nhl95.h"

/* DeskSetExit3 (179E6) - desk menu callback: deskexit = 3; returns 1. */
int DeskSetExit3(void)
{
    deskexit = 3;
    return 1;
}

/* DeskSetExit2 (179D0) - desk menu callback: deskexit = 2; returns 1. It jumps forward into DeskSetExit3's
   "mov eax, 1 / ret": Watcom only merges into code it has already generated, so DeskSetExit3 is defined first
   here and the blocks are placed in address order by cc.py (one marker per function). */
int DeskSetExit2(void)
{
    deskexit = 2;
    return 1;
}


