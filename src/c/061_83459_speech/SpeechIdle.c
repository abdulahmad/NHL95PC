/* Speech: queue state. */
#include "nhl95.h"

/* SpeechIdle (83711) - 1 when the speech system is up and its queue (speechq) has nothing playing (+60h) or waiting
   (+5Ch); else 0. */
int SpeechIdle(void)
{
    int *q;

    if (!speechinit) return 0;
    q = (int *)speechq;
    if (q[0x60 / 4] || q[0x5C / 4]) return 0;
    return 1;
}
