/* Gadgets replay: sound library call. */
#include "nhl95.h"

/* GadgetSoundStub: MviGetFrame(dword_ED6D0) (EA sound library, one stack argument). */
void GadgetSoundStub(void)
{
    MviGetFrame(dword_ED6D0);
}
