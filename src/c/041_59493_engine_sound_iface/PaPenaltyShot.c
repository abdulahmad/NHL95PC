/* Engine sound interface: announcer wrappers. */
#include "nhl95.h"

/* PaPenaltyShot (59B88) - with music and announcer speech on: reset the music channel and announce the penalty shot. */
void PaPenaltyShot(int a)
{
    if (musicon && gameopts.speech) {
        MusicChanReset();
        SayPenaltyShot(a);
    }
}
