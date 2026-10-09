/* Announcer: penalty shot. */
#include "nhl95.h"

/* SayPenaltyShot (8511E) - when speech is up and idle: announce "<team> penalty shot <number>, at <min>:<sec>":
   priority 1Ah (+3B70h of speechbank), request the clips (with "one left" and the time clips), make room, queue
   them and start the queue. Returns 1, else 0. */
int SayPenaltyShot(char *team, int num, int min, int sec)
{
    char teamclip[16];
    char numclip[16];

    if (!speechinit) return 0;
    if (!SpeechIdle()) return 0;
    *(int *)((char *)speechbank + 0x3B70) = 0x1A;
    sprintf(teamclip, (char *)str_SS5, team, (char *)str_Tea);
    sprintf(numclip, (char *)str_DS, num, (char *)str_Num);
    ResetSampleReq();
    ResetSpeechQueue();
    RequestSample((char *)str_OneleftCor);
    RequestSample(teamclip);
    RequestSample((char *)str_PenshotCor);
    RequestSample(numclip);
    RequestSample((char *)str_PauseCor);
    RequestTimeClips(min, sec);
    EnsureSampleRoom();
    QueueSpeechClip(teamclip);
    QueueSpeechClip((char *)str_PenshotCor);
    QueueSpeechClip(numclip);
    QueueSpeechClip((char *)str_PauseCor);
    QueueTimeClips(min, sec);
    ((int *)speechq)[0x60 / 4] = 1;
    return 1;
}
