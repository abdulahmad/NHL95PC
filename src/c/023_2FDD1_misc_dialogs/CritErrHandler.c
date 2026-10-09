/* Misc dialogs: DOS critical error handler. */
#include "nhl95.h"

/* CritErrHandler (3149D) - DOS critical error (INT 24h) handler: flag the error (criterrflag = -1) and return 0
   (ignore), so the failing call returns an error instead of the DOS abort prompt. */
int CritErrHandler(void)
{
    criterrflag = -1;
    return 0;
}
