/* File utilities: key / season records and file copy. */
#include "nhl95.h"

/* ReadKeyRec (1463D) - read one 34h-byte key database record into rec from file position pos. */
int ReadKeyRec(int fh, void *rec, long pos)
{
    return FileReadAt(fh, rec, pos, 0x34);
}

/* WriteKeyRec (14654) - write one 34h-byte key database record from rec at file position pos. */
void WriteKeyRec(int fh, void *rec, long pos)
{
    FileWriteAt(fh, rec, pos, 0x34);
}

/* CopyFile (1466B) - copy srcdir\name.srcext to dstdir\name.dstext in 1 KB blocks (_dos_read / _dos_write; a
   short write is an error). Both handles are closed. Returns 0 or the first DOS error (1 for a short write).
   Draft: stack slots match; the argument shuffle before the first MakePath differs (asm parks srcdir in eax,
   this parks srcext). */
int CopyFile(char *name, char *srcext, char *dstext, char *srcdir, char *dstdir)
{
    char buf[0x400];
    char dst[32];
    char src[32];
    unsigned wrote;
    int fin;
    int fout;
    unsigned got;
    int err;

    fout = fin = -1;
    MakePath(src, srcdir, name, srcext);
    if (!(err = FileOpenRead(src, &fin))) {
        MakePath(dst, dstdir, name, dstext);
        err = FileCreate(dst, &fout);
    }
    if (!err) {
        do {
            if (!(err = _dos_read(fin, buf, 0x400, &got)) && got > 0) {
                err = _dos_write(fout, buf, got, &wrote);
                if (wrote != got) err = 1;
            }
        } while (got > 0 && !err);
    }
    FileClose(&fout);
    FileClose(&fin);
    return err;
}

/* ReadSeasonRec (1478B) - read one 2Fh-byte season record into rec from file position pos. */
int ReadSeasonRec(int fh, void *rec, long pos)
{
    return FileReadAt(fh, rec, pos, 0x2F);
}
