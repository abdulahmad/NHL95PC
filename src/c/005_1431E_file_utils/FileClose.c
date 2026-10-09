/* File utilities: close a DOS file handle. */
#include "nhl95.h"

/* FileClose (1457C) - close the DOS handle *h if it is open (>= 0) and mark it closed (-1). Returns the
   _dos_close result, 0 when the handle was not open. */
int FileClose(int *h)
{
    int r;

    r = 0;
    if (*h >= 0) r = _dos_close(*h);
    *h = -1;
    return r;
}
