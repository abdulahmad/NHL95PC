/* Output files: desk menu callbacks 2 and 3. */
#include "nhl95.h"

/* DeskSetExit2 (179D0) - desk menu callback: deskexit = 2; returns 1. Draft: the asm jumps forward into
   DeskSetExit3's "mov eax, 1 / ret"; this compiles its own copy. */
int DeskSetExit2(void)
{
    deskexit = 2;
    return 1;
}

/* DeskSetExit3 (179E6) - desk menu callback: deskexit = 3; returns 1. */
int DeskSetExit3(void)
{
    deskexit = 3;
    return 1;
}
