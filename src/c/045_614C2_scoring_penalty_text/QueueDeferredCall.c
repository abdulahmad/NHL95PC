/* Scoring / penalties: deferred calls. */
#include "nhl95.h"

/* QueueDeferredCall (619C8) - PC only: queue a call of fn with arguments a-g (run later by RunDeferredCalls): the
   32-byte entry defercount of the table, function at +1Ch, the arguments from +0 (dword_E9BA4 ...). */
void QueueDeferredCall(void (*fn)(int, int, int, int, int, int, int), int a, int b, int c, int d, int e, int f, int g)
{
    int i;

    i = defercount * 8;
    dword_E9BC0[i] = (int)fn;
    dword_E9BA4[i] = a;
    dword_E9BA8[i] = b;
    dword_E9BAC[i] = c;
    dword_E9BB0[i] = d;
    dword_E9BB4[i] = e;
    dword_E9BB8[i] = f;
    dword_E9BBC[i] = g;
    defercount++;
}
