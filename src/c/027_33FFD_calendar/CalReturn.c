/* Calendar: menu callbacks. */
#include "nhl95.h"

/* CalReturn (3476B) - calendar "return" button: no selection, leave the calendar (calsel = calexit = -1). */
void CalReturn(void)
{
    calsel = calexit = -1;
}
