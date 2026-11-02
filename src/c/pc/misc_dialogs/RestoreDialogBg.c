/* Misc dialogs: dialog background. */
#include "nhl95.h"

/* RestoreDialogBg: put the saved dialog background back at (dlgsavex, dlgsavey) and free it. */
void RestoreDialogBg(void)
{
    if (dlgsavebuf) {
        sub_903F0(dlgsavebuf, dlgsavex, dlgsavey);
        FreeMemBlock(dlgsavebuf);
        dlgsavebuf = 0;
    }
}
