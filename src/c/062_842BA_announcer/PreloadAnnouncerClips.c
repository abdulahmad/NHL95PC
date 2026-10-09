/* Announcer: preload. */
#include "nhl95.h"

/* PreloadAnnouncerClips (8579E) - when speech is up and idle: open the XBRUCE2.VIV speech bank (1Ah slots) and preload the
   clips used in a game (one minute left, pause, both team names <name>Tea, goal/assist/and/penalty numbers,
   2 minutes, at) plus the penalty types by requesting and queueing them; returns 1, else 0. */
int PreloadAnnouncerClips(char *home, char *vis)
{
    char h[16];
    char v[16];
    char path[16];

    if (!speechinit) return 0;
    if (!SpeechIdle()) return 0;
    ResetSampleReq();
    ResetSpeechQueue();
    MakePath(path, fileoncd[0x1C0] == 1 ? (char *)cddriveptr : 0, (char *)str_XBRUCE2, (char *)str_VIV);
    OpenSpeechBank(path, 0x1A);
    sprintf(h, (char *)str_SS5, home, str_Tea);
    sprintf(v, (char *)str_SS5, vis, str_Tea);
    RequestSample((char *)str_OneleftCor);
    RequestSample((char *)str_PauseCor);
    RequestSample(h);
    RequestSample(v);
    RequestSample((char *)str_GoalnumCor);
    RequestSample((char *)str_AsstnumCor);
    RequestSample((char *)str_AndnumCor);
    RequestSample((char *)str_PennumCor);
    RequestSample((char *)str_PensnumCor);
    RequestSample((char *)str_2minCor);
    RequestSample((char *)str_AtCor);
    QueueSpeechClip((char *)str_OneleftCor);
    QueueSpeechClip((char *)str_PauseCor);
    QueueSpeechClip(h);
    QueueSpeechClip(v);
    QueueSpeechClip((char *)str_GoalnumCor);
    QueueSpeechClip((char *)str_AsstnumCor);
    QueueSpeechClip((char *)str_AndnumCor);
    QueueSpeechClip((char *)str_PennumCor);
    QueueSpeechClip((char *)str_PensnumCor);
    QueueSpeechClip((char *)str_2minCor);
    QueueSpeechClip((char *)str_AtCor);
    QueuePenaltyType();
    return 1;
}
