/* League setup: league file team entries. */
#include "nhl95.h"

/* ReadLeagueTeamEntry (3A31E) - read team entry n (1Eh bytes each, after a 20h-byte header) of the league file. */
void ReadLeagueTeamEntry(int fh, void *entry, int n)
{
    FileReadAt(fh, entry, n * 30 + 0x20, 0x1E);
}
