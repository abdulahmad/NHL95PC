/* Speech: is the announcer still talking. */
#include "nhl95.h"

/* SpeechBusy (836E4) - PC only: 1 while the speech system is up and the speech queue has a clip playing or
   pending (the dwords at +60h / +5Ch of speechq), else 0. */
int SpeechBusy(void)
{
    if (speechinit != 0) {
        if (*(int *)(speechq + 0x60) != 0) return 1;
        if (*(int *)(speechq + 0x5C) != 0) return 1;
    }
    return 0;
}
