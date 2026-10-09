/* Speech: speech bank slots (26h bytes each: size at +16h, loaded flag at +22h). */
#include "nhl95.h"

/* SpeechSlotLoaded (83F35) - 1 when speech bank slot i holds a loaded sample. */
int SpeechSlotLoaded(int i)
{
    return speechbank[i].loaded == 1;
}
