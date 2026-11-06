/* Database save: writing the league databases to a directory. */
#define SaveDbsToDir SaveDbsToDir_decl
#include "nhl95.h"
#undef SaveDbsToDir

typedef struct DiskFree {
    unsigned short total_clusters;
    unsigned short avail_clusters;
    unsigned short sectors_per_cluster;
    unsigned short bytes_per_sector;
} DiskFree;

typedef struct FindT {
    char reserved[0x15];
    char attrib;
    unsigned short wr_time;
    unsigned short wr_date;
    unsigned long size;
    char name[0x0E];
} FindT;

/* SaveDbsToDir (6C4BA, PC only): write the six league databases (leaguedbnames 5, 1, 3, 0, 4, 2: season, career,
   career teams, key, teams, attributes) to dir with extension ext. First count the clusters of drive 0 the new
   files need beyond the ones already there (each file's KB rounded up to whole clusters); when that is more
   than are free, say how many KB of free space are needed (nodiskspacemsg, the mouse at 140h / F0h) and remove
   dir if one was given. Else write the files and clear dbdirty. */
void SaveDbsToDir(char *dir, char *ext)
{
    struct {
        FindT ft;
        char path[0x20];
        int old[8];
        int new[7];
        int pad;
        DiskFree df;
        int y;
        int x;
        char *ext;
    } s;
    int cl;
    int i;
    int need;

    s.ext = ext;
    if (_dos_getdiskfree(0, &s.df)) FatalError((char *)str_ErrorGettingDiskSpace);
    cl = s.df.sectors_per_cluster;  /* in two steps: one product swaps cl (esi) and need (edi) */
    cl *= s.df.bytes_per_sector;
    MakePath(s.path, dir, (char *)leaguedbnames[5], s.ext);
    if (unknown_libname_1(s.path, 0, &s.ft)) s.old[0] = 0;
    else s.old[0] = (s.ft.size + 0x3FF) >> 10;
    MakePath(s.path, dir, (char *)leaguedbnames[1], s.ext);
    if (unknown_libname_1(s.path, 0, &s.ft)) s.old[1] = 0;
    else s.old[1] = (s.ft.size + 0x3FF) >> 10;
    MakePath(s.path, dir, (char *)leaguedbnames[3], s.ext);
    if (unknown_libname_1(s.path, 0, &s.ft)) s.old[2] = 0;
    else s.old[2] = (s.ft.size + 0x3FF) >> 10;
    MakePath(s.path, dir, (char *)leaguedbnames[0], s.ext);
    if (unknown_libname_1(s.path, 0, &s.ft)) s.old[3] = 0;
    else s.old[3] = (s.ft.size + 0x3FF) >> 10;
    MakePath(s.path, dir, (char *)leaguedbnames[4], s.ext);
    if (unknown_libname_1(s.path, 0, &s.ft)) s.old[4] = 0;
    else s.old[4] = (s.ft.size + 0x3FF) >> 10;
    MakePath(s.path, dir, (char *)leaguedbnames[2], s.ext);
    if (unknown_libname_1(s.path, 0, &s.ft)) s.old[5] = 0;
    else s.old[5] = (s.ft.size + 0x3FF) >> 10;
    s.new[0] = (seasondb_size + 0x3FF) / 1024;
    s.new[1] = (careerdb_size + 0x3FF) / 1024;
    s.new[2] = (carteamsdb_size + 0x3FF) / 1024;
    s.new[3] = (keydb_size + 0x3FF) / 1024;
    s.new[4] = (teamsdb_size + 0x3FF) / 1024;
    s.new[5] = (attdb_size + 0x3FF) / 1024;
    s.new[6] = 0;
    need = 0;
    for (i = 0; i < 6; i++) {
        need += (s.new[i] + cl - 1) / cl;
        need -= (s.old[i] + cl - 1) / cl;
    }
    if (need > s.df.avail_clusters) {
        s.x = 0x140;
        s.y = 0xF0;
        MouseSetPos(s.x, s.y);
        for (i = 0; i < 6; i++) need += (s.new[i] + cl - 1) / cl;
        sprintf((char *)str_XXXKbytesOfFree2, (char *)str_3dKbytesOfFree2, need * cl / 1024);
        MessageBox(-1, -1, (char *)nodiskspacemsg, 3, 0, 0, (int)&s.x, (int)&s.y, 0x320);
        if (*dir) rmdir(dir);
        return;
    }
    MakePath(s.path, dir, (char *)leaguedbnames[5], s.ext);
    sub_932D0(s.path, seasondb, seasondb_size);
    MakePath(s.path, dir, (char *)leaguedbnames[1], s.ext);
    sub_932D0(s.path, careerdb, careerdb_size);
    MakePath(s.path, dir, (char *)leaguedbnames[3], s.ext);
    sub_932D0(s.path, carteamsdb, carteamsdb_size);
    MakePath(s.path, dir, (char *)leaguedbnames[0], s.ext);
    sub_932D0(s.path, keydb, keydb_size);
    MakePath(s.path, dir, (char *)leaguedbnames[4], s.ext);
    sub_932D0(s.path, teamsdb, teamsdb_size);
    MakePath(s.path, dir, (char *)leaguedbnames[2], s.ext);
    sub_932D0(s.path, attdb, attdb_size);
    dbdirty = 0;
}
