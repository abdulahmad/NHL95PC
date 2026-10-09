/* EASN stats: memory. */
#include "nhl95.h"

/* FreeCalendarIfLowMem (212C6) - when free memory (sub_8DAB8) is at most 4B708h bytes, release the calendar shapes. */
void FreeCalendarIfLowMem(void)
{
    if (sub_8DAB8() <= 0x4B708) {
        if (calendarshapes) jctime(calendarshapes);
        calendarshapes = 0;
    }
}
