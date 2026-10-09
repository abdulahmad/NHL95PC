/* Gadgets / replay: hit test. */
#include "nhl95.h"

typedef struct Gadget {
    Rect4 r;                    /* gadgetrects / gadgetrect_y0 / gadgetrect_x1 / gadgetrect_y1 */
    int pad[3];
} Gadget;

/* GadgetHitTest (7E8E5) - which of the 10 replay gadgets (1Ch bytes each) contains the mouse point (x + 5, y): *hit = its
   number, returns 1; 0 when none. */
int GadgetHitTest(int x, int y, int *hit)
{
    int i;

    x += 5;
    for (i = 0; i < 10; i++) {
        if (x >= ((Gadget *)gadgetrects)[i].r.l && x <= ((Gadget *)gadgetrects)[i].r.r
         && y >= ((Gadget *)gadgetrects)[i].r.t && y <= ((Gadget *)gadgetrects)[i].r.b) {
            *hit = i;
            return 1;
        }
    }
    return 0;
}
