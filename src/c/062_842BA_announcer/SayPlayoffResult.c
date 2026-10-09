/* Announcer: playoff result. */
#include "nhl95.h"

/* SayPlayoffResult (8490D) - when speech is up and idle: "[In overtime] <team> have won [game <game> of] <round clip>"
   (team clip <team>Awa, round clip from PlayoffRoundClipD; the game number part only when final is 0); starts
   the queue and returns 1, else 0. */
int SayPlayoffResult(char *team, int game, unsigned conf, unsigned round, int ot, int final)
{
    char t[16];
    char num[16];
    char g[16];
    char rc[16];

    if (!speechinit) return 0;
    if (!SpeechIdle()) return 0;
    *(int *)((char *)speechbank + 0x3B70) = 0;
    sprintf(t, (char *)str_SS5, team, str_Awa);
    itoa(game, num, 10);
    sprintf(g, (char *)str_SSS, str_Gamenum, num, str_Bar);
    PlayoffRoundClipD(rc, conf, round);
    ResetSampleReq();
    ResetSpeechQueue();
    if (ot) RequestSample((char *)str_OvertimeBar);
    RequestSample(t);
    RequestSample((char *)str_HavewonBar);
    if (!final) {
        RequestSample((char *)str_GamenumBar);
        RequestSample(g);
        RequestSample((char *)str_OfBar);
    }
    RequestSample(rc);
    EnsureSampleRoom();
    if (ot) QueueSpeechClip((char *)str_OvertimeBar);
    QueueSpeechClip(t);
    QueueSpeechClip((char *)str_HavewonBar);
    if (!final) {
        QueueSpeechClip((char *)str_GamenumBar);
        QueueSpeechClip(g);
        QueueSpeechClip((char *)str_OfBar);
    }
    QueueSpeechClip(rc);
    ((int *)speechq)[0x60 / 4] = 1;
    return 1;
}
