/* Joystick calibration file: free-agent list. */
#include "nhl95.h"

/* BuildFreeAgentList: falist entries (27 bytes: position, jersey, index, "F. Lastname") for keydb records
 whose team byte is 0FFh, up to facount. The key offset (record * 34h) is stored at +4. */
void BuildFreeAgentList(void)
{
    unsigned n;
    int i;
    int s;
    int rec;
    int off;
    unsigned char *p;

    n = (unsigned)keydb_size / 0x34;
    i = 0;
    for (s = 0; s < (int)n && i < facount; s++) {
        rec = (s * 12 + s) * 4;
        p = keydb + rec;
        if (p[0] != 0xFF) continue;
        off = i * 27;
        falist[off + 2] = i;
        falist[off] = p[2];
        falist[off + 1] = p[1];
        falist[off + 3] = 3;
        *(int *)(falist + off + 4) = rec;
        falist[off + 8] = p[3];
        falist[off + 9] = str_dot;
        falist[off + 10] = str_space;
        falist[off + 11] = 0;
        p += 0x13;
        strcat((char *)falist + off + 8, (char *)p);
        i++;
    }
}

/* WriteLeagueDbsMem (6C96C, PC only; segment 051, ends in BuildFreeAgentList_ret): write the six league databases
   held in memory back to files in dir (the pair of LoadLeagueDbsMem): season, career, career teams, key, teams and
   attributes, each named from leaguedbnames (MakePath) and written whole (sub_932D0). dir: the extension or
   directory part MakePath appends. No result. */
void WriteLeagueDbsMem(char *dir)
{
    char path[0x20];

    MakePath(path, 0, (char *)leaguedbnames[5], dir);
    sub_932D0(path, seasondb, seasondb_size);
    MakePath(path, 0, (char *)leaguedbnames[1], dir);
    sub_932D0(path, careerdb, careerdb_size);
    MakePath(path, 0, (char *)leaguedbnames[3], dir);
    sub_932D0(path, carteamsdb, carteamsdb_size);
    MakePath(path, 0, (char *)leaguedbnames[0], dir);
    sub_932D0(path, keydb, keydb_size);
    MakePath(path, 0, (char *)leaguedbnames[4], dir);
    sub_932D0(path, teamsdb, teamsdb_size);
    MakePath(path, 0, (char *)leaguedbnames[2], dir);
    sub_932D0(path, attdb, attdb_size);
}

/* FreeLeagueDbsMem (6CA8F, PC only; database-save segment 051, the same source file: it ends in
   BuildFreeAgentList_ret): free the six league databases held in memory (attribute, team, key, career team,
   career and season) and clear their pointers and sizes. No arguments, no result. */
void FreeLeagueDbsMem(void)
{
    if (attdb) {
        FreeMemBlock((int)attdb);
        attdb_size = (int)(attdb = 0);
    }
    if (teamsdb) {
        FreeMemBlock((int)teamsdb);
        teamsdb_size = (int)(teamsdb = 0);
    }
    if (keydb) {
        FreeMemBlock((int)keydb);
        keydb_size = (int)(keydb = 0);
    }
    if (carteamsdb) {
        FreeMemBlock((int)carteamsdb);
        carteamsdb_size = (int)(carteamsdb = 0);
    }
    if (careerdb) {
        FreeMemBlock((int)careerdb);
        careerdb_size = (int)(careerdb = 0);
    }
    if (seasondb) {
        FreeMemBlock((int)seasondb);
        seasondb_size = (int)(seasondb = 0);
    }
}
