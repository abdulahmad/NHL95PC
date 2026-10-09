/* Scoring / penalties: deferred calls. */
#include "nhl95.h"

/* one queued call: 7 arguments and the function (20h bytes, table at E9BA4) */
typedef struct DeferCall {
    int a, b, c, d, e, f, g;
    void (*fn)(int, int, int, int, int, int, int);
} DeferCall;

#define Q(i) ((DeferCall *)dword_E9BA4)[i]

/* RunDeferredCalls (61A27) - PC only: make the defercount queued calls (dword_E9BA4 table: arguments in eax, edx,
   ebx, ecx, then 3 on the stack) in order and empty the queue. */
void RunDeferredCalls(void)
{
    int i;

    for (i = 0; i < defercount; i++) {
        Q(i).fn(Q(i).a, Q(i).b, Q(i).c, Q(i).d, Q(i).e, Q(i).f, Q(i).g);
    }
    defercount = 0;
}
