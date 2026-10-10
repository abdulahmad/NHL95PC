/* EASN stats: calendar shapes. */
#include "nhl95.h"

/* LoadCalendarShapes (212FE) - load the CALENDAR shape bank once (calendarshapes; from the CD when fileoncd says so). */
void LoadCalendarShapes(void)
{
    char path[32];

    if (calendarshapes) return;
    MakePath(path, fileoncd[0x1C1] == 1 ? (char *)cddriveptr : 0, (char *)str_calendar, 0);
    calendarshapes = sub_8E83C(path, 0x20);
}
