/* File utils: open an existing file (DOS handle). */
#include "nhl95.h"

unsigned _dos_open(const char *path, unsigned mode, int *fh);  /* Watcom CRT _dos_open_ */

/* FileOpenRead (14525) - _dos_open name read-only, deny-none sharing (40h), handle into *h. 0 = ok. */
int FileOpenRead(char *name, int *h)
{
    return _dos_open(name, 0x40, h);
}

/* FileOpenWrite (1453E) - as FileOpenRead, write-only (41h). */
int FileOpenWrite(char *name, int *h)
{
    return _dos_open(name, 0x41, h);
}

/* FileOpenRW (14552) - as FileOpenRead, read / write (42h). */
int FileOpenRW(char *name, int *h)
{
    return _dos_open(name, 0x42, h);
}
