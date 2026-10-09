/* Settings / locker room: hit test. */
#include "nhl95.h"

/* LockerHitTest (81520) - which of the 8 locker room rects (left, top, right, bottom) contains (x + 4, y): *hit = its
   number, returns 1; 0 when none. */
typedef struct { int l, t, r, b; } Rect4;

int LockerHitTest(int x, int y, int *hit)
{
    int i;

    x += 4;
    for (i = 0; i < 8; i++) {
        if (x >= ((Rect4 *)lockerrects)[i].l && x <= ((Rect4 *)lockerrects)[i].r
         && y >= ((Rect4 *)lockerrects)[i].t && y <= ((Rect4 *)lockerrects)[i].b) {
            *hit = i;
            return 1;
        }
    }
    return 0;
}
