/* Settings / locker room: sound card dialog hit test. */
#include "nhl95.h"

/* SoundCardHitTest (827B3) - which of the 8 sound card dialog rects contains the mouse point (x - 6, y - 13h): *hit =
   its number, returns 1; 0 when none. */
int SoundCardHitTest(int x, int y, int *hit)
{
    int i;

    x -= 6;
    y -= 0x13;
    for (i = 0; i < 8; i++) {
        if (x >= ((Rect4 *)soundcardrects)[i].l && x <= ((Rect4 *)soundcardrects)[i].r
         && y >= ((Rect4 *)soundcardrects)[i].t && y <= ((Rect4 *)soundcardrects)[i].b) {
            *hit = i;
            return 1;
        }
    }
    return 0;
}
