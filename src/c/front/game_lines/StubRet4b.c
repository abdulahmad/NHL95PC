/* Team select: empty dialog draw hook. */
#include "nhl95.h"

/* StubRet4b: does nothing; a dialog hook taking five arguments (one on the stack). Its __CHK 10h counts the 12
   bytes of arguments of a call that the optimizer removes (Watcom sizes the frame before it drops dead code): a
   call behind a local flag that is always 0, as a debug print would be. Which function the original called is
   unknown; any three-argument cdecl call gives these bytes (a constant if (0) does not, the front end drops it). */
void StubRet4b(int a, int b, int c, int d, int e)
{
    int dbg = 0;

    if (dbg) sub_91964((char *)a, b, c);
}
