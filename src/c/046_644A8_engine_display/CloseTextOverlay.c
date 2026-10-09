/* CloseTextOverlay (66DDA) - PC only: close the text overlay. ovltimer 100h means fully shown: start sliding it
   out (10h); otherwise remove it at once (0). */
#include "nhl95.h"

void CloseTextOverlay(void)
{
    if (ovltimer == 0x100) ovltimer = 0x10;     /* fully shown: slide out */
    else ovltimer = 0;
}
