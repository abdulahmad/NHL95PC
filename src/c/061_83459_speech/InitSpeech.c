/* Speech: speech system setup. */
#include "nhl95.h"

/* InitSpeech (8357A) - once: set up the speech system (sentence queue, sample request block, speech bank of size
   bytes, copy buffer) and hook SpeechTimerTick on the timer. */
void InitSpeech(unsigned char id, int size, int copybuf, int copylen)
{
    if (SpeechIsInit()) return;
    byte_D27B6 = id;
    dword_D27B2 = 0;
    speechcopybuf = copybuf;
    speechcopylen = copylen;
    speechq = sub_8CCA8((char *)str_Sentence, 100, dword_CCC94);
    ResetSpeechQueue();
    samplereq = (unsigned char *)sub_8CCA8((char *)str_SampleMemMan, 0x110, dword_CCC94);
    ResetSampleReq();
    speechbank = (SpeechSlot *)sub_8CCA8((char *)str_SpeechBank, 0x3B93, dword_CCC94);
    InitSpeechSlots(size);
    sub_8E4C0((void (*)(void))SpeechTimerTick);
    speechinit = 1;
}
