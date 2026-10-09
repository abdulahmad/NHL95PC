/* Engine sound interface: announcer wrappers. */
#include "nhl95.h"

/* PaPlayoffTonight (59D16) - with music and announcer speech on: announce tonight's playoff game between teams
   home and away (their abbreviations; home is passed twice) with game, conference and round. */
void PaPlayoffTonight(int home, int away, int game, unsigned conf, unsigned round)
{
    if (musicon && gameopts.speech)
        SayPlayoffTonight((char *)teamabbrevs[home], (char *)teamabbrevs[away], (char *)teamabbrevs[home], game, conf, round);
}
