/* Announcer: say a game time. */
#include "nhl95.h"

/* QueueTimeClips (84EAC) - PC only: queue the speech clips for "at <min> minutes <sec> seconds": AT, a pause,
   then the minutes ("<min>.NUM"; "1 minute" alone, or "<min> minutes" when the seconds are 0) and the seconds
   ("<sec:02>.NUM" after minutes; "1 second" or "<sec> seconds" alone). */
void QueueTimeClips(int min, int sec)
{
    char mins[16];
    char secs[16];

    sprintf(mins, (char *)str_DS, min, (char *)str_Num);
    sprintf(secs, (char *)str_02dS, sec, (char *)str_Num);
    QueueSpeechClip((char *)str_AtCor);
    QueueSpeechClip((char *)str_PauseCor);
    if (min != 0) {
        if (sec == 0) {
            if (min == 1) {
                QueueSpeechClip((char *)str_1minuteCor);
            } else {
                QueueSpeechClip(mins);
                QueueSpeechClip((char *)str_MinutesCor);
            }
        } else {
            QueueSpeechClip(mins);
        }
    }
    if (sec == 1) {
        if (min == 0) QueueSpeechClip((char *)str_1secondCor);
        else QueueSpeechClip(secs);
    } else if (sec > 0) {
        if (min == 0) {
            sprintf(secs, (char *)str_DS, sec, (char *)str_Num);
            QueueSpeechClip(secs);
            QueueSpeechClip((char *)str_SecondsCor);
        } else {
            QueueSpeechClip(secs);
        }
    }
}
