/* Database dialogs: load. */
#include "nhl95.h"

/* LoadDbsFromDir (7345B) - free the league databases and load them from directory dir with extension ext (season, career,
   career teams, key, teams, attributes), remembering each buffer's file size; the databases are clean (dbdirty 0). */
void LoadDbsFromDir(char *dir, char *ext)
{
    char path[32];

    FreeLeagueDbsMem();
    MakePath(path, dir, (char *)leaguedbnames[5], ext);
    seasondb = (unsigned char *)sub_8E8A0(path, 0x20);
    seasondb_size = sub_92DE0(path);
    MakePath(path, dir, (char *)leaguedbnames[1], ext);
    careerdb = (unsigned char *)sub_8E8A0(path, 0x20);
    careerdb_size = sub_92DE0(path);
    MakePath(path, dir, (char *)leaguedbnames[3], ext);
    carteamsdb = (unsigned char *)sub_8E8A0(path, 0x20);
    carteamsdb_size = sub_92DE0(path);
    MakePath(path, dir, (char *)leaguedbnames[0], ext);
    keydb = (unsigned char *)sub_8E8A0(path, 0x20);
    keydb_size = sub_92DE0(path);
    MakePath(path, dir, (char *)leaguedbnames[4], ext);
    teamsdb = (unsigned char *)sub_8E8A0(path, 0x20);
    teamsdb_size = sub_92DE0(path);
    MakePath(path, dir, (char *)leaguedbnames[2], ext);
    attdb = (unsigned char *)sub_8E8A0(path, 0x20);
    attdb_size = sub_92DE0(path);
    dbdirty = 0;
}
