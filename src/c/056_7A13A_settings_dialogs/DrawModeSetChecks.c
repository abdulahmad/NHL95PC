/* Settings dialogs: check boxes. */
#include "nhl95.h"

/* DrawModeSetChecks (7B7BE) - draw the 9 mode settings check boxes (on / off sprite by setbits bit i) at their rects
   (2 rects per item; item 5 is skipped). */
void DrawModeSetChecks(void)
{
    Rect4 *r;
    int i;

    r = (Rect4 *)modesetrects;
    for (i = 0; i < 9; i++, r += 2) {
        if (i == 5) {
            i++;
            r += 2;
        }
        if (setbits[0] & (1 << i)) sub_903F0(chkonspr, r->l + 10, r->t + 0x13);
        else sub_903F0(chkoffspr, r->l + 10, r->t + 0x13);
    }
}
