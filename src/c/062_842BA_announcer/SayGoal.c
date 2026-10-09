/* Announcer: a goal. */
#include "nhl95.h"

/* SayGoal (8531F) - when speech is up and idle: announce "<team> goal, number <scorer>" and with nast assists
   "assisted by number <a1>" (nast > 0) "and number <a2>" (nast > 1): priority 1Ah, request the clips (with "one
   left"), make room, queue them and start the queue. Returns 1, else 0. */
int SayGoal(char *team, int nast, int scorer, int a1, int a2)
{
    char teamclip[16];
    char scorerclip[16];
    char a1clip[16];
    char a2clip[16];

    if (!speechinit) return 0;
    if (!SpeechIdle()) return 0;
    *(int *)((char *)speechbank + 0x3B70) = 0x1A;
    sprintf(teamclip, (char *)str_SS5, team, (char *)str_Tea);
    sprintf(scorerclip, (char *)str_DS, scorer, (char *)str_Num);
    sprintf(a1clip, (char *)str_DS, a1, (char *)str_Num);
    sprintf(a2clip, (char *)str_DS, a2, (char *)str_Num);
    ResetSampleReq();
    ResetSpeechQueue();
    RequestSample((char *)str_OneleftCor);
    RequestSample(teamclip);
    RequestSample((char *)str_GoalnumCor);
    RequestSample(scorerclip);
    if (nast > 0) {
        RequestSample((char *)str_PauseCor);
        RequestSample((char *)str_AsstnumCor);
        RequestSample(a1clip);
    }
    if (nast > 1) {
        RequestSample((char *)str_PauseCor);
        RequestSample((char *)str_AndnumCor);
        RequestSample(a2clip);
    }
    EnsureSampleRoom();
    QueueSpeechClip(teamclip);
    QueueSpeechClip((char *)str_GoalnumCor);
    QueueSpeechClip(scorerclip);
    if (nast > 0) {
        QueueSpeechClip((char *)str_PauseCor);
        QueueSpeechClip((char *)str_AsstnumCor);
        QueueSpeechClip(a1clip);
    }
    if (nast > 1) {
        QueueSpeechClip((char *)str_PauseCor);
        QueueSpeechClip((char *)str_AndnumCor);
        QueueSpeechClip(a2clip);
    }
    ((int *)speechq)[0x60 / 4] = 1;
    return 1;
}
