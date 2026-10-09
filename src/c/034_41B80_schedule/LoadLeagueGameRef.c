/* Schedule: league game reference. */
#include "nhl95.h"

/* LoadLeagueGameRef (41B80) - read the league game reference block from file fh at the current position: team / game
   words (lgplayteam, dword_DDD34, dword_DDD3C, word_DDD48, word_DDD4A, lggameidx, 4 bytes each), the two saved
   league names (0Dh bytes each) and 6 bytes at byte_DDD40. Stops at the first error; returns its code (0 ok). */
int LoadLeagueGameRef(int fh)
{
    int r;

    r = FileReadAt(fh, &lgplayteam, -1, 4);
    if (!r) r = FileReadAt(fh, &dword_DDD34, -1, 4);
    if (!r) r = FileReadAt(fh, &dword_DDD3C, -1, 4);
    if (!r) r = FileReadAt(fh, &word_DDD48, -1, 4);
    if (!r) r = FileReadAt(fh, &word_DDD4A, -1, 4);
    if (!r) r = FileReadAt(fh, &lggameidx, -1, 4);
    if (!r) r = FileReadAt(fh, savleague1, -1, 0xD);
    if (!r) r = FileReadAt(fh, savleague2, -1, 0xD);
    if (!r) r = FileReadAt(fh, &byte_DDD40, -1, 6);
    return r;
}
