/* File utilities: schedule records. */
#include "nhl95.h"

/* ReadSchedGame: read schedule game n (6 bytes each, after a 2-byte header) from the schedule file
 into game. */
void ReadSchedGame(int fh, void *game, int n)
{
    FileReadAt(fh, game, n * 6 + 2, 6);
}
