/* Sound config: speech slots. */
#include "nhl95.h"

/* ClearSpeechSlot (833C5) - clear speech slot s: name byte, flag byte at +0Dh and the dwords at +0Eh, +12h, +16h (size),
   +1Eh and +22h (loaded). */
void ClearSpeechSlot(unsigned char *s)
{
    s[0] = 0;
    s[0x0D] = 0;
    *(int *)(s + 0x0E) = 0;
    *(int *)(s + 0x12) = 0;
    *(int *)(s + 0x16) = 0;
    *(int *)(s + 0x1E) = 0;
    *(int *)(s + 0x22) = 0;
}
