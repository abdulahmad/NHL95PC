/* League setup: fixed-size record reads writes of the league and database files. */
#include "nhl95.h"

/* WriteSeasonRec: write a 2Fh-byte season record at pos. */
int WriteSeasonRec(int fh, void *rec, long pos)
{
    return FileWriteAt(fh, rec, pos, 0x2F);
}

/* ReadGoalieSeasonRec: read a 36h-byte goalie season record at pos. */
int ReadGoalieSeasonRec(int fh, void *rec, long pos)
{
    return FileReadAt(fh, rec, pos, 0x36);
}

/* WriteGoalieSeasonRec: write a 36h-byte goalie season record at pos. */
int WriteGoalieSeasonRec(int fh, void *rec, long pos)
{
    return FileWriteAt(fh, rec, pos, 0x36);
}

/* WriteSchedGame: write schedule game n (6 bytes each, after a 2-byte header). */
int WriteSchedGame(int fh, void *game, int n)
{
    return FileWriteAt(fh, game, n * 6 + 2, 6);
}

/* WriteTeamRec: write team record n (2E8h bytes each) to the team database file. */
void WriteTeamRec(int fh, void *rec, int n)
{
    FileWriteAt(fh, rec, n * 0x2E8, 0x2E8);
}

/* ReadDbRec4Ch: read database record n (4Ch bytes each). */
void ReadDbRec4Ch(int fh, void *rec, int n)
{
    FileReadAt(fh, rec, n * 0x4C, 0x4C);
}

/* ReadLeagueTeamEntry: read team entry n (1Eh bytes each, after a 20h-byte header) of the league file. */
void ReadLeagueTeamEntry(int fh, void *entry, int n)
{
    FileReadAt(fh, entry, n * 30 + 0x20, 0x1E);
}

/* WriteLeagueTeamEntry: write team entry n of the league file (as ReadLeagueTeamEntry). */
int WriteLeagueTeamEntry(int fh, void *entry, int n)
{
    return FileWriteAt(fh, entry, n * 30 + 0x20, 0x1E);
}

/* ReadDbRec28h: read a 28h-byte database record at pos. */
int ReadDbRec28h(int fh, void *rec, long pos)
{
    return FileReadAt(fh, rec, pos, 0x28);
}

/* ReadDbRec2Ch: read a 2Ch-byte database record at pos. */
int ReadDbRec2Ch(int fh, void *rec, long pos)
{
    return FileReadAt(fh, rec, pos, 0x2C);
}
