/* Speech: shut the speech system down. */
#include "nhl95.h"

#define BANKD(off) (*(int *)((char *)speechbank + (off)))

/* ShutdownSpeech (8363C) - PC only: when the speech system is up, remove the SpeechTimerTick timer handler,
   close the open bank file (flag +3B78h, handle +3B7Ch of speechbank), free the speech queue, the sample memory
   (+3B60h, sub_8D2F0), the bank and the request block, and clear speechinit. */
void ShutdownSpeech(void)
{
    if (speechinit != 0) {
        sub_8E4F8(SpeechTimerTick);
        if (BANKD(0x3B78) != 0) _dos_close(BANKD(0x3B7C));
        jctime(speechq);
        sub_8D2F0(BANKD(0x3B60));
        jctime((int)speechbank);
        jctime((int)samplereq);
        speechinit = 0;
    }
}
