/* Misc dialogs: dialog buttons. */
#include "nhl95.h"

/* DrawButtons (30AE2) - draw the n buttons of array b, each in its normal (not pressed: +10h = 0) state. */
void DrawButtons(Button *b, int n)
{
    int i;

    for (i = 0; i < n; i++) {
        b[i].pressed = 0;
        DrawButton(&b[i]);
    }
}
