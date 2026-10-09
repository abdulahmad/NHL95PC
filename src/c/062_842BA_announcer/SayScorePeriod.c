/* Announcer: score by period. */
#include "nhl95.h"

/* SayScorePeriod (84657) - when speech is up and idle: queue the "scoring by period" clip for period per (scorperclips)
   and start the queue; returns 1, else 0. */
int SayScorePeriod(int per)
{
    if (!speechinit) return 0;
    if (!SpeechIdle()) return 0;
    ResetSpeechQueue();
    ResetSampleReq();
    RequestSample((char *)scorperclips[per]);
    EnsureSampleRoom();
    QueueSpeechClip((char *)scorperclips[per]);
    ((int *)speechq)[0x60 / 4] = 1;
    return 1;
}
