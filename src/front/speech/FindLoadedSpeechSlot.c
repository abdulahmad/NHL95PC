/* Speech: speech bank slots. */
#include "nhl95.h"

/* FindLoadedSpeechSlot: first speech bank slot from i on (of 400) with a sample loaded; -1 when none. */
int FindLoadedSpeechSlot(int i)
{
    SpeechSlot *b;

    b = speechbank;
    for (; i < 400; i++) {
        int offset = i;
        offset <<= 2;
        offset += i;
        offset <<= 2;
        offset -= i;
        if (*(int *)((char *)b + offset * 2 + 0x22) == 1) return i;
    }
    return -1;
}
