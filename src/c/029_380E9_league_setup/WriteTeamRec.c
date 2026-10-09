/* League setup: team records. */
#include "nhl95.h"

/* WriteTeamRec (3A2B8) - write team record n (2E8h bytes each) to the team database file. */
void WriteTeamRec(int fh, void *rec, int n)
{
    FileWriteAt(fh, rec, n * 0x2E8, 0x2E8);
}
