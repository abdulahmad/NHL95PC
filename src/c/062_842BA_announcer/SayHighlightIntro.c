/* Announcer: game intros. */
#include "nhl95.h"

/* SayHighlightIntro (847CE) - like SayTonightIntro: "Take you now to <rnk> highlight of game between <away> and <home>". */
int SayHighlightIntro(char *rnk, char *away, char *home)
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
    RequestSample((char *)str_TakeynowBar);
    RequestSample(r);
    RequestSample((char *)str_HighliteBar);
    RequestSample((char *)str_OfBar);
    RequestSample((char *)str_GamebtwnBar);
    RequestSample(a);
    RequestSample((char *)str_AndBar);
    RequestSample(h);
    EnsureSampleRoom();
    QueueSpeechClip((char *)str_TakeynowBar);
    QueueSpeechClip(r);
    QueueSpeechClip((char *)str_HighliteBar);
    QueueSpeechClip((char *)str_OfBar);
    QueueSpeechClip((char *)str_GamebtwnBar);
    QueueSpeechClip(a);
    QueueSpeechClip((char *)str_AndBar);
    QueueSpeechClip(h);
    ((int *)speechq)[0x60 / 4] = 1;
    return 1;
}
