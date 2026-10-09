/* Speech: speech bank slots. */
#include "nhl95.h"

/* FindLoadedSpeechSlot (83EAC) - first speech bank slot from i on (of 400) with a sample loaded; -1 when none. */
int FindLoadedSpeechSlot(int i)
{
    SpeechSlot *b;

    b = speechbank;
    for (; i < 400; i++) {
        if (b[i].loaded == 1) return i;
    }
    return -1;
}
