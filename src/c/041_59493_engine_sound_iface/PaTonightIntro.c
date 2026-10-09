/* Engine sound interface: announcer wrappers. */
#include "nhl95.h"

/* PaTonightIntro (59BB5) - with music and announcer speech on: announce tonight's game between home and away
   (abbreviations; the first one is home's, or entry 12 for a team number 26 and up). */
void PaTonightIntro(int home, int away)
{
    int first;

    first = home;
    if (home >= 26) first = 12;
    if (musicon && gameopts.speech)
        SayTonightIntro((char *)teamabbrevs[first], (char *)teamabbrevs[away], (char *)teamabbrevs[home]);
}
