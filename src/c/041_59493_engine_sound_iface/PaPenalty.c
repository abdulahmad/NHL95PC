/* Engine sound interface: announcer wrappers. */
#include "nhl95.h"

/* PaPenalty (59B3C) - with music and announcer speech on: reset the music channel and announce the penalty
   (SayPenalty, arguments passed through). */
void PaPenalty(char *team, int num, int len, char *pen, int a, int b, int idx, int cnt, int withtime)
{
    if (musicon && gameopts.speech) {
        MusicChanReset();
        SayPenalty(team, num, len, pen, a, b, idx, cnt, withtime);
    }
}
