/* Speech: speech system setup. */
#include "nhl95.h"

/* InitSpeech: once: set up the speech system (sentence queue, sample request block, speech bank of size
 bytes, copy buffer) and hook SpeechTimerTick on the timer. */
void InitSpeech(unsigned char id, int size, int copybuf, int copylen)
{
    if (SpeechIsInit()) return;
    SpeechInitMode = id;
    speechchannel = 0;
    speechcopybuf = copybuf;
    speechcopylen = copylen;
    speechq = AllocMemBlock((char *)str_Sentence, 100, cursndbank);
    ResetSpeechQueue();
    samplereq = (unsigned char *)AllocMemBlock((char *)str_SampleMemMan, 0x110, cursndbank);
    ResetSampleReq();
    speechbank = (SpeechSlot *)AllocMemBlock((char *)str_SpeechBank, 0x3B93, cursndbank);
    InitSpeechSlots(size);
    addtimer((void (*)(void))SpeechTimerTick);
    speechinit = 1;
}
