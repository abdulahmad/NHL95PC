/* File utilities: create a file. */
#include "nhl95.h"

/* FileCreate (14566) - create (truncate) file name with normal attributes; the DOS handle goes to *h. Returns
   the _dos_creat result (0 = ok). */
int FileCreate(char *name, int *h)
{
    return _dos_creat(name, 0, h);
}
