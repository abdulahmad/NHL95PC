/* Announcer: one minute left. */
#include "nhl95.h"

/* SayOneMinuteLeft (854AC) - when speech is up and idle: queue the "one minute left" clip, mark it said (dword_CCC98) and
   start the queue; returns 1, else 0. */
int SayOneMinuteLeft(void)
{
    if (!speechinit) return 0;
    if (!SpeechIdle()) return 0;
    ResetSampleReq();
    ResetSpeechQueue();
    RequestSample((char *)str_OneleftCor);
    EnsureSampleRoom();
    QueueSpeechClip((char *)str_OneleftCor);
    dword_CCC98 = 1;
    ((int *)speechq)[0x60 / 4] = 1;
    return 1;
}
