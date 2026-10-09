/* Scoring / penalties: game summary file header. */
#include "nhl95.h"

/* ReadGSumHeader (61BBF) - PC only: open the game summary file (gsummarypath; error "B3") and write the 11-byte
   header unk_C5423 at the current position (error "B4"), then close it. */
void ReadGSumHeader(void)
{
    int fh;

    if (FileOpenRW((char *)&gsummarypath, &fh) != 0) FatalError((char *)str_B3);
    if (FileWriteAt(fh, unk_C5423, -1, 11) != 0) FatalError((char *)str_B4);
    FileClose(&fh);
}

/* ReadGSumTail (61C22) - PC only: open the game summary file ("B3"), seek 11 bytes before its end ("B6") and
   write the 11-byte block unk_C542E there ("B4"), then close it. Ends in ReadGSumHeader's code (shared tail). */
void ReadGSumTail(void)
{
    int fh;

    if (FileOpenRW((char *)&gsummarypath, &fh) != 0) FatalError((char *)str_B3);
    if (lseek(fh, -11, 2) < 0) FatalError((char *)str_B6);
    if (FileWriteAt(fh, unk_C542E, -1, 11) != 0) FatalError((char *)str_B4);
    FileClose(&fh);
}

/* WriteGSumHeader (61C86) - PC only: count one more game (word_C5428), open the game summary file ("B3"), rewrite
   the 11-byte header at the start ("B4" seek, "B5" write) and the 11-byte block at the end ("B6" seek, "B8"
   write), then close it. Shares the error / close tail with ReadGSumHeader. */
void WriteGSumHeader(void)
{
    int fh;

    word_C5428++;
    if (FileOpenRW((char *)&gsummarypath, &fh) != 0) FatalError((char *)str_B3);
    if (lseek(fh, 0, 0) < 0) FatalError((char *)str_B4);
    if (FileWriteAt(fh, unk_C5423, -1, 11) != 0) FatalError((char *)str_B5);
    if (lseek(fh, 0, 2) < 0) FatalError((char *)str_B6);
    if (FileWriteAt(fh, unk_C542E, -1, 11) != 0) FatalError((char *)str_B8);
    FileClose(&fh);
}
