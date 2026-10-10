/* Team select: empty dialog draw hook. */
#include "nhl95.h"

/* StubRet4b (78E29) - PC only: does nothing; a dialog hook taking five arguments (one on the stack). */
void StubRet4b(int a, int b, int c, int d, int e)
{
    char unused[12];    /* draft: asm __CHK 10h (12 bytes of locals) but Watcom drops an unused array; push 4 here */
}
