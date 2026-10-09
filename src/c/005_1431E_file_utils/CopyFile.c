/* File utilities: copy a file. */
#include "nhl95.h"

/* CopyFile (1466B) - PC only: copy file name from directory srcdir (extension srcext) to directory dstdir
   (extension dstext) in 1 KB blocks (_dos_read / _dos_write; a short write is error 1). Both files are closed.
   Returns the error (0 ok). */
int CopyFile(char *name, char *srcext, char *dstext, char *srcdir, char *dstdir)
{
    int out;
    unsigned put;
    int in;
    unsigned got;
    char dst[32];
    char src[32];
    char buf[0x400];
    int err;

    in = -1;
    out = -1;
    MakePath(src, srcdir, name, srcext);
    err = FileOpenRead(src, &in);
    if (err == 0) {
        MakePath(dst, dstdir, name, dstext);
        err = FileCreate(dst, &out);
    }
    if (err == 0) {
        do {
            err = _dos_read(in, buf, 0x400, &got);
            if (err == 0 && got > 0) {
                err = _dos_write(out, buf, got, &put);
                if (put != got) err = 1;
            }
        } while (got > 0 && err == 0);
    }
    FileClose(&out);
    FileClose(&in);
    return err;
}
