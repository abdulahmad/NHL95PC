/* Engine sound interface: digital samples. */
#include "nhl95.h"

/* PlayDigiSample: stop the current sample, then (unless sounddev has no digital output: bits 11h) start
 sample s; its handle goes to digihandle. */
void PlayDigiSample(void *s)
{
    StopDigiSample();
    if (!(sounddev & 0x11) && s) digihandle = sub_8F270(s, dword_D2427);
}
