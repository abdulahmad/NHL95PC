/* Scoring penalties: game summary file. */
#include "nhl95.h"

/* AppendGSumRecord: count one more record (gsumcount), open the game summary file ("B3"),
 rewrite the 11-byte header at the start ("B4" seek, "B5" write), then at 11 bytes before the end ("B6") write
 the 11-byte record rec over the old tail ("B7") and the tail block gsumtail after it ("B8"), and close it. */
void AppendGSumRecord(void *rec)
{
    int fh;

    gsumcount++;
    if (FileOpenRW((char *)&gsummarypath, &fh) != 0) FatalError((char *)str_B3);
    if (lseek(fh, 0, 0) < 0) FatalError((char *)str_B4);
    if (FileWriteAt(fh, gsumheader, -1, 11) != 0) FatalError((char *)str_B5);
    if (lseek(fh, -11, 2) < 0) FatalError((char *)str_B6);
    if (FileWriteAt(fh, rec, -1, 11) != 0) FatalError((char *)str_B7);
    if (FileWriteAt(fh, gsumtail, -1, 11) != 0) FatalError((char *)str_B8);
    FileClose(&fh);
}
