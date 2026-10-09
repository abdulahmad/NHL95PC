/* Speech: speech bank slots. */
#include "nhl95.h"

/* FindSpeechSlot (83EEB) - number of the speech bank slot (of 400) named name (case-insensitive), or -1. */
int FindSpeechSlot(char *name)
{
    int i;

    for (i = 0; i < 400; i++) {
        if (StrEqNoCase(name, (char *)speechbank + i * 38)) return i;
    }
    return -1;
}
