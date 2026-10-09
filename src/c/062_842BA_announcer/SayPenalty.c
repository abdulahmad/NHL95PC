/* Announcer: penalties. */
#include "nhl95.h"

/* SayPenalty (84F7B) - when speech is up and idle: announce a penalty: "<team> [penalty / penalties on] number <num>,
   <length clip>, <pen>" (team clip <team>Tea, number clip <num>Num, length from PenaltyLenClip, penalty clip
   <pen>Pen; idx 1 gives the team clip and penalty / penalties (idx < cnt) wording, else "and number"), with the
   time clips (RequestTimeClips / QueueTimeClips a, b) when withtime; starts the queue and returns 1, else 0. */
int SayPenalty(char *team, int num, int len, char *pen, int a, int b, int idx, int cnt, int withtime)
{
    char n[16];
    char lc[16];
    char pn[16];
    char t[16];

    if (!speechinit) return 0;
    if (!SpeechIdle()) return 0;
    *(int *)((char *)speechbank + 0x3B70) = 0x1A;
    sprintf(t, (char *)str_SS5, team, str_Tea);
    sprintf(n, (char *)str_DS, num, str_Num);
    PenaltyLenClip(len, lc);
    sprintf(pn, (char *)str_SS5, pen, str_Pen);
    ResetSampleReq();
    ResetSpeechQueue();
    RequestSample((char *)str_OneleftCor);
    if (idx == 1) {
        RequestSample(t);
        RequestSample(idx < cnt ? (char *)str_PensnumCor : (char *)str_PennumCor);
    } else {
        RequestSample((char *)str_AndnumCor);
    }
    RequestSample(n);
    RequestSample((char *)str_PauseCor);
    RequestSample(lc);
    RequestSample(pn);
    RequestSample((char *)str_PauseCor);
    if (withtime) RequestTimeClips(a, b);
    EnsureSampleRoom();
    if (idx == 1) {
        QueueSpeechClip(t);
        QueueSpeechClip(idx < cnt ? (char *)str_PensnumCor : (char *)str_PennumCor);
    } else {
        QueueSpeechClip((char *)str_AndnumCor);
    }
    QueueSpeechClip(n);
    QueueSpeechClip((char *)str_PauseCor);
    QueueSpeechClip(lc);
    QueueSpeechClip(pn);
    QueueSpeechClip((char *)str_PauseCor);
    if (withtime) QueueTimeClips(a, b);
    ((int *)speechq)[0x60 / 4] = 1;
    return 1;
}
