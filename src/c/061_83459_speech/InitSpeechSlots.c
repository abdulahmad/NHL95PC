/* Speech: speech bank setup. */
#include "nhl95.h"

/* InitSpeechSlots (83459) - clear the 400 speech bank slots and set up the bank's sample buffer: size - 1388h usable
   bytes (+3B68h), a "Speechbuf" block of size bytes (+3B60h, library handle +3B64h), counters +3B6Ch..+3B78h 0. */
void InitSpeechSlots(int size)
{
    int i;

    for (i = 0; i < 400; i++) ClearSpeechSlot((unsigned char *)&speechbank[i]);
    *(int *)((char *)speechbank + 0x3B68) = size - 0x1388;
    *(int *)((char *)speechbank + 0x3B60) = sub_8CC70((char *)str_Speechbuf, size, dword_CCC94);
    *(int *)((char *)speechbank + 0x3B64) = sub_8DBD4(*(int *)((char *)speechbank + 0x3B60));
    *(int *)((char *)speechbank + 0x3B6C) = 0;
    *(int *)((char *)speechbank + 0x3B74) = 0;
    *(int *)((char *)speechbank + 0x3B70) = 0;
    *(int *)((char *)speechbank + 0x3B78) = 0;
}
