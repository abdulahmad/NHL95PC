/* Misc dialogs: dialog background. */
#include "nhl95.h"

/* SaveDialogBg (30E66) - save the screen under a w x h dialog at x / y (x rounded down to 4) into a new DBOX buffer
   (dlgsavebuf: the pointer sprite header, then (w + 7) x (h + 4) pixels); dlgsavex / dlgsavey remember where. */
typedef struct Hdr17 { char c[17]; } Hdr17;

void SaveDialogBg(int x, int y, int w, int h)
{
    int n;

    n = (w + 8) * (h + 4) + 0x11;
    dlgsavebuf = sub_8CCA8((char *)str_DBOX, n, 0x20);
    if (!dlgsavebuf) return;
    *(Hdr17 *)dlgsavebuf = *(Hdr17 *)pointerspr;
    ((short *)dlgsavebuf)[2] = w + 7;
    ((short *)dlgsavebuf)[3] = h + 4;
    dlgsavex = x / 4 * 4;
    dlgsavey = y;
    sub_91400(dlgsavebuf, dlgsavex, dlgsavey);
}
