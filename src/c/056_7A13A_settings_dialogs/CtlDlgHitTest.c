/* Settings dialogs: controls dialog hit test. */
#include "nhl95.h"

/* CtlDlgHitTest (7D61F) - which of the 9 control dialog rects contains the mouse point (x - 6, y - 13h): *hit = its
   number, returns 1; 0 when none. */
int CtlDlgHitTest(int x, int y, int *hit)
{
    int i;

    x -= 6;
    y -= 0x13;
    for (i = 0; i < 9; i++) {
        if (x >= ((Rect4 *)ctldlgrects)[i].l && x <= ((Rect4 *)ctldlgrects)[i].r
         && y >= ((Rect4 *)ctldlgrects)[i].t && y <= ((Rect4 *)ctldlgrects)[i].b) {
            *hit = i;
            return 1;
        }
    }
    return 0;
}
