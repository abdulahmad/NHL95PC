/* EASN stats: memory. */
#include "nhl95.h"

/* FreeCalendarIfLowMem: when free memory (MemLargestFree) is at most 4B708h bytes, release the calendar shapes. */
void FreeCalendarIfLowMem(void)
{
    if (MemLargestFree() <= 0x4B708) {
        if (calendarshapes) FreeMemBlock(calendarshapes);
        calendarshapes = 0;
    }
}
