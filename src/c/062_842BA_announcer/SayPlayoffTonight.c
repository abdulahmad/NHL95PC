/* Announcer: game intros. */
#include "nhl95.h"

/* SayPlayoffTonight (84C38) - when speech is up and idle: "Tonight <rnk> EA Sports <game number> of <round clip> between
   <away> and <home>" (team clips <name>Rnk / Awa / Hom, the round clip from PlayoffRoundClipU); starts the queue
   and returns 1, else 0. */
int SayPlayoffTonight(char *rnk, char *away, char *home, int game, unsigned conf, unsigned round)
{
    char a[16];
    char r[16];
    char num[16];
    char g[16];
    char h[16];
    char rc[16];

    if (!speechinit) return 0;
    if (!SpeechIdle()) return 0;
    *(int *)((char *)speechbank + 0x3B70) = 0;
    sprintf(r, (char *)str_SS5, rnk, str_Rnk);
    sprintf(a, (char *)str_SS5, away, str_Awa);
    sprintf(h, (char *)str_SS5, home, str_Hom);
    itoa(game, num, 10);
    sprintf(g, (char *)str_SSS, str_Gamenum, num, str_Bar);
    PlayoffRoundClipU(rc, conf, round);
    ResetSpeechQueue();
    ResetSampleReq();
    RequestSample((char *)str_TonightBar);
    RequestSample(r);
    RequestSample((char *)str_EasportsBar);
    RequestSample(g);
    RequestSample((char *)str_OfBar);
    RequestSample(rc);
    RequestSample((char *)str_BetweenBar);
    RequestSample(a);
    RequestSample((char *)str_AndBar);
    RequestSample(h);
    EnsureSampleRoom();
    QueueSpeechClip((char *)str_TonightBar);
    QueueSpeechClip(r);
    QueueSpeechClip((char *)str_EasportsBar);
    QueueSpeechClip(g);
    QueueSpeechClip((char *)str_OfBar);
    QueueSpeechClip(rc);
    QueueSpeechClip((char *)str_BetweenBar);
    QueueSpeechClip(a);
    QueueSpeechClip((char *)str_AndBar);
    QueueSpeechClip(h);
    ((int *)speechq)[0x60 / 4] = 1;
    return 1;
}
