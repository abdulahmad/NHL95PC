/* Announcer: preload the clips of a game time. */
#include "nhl95.h"

/* RequestTimeClips (84DDD) - PC only: as QueueTimeClips, but request (preload) the speech samples for "at <min> minutes <sec> seconds": AT, a pause,
   then the minutes ("<min>.NUM"; "1 minute" alone, or "<min> minutes" when the seconds are 0) and the seconds
   ("<sec:02>.NUM" after minutes; "1 second" or "<sec> seconds" alone). */
void RequestTimeClips(int min, int sec)
{
    char mins[16];
    char secs[16];

    sprintf(mins, (char *)str_DS, min, (char *)str_Num);
    sprintf(secs, (char *)str_02dS, sec, (char *)str_Num);
    RequestSample((char *)str_AtCor);
    RequestSample((char *)str_PauseCor);
    if (min != 0) {
        if (sec == 0) {
            if (min == 1) {
                RequestSample((char *)str_1minuteCor);
            } else {
                RequestSample(mins);
                RequestSample((char *)str_MinutesCor);
            }
        } else {
            RequestSample(mins);
        }
    }
    if (sec == 1) {
        if (min == 0) RequestSample((char *)str_1secondCor);
        else RequestSample(secs);
    } else if (sec > 0) {
        if (min == 0) {
            sprintf(secs, (char *)str_DS, sec, (char *)str_Num);
            RequestSample(secs);
            RequestSample((char *)str_SecondsCor);
        } else {
            RequestSample(secs);
        }
    }
}
