/* Speech: speech bank slots (26h bytes each: size at +16h, loaded flag at +22h). */
#include "nhl95.h"

/* SpeechSlotSize (83BC7) - sample size of speech bank slot i; 0 for no slot (-1). */
int SpeechSlotSize(int i)
{
    if (i == -1) return 0;
    return speechbank[i].size;
}
