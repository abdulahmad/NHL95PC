/* Gadgets replay: sound library call. */
#include "nhl95.h"

/* GadgetMovieFrameRate: MviGetFrameRate(GadgetMovie) (EA sound library, one stack argument). */
void GadgetMovieFrameRate(void)
{
    MviGetFrameRate(GadgetMovie);
}
