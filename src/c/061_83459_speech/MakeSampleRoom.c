/* Speech: sample memory. */
#include "nhl95.h"

/* MakeSampleRoom (84205) - while the requested samples (samplereq +104h) do not fit next to the loaded ones
   (speechbank +3B6Ch) in the bank size (+3B68h), free unrequested samples (at most 400 tries). */
void MakeSampleRoom(void)
{
    int k;
    int done;
    unsigned lim;

    k = 0;
    done = 0;
    lim = *(unsigned *)((unsigned char *)speechbank + 0x3B68);
    if (*(unsigned *)((unsigned char *)speechbank + 0x3B6C) + *(unsigned *)(samplereq + 0x104) > lim) {
        do {
            FreeUnrequestedSamples();
            if (*(unsigned *)((unsigned char *)speechbank + 0x3B6C) + *(unsigned *)(samplereq + 0x104) < lim)
                done = 1;
        } while (!done && ++k < 400);
    }
}
