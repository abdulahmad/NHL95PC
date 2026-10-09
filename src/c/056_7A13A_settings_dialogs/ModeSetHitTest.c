/* Settings dialogs: mode settings hit test. */
#include "nhl95.h"

/* ModeSetHitTest (7B734) - as ExhSetHitTest for the 20 mode settings rects (modesetrects). */
int ModeSetHitTest(int x, int y, int *hit)
{
    int i;

    x -= 6;
    y -= 0x13;
    for (i = 0; i < 0x14; i++) {
        if (x >= ((Rect4 *)modesetrects)[i].l && x <= ((Rect4 *)modesetrects)[i].r
         && y >= ((Rect4 *)modesetrects)[i].t && y <= ((Rect4 *)modesetrects)[i].b) {
            if (i == 10 || i == 11) return 0;
            if (i >= 12 && i <= 15 && sounddev == 0x10) return 0;
            if ((i == 16 || i == 17) && !musicon) return 0;
            *hit = i;
            return 1;
        }
    }
    return 0;
}
