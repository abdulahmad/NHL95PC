/* Engine sound interface: announcer wrappers. */
#include "nhl95.h"

/* PaPlayoffResult (59CDD) - with music and announcer speech on: announce the playoff result of team (its
   abbreviation, teamabbrevs) - the other arguments pass straight to SayPlayoffResult. */
void PaPlayoffResult(int team, int game, unsigned conf, unsigned round, int ot, int final)
{
    if (musicon && gameopts.speech) SayPlayoffResult((char *)teamabbrevs[team], game, conf, round, ot, final);
}
