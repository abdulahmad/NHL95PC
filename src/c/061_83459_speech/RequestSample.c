/* Speech: sample requests. */
#include "nhl95.h"

/* RequestSample (83FAF) - add clip name to the sample request list (13-byte names, count at +108h) unless it is there;
   a known slot that is not loaded adds its size to the requested bytes (+104h). Counts requests at +10Ch. */
void RequestSample(char *name)
{
    int slot;

    if (IsSampleRequested(name) == 1) return;
    strncpy((char *)samplereq + (*(int *)(samplereq + 0x108))++ * 13, name, 13);
    slot = FindSpeechSlot(name);
    if (slot != -1 && !SpeechSlotLoaded(slot)) *(int *)(samplereq + 0x104) += SpeechSlotSize(slot);
    (*(int *)(samplereq + 0x10C))++;
}
