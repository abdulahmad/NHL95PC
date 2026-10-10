/* Engine sound interface: penalty shot announcement. */
#include "nhl95.h"

/* PaPenaltyShot (59B88) - with music and announcer speech on: MusicChanReset, then SayPenaltyShot (arguments passed through). */
void PaPenaltyShot(char *team, int num, int min, int sec)
{
    if (musicon && gameopts.speech) {
        MusicChanReset();
        SayPenaltyShot(team, num, min, sec);
    }
}
