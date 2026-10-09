/* File utilities: key database records. */
#include "nhl95.h"

/* WriteKeyRec (14654) - write one 34h-byte key database record from rec at file position pos. */
void WriteKeyRec(int fh, void *rec, long pos)
{
    FileWriteAt(fh, rec, pos, 0x34);
}
