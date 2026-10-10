/* File utilities: team and game summary records. */
#include "nhl95.h"

/* ReadTeamRec (147C9) - read team record n (2E8h bytes each) of the team database file. */
int ReadTeamRec(int fh, void *rec, int n)
{
    FileReadAt(fh, rec, n * 0x2E8, 0x2E8);   /* no return: the asm leaves FileReadAt's result in eax */
}

/* ReadGSummaryRec (147FF) - read game summary record n (0Bh bytes each); shares ReadTeamRec's call. */
void ReadGSummaryRec(int fh, void *rec, int n)
{
    FileReadAt(fh, rec, n * 11, 11);
}
