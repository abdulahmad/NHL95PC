/* Settings dialogs: exhibition settings hit test. */
#include "nhl95.h"

/* ExhSetHitTest (7C28D) - which of the 23 exhibition settings rects contains the mouse point (x - 6, y - 13h): *hit = its
   number, returns 1. Disabled items return 0: 10 and 11, 12-15 without a sound card (sounddev 10h), 16 and 17
   with the music off. */
int ExhSetHitTest(int x, int y, int *hit)
{
    int i;

    x -= 6;
    y -= 0x13;
    for (i = 0; i < 0x17; i++) {
        if (x >= ((Rect4 *)exhsetrects)[i].l && x <= ((Rect4 *)exhsetrects)[i].r
         && y >= ((Rect4 *)exhsetrects)[i].t && y <= ((Rect4 *)exhsetrects)[i].b) {
            if (i == 10 || i == 11) return 0;
            if (i >= 12 && i <= 15 && sounddev == 0x10) return 0;
            if ((i == 16 || i == 17) && !musicon) return 0;
            *hit = i;
            return 1;
        }
    }
    return 0;
}
