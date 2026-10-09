/* Engine sound interface: announcer wrappers. */
#include "nhl95.h"

/* PaGoal (59AD0) - with music and announcer speech on and gmode bit 4 clear: reset the music channel and announce
   the goal (SayGoal, arguments passed through). */
void PaGoal(char *team, int nast, int scorer, int a1, int a2)
{
    if (musicon && gameopts.speech && (gmode & 0x10) == 0) {
        MusicChanReset();
        SayGoal(team, nast, scorer, a1, a2);
    }
}
