/* Engine sound interface: announcer wrappers. */
#include "nhl95.h"

/* PaHighlightIntro (59CA9) - with music and announcer speech on: the highlight intro for the two teams (abbreviations;
   the home one is passed twice). */
void PaHighlightIntro(int home, int vis)
{
    if (musicon && gameopts.speech) {
        SayHighlightIntro(teamabbrevs[home], teamabbrevs[vis], teamabbrevs[home]);
    }
}
