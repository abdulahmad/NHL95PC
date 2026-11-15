/* Scoring penalties: deferred calls. */
#include "nhl95.h"

/* QueueDeferredCall: queue a call of fn with arguments a-g (run later by RunDeferredCalls): the
 32-byte entry defercount of the table, function at +1Ch, the arguments from +0 (defertab...). */
void QueueDeferredCall(void (*fn)(int, int, int, int, int, int, int), int a, int b, int c, int d, int e, int f, int g)
{
    int i;

    i = defercount * 8;
    defertab_fn[i] = (int)fn;
    defertab[i] = a;
    defertab_a1[i] = b;
    defertab_a2[i] = c;
    defertab_a3[i] = d;
    defertab_a4[i] = e;
    defertab_a5[i] = f;
    defertab_a6[i] = g;
    defercount++;
}
