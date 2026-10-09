/* File utilities: database sizes. */
#include "nhl95.h"

/* GetLeagueDBSizes (149BF) - kb[i] = size in KB (rounded up) of each of the 7 league database files (leaguedbnames) on
   drive. Returns 0. */
typedef struct FindT {
    char reserved[21];
    char attrib;
    unsigned short wr_time;
    unsigned short wr_date;
    unsigned long size;
    char name[13];
} FindT;

int GetLeagueDBSizes(char *drive, int *kb, char *ext)
{
    char path[32];
    FindT ft;
    int i;

    for (i = 0; i < 7; i++) {
        MakePath(path, drive, (char *)leaguedbnames[i], ext);
        unknown_libname_1(path, 0, &ft);
        kb[i] = (ft.size + 0x3FF) >> 10;
    }
    return 0;
}
