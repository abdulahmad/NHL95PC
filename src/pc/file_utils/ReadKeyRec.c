/* File utilities: key season records and file copy. */
#include "nhl95.h"

/* ReadKeyRec: read one 34h-byte key database record into rec from file position pos. */
int ReadKeyRec(int fh, void *rec, long pos)
{
    return FileReadAt(fh, rec, pos, 0x34);
}

/* WriteKeyRec: write one 34h-byte key database record from rec at file position pos. */
void WriteKeyRec(int fh, void *rec, long pos)
{
    FileWriteAt(fh, rec, pos, 0x34);
}

/* CopyFile (1466B, PC only): copy srcdir\name.srcext to dstdir\name.dstext in 1 KB blocks (_dos_read,
   _dos_write; a short write is error 1). Both handles are closed. name: the file name; srcext, dstext: the
   extensions; srcdir, dstdir: the directories. Result: 0 or the first DOS error. The declaration order of in,
   got, dst, put, src, buf, err, out gives the EXE's argument shuffle (found by tools/permute.py). */
int CopyFile(char *name, char *srcext, char *dstext, char *srcdir, char *dstdir)
{
    int in;
    unsigned got;
    char dst[32];
    unsigned put;
    char src[32];
    char buf[0x400];
    int err;
    int out;

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

/* ReadSeasonRec: read one 2Fh-byte season record into rec from file position pos. */
int ReadSeasonRec(int fh, void *rec, long pos)
{
    return FileReadAt(fh, rec, pos, 0x2F);
}
