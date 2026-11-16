/* Create player: temporary databases. */
#include "nhl95.h"

/* LoadTempDatabases: free the league databases and load the.TMP copies instead (season, career, career teams,
 key, teams, attributes), remembering each buffer's file size (GetFileSize). */
void LoadTempDatabases(void)
{
    FreeLeagueDbsMem();
    MakePath((char *)tmpdbpath, 0, (char *)leaguedbnames[5], (char *)str_TMP);
    seasondb = (unsigned char *)OpenArtArchiveErr((char *)tmpdbpath, 0x20);
    seasondb_size = GetFileSize((char *)tmpdbpath);
    MakePath((char *)tmpdbpath, 0, (char *)leaguedbnames[1], (char *)str_TMP);
    careerdb = (unsigned char *)OpenArtArchiveErr((char *)tmpdbpath, 0x20);
    careerdb_size = GetFileSize((char *)tmpdbpath);
    MakePath((char *)tmpdbpath, 0, (char *)leaguedbnames[3], (char *)str_TMP);
    carteamsdb = (unsigned char *)OpenArtArchiveErr((char *)tmpdbpath, 0x20);
    carteamsdb_size = GetFileSize((char *)tmpdbpath);
    MakePath((char *)tmpdbpath, 0, (char *)leaguedbnames[0], (char *)str_TMP);
    keydb = (unsigned char *)OpenArtArchiveErr((char *)tmpdbpath, 0x20);
    keydb_size = GetFileSize((char *)tmpdbpath);
    MakePath((char *)tmpdbpath, 0, (char *)leaguedbnames[4], (char *)str_TMP);
    teamsdb = (unsigned char *)OpenArtArchiveErr((char *)tmpdbpath, 0x20);
    teamsdb_size = GetFileSize((char *)tmpdbpath);
    MakePath((char *)tmpdbpath, 0, (char *)leaguedbnames[2], (char *)str_TMP);
    attdb = (unsigned char *)OpenArtArchiveErr((char *)tmpdbpath, 0x20);
    attdb_size = GetFileSize((char *)tmpdbpath);
}
