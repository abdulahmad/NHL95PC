/* File utilities: positioned file reads and writes. */
#include "nhl95.h"

/* FileReadAt (145A2) - PC only: seek file fh to pos (pos < 0: no seek; a failed seek gives -1), then read len
   bytes into buf (_dos_read). Returns the error, or 1 when fewer than len bytes came in. */
int FileReadAt(int fh, void *buf, long pos, unsigned len)
{
    unsigned got;
    int err;

    err = 0;
    if (pos >= 0 && lseek(fh, pos, 0) < 0) err = -1;
    if (err == 0) err = _dos_read(fh, buf, len, &got);
    if (len != got) err = 1;
    return err;
}

/* FileWriteAt (145F9) - PC only: the same for writing len bytes of buf (_dos_write). Its end is FileReadAt's
   (shared tail), so both are in this file. */
int FileWriteAt(int fh, void *buf, long pos, unsigned len)
{
    unsigned got;
    int err;

    err = 0;
    if (pos >= 0 && lseek(fh, pos, 0) < 0) err = -1;
    if (err == 0) err = _dos_write(fh, buf, len, &got);
    if (len != got) err = 1;
    return err;
}
