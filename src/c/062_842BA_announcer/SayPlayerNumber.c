/* Announcer: a player number. */
#include "nhl95.h"

/* SayPlayerNumber (85213) - when speech is up and idle: announce "<team> <phrase>, number <n>": priority 1Ah
   (+3B70h of speechbank), the team clip "<team>.frm", phrase clip dword_D27A2[phrase] (13 characters) and
   "<n>.num"; request them (with "one left"), make room, queue them and start the queue. Returns 1, else 0. */
int SayPlayerNumber(char *team, int phrase, int number)
{
    char teamclip[16];
    char numclip[16];
    char phraseclip[16];

    if (!speechinit) return 0;
    if (!SpeechIdle()) return 0;
    *(int *)((char *)speechbank + 0x3B70) = 0x1A;
    sprintf(teamclip, (char *)str_SS5, team, (char *)str_Frm);
    strncpy(phraseclip, (char *)dword_D27A2[phrase], 13);
    sprintf(numclip, (char *)str_DS, number, (char *)str_Num);
    ResetSampleReq();
    ResetSpeechQueue();
    RequestSample((char *)str_OneleftCor);
    RequestSample(phraseclip);
    RequestSample(teamclip);
    RequestSample((char *)str_PauseCor);
    RequestSample((char *)str_NumberCor);
    RequestSample(numclip);
    EnsureSampleRoom();
    QueueSpeechClip(phraseclip);
    QueueSpeechClip(teamclip);
    QueueSpeechClip((char *)str_PauseCor);
    QueueSpeechClip((char *)str_NumberCor);
    QueueSpeechClip(numclip);
    ((int *)speechq)[0x60 / 4] = 1;
    return 1;
}
