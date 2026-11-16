/* Schedule: league game reference. */
#include "nhl95.h"

/* LoadLeagueGameRef: read the league game reference block from file fh at the current position: team game
 words (lgplayteam, lgoppteam, lgopphuman, lggamecount, lgoppgamecount, lggameidx, 4 bytes each), the two saved
 league names (0Dh bytes each) and 6 bytes at lgschedrec. Stops at the first error; returns its code (0 ok). */
int LoadLeagueGameRef(int fh)
{
    int r;

    r = FileReadAt(fh, &lgplayteam, -1, 4);
    if (!r) r = FileReadAt(fh, &lgoppteam, -1, 4);
    if (!r) r = FileReadAt(fh, &lgopphuman, -1, 4);
    if (!r) r = FileReadAt(fh, &lggamecount, -1, 4);
    if (!r) r = FileReadAt(fh, &lgoppgamecount, -1, 4);
    if (!r) r = FileReadAt(fh, &lggameidx, -1, 4);
    if (!r) r = FileReadAt(fh, savleague1, -1, 0xD);
    if (!r) r = FileReadAt(fh, savleague2, -1, 0xD);
    if (!r) r = FileReadAt(fh, &lgschedrec, -1, 6);
    return r;
}
