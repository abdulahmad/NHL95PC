/* Scoring penalty text: game summary queue. */
#include "nhl95.h"

/* FlushGSumQueue: append every queued game summary record (11 bytes each, gsumqueue) to the game summary and
 empty the queue. */
void FlushGSumQueue(void)
{
    int i;

    for (i = 0; i < gsumqcount; i++) AppendGSumRecord(gsumqueue + i * 11);
    gsumqcount = 0;
}
