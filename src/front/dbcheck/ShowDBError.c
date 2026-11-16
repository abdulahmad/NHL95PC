/* Create player: database error. */
#include "nhl95.h"

/* ShowDBError: database error during create-player: reset the screen, clear the selection (*sel = -1,
 *state = 0) and show the error screen for msg arg until a key. Returns that screen's result. */
int ShowDBError(int *sel, int *state, int msg, int arg)
{
    SetScreenTarget();
    DrawArtOpaqueAtOwnPos(((int *)fullscrbmp)[0x2C / 4]);
    *sel = -1;
    *state = 0;
    return ErrorScreenWait(msg, arg, (char *)btn_DBError, 2);
}
