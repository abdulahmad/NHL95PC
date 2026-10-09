/* Engine sound interface: announcer wrappers. */
#include "nhl95.h"

/* PaPenaltyShot (59B88) - with music and announcer speech on: reset the music channel and announce the penalty shot. */
void PaPenaltyShot(char *team, int num, int min, int sec)
{
    if (musicon && gameopts.speech) {
        MusicChanReset();
        SayPenaltyShot(team, num, min, sec);
    }
}
