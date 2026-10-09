/* Create player: temporary databases. */
#include "nhl95.h"

/* LoadTempDatabases (710D8) - free the league databases and load the .TMP copies instead (season, career, career teams,
   key, teams, attributes), remembering each buffer's file size (sub_92DE0). */
void LoadTempDatabases(void)
{
    FreeLeagueDbsMem();
    MakePath((char *)unk_EA968, 0, (char *)leaguedbnames[5], (char *)str_TMP);
    seasondb = (unsigned char *)sub_8E8A0((char *)unk_EA968, 0x20);
    seasondb_size = sub_92DE0((char *)unk_EA968);
    MakePath((char *)unk_EA968, 0, (char *)leaguedbnames[1], (char *)str_TMP);
    careerdb = (unsigned char *)sub_8E8A0((char *)unk_EA968, 0x20);
    careerdb_size = sub_92DE0((char *)unk_EA968);
    MakePath((char *)unk_EA968, 0, (char *)leaguedbnames[3], (char *)str_TMP);
    carteamsdb = (unsigned char *)sub_8E8A0((char *)unk_EA968, 0x20);
    carteamsdb_size = sub_92DE0((char *)unk_EA968);
    MakePath((char *)unk_EA968, 0, (char *)leaguedbnames[0], (char *)str_TMP);
    keydb = (unsigned char *)sub_8E8A0((char *)unk_EA968, 0x20);
    keydb_size = sub_92DE0((char *)unk_EA968);
    MakePath((char *)unk_EA968, 0, (char *)leaguedbnames[4], (char *)str_TMP);
    teamsdb = (unsigned char *)sub_8E8A0((char *)unk_EA968, 0x20);
    teamsdb_size = sub_92DE0((char *)unk_EA968);
    MakePath((char *)unk_EA968, 0, (char *)leaguedbnames[2], (char *)str_TMP);
    attdb = (unsigned char *)sub_8E8A0((char *)unk_EA968, 0x20);
    attdb_size = sub_92DE0((char *)unk_EA968);
}
