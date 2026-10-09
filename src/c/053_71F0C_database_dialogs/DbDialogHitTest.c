/* Database dialogs: hit test. */
#include "nhl95.h"

/* DbDialogHitTest (72A5C) - which of the 16 database dialog rects contains the mouse point (x - 6, y - 13h, the pointer
   hot spot): *hit = its number, returns 1; 0 when none. */
int DbDialogHitTest(int x, int y, int *hit)
{
    int i;

    x -= 6;
    y -= 0x13;
    for (i = 0; i < 16; i++) {
        if (x >= ((Rect4 *)dbdlgrects)[i].l && x <= ((Rect4 *)dbdlgrects)[i].r
         && y >= ((Rect4 *)dbdlgrects)[i].t && y <= ((Rect4 *)dbdlgrects)[i].b) {
            *hit = i;
            return 1;
        }
    }
    return 0;
}
