/* Speech: read a big-endian 24-bit number from a file. */
#include "nhl95.h"

/* ReadBE24 (837FB) - PC only: read three bytes from file fh, most significant first (the VIV bank headers are
   big-endian), and return them as a number. */
int ReadBE24(int fh)
{
    unsigned got;
    int value;

    ((unsigned char *)&value)[3] = 0;
    _dos_read(fh, (unsigned char *)&value + 2, 1, &got);
    _dos_read(fh, (unsigned char *)&value + 1, 1, &got);
    _dos_read(fh, (unsigned char *)&value, 1, &got);
    return value;
}
