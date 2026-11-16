/* League databases: load. */
#include "nhl95.h"

/* LoadLeagueDbsMem: free the league databases and load them again from the files with extension ext (season,
 career, career teams, key, teams, attributes), remembering each buffer's file size (GetFileSize). */
void LoadLeagueDbsMem(char *ext)
{
    char path[32];

    FreeLeagueDbsMem();
    MakePath(path, 0, (char *)leaguedbnames[5], ext);
    seasondb = (unsigned char *)OpenArtArchiveErr(path, 0x20);
    seasondb_size = GetFileSize(path);
    MakePath(path, 0, (char *)leaguedbnames[1], ext);
    careerdb = (unsigned char *)OpenArtArchiveErr(path, 0x20);
    careerdb_size = GetFileSize(path);
    MakePath(path, 0, (char *)leaguedbnames[3], ext);
    carteamsdb = (unsigned char *)OpenArtArchiveErr(path, 0x20);
    carteamsdb_size = GetFileSize(path);
    MakePath(path, 0, (char *)leaguedbnames[0], ext);
    keydb = (unsigned char *)OpenArtArchiveErr(path, 0x20);
    keydb_size = GetFileSize(path);
    MakePath(path, 0, (char *)leaguedbnames[4], ext);
    teamsdb = (unsigned char *)OpenArtArchiveErr(path, 0x20);
    teamsdb_size = GetFileSize(path);
    MakePath(path, 0, (char *)leaguedbnames[2], ext);
    attdb = (unsigned char *)OpenArtArchiveErr(path, 0x20);
    attdb_size = GetFileSize(path);
}
