/* Scoring / penalty text: referee penalty call (93G SetPA). */
#include "nhl95.h"

/* SetPA (62EA2) - referee calls penalty pa (not for 5 and 1Ch): RefPen = pa, RefStep 0, and the referee (SortCords[16])
   gets assignment 23h for penalty 7, else 20h. */
void SetPA(short pa)
{
    if (pa != 5 && pa != 0x1C) {
        RefPen = pa;
        RefStep[0] = 0;
        assreplace(&SortCords[16], (short)(pa == 7 ? 0x23 : 0x20));
    }
}
