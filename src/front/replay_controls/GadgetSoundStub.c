/* Gadgets replay: sound library call. */
#include "nhl95.h"

/* GadgetSoundStub: MviGetFrame(GadgetMovie) (EA sound library, one stack argument). */
void GadgetSoundStub(void)
{
    MviGetFrame(GadgetMovie);
}
