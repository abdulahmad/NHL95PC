/* Asset loading: file test. */
#include "nhl95.h"

/* FileExists (142E7) - 1 when file name can be opened for reading, else 0 (the handle is closed again). */
int FileExists(char *name)
{
    int h;
    int r;

    h = -1;
    r = 0;
    if (!FileOpenRead(name, &h)) r = 1;
    FileClose(&h);
    return r;
}
