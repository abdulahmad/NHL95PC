/* Announcer: game intros. */
#include "nhl95.h"

/* SayTonightIntro (84B0D) - when speech is up and idle: "Tonight <rnk> EA Sports game between <away> and <home>", the
   team clip names built as <name>Rnk / <name>Awa / <name>Hom (str_SS5); starts the queue and returns 1, else 0. */
int SayTonightIntro(char *rnk, char *away, char *home)
{
    char r[16];
    char a[16];
    char h[16];

    if (!speechinit) return 0;
    if (!SpeechIdle()) return 0;
    *(int *)((char *)speechbank + 0x3B70) = 0;
    sprintf(r, (char *)str_SS5, rnk, str_Rnk);
    sprintf(a, (char *)str_SS5, away, str_Awa);
    sprintf(h, (char *)str_SS5, home, str_Hom);
    ResetSpeechQueue();
    ResetSampleReq();
    RequestSample((char *)str_TonightBar);
    RequestSample(r);
    RequestSample((char *)str_EasportsBar);
    RequestSample((char *)str_GamebtwnBar);
    RequestSample(a);
    RequestSample((char *)str_AndBar);
    RequestSample(h);
    EnsureSampleRoom();
    QueueSpeechClip((char *)str_TonightBar);
    QueueSpeechClip(r);
    QueueSpeechClip((char *)str_EasportsBar);
    QueueSpeechClip((char *)str_GamebtwnBar);
    QueueSpeechClip(a);
    QueueSpeechClip((char *)str_AndBar);
    QueueSpeechClip(h);
    ((int *)speechq)[0x60 / 4] = 1;
    return 1;
}
