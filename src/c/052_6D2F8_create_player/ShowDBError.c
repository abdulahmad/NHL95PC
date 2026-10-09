/* Create player: database error. */
#include "nhl95.h"

/* ShowDBError (6ED39) - database error during create-player: reset the screen, clear the selection (*sel = -1,
   *state = 0) and show the error screen for msg / arg until a key. */
void ShowDBError(int *sel, int *state, int msg, int arg)
{
    sub_B4BA8();
    sub_9121C(((int *)fullscrbmp)[0x2C / 4]);
    *sel = -1;
    *state = 0;
    ErrorScreenWait(msg, arg, (char *)unk_D0CA2, 2);
}
