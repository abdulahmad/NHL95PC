/* Scoring / penalty text: game summary queue. */
#include "nhl95.h"

/* FlushGSumQueue (61B85) - append every queued game summary record (11 bytes each, unk_E9B4C) to the game summary and
   empty the queue. */
void FlushGSumQueue(void)
{
    int i;

    for (i = 0; i < gsumqcount; i++) AppendGSumRecord(unk_E9B4C + i * 11);
    gsumqcount = 0;
}
