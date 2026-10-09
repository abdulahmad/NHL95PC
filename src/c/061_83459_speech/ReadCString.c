/* Speech: file string reader. */
#include "nhl95.h"

/* ReadCString (8385F) - read a 0-terminated string from file fh into s, one byte at a time. */
void ReadCString(char *s, int fh)
{
    unsigned got;

    do {
        _dos_read(fh, s, 1, &got);
    } while (*s++);
}
