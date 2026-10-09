/* Speech: speech bank slots. */
#include "nhl95.h"

/* FindFreeSpeechSlot (83E6D) - first speech bank slot from i on (of 400) with no sample loaded; -1 when none. */
int FindFreeSpeechSlot(int i)
{
    SpeechSlot *b;

    b = speechbank;
    for (; i < 400; i++) {
        if (b[i].loaded == 0) return i;
    }
    return -1;
}
